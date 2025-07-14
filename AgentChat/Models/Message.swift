//
//  Message.swift
//  AgentChat
//
//  Created by Mario Moschetta on 14/07/25.
//

import Foundation

struct Message: Identifiable, Codable {
    let id = UUID()
    let content: String
    let isUser: Bool
    let timestamp: Date
    
    init(content: String, isUser: Bool) {
        self.content = content
        self.isUser = isUser
        self.timestamp = Date()
    }
}