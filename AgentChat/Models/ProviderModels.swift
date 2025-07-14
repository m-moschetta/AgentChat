//
//  ProviderModels.swift
//  AgentChat
//
//  Created by Mario Moschetta on 14/07/25.
//

import Foundation

// MARK: - Common Request/Response Models

struct APIError: Codable {
    let error: ErrorDetail
}

struct ErrorDetail: Codable {
    let message: String
    let type: String?
    let code: String?
}

// MARK: - Provider-specific Models

// OpenAI Models are already defined in OpenAIService.swift
// Anthropic Models are already defined in AnthropicService.swift
// Mistral Models are already defined in MistralService.swift
// Perplexity Models are already defined in PerplexityService.swift

// MARK: - Custom Provider Models

struct CustomProviderRequest: Codable {
    let message: String
    let model: String
    let parameters: [String: String]?
}

struct CustomProviderResponse: Codable {
    let response: String
    let status: String?
    let metadata: [String: String]?
}