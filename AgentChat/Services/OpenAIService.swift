//
//  OpenAIService.swift
//  AgentChat
//
//  Created by Mario Moschetta on 14/07/25.
//

import Foundation

class OpenAIService {
    private let baseURL = "https://api.openai.com/v1/chat/completions"
    
    func sendMessage(_ message: String, model: String) async throws -> String {
        guard let apiKey = try KeychainService.shared.getAPIKey(for: "openai") else {
            throw ChatServiceError.invalidAPIKey
        }
        
        let request = OpenAIRequest(
            model: model,
            messages: [OpenAIMessage(role: "user", content: message)]
        )
        
        var urlRequest = URLRequest(url: URL(string: baseURL)!)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try JSONEncoder().encode(request)
        
        do {
            let (data, _) = try await URLSession.shared.data(for: urlRequest)
            let response = try JSONDecoder().decode(OpenAIResponse.self, from: data)
            
            guard let content = response.choices.first?.message.content else {
                throw ChatServiceError.invalidResponse
            }
            
            return content
        } catch {
            throw ChatServiceError.networkError(error)
        }
    }
}

struct OpenAIRequest: Codable {
    let model: String
    let messages: [OpenAIMessage]
}

struct OpenAIMessage: Codable {
    let role: String
    let content: String
}

struct OpenAIResponse: Codable {
    let choices: [OpenAIChoice]
}

struct OpenAIChoice: Codable {
    let message: OpenAIMessage
}