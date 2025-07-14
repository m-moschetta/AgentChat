//
//  Chat.swift
//  AgentChat
//
//  Created by Mario Moschetta on 14/07/25.
//

import Foundation

struct Chat: Identifiable, Codable {
    let id = UUID()
    var title: String
    var messages: [Message]
    var createdAt: Date
    var agentType: AgentType
    var model: String
    
    init(title: String, agentType: AgentType, model: String) {
        self.title = title
        self.messages = []
        self.createdAt = Date()
        self.agentType = agentType
        self.model = model
    }
    
    var lastMessage: Message? {
        return messages.last
    }
    
    var lastMessageTime: Date? {
        return lastMessage?.timestamp
    }
}