//
//  AnthropicService.swift
//  AgentChat
//
//  Created by Mario Moschetta on 14/07/25.
//

import Foundation

class AnthropicService {
    private let baseURL = "https://api.anthropic.com/v1/messages"
    
    func sendMessage(_ message: String, model: String) async throws -> String {
        guard let apiKey = try KeychainService.shared.getAPIKey(for: "anthropic") else {
            throw ChatServiceError.invalidAPIKey
        }
        
        let request = AnthropicRequest(
            model: model,
            max_tokens: 1024,
            messages: [AnthropicMessage(role: "user", content: message)]
        )
        
        var urlRequest = URLRequest(url: URL(string: baseURL)!)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue(apiKey, forHTTPHeaderField: "x-api-key")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("2023-06-01", forHTTPHeaderField: "anthropic-version")
        urlRequest.httpBody = try JSONEncoder().encode(request)
        
        do {
            let (data, _) = try await URLSession.shared.data(for: urlRequest)
            let response = try JSONDecoder().decode(AnthropicResponse.self, from: data)
            
            guard let content = response.content.first?.text else {
                throw ChatServiceError.invalidResponse
            }
            
            return content
        } catch {
            throw ChatServiceError.networkError(error)
        }
    }
}

struct AnthropicRequest: Codable {
    let model: String
    let max_tokens: Int
    let messages: [AnthropicMessage]
}

struct AnthropicMessage: Codable {
    let role: String
    let content: String
}

struct AnthropicResponse: Codable {
    let content: [AnthropicContent]
}

struct AnthropicContent: Codable {
    let text: String
}