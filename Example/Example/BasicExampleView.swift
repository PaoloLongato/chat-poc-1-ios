//
//  BasicExampleView.swift
//  SwiftyChatExample
//
//  Created by Enes Karaosman on 21.10.2020.
//

import SwiftUI
import SwiftyChat
import SwiftyChatMock

struct BasicExampleView: View {

    @State var messages: [MessageMocker.ChatMessageItem] = MessageMocker.generate(kind: .text, count: 20)
    @State var scrollToBottom = false
    @State private var message = ""

    var body: some View {
        chatView
    }

    private var chatView: some View {
        ChatView<MessageMocker.ChatMessageItem, MessageMocker.ChatUserItem>(
            messages: $messages,
            scrollToBottom: $scrollToBottom
        ) {

            BasicInputView(
                message: $message,
                placeholder: "Type something",
                onCommit: { messageKind in
                    self.messages.append(
                        .init(user: MessageMocker.sender, messageKind: messageKind, isSender: true)
                    )
                    self.messages.append(
                        .init(user: MessageMocker.sender, messageKind: .loading, isSender: false)
                    )
                    scrollToBottom = true
                    Task {
                        try await Task.sleep(nanoseconds: 2_000_000_000)
                        let response = MessageMocker.ChatMessageItem(
                            user: MessageMocker.chatbot,
                            messageKind: .text("Bot response..."),
                            isSender: false
                        )
                        self.messages.removeLast()
                        self.messages.append(response)
                        scrollToBottom = true
                    }
                }
            )
            .background(Color.primary.colorInvert())
            .embedInAnyView()

        }
        // ▼ Optional, Present context menu when cell long pressed
        .messageCellContextMenu { message -> AnyView in
            switch message.messageKind {
            case .text(let text):
                return Button(
                    action: {
                        print("Copy Context Menu tapped!!")
                        #if os(iOS)
                        UIPasteboard.general.string = text
                        #endif
                        #if os(macOS)
                        NSPasteboard.general.setString(text, forType: .string)
                        #endif
                    },
                    label: {
                        Text("Copy")
                        Image(systemName: "doc.on.doc")
                    }
                ).embedInAnyView()
            default:
                // If you don't want to implement contextMenu action
                // for a specific case, simply return EmptyView like below;
                return EmptyView().embedInAnyView()
            }
        }
        // ▼ Required
        .environmentObject(ChatMessageCellStyle.basicStyle)
        #if os(iOS)
        .navigationBarTitle("Basic")
        #endif
        .onAppear {
            scrollToBottom = true
        }
    }
}

struct BasicExampleView_Previews: PreviewProvider {
    static var previews: some View {
        BasicExampleView()
    }
}
