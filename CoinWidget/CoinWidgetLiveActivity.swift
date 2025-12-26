//
//  CoinWidgetLiveActivity.swift
//  CoinWidget
//
//  Created by Akinalp Fidan on 27.12.2025.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct CoinWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct CoinWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: CoinWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension CoinWidgetAttributes {
    fileprivate static var preview: CoinWidgetAttributes {
        CoinWidgetAttributes(name: "World")
    }
}

extension CoinWidgetAttributes.ContentState {
    fileprivate static var smiley: CoinWidgetAttributes.ContentState {
        CoinWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: CoinWidgetAttributes.ContentState {
         CoinWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: CoinWidgetAttributes.preview) {
   CoinWidgetLiveActivity()
} contentStates: {
    CoinWidgetAttributes.ContentState.smiley
    CoinWidgetAttributes.ContentState.starEyes
}
