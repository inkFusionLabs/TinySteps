//
//  TipsManager.swift
//  TinySteps
//
//  Provides localized micro-tips and a deterministic tip-of-the-day.
//

import Foundation

enum TipsManager {
    static func allTips() -> [String] {
        // Localized short tips
        return [
            NSLocalizedString("tip.breathe.box", comment: "Box breathing tip"),
            NSLocalizedString("tip.micro.walk", comment: "Short walk tip"),
            NSLocalizedString("tip.hydration", comment: "Hydration tip"),
            NSLocalizedString("tip.ask.questions", comment: "Ask questions tip"),
            NSLocalizedString("tip.skin.to.skin", comment: "Skin-to-skin tip"),
            NSLocalizedString("tip.note.small.wins", comment: "Note small wins tip"),
            NSLocalizedString("tip.rest.catnap", comment: "Catnap tip"),
        ].filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
    }
    
    static func tipOfTheDay(for date: Date = Date()) -> String? {
        let tips = allTips()
        guard !tips.isEmpty else { return nil }
        let dayIndex = Calendar.current.ordinality(of: .day, in: .year, for: date) ?? 1
        return tips[(dayIndex - 1) % tips.count]
    }
}









