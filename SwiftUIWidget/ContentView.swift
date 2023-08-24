//
//  ContentView.swift
//  SwiftUIWidget
//
//

import SwiftUI
import WidgetKit

struct ContentView: View {
    @State private var text: String = ""
    @FocusState private var textIsFocused: Bool

    @State private var quotes: [(String, Int)]

    init(quotes: [(String, Int)] = ContentView.quotes()) {
        self.quotes = quotes
    }

    var body: some View {
        VStack {
            HStack {
                TextField(text: $text, prompt: Text("Enter some test"), label: {})
                    .onSubmit {
                        save()
                    }
                    .focused($textIsFocused)
                    .padding()
                    .border(Color.black, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                Button("Done", action: save)
            }
            Button(action: {
                self.quotes = ContentView.quotes()
            }, label: {
                Image(systemName: "arrow.triangle.2.circlepath")
                    .padding()
            })
            List($quotes, id: \.0) { quote in
                HStack {
                    Text(quote.wrappedValue.0)
                    Spacer()
                    Text("\(quote.wrappedValue.1)")
                        .foregroundStyle(.white)
                        .padding(.minimum(4, 8))
                        .background(.gray)
                        .background(in: .capsule)
                }
            }
            .refreshable {
                self.quotes = ContentView.quotes()
            }
        }
        .padding()
    }

    private func save() {
        guard !text.isEmpty else {
            return
        }
        textIsFocused = false
        if Self.save(quote: text) {
            quotes.insert((text, 100), at: 0)
            text = ""
        }
    }

    private static func save(quote: String) -> Bool {
        guard let userDefault = UserDefaults(suiteName: "group.widgetdatacache.com")
        else {
            print("FAILED")
            return false
        }
        var quotes = userDefault.dictionary(forKey: "quotes") as? [String: Int] ?? [:]
        quotes[quote] = 100
        userDefault.setValue(quotes, forKey: "quotes")
        WidgetCenter.shared.reloadAllTimelines()
        return true
    }

    private static func quotes() -> [(String, Int)] {
        guard let userDefault = UserDefaults(suiteName: "group.widgetdatacache.com"),
              let quotes = userDefault.dictionary(forKey: "quotes") as? [String: Int]
        else {
            return []
        }
        return quotes
            .sorted {
                $0.value > $1.value
            }
    }
}

#Preview {
    ContentView(
        quotes: [
            ("Go confidently in the direction of your dreams! Live the life you've imagined.", 100),
            ("Life itself is the most wonderful fairy tale.", 1000)
        ]
    )
}
