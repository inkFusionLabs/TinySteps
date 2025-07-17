import Foundation
import SwiftUI

public struct UserAvatar: Codable, Equatable {
    public var hairStyle: HairStyle = .short
    public var hairColor: HairColor = .brown
    public var eyeColor: EyeColor = .brown
    public var skinTone: SkinTone = .medium
    public var facialHair: FacialHair = .none
    public var glasses: Bool = false
    public var accessories: [Accessory] = []
    
    public init() {}
    
    public enum HairStyle: String, CaseIterable, Codable {
        case short = "Short"
        case medium = "Medium"
        case long = "Long"
        case bald = "Bald"
        case curly = "Curly"
        case spiky = "Spiky"
        
        var icon: String {
            switch self {
            case .short: return "person.crop.circle"
            case .medium: return "person.crop.circle.fill"
            case .long: return "person.crop.circle.badge.plus"
            case .bald: return "person.crop.circle.badge.minus"
            case .curly: return "person.crop.circle.badge.checkmark"
            case .spiky: return "person.crop.circle.badge.exclamationmark"
            }
        }
    }
    
    public enum HairColor: String, CaseIterable, Codable {
        case black = "Black"
        case brown = "Brown"
        case blonde = "Blonde"
        case red = "Red"
        case gray = "Gray"
        case white = "White"
        
        var color: Color {
            switch self {
            case .black: return .black
            case .brown: return Color(red: 0.4, green: 0.2, blue: 0.0)
            case .blonde: return Color(red: 0.9, green: 0.8, blue: 0.6)
            case .red: return Color(red: 0.8, green: 0.2, blue: 0.0)
            case .gray: return .gray
            case .white: return .white
            }
        }
    }
    
    public enum EyeColor: String, CaseIterable, Codable {
        case brown = "Brown"
        case blue = "Blue"
        case green = "Green"
        case hazel = "Hazel"
        case gray = "Gray"
        
        var color: Color {
            switch self {
            case .brown: return Color(red: 0.4, green: 0.2, blue: 0.0)
            case .blue: return .blue
            case .green: return .green
            case .hazel: return Color(red: 0.6, green: 0.4, blue: 0.2)
            case .gray: return .gray
            }
        }
    }
    
    public enum SkinTone: String, CaseIterable, Codable {
        case light = "Light"
        case medium = "Medium"
        case dark = "Dark"
        case tan = "Tan"
        
        var color: Color {
            switch self {
            case .light: return Color(red: 0.9, green: 0.8, blue: 0.7)
            case .medium: return Color(red: 0.8, green: 0.6, blue: 0.5)
            case .dark: return Color(red: 0.4, green: 0.3, blue: 0.2)
            case .tan: return Color(red: 0.9, green: 0.7, blue: 0.5)
            }
        }
    }
    
    public enum FacialHair: String, CaseIterable, Codable {
        case none = "None"
        case stubble = "Stubble"
        case beard = "Beard"
        case mustache = "Mustache"
        case goatee = "Goatee"
        
        var icon: String {
            switch self {
            case .none: return "person.crop.circle"
            case .stubble: return "person.crop.circle.badge.plus"
            case .beard: return "person.crop.circle.badge.checkmark"
            case .mustache: return "person.crop.circle.badge.exclamationmark"
            case .goatee: return "person.crop.circle.badge.minus"
            }
        }
    }
    
    public enum Accessory: String, CaseIterable, Codable {
        case hat = "Hat"
        case scarf = "Scarf"
        case tie = "Tie"
        case necklace = "Necklace"
        case earrings = "Earrings"
        
        var icon: String {
            switch self {
            case .hat: return "crown"
            case .scarf: return "scarf"
            case .tie: return "tie"
            case .necklace: return "circle"
            case .earrings: return "circle.fill"
            }
        }
    }
} 