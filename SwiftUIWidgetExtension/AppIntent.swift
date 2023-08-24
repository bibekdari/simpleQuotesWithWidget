//
//  AppIntent.swift
//  SwiftUIWidgetExtension
//
//

import WidgetKit
import AppIntents

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Configuration"
    static var description = IntentDescription("This is an example widget.")

    // An example configurable parameter.
    @Parameter(title: "Favorite Emoji", default: "😃")
    var favoriteEmoji: String
}

struct LikeIntent: AppIntent {
    static var title: LocalizedStringResource = "Like the quote"
    static var description = IntentDescription("Use this to denote you like the quote")

    @Parameter(title: "quote")
    var quote: String

    init(quote: String) {
        self.quote = quote
    }

    init() {}

    func perform() async throws -> some IntentResult {
        guard let userDefault = UserDefaults(suiteName: "group.widgetdatacache.com"),
              var quotes = userDefault.dictionary(forKey: "quotes") as? [String: Int],
              let weight = quotes[quote] else {
            return .result()
        }
        quotes[quote] = weight + 1
        userDefault.setValue(quotes, forKey: "quotes")
        return .result()
    }
}

struct DislikeIntent: AppIntent {
    static var title: LocalizedStringResource = "Dislike the quote"
    static var description = IntentDescription("Use this to denote you dislike the quote")

    @Parameter(title: "quote")
    var quote: String

    init(quote: String) {
        self.quote = quote
    }

    init() {
    }

    func perform() async throws -> some IntentResult {
        guard let userDefault = UserDefaults(suiteName: "group.widgetdatacache.com"),
              var quotes = userDefault.dictionary(forKey: "quotes") as? [String: Int],
              let weight = quotes[quote] else {
            return .result()
        }
        
        quotes[quote] = weight - 1
        userDefault.setValue(quotes, forKey: "quotes")
        return .result()
    }
}

struct MustShowIntent: AppIntent {
    static var title: LocalizedStringResource = "Must show the quote"
    static var description = IntentDescription("Use this to denote you want to see the quote mandatorily once a day")

    @Parameter(title: "quote")
    var quote: String

    init(quote: String) {
        self.quote = quote
    }

    init() {
    }

    func perform() async throws -> some IntentResult {
        guard let userDefault = UserDefaults(suiteName: "group.widgetdatacache.com"),
              var quotes = userDefault.dictionary(forKey: "quotes") as? [String: Int],
              let weight = quotes[quote].map({ max(0, $0) })
        else {
            return .result()
        }
        quotes[quote] = weight < 1000 ? (weight + 1000) : (weight - 1000)
        userDefault.setValue(quotes, forKey: "quotes")
        return .result()
    }
}



struct EmptyIntent: AppIntent {
    static var title: LocalizedStringResource = "Just reload the widget"
    static var description = IntentDescription("Use this to denote you want to reload widget")

    func perform() async throws -> some IntentResult {
        return .result()
    }
}

