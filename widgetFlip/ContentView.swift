import SwiftUI

struct ContentView: View {
    // Access the same shared defaults
    let sharedDefaults = UserDefaults(suiteName: "group.com.akinalpfdn.widgetflip")
    
    @State private var history: [String] = []

    var body: some View {
        NavigationView {
            List {
                if history.isEmpty {
                    Text("No flips yet. Add the widget and start flipping!")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(history, id: \.self) { item in
                        HStack {
                            Image(systemName: item.contains("HEADS") ? "crown.fill" : "eagle")
                                .foregroundStyle(item.contains("HEADS") ? .orange : .gray)
                            Text(item)
                        }
                    }
                }
            }
            .navigationTitle("Flip History")
            .onAppear {
                loadHistory()
            }
            // Reload history when app comes to foreground
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                loadHistory()
            }
        }
    }
    
    func loadHistory() {
        history = sharedDefaults?.stringArray(forKey: "flipHistory") ?? []
    }
}
