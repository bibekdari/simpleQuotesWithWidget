//
//  SwiftUIWidgetExtension.swift
//  SwiftUIWidgetExtension
//
//

import WidgetKit
import SwiftUI
import AppIntents

struct Provider: TimelineProvider {

    private var quotes: [String: Int]? {
        let userDefault = UserDefaults(suiteName: "group.widgetdatacache.com")
        return userDefault?.dictionary(forKey: "quotes") as? [String: Int]
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let firstQuote = quotes?.first ?? ("", 0)
        completion(SimpleEntry(date: Date(), text: firstQuote.key, type: .normal))
    }

    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), text: "My personal quotes", type: .normal)
    }

    func getTimeline(
        in context: Context,
        completion: @escaping (Timeline<SimpleEntry>) -> Void
    ) {
        let randomQuotes: [(String, Int)] = {
            guard let quotes, !quotes.isEmpty else {
                return []
            }

            var mustShowQuotes: [(String, Int)] = []
            var optionalQuotes: [(String, Int)] = []
            quotes.forEach {
                if $0.value >= 1000 {
                    mustShowQuotes.append(($0.key, $0.value))
                } else {
                    optionalQuotes.append(($0.key, $0.value))
                }
            }

            let flattenedQuotes = optionalQuotes.reduce([(String, Int)]()) { partialResult, element in
                var newResult = partialResult
                for _ in 0..<max(element.1, 1) {
                    newResult.append((element.0, element.1))
                }
                return newResult
            }

            let randomQuotes = (0..<10).compactMap { _ in
                flattenedQuotes.randomElement()
            }
            return (randomQuotes + mustShowQuotes).shuffled()
        }()

        guard !randomQuotes.isEmpty else {
            let noneEntry = SimpleEntry(
                date: Date(),
                text: "Add new quotes",
                type: .none
            )
            completion(Timeline(entries: [noneEntry], policy: .atEnd))
            return
        }

        var entries: [SimpleEntry] = []
        for i in 0 ..< randomQuotes.count {
            let entryDate = Calendar.current.date(
                byAdding: .minute,
                value: i * 30,
                to: Date()
            )!
            let (quote, weight) = randomQuotes[i]
            let entry = SimpleEntry(
                date: entryDate,
                text: quote,
                type: weight >= 1000 ? .favourite : .normal
            )
            entries.append(entry)
        }

        completion(Timeline(entries: entries, policy: .atEnd))
    }
}

struct SimpleEntry: TimelineEntry {
    enum EntryType {
        case none, favourite, normal
    }
    let date: Date
    let text: String
    let type: EntryType
}

struct SwiftUIWidgetExtensionEntryView : View {
    var entry: Provider.Entry

    @Environment(\.widgetFamily) var family

    var body: some View {
        switch family {
        case .accessoryInline:
            Text(entry.text)
                .font(.footnote)
                .widgetAccentable()
        case .systemMedium:
            VStack {
                VStack {
                    Spacer()
                    Text(entry.text)
                    Spacer()
                }
                if entry.type != .none {
                    ZStack {
                        ActionButtonsView(
                            isFavourite: entry.type == .favourite,
                            quote: entry.text
                        )
                        HStack {
                            Spacer()
                            Button(intent: EmptyIntent() ) {
                                Image(systemName: "shuffle")
                            }
                        }
                    }
                }
            }
        default :
            Text(entry.text)
                .widgetAccentable()
        }
    }
}

private struct ActionButtonsView: View {
    let isFavourite: Bool
    let quote: String

    var body: some View {
        HStack {
            if !isFavourite {
                Button(intent: LikeIntent(quote: quote)) {
                    Text("👍")
                }
                Button(intent: DislikeIntent(quote: quote)) {
                    Text("👎")
                }
            }
            Toggle("❤️", isOn: isFavourite, intent: MustShowIntent(quote: quote))
        }
    }
}

struct SwiftUIWidgetExtension: Widget {
    let kind: String = "SwiftUIWidgetExtension"

    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: kind,
            provider: Provider()
        ) { entry in
            SwiftUIWidgetExtensionEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }.supportedFamilies([
            .accessoryInline,
            .accessoryRectangular,
            .systemSmall,
            .systemMedium
        ])
    }
}

let previewEntries = [
    SimpleEntry(date: .now, text: "May you live all the days of your life.", type: .favourite),
    SimpleEntry(date: .now, text: "Life itself is the most wonderful fairy tale.", type: .normal),
    SimpleEntry(date: .now, text: "Go confidently in the direction of your dreams! Live the life you've imagined.", type: .none)
]

#Preview(as: .systemMedium, widget: {
    SwiftUIWidgetExtension()
}, timeline: {
    previewEntries[0]
    previewEntries[1]
    previewEntries[2]
})

#Preview(as: .systemMedium) {
    SwiftUIWidgetExtension()
} timeline: {
    previewEntries[0]
    previewEntries[1]
    previewEntries[2]
}

#Preview(as: .accessoryInline) {
    SwiftUIWidgetExtension()
} timeline: {
    previewEntries[0]
    previewEntries[1]
    previewEntries[2]
}

#Preview(as: .accessoryRectangular) {
    SwiftUIWidgetExtension()
} timeline: {
    previewEntries[0]
    previewEntries[1]
    previewEntries[2]
}

#Preview(as: .systemLarge) {
    SwiftUIWidgetExtension()
} timeline: {
    previewEntries[0]
    previewEntries[1]
    previewEntries[2]
}

#Preview(as: .systemExtraLarge) {
    SwiftUIWidgetExtension()
} timeline: {
    previewEntries[0]
    previewEntries[1]
    previewEntries[2]
}

#Preview(as: .systemSmall) {
    SwiftUIWidgetExtension()
} timeline: {
    previewEntries[0]
    previewEntries[1]
    previewEntries[2]
}
