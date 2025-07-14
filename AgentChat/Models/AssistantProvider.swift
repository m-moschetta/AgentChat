//
//  AssistantProvider.swift
//  AgentChat
//
//  Created by Mario Moschetta on 14/07/25.
//

import Foundation

struct AssistantProvider: Identifiable, Codable {
    let id = UUID()
    let type: AgentType
    let name: String
    let baseURL: String
    let models: [String]
    
    init(type: AgentType, name: String, baseURL: String, models: [String]) {
        self.type = type
        self.name = name
        self.baseURL = baseURL
        self.models = models
    }
}