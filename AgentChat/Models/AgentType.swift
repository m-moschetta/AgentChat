//
//  AgentType.swift
//  AgentChat
//
//  Created by Mario Moschetta on 14/07/25.
//

import Foundation

enum AgentType: String, CaseIterable, Codable {
    case openai = "openai"
    case anthropic = "anthropic"
    case mistral = "mistral"
    case perplexity = "perplexity"
    case n8n = "n8n"
    case custom = "custom"
    
    var displayName: String {
        switch self {
        case .openai:
            return "OpenAI"
        case .anthropic:
            return "Anthropic"
        case .mistral:
            return "Mistral"
        case .perplexity:
            return "Perplexity"
        case .n8n:
            return "N8N"
        case .custom:
            return "Custom"
        }
    }
    
    var defaultModels: [String] {
        switch self {
        case .openai:
            return ["gpt-4", "gpt-3.5-turbo", "gpt-4-turbo"]
        case .anthropic:
            return ["claude-3-opus-20240229", "claude-3-sonnet-20240229", "claude-3-haiku-20240307"]
        case .mistral:
            return ["mistral-large-latest", "mistral-medium-latest", "mistral-small-latest"]
        case .perplexity:
            return ["llama-3.1-sonar-large-128k-online", "llama-3.1-sonar-small-128k-online"]
        case .n8n:
            return ["workflow"]
        case .custom:
            return ["custom-model"]
        }
    }
}