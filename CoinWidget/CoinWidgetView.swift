import SwiftUI
import WidgetKit
import AppIntents

struct CoinWidgetView: View {
    var entry: CoinEntry

    var body: some View {
        GeometryReader { geo in
            ZStack {
                VStack(spacing: 16) {
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
                            .contentTransition(.symbolEffect(.replace))
                    }
                    .frame(width: 85, height: 85)
                    .rotation3DEffect(
                        .degrees(entry.id == 0 ? 0 : 360),
                        axis: (x: 0.0, y: 1.0, z: 0.0), // Y-axis spin looks more like a real coin flip
                        perspective: 0.5
                    )
                    .id(entry.id)
                    
                    // Result Text
                    Text(entry.side)
                        .font(.system(size: 14, weight: .heavy, design: .rounded))
                        .tracking(2)
                        .foregroundStyle(entry.side == "HEADS" ? Color.orange : Color(white: 0.8))
                        .contentTransition(.numericText())
                }
                .padding()
            }
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
