import SwiftUI
import WidgetKit

struct ContentView: View {
    let sharedDefaults = UserDefaults(suiteName: "group.com.akinalpfdn.widgetflip")
    
    @State private var history: [String] = []
    @State private var coinSide: String = "HEADS"
    @State private var rotation: Double = 0
    @State private var isFlipping = false
    @State private var showParticles = false
    
    // Gradients
    let darkGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color(red: 0.1, green: 0.1, blue: 0.12),
            Color(red: 0.05, green: 0.05, blue: 0.06)
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    let goldGradient = LinearGradient(
        gradient: Gradient(colors: [.yellow, .orange]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    let silverGradient = LinearGradient(
        gradient: Gradient(colors: [Color(white: 0.9), Color(white: 0.6)]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    var body: some View {
        ZStack {
            darkGradient.ignoresSafeArea()
            
            VStack {
                Spacer()
                
                // MAIN COIN
                ZStack {
                    // Glow
                    Circle()
                        .fill(coinSide == "HEADS" ? Color.orange.opacity(0.4) : Color.blue.opacity(0.4))
                        .frame(width: 220, height: 220)
                        .blur(radius: 30)
                    
                    // Coin
                    Circle()
                        .fill(coinSide == "HEADS" ? goldGradient : silverGradient)
                        .frame(width: 200, height: 200)
                        .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 10)
                        .overlay(
                            Circle()
                                .strokeBorder(
                                    LinearGradient(
                                        gradient: Gradient(colors: [.white.opacity(0.8), .clear, .black.opacity(0.5)]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 4
                                )
                        )
                    
                    Image(systemName: coinSide == "HEADS" ? "crown.fill" : "shield.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 2)
                }
                .rotation3DEffect(.degrees(rotation), axis: (x: 1, y: 0, z: 0))
                .onTapGesture {
                    flipCoin()
                }
                .sensoryFeedback(.impact(weight: .heavy), trigger: rotation)
                
                Spacer()
                
                // HISTORY
                VStack(alignment: .leading, spacing: 10) {
                    Text("RECENT FLIPS")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(history, id: \.self) { item in
                                VStack {
                                    Image(systemName: item.contains("HEADS") ? "crown.fill" : "shield.fill")
                                        .font(.title2)
                                        .foregroundStyle(item.contains("HEADS") ? .orange : .gray)
                                    Text(item.components(separatedBy: " - ").first ?? "FLIP")
                                        .font(.caption2)
                                        .fontWeight(.bold)
                                        .foregroundStyle(.white)
                                }
                                .padding()
                                .background(Color.white.opacity(0.05))
                                .cornerRadius(12)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .frame(height: 120)
                .padding(.bottom, 20)
            }
            
            // Particle Effect Overlay
            if showParticles {
                ParticleView()
            }
        }
        .onAppear { loadHistory() }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            loadHistory()
        }
    }
    
    func flipCoin() {
        guard !isFlipping else { return }
        isFlipping = true
        showParticles = false
        
        // Prepare result
        let isHeads = Bool.random()
        let result = isHeads ? "HEADS" : "TAILS"
        let icon = isHeads ? "crown.fill" : "shield.fill"
        
        // Animate
        withAnimation(.interpolatingSpring(stiffness: 100, damping: 10)) {
            rotation += 1080 // 3 spins
        }
        
        // Delay state update to middle of spin
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            coinSide = result
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            isFlipping = false
            if isHeads { showParticles = true } 
            saveResult(side: result, icon: icon)
        }
    }
    
    func saveResult(side: String, icon: String) {
        sharedDefaults?.set(side, forKey: "coinSide")
        sharedDefaults?.set(icon, forKey: "coinIcon")
        sharedDefaults?.set(Date().timeIntervalSince1970, forKey: "lastFlipTime")
        
        let timestamp = Date().formatted(date: .abbreviated, time: .shortened)
        let entry = "\(side) - \(timestamp)"
        history.insert(entry, at: 0)
        if history.count > 50 { history = Array(history.prefix(50)) }
        sharedDefaults?.set(history, forKey: "flipHistory")
        
        // Reload widget timeline
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    func loadHistory() {
        history = sharedDefaults?.stringArray(forKey: "flipHistory") ?? []
        coinSide = sharedDefaults?.string(forKey: "coinSide") ?? "HEADS"
    }
}

// Simple Particle Effect Implementation
struct ParticleView: View {
    @State private var time = 0.0
    
    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                let now = timeline.date.timeIntervalSinceReferenceDate
                let angle = Angle.degrees(now * 100)
                let x = size.width / 2
                let y = size.height / 2
                
                for i in 0..<20 {
                    let offset = Double(i) * 20
                    let _ = context.draw(
                        Image(systemName: "star.fill"),
                        at: CGPoint(
                            x: x + cos(angle.radians + offset) * 100,
                            y: y + sin(angle.radians + offset) * 100
                        )
                    )
                }
            }
        }
        .foregroundStyle(.yellow)
        .opacity(0.8)
        .allowsHitTesting(false)
        .mask(
            RadialGradient(colors: [.black, .clear], center: .center, startRadius: 50, endRadius: 200)
        )
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                // Fade out handling would be here in a real particle system
            }
        }
    }
}
