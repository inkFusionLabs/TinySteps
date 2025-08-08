//
//  ChatService.swift
//  TinySteps
//
//  Created by inkfusionlabs on 08/07/2025.
//

import Foundation
import Combine
import SwiftUI

// MARK: - Chat Service Protocol
protocol ChatServiceProtocol: ObservableObject {
    func connect()
    func disconnect()
    func sendMessage(_ message: ChatMessage, in room: ChatRoom)
    func joinRoom(_ room: ChatRoom)
    func leaveRoom(_ room: ChatRoom)
    func createRoom(_ room: ChatRoom)
    func updateUserProfile(_ profile: UserProfile)
    func getRooms() -> AnyPublisher<[ChatRoom], Error>
    func getMessages(for room: ChatRoom) -> AnyPublisher<[ChatMessage], Error>
    func markMessagesAsRead()
}

// MARK: - Mock Chat Service Implementation
class MockChatService: ObservableObject, ChatServiceProtocol {
    @Published var currentUser: UserProfile?
    @Published var isConnected = false
    @Published var rooms: [ChatRoom] = []
    @Published var messages: [ChatMessage] = []
    @Published var currentRoom: ChatRoom?
    @Published var unreadMessageCount: Int = 0
    
    private var cancellables = Set<AnyCancellable>()
    private var messageTimer: Timer?
    
    init() {
        setupMockData()
        startUnreadMessageSimulation()
    }
    
    private func setupMockData() {
        // Create mock rooms
        rooms = [
            ChatRoom(name: "New Dads Welcome", description: "A safe space for new dads to ask questions and share experiences", category: .general),
            ChatRoom(name: "Sleep Struggles", description: "Tips and support for getting your little one to sleep", category: .sleep),
            ChatRoom(name: "Feeding Adventures", description: "From bottles to solids - share your feeding journey", category: .feeding),
            ChatRoom(name: "Newborn Support", description: "First-time dads with newborns (0-3 months)", category: .newborns),
            ChatRoom(name: "Mental Health Check", description: "Supporting each other's mental health and wellbeing", category: .mentalHealth),
            ChatRoom(name: "Activities & Play", description: "Creative ideas for engaging with your little one", category: .activities),
            ChatRoom(name: "Health & Safety", description: "Medical questions and safety concerns", category: .health),
            ChatRoom(name: "Toddler Life", description: "Dads with toddlers (1-3 years)", category: .toddlers)
        ]
        
        // Create mock user
        currentUser = UserProfile(
            id: "mock-user-id",
            name: "Dad",
            avatar: nil,
            location: "UK",
            babyAge: "6 months",
            interests: ["Sleep", "Feeding", "Activities"]
        )
    }
    
    func connect() {
        isConnected = true
    }
    
    func disconnect() {
        isConnected = false
        messageTimer?.invalidate()
        messageTimer = nil
    }
    
    func sendMessage(_ message: ChatMessage, in room: ChatRoom) {
        messages.append(message)
        
        // Simulate message status progression
        simulateMessageStatusProgression(for: message)
        
        // Simulate other users responding
        DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 2...8)) {
            self.simulateResponse()
        }
    }
    
    func joinRoom(_ room: ChatRoom) {
        currentRoom = room
        loadMockMessages(for: room)
    }
    
    func leaveRoom(_ room: ChatRoom) {
        currentRoom = nil
        messages.removeAll()
    }
    
    func createRoom(_ room: ChatRoom) {
        rooms.append(room)
    }
    
    func updateUserProfile(_ profile: UserProfile) {
        currentUser = profile
    }
    
    private func loadMockMessages(for room: ChatRoom) {
        let sampleMessages = [
            ChatMessage(senderId: "dad1", senderName: "Mike", content: "Hey everyone! New dad here with a 3-month-old. Any tips for getting her to sleep longer at night?"),
            ChatMessage(senderId: "dad2", senderName: "James", content: "Welcome Mike! We've all been there. Have you tried a consistent bedtime routine?"),
            ChatMessage(senderId: "dad3", senderName: "David", content: "White noise machine was a game changer for us. Worth trying!"),
            ChatMessage(senderId: "dad1", senderName: "Mike", content: "Thanks guys! Will definitely try the white noise machine."),
            ChatMessage(senderId: "dad4", senderName: "Tom", content: "Also, make sure the room is dark enough. Blackout curtains helped us a lot.")
        ]
        
        messages = sampleMessages
    }
    
    private func simulateResponse() {
        let responses = [
            "That's great advice!",
            "I'll definitely try that.",
            "Thanks for sharing your experience.",
            "How long did it take to see results?",
            "Anyone else have similar experiences?",
            "This is really helpful, thanks!",
            "I'm going through the same thing right now.",
            "Keep us updated on how it goes!"
        ]
        
        let randomResponse = responses.randomElement() ?? "Thanks!"
        let randomDad = ["Alex", "Chris", "Sam", "Rob", "Dan"].randomElement() ?? "Dad"
        
        let message = ChatMessage(
            senderId: "other",
            senderName: randomDad,
            content: randomResponse
        )
        
        messages.append(message)
    }
    
    func getRooms() -> AnyPublisher<[ChatRoom], Error> {
        return $rooms
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func getMessages(for room: ChatRoom) -> AnyPublisher<[ChatMessage], Error> {
        return $messages
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func markMessagesAsRead() {
        unreadMessageCount = 0
    }
    
    private func startUnreadMessageSimulation() {
        // Simulate new messages appearing periodically
        messageTimer = Timer.scheduledTimer(withTimeInterval: 30.0, repeats: true) { _ in
            DispatchQueue.main.async {
                // Randomly increase unread count
                if Bool.random() {
                    self.unreadMessageCount += Int.random(in: 1...3)
                }
            }
        }
    }
    
    private func simulateMessageStatusProgression(for message: ChatMessage) {
        // Find the message in the array and update its status
        if let index = messages.firstIndex(where: { $0.id == message.id }) {
            // Simulate delivered status after 1 second
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                if index < self.messages.count {
                    // Create a new message with delivered status
                    _ = ChatMessage(
                        senderId: self.messages[index].senderId,
                        senderName: self.messages[index].senderName,
                        senderAvatar: self.messages[index].senderAvatar,
                        content: self.messages[index].content,
                        messageType: self.messages[index].messageType
                    )
                    
                    // Note: We can't directly update the status due to struct immutability
                    // In a real app, you'd use a class or @Published property
                }
            }
            
            // Simulate read status after 3 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                if index < self.messages.count {
                    // Create a new message with read status
                    _ = ChatMessage(
                        senderId: self.messages[index].senderId,
                        senderName: self.messages[index].senderName,
                        senderAvatar: self.messages[index].senderAvatar,
                        content: self.messages[index].content,
                        messageType: self.messages[index].messageType
                    )
                    
                    // Note: We can't directly update the status due to struct immutability
                    // In a real app, you'd use a class or @Published property
                }
            }
        }
    }
}

 