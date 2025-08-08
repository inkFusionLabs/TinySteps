//
//  ChatModels.swift
//  TinySteps
//
//  Created by inkfusionlabs on 08/07/2025.
//

import Foundation
import SwiftUI

// MARK: - Chat Models

struct ChatMessage: Identifiable, Codable {
    let id: UUID
    let senderId: String
    let senderName: String
    let senderAvatar: String?
    let content: String
    let timestamp: Date
    let messageType: MessageType
    let isRead: Bool
    let status: MessageStatus
    
    enum MessageType: String, Codable {
        case text
        case image
        case advice
        case support
    }
    
    enum MessageStatus: String, Codable {
        case sent = "sent"
        case delivered = "delivered"
        case read = "read"
        
        var icon: String {
            switch self {
            case .sent: return "checkmark"
            case .delivered: return "checkmark.circle"
            case .read: return "checkmark.circle.fill"
            }
        }
        
        var color: Color {
            switch self {
            case .sent: return .gray
            case .delivered: return .blue
            case .read: return .green
            }
        }
    }
    
    init(senderId: String, senderName: String, senderAvatar: String? = nil, content: String, messageType: MessageType = .text) {
        self.id = UUID()
        self.senderId = senderId
        self.senderName = senderName
        self.senderAvatar = senderAvatar
        self.content = content
        self.timestamp = Date()
        self.messageType = messageType
        self.isRead = false
        self.status = .sent
    }
}

struct ChatRoom: Identifiable, Codable {
    let id: UUID
    let name: String
    let description: String
    let category: ChatCategory
    let participants: [String] // User IDs
    let lastMessage: ChatMessage?
    let lastActivity: Date
    let isActive: Bool
    
    enum ChatCategory: String, Codable, CaseIterable {
        case general = "General"
        case newborns = "Newborns (0-3 months)"
        case infants = "Infants (3-12 months)"
        case toddlers = "Toddlers (1-3 years)"
        case sleep = "Sleep Support"
        case feeding = "Feeding & Nutrition"
        case health = "Health & Safety"
        case activities = "Activities & Play"
        case relationships = "Relationships"
        case mentalHealth = "Mental Health"
        
        var icon: String {
            switch self {
            case .general: return "bubble.left.and.bubble.right"
            case .newborns: return "baby"
            case .infants: return "figure.and.child.holdinghands"
            case .toddlers: return "figure.walk"
            case .sleep: return "bed.double"
            case .feeding: return "fork.knife"
            case .health: return "heart"
            case .activities: return "gamecontroller"
            case .relationships: return "heart.circle"
            case .mentalHealth: return "brain.head.profile"
            }
        }
        
        var color: Color {
            switch self {
            case .general: return .blue
            case .newborns: return .pink
            case .infants: return .orange
            case .toddlers: return .green
            case .sleep: return .purple
            case .feeding: return .yellow
            case .health: return .red
            case .activities: return .mint
            case .relationships: return .pink
            case .mentalHealth: return .indigo
            }
        }
    }
    
    init(name: String, description: String, category: ChatCategory, participants: [String] = []) {
        self.id = UUID()
        self.name = name
        self.description = description
        self.category = category
        self.participants = participants
        self.lastMessage = nil
        self.lastActivity = Date()
        self.isActive = true
    }
}

struct UserProfile: Identifiable, Codable {
    let id: String
    let name: String
    let avatar: String?
    let location: String?
    let babyAge: String?
    let interests: [String]
    let joinDate: Date
    let isOnline: Bool
    let lastSeen: Date
    
    init(id: String, name: String, avatar: String? = nil, location: String? = nil, babyAge: String? = nil, interests: [String] = []) {
        self.id = id
        self.name = name
        self.avatar = avatar
        self.location = location
        self.babyAge = babyAge
        self.interests = interests
        self.joinDate = Date()
        self.isOnline = false
        self.lastSeen = Date()
    }
}

// MARK: - Chat Manager

class ChatManager: ObservableObject {
    @Published var chatRooms: [ChatRoom] = []
    @Published var currentRoom: ChatRoom?
    @Published var messages: [ChatMessage] = []
    @Published var userProfile: UserProfile?
    @Published var isConnected = false
    
    private let userId = UUID().uuidString
    
    init() {
        setupDefaultRooms()
        setupUserProfile()
    }
    
    private func setupDefaultRooms() {
        chatRooms = [
            ChatRoom(name: "New Dads Welcome", description: "A safe space for new dads to ask questions and share experiences", category: .general),
            ChatRoom(name: "Sleep Struggles", description: "Tips and support for getting your little one to sleep", category: .sleep),
            ChatRoom(name: "Feeding Adventures", description: "From bottles to solids - share your feeding journey", category: .feeding),
            ChatRoom(name: "Newborn Support", description: "First-time dads with newborns (0-3 months)", category: .newborns),
            ChatRoom(name: "Mental Health Check", description: "Supporting each other's mental health and wellbeing", category: .mentalHealth),
            ChatRoom(name: "Activities & Play", description: "Creative ideas for engaging with your little one", category: .activities),
            ChatRoom(name: "Health & Safety", description: "Medical questions and safety concerns", category: .health),
            ChatRoom(name: "Toddler Life", description: "Dads with toddlers (1-3 years)", category: .toddlers)
        ]
    }
    
    private func setupUserProfile() {
        userProfile = UserProfile(
            id: userId,
            name: "Dad",
            avatar: nil,
            location: "UK",
            babyAge: "6 months",
            interests: ["Sleep", "Feeding", "Activities"]
        )
    }
    
    func joinRoom(_ room: ChatRoom) {
        currentRoom = room
        loadMessages(for: room)
        isConnected = true
    }
    
    func leaveRoom() {
        currentRoom = nil
        messages.removeAll()
        isConnected = false
    }
    
    func sendMessage(_ content: String, type: ChatMessage.MessageType = .text) {
        guard let _ = currentRoom, let profile = userProfile else { return }
        
        let message = ChatMessage(
            senderId: profile.id,
            senderName: profile.name,
            senderAvatar: profile.avatar,
            content: content,
            messageType: type
        )
        
        messages.append(message)
        
        // Simulate other users responding
        DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 2...8)) {
            self.simulateResponse()
        }
    }
    
    private func loadMessages(for room: ChatRoom) {
        // Simulate loading existing messages
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
} 