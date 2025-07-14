//
//  UniversalAssistantService.swift
//  AgentChat
//
//  Created by Mario Moschetta on 14/07/25.
//

import Foundation

class UniversalAssistantService {
    private let openAIService = OpenAIService()
    private let anthropicService = AnthropicService()
    private let mistralService = MistralService()
    private let perplexityService = PerplexityService()
    private let n8nService = N8NService()
    
    func sendMessage(_ message: String, agentType: AgentType, model: String) async throws -> String {
        switch agentType {
        case .openai:
            return try await openAIService.sendMessage(message, model: model)
        case .anthropic:
            return try await anthropicService.sendMessage(message, model: model)
        case .mistral:
            return try await mistralService.sendMessage(message, model: model)
        case .perplexity:
            return try await perplexityService.sendMessage(message, model: model)
        case .n8n:
            return try await n8nService.sendMessage(message, model: model)
        case .custom:
            throw ChatServiceError.unsupportedProvider
        }
    }
}

enum ChatServiceError: Error, LocalizedError {
    case invalidAPIKey
    case networkError(Error)
    case invalidResponse
    case rateLimitExceeded
    case unsupportedProvider
    
    var errorDescription: String? {
        switch self {
        case .invalidAPIKey:
            return "API key non valida"
        case .networkError(let error):
            return "Errore di rete: \(error.localizedDescription)"
        case .invalidResponse:
            return "Risposta non valida dal server"
        case .rateLimitExceeded:
            return "Limite di richieste superato"
        case .unsupportedProvider:
            return "Provider non supportato"
        }
    }
}