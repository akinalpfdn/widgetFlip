import WidgetKit
import SwiftUI

struct CoinEntry: TimelineEntry {
    let date: Date
    let side: String
    let iconName: String
    let id: Double
}

struct CoinProvider: TimelineProvider {
    func placeholder(in context: Context) -> CoinEntry {
        CoinEntry(date: Date(), side: "HEADS", iconName: "crown.fill", id: 0)
    }

    func getSnapshot(in context: Context, completion: @escaping (CoinEntry) -> ()) {
        let entry = CoinEntry(date: Date(), side: "HEADS", iconName: "crown.fill", id: 0)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<CoinEntry>) -> ()) {
            // Use the shared App Group
            let defaults = UserDefaults(suiteName: "group.com.akinalpfdn.widgetflip")
            
            // Fetch data (safely unwrap with default values if empty)
            let side = defaults?.string(forKey: "coinSide") ?? "FLIP"
            let icon = defaults?.string(forKey: "coinIcon") ?? "arrow.triangle.2.circlepath"
            let lastId = defaults?.double(forKey: "lastFlipTime") ?? 0
            
            let entry = CoinEntry(date: Date(), side: side, iconName: icon, id: lastId)

            let timeline = Timeline(entries: [entry], policy: .never)
            completion(timeline)
        }
}

@main
struct CoinWidget: Widget {
    let kind: String = "CoinWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: CoinProvider()) { entry in
            CoinWidgetView(entry: entry)
                .containerBackground(for: .widget) {
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.1, green: 0.1, blue: 0.12),
                            Color(red: 0.05, green: 0.05, blue: 0.06)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                }
        }
        .configurationDisplayName("Flip Coin")
        .description("Tap to flip the coin.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

// Add a Color Set named "WidgetBackground" in Assets if you want custom colors,
// otherwise it defaults to System Background.
