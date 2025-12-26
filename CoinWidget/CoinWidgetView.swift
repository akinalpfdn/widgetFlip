import SwiftUI
import WidgetKit
import AppIntents
struct CoinWidgetView: View {
    var entry: CoinEntry

    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Background Gradient
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                
                VStack(spacing: 12) {
                    // Coin Visual
                    ZStack {
                        Circle()
                            .fill(entry.side == "HEADS" ? Color.orange : Color.gray)
                            .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 4)
                        
                        Circle()
                            .strokeBorder(Color.white.opacity(0.5), lineWidth: 4)
                        
                        Image(systemName: entry.iconName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 35, height: 35)
                            .foregroundColor(.white)
                            .contentTransition(.symbolEffect(.replace)) // iOS 17 animation
                    }
                    .frame(width: 80, height: 80)
                    // Animation: Rotate effect based on ID change
                    .rotation3DEffect(
                        .degrees(entry.id == 0 ? 0 : 360), // Simple visual trigger
                        axis: (x: 1.0, y: 0.0, z: 0.0)
                    )
                    .id(entry.id) // Forces view refresh for transition
                    
                    // Result Text
                    Text(entry.side)
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundStyle(.primary)
                        .contentTransition(.numericText()) // Smooth text transition
                }
                .padding()
            }
            // Make the whole widget tappable
            .widgetURL(nil) // Disable opening app on tap
        }
        // Button overlays the entire view for interactivity
        .overlay {
            Button(intent: FlipCoinIntent()) {
                // Empty view, the button is just the hit area
                Color.clear
            }
            .buttonStyle(.plain)
        }
    }
}
