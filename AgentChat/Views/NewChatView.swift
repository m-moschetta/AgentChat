//
//  NewChatView.swift
//  AgentChat
//
//  Created by Mario Moschetta on 14/07/25.
//

import SwiftUI

struct NewChatView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var chatService: ChatService
    
    @State private var title = ""
    @State private var selectedAgentType = AgentType.openai
    @State private var selectedModel = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section("Chat Details") {
                    TextField("Chat Title", text: $title)
                }
                
                Section("AI Provider") {
                    Picker("Provider", selection: $selectedAgentType) {
                        ForEach(AgentType.allCases, id: \.self) { agentType in
                            Text(agentType.displayName).tag(agentType)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    
                    Picker("Model", selection: $selectedModel) {
                        ForEach(selectedAgentType.defaultModels, id: \.self) { model in
                            Text(model).tag(model)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
            }
            .navigationTitle("New Chat")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Create") {
                        createChat()
                    }
                    .disabled(title.isEmpty || selectedModel.isEmpty)
                }
            }
        }
        .onAppear {
            if selectedModel.isEmpty {
                selectedModel = selectedAgentType.defaultModels.first ?? ""
            }
        }
        .onChange(of: selectedAgentType) { _ in
            selectedModel = selectedAgentType.defaultModels.first ?? ""
        }
    }
    
    private func createChat() {
        let _ = chatService.createChat(title: title, agentType: selectedAgentType, model: selectedModel)
        dismiss()
    }
}

#Preview {
    NewChatView(chatService: ChatService())
}