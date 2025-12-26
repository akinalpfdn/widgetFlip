import AppIntents
import WidgetKit
import SwiftUI

struct FlipCoinIntent: AppIntent {
    static var title: LocalizedStringResource = "Flip Coin"
    
    init() {}

    func perform() async throws -> some IntentResult {
        let isHeads = Bool.random()
        let resultString = isHeads ? "HEADS" : "TAILS"
        let iconString = isHeads ? "crown.fill" : "shield.fill"
        
        // Access the shared App Group
        if let sharedDefaults = UserDefaults(suiteName: "group.com.akinalpfdn.widgetflip") {
            
            // 1. Save current state for the Widget to display
            sharedDefaults.set(resultString, forKey: "coinSide")
            sharedDefaults.set(iconString, forKey: "coinIcon")
            sharedDefaults.set(Date().timeIntervalSince1970, forKey: "lastFlipTime")
            
            // 2. Append to History for the Main App
            var history = sharedDefaults.stringArray(forKey: "flipHistory") ?? []
            let timestamp = Date().formatted(date: .abbreviated, time: .shortened)
            let entry = "\(resultString) - \(timestamp)"
            
            // Insert at the top of the list
            history.insert(entry, at: 0)
            
            // Keep only the last 50 entries to save space
            if history.count > 50 { history = Array(history.prefix(50)) }
            
            sharedDefaults.set(history, forKey: "flipHistory")
        }
        
        return .result()
    }
}
