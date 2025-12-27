import SwiftUI
import WidgetKit
import AppIntents

struct CoinWidgetView: View {
    let entry: CoinEntry
    @Environment(\.widgetFamily) var family
    
    var coinSize: CGFloat {
        switch family {
        case .systemSmall, .systemMedium:
            return 85
        case .systemLarge:
            return 160
        case .systemExtraLarge:
            return 240
        @unknown default:
            return 85
        }
    }

    var body: some View {
        ZStack {
            VStack(spacing: 8) {
                // Coin Image Asset
                Image(entry.iconName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: coinSize, height: coinSize)
                    .clipShape(Circle())
                    .contentTransition(.symbolEffect(.replace.downUp.byLayer))
                    .rotation3DEffect(
                        .degrees(Double(entry.flipCount) * 720 + (entry.side == "HEADS" ? 0 : 180)),
                        axis: (x: 0.0, y: 1.0, z: 0.0),
                        perspective: 0.5
                    )
                    .animation(.spring(response: 0.6, dampingFraction: 0.5), value: entry.id)
                
                // Result Text
                Text(LocalizedStringKey(entry.side))
                    .font(.system(size: 14, weight: .heavy, design: .rounded))
                    .tracking(2)
                    .foregroundStyle(entry.side == "HEADS" ? Color.orange : Color(white: 0.8))
                    .contentTransition(.numericText())
            }
            .padding()
        }
        .widgetURL(nil)
        .overlay {
            Button(intent: FlipCoinIntent()) {
                Color.clear
            }
            .buttonStyle(.plain)
        }
    }
}
