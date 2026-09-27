import SwiftUI
import StoreKit
import WidgetKit

struct ContentView: View {
    let sharedDefaults = UserDefaults(suiteName: "group.com.akinalpfdn.widgetflip")
    let reviewFlipThreshold = 10

    @State private var history: [String] = []
    @State private var coinSide: String = "HEADS"
    @State private var rotation: Double = 0
    @State private var isFlipping = false
    @State private var isShowingWidgetGuide = false
    @State private var isShowingSupport = false
    @AppStorage("hasSeenWidgetSetupGuide") private var hasSeenWidgetSetupGuide = false
    @AppStorage("lastReviewRequestVersion") private var lastReviewRequestVersion = ""
    @Environment(\.requestReview) private var requestReview

    
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
            
            // Portrait image fixed to the device; see FixedBackground for how it stays still during rotation.
            FixedBackground(imageName: "AppBackground")
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Button {
                        isShowingSupport = true
                    } label: {
                        Image(systemName: "star.fill")
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundStyle(.orange)
                            .frame(width: 50, height: 50)
                            .background(.black.opacity(0.4), in: Circle())
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Support Widget Flip")

                    Spacer()
                    Button {
                        isShowingWidgetGuide = true
                    } label: {
                        Label("How to add a widget", systemImage: "square.grid.2x2")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(.orange)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(.black.opacity(0.4), in: Capsule())
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal)
                .padding(.top, 8)

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
                            // Entries repeat (same side within the same minute), so identify them by position
                            ForEach(Array(history.enumerated()), id: \.offset) { _, item in
                                VStack {
                                    Image(decorative: item.contains("HEADS") ? "HeadsImage" : "TailsImage")
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
        .task {
            if !hasSeenWidgetSetupGuide {
                isShowingWidgetGuide = true
            }
        }
        .sheet(isPresented: $isShowingWidgetGuide, onDismiss: {
            hasSeenWidgetSetupGuide = true
        }) {
            WidgetSetupGuideView()
        }
        .sheet(isPresented: $isShowingSupport) {
            SupportView()
        }
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

        // Count every flip (app and widget) for the review prompt
        let totalFlips = (sharedDefaults?.integer(forKey: "totalFlips") ?? 0) + 1
        sharedDefaults?.set(totalFlips, forKey: "totalFlips")

        // Reload widget timeline
        WidgetCenter.shared.reloadAllTimelines()

        requestReviewIfNeeded(totalFlips: totalFlips)
    }

    // Asks once per app version, right after a finished flip; iOS decides whether the prompt actually shows.
    func requestReviewIfNeeded(totalFlips: Int) {
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
        guard totalFlips >= reviewFlipThreshold, lastReviewRequestVersion != version else { return }
        lastReviewRequestVersion = version
        requestReview()
    }

    func loadHistory() {
        history = sharedDefaults?.stringArray(forKey: "flipHistory") ?? []
        coinSide = sharedDefaults?.string(forKey: "coinSide") ?? "HEADS"
    }
}

