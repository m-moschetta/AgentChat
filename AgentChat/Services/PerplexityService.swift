//
//  PerplexityService.swift
//  AgentChat
//
//  Created by Mario Moschetta on 14/07/25.
//

import Foundation

class PerplexityService {
    private let baseURL = "https://api.perplexity.ai/chat/completions"
    
    func sendMessage(_ message: String, model: String) async throws -> String {
        guard let apiKey = try KeychainService.shared.getAPIKey(for: "perplexity") else {
            throw ChatServiceError.invalidAPIKey
        }
        
        let request = PerplexityRequest(
            model: model,
            messages: [PerplexityMessage(role: "user", content: message)]
        )
        
        var urlRequest = URLRequest(url: URL(string: baseURL)!)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try JSONEncoder().encode(request)
        
        do {
            let (data, _) = try await URLSession.shared.data(for: urlRequest)
            let response = try JSONDecoder().decode(PerplexityResponse.self, from: data)
            
            guard let content = response.choices.first?.message.content else {
                throw ChatServiceError.invalidResponse
            }
            
            return content
        } catch {
            throw ChatServiceError.networkError(error)
        }
    }
}

struct PerplexityRequest: Codable {
    let model: String
    let messages: [PerplexityMessage]
}

struct PerplexityMessage: Codable {
    let role: String
    let content: String
}

struct PerplexityResponse: Codable {
    let choices: [PerplexityChoice]
}

struct PerplexityChoice: Codable {
    let message: PerplexityMessage
}