import SwiftUI

struct PatternListView: View {
    @State var patterns: [Pattern] = Fakes.patterns

    init(patterns: [Pattern]) {
        self.patterns = patterns
    }

    var body: some View {
        VStack {
            NavigationView {
                List {
                    ForEach(patterns) { pattern in
                        PatternCellView(pattern: pattern)
                            .listRowSeparator(.hidden)
                            .onTapGesture {
                                print(pattern.id)
                            }
                    }
                }
                .listStyle(.plain)
            }
        }
    }
}
