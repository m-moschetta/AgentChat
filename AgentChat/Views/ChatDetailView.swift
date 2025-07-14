//
//  ChatDetailView.swift
//  AgentChat
//
//  Created by Mario Moschetta on 14/07/25.
//

import SwiftUI

struct ChatDetailView: View {
    let chat: Chat
    @ObservedObject var chatService: ChatService
    @State private var messageText = ""
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    var body: some View {
        VStack {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(currentChat?.messages ?? []) { message in
                            MessageBubble(message: message)
                                .id(message.id)
                        }
                        
                        if isLoading {
                            HStack {
                                ProgressView()
                                    .scaleEffect(0.8)
                                Text("Thinking...")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Spacer()
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding()
                }
                .onChange(of: currentChat?.messages.count) { _ in
                    scrollToLastMessage(proxy: proxy)
                }
            }
            
            Divider()
            
            HStack {
                TextField("Type a message...", text: $messageText, axis: .vertical)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .lineLimit(1...5)
                
                Button("Send") {
                    sendMessage()
                }
                .disabled(messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isLoading)
            }
            .padding()
        }
        .navigationTitle(chat.title)
        .navigationBarTitleDisplayMode(.inline)
        .alert("Error", isPresented: .constant(errorMessage != nil)) {
            Button("OK") {
                errorMessage = nil
            }
        } message: {
            Text(errorMessage ?? "")
        }
    }
    
    private var currentChat: Chat? {
        chatService.chats.first { $0.id == chat.id }
    }
    
    private func scrollToLastMessage(proxy: ScrollViewProxy) {
        if let lastMessage = currentChat?.messages.last {
            withAnimation(.easeOut(duration: 0.3)) {
                proxy.scrollTo(lastMessage.id, anchor: .bottom)
            }
        }
    }
    
    private func sendMessage() {
        let text = messageText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }
        
        messageText = ""
        isLoading = true
        
        Task {
            do {
                let _ = try await chatService.sendMessage(text, to: chat)
            } catch {
                await MainActor.run {
                    errorMessage = error.localizedDescription
                }
            }
            
            await MainActor.run {
                isLoading = false
            }
        }
    }
}

struct MessageBubble: View {
    let message: Message
    
    var body: some View {
        HStack {
            if message.isUser {
                Spacer(minLength: 50)
            }
            
            VStack(alignment: message.isUser ? .trailing : .leading, spacing: 4) {
                Text(message.content)
                    .padding(12)
                    .background(message.isUser ? Color.blue : Color.gray.opacity(0.2))
                    .foregroundColor(message.isUser ? .white : .primary)
                    .cornerRadius(16)
                
                Text(message.timestamp, style: .time)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            if !message.isUser {
                Spacer(minLength: 50)
            }
        }
    }
}

#Preview {
    NavigationView {
        ChatDetailView(
            chat: Chat(title: "Test Chat", agentType: .openai, model: "gpt-4"),
            chatService: ChatService()
        )
    }
}