import SwiftUI
import WidgetKit

struct ContentView: View {
    let sharedDefaults = UserDefaults(suiteName: "group.com.akinalpfdn.widgetflip")
    
    @State private var history: [String] = []
    @State private var coinSide: String = "HEADS"
    @State private var rotation: Double = 0
    @State private var isFlipping = false

    
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
            
            Image("WidgetBackground")
                .resizable() 
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                // MAIN COIN
                Image(coinSide == "HEADS" ? "HeadsImage" : "TailsImage")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 200, height: 200)
                    .clipShape(Circle())
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
                                    Image(item.contains("HEADS") ? "HeadsImage" : "TailsImage")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 24, height: 24)
                                        // Removed font() and foregroundStyle()modifiers
                                    Text(LocalizedStringKey(item.components(separatedBy: " - ").first ?? "FLIP"))
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
            
        }
        .onAppear { loadHistory() }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            loadHistory()
        }
    }
    
    func flipCoin() {
        guard !isFlipping else { return }
        isFlipping = true
        
        // Prepare result
        let isHeads = Bool.random()
        let result = isHeads ? "HEADS" : "TAILS"
        let icon = isHeads ? "HeadsImage" : "TailsImage"
        
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


