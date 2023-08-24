//
//  SwiftUIWidgetExtensionLiveActivity.swift
//  SwiftUIWidgetExtension
//
//

import ActivityKit
import WidgetKit
import SwiftUI

struct SwiftUIWidgetExtensionAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct SwiftUIWidgetExtensionLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: SwiftUIWidgetExtensionAttributes.self) { context in
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

extension SwiftUIWidgetExtensionAttributes {
    fileprivate static var preview: SwiftUIWidgetExtensionAttributes {
        SwiftUIWidgetExtensionAttributes(name: "World")
    }
}

extension SwiftUIWidgetExtensionAttributes.ContentState {
    fileprivate static var smiley: SwiftUIWidgetExtensionAttributes.ContentState {
        SwiftUIWidgetExtensionAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: SwiftUIWidgetExtensionAttributes.ContentState {
         SwiftUIWidgetExtensionAttributes.ContentState(emoji: "🤩")
     }
}
//
//#Preview("Notification", as: .content, using: SwiftUIWidgetExtensionAttributes.preview) {
//   SwiftUIWidgetExtensionLiveActivity()
//} contentStates: {
//    SwiftUIWidgetExtensionAttributes.ContentState.smiley
//    SwiftUIWidgetExtensionAttributes.ContentState.starEyes
//}
