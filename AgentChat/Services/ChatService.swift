//
//  ChatService.swift
//  AgentChat
//
//  Created by Mario Moschetta on 14/07/25.
//

import Foundation

class ChatService: ObservableObject {
    @Published var chats: [Chat] = []
    private let universalService = UniversalAssistantService()
    
    init() {
        loadChats()
    }
    
    func createChat(title: String, agentType: AgentType, model: String) -> Chat {
        let chat = Chat(title: title, agentType: agentType, model: model)
        chats.append(chat)
        saveChats()
        return chat
    }
    
    func deleteChat(_ chat: Chat) {
        chats.removeAll { $0.id == chat.id }
        saveChats()
    }
    
    func sendMessage(_ content: String, to chat: Chat) async throws -> String {
        let userMessage = Message(content: content, isUser: true)
        
        if let index = chats.firstIndex(where: { $0.id == chat.id }) {
            chats[index].messages.append(userMessage)
        }
        
        let response = try await universalService.sendMessage(content, agentType: chat.agentType, model: chat.model)
        
        let assistantMessage = Message(content: response, isUser: false)
        
        if let index = chats.firstIndex(where: { $0.id == chat.id }) {
            chats[index].messages.append(assistantMessage)
            saveChats()
        }
        
        return response
    }
    
    private func saveChats() {
        if let encoded = try? JSONEncoder().encode(chats) {
            UserDefaults.standard.set(encoded, forKey: "SavedChats")
        }
    }
    
    private func loadChats() {
        if let data = UserDefaults.standard.data(forKey: "SavedChats"),
           let decoded = try? JSONDecoder().decode([Chat].self, from: data) {
            chats = decoded
        }
    }
}