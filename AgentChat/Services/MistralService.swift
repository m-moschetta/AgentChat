//
//  MistralService.swift
//  AgentChat
//
//  Created by Mario Moschetta on 14/07/25.
//

import Foundation

class MistralService {
    private let baseURL = "https://api.mistral.ai/v1/chat/completions"
    
    func sendMessage(_ message: String, model: String) async throws -> String {
        guard let apiKey = try KeychainService.shared.getAPIKey(for: "mistral") else {
            throw ChatServiceError.invalidAPIKey
        }
        
        let request = MistralRequest(
            model: model,
            messages: [MistralMessage(role: "user", content: message)]
        )
        
        var urlRequest = URLRequest(url: URL(string: baseURL)!)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try JSONEncoder().encode(request)
        
        do {
            let (data, _) = try await URLSession.shared.data(for: urlRequest)
            let response = try JSONDecoder().decode(MistralResponse.self, from: data)
            
            guard let content = response.choices.first?.message.content else {
                throw ChatServiceError.invalidResponse
            }
            
            return content
        } catch {
            throw ChatServiceError.networkError(error)
        }
    }
}

struct MistralRequest: Codable {
    let model: String
    let messages: [MistralMessage]
}

struct MistralMessage: Codable {
    let role: String
    let content: String
}

struct MistralResponse: Codable {
    let choices: [MistralChoice]
}

struct MistralChoice: Codable {
    let message: MistralMessage
}