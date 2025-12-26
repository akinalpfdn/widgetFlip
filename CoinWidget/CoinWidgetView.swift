import SwiftUI
import WidgetKit
import AppIntents

struct CoinWidgetView: View {
    var entry: CoinEntry

    var body: some View {
        ZStack {
            VStack(spacing: 8) {
                // Coin Visual
                ZStack {
                    // Ambient Glow
                    Circle()
                        .fill(entry.side == "HEADS" ? Color.orange.opacity(0.3) : Color.blue.opacity(0.3))
                        .frame(width: 90, height: 90)
                        .blur(radius: 15)
                    
                    // Coin Body
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: entry.side == "HEADS" ?
                                    [Color.yellow, Color.orange] :
                                    [Color(white: 0.9), Color(white: 0.6)]
                                ),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 5)
                        .overlay(
                            Circle()
                                .strokeBorder(
                                    LinearGradient(
                                        gradient: Gradient(colors: [.white.opacity(0.6), .clear, .black.opacity(0.3)]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 2
                                )
                        )
                    
                    // Inner Ring
                    Circle()
                        .strokeBorder(Color.black.opacity(0.1), lineWidth: 1)
                        .padding(4)
                    
                    // Icon
                    Image(systemName: entry.iconName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 40)
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.2), radius: 1, x: 0, y: 1)
                        .contentTransition(.symbolEffect(.replace.downUp.byLayer))
                }
                .frame(width: 85, height: 85)
                .rotation3DEffect(
                    .degrees(Double(entry.flipCount) * 720 + (entry.side == "HEADS" ? 0 : 180)),
                    axis: (x: 0.0, y: 1.0, z: 0.0),
                    perspective: 0.5
                )
                // This animation modifier ensures the transition happens smoothly when the entry ID updates
                .animation(.spring(response: 0.6, dampingFraction: 0.5), value: entry.id)
                
                // Result Text
                Text(entry.side)
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
