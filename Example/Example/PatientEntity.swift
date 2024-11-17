//
//  PatientEntity.swift
//  Example
//
//  Created by Paolo Longato on 17/11/2024.
//

import Foundation

class Patient {
    let id: UUID
    let name: String
    var chat: [ChatEntry]
    
    internal init(id: UUID, name: String, chat: [ChatEntry]) {
        self.id = id
        self.name = name
        self.chat = chat
    }
}

class ChatEntry {
    let text: String
    let isResponse: Bool
    
    init(text: String, isResponse: Bool) {
        self.text = text
        self.isResponse = isResponse
    }
}

