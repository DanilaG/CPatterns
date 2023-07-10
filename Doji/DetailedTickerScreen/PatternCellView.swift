import SwiftUI

struct PatternCellView: View {
    var patternViewData: PatternViewData
    let infoAction: () -> Void

    var body: some View {
        Group {
            HStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text(patternViewData.title)
                            .font(.title2)
                            .foregroundColor(patternViewData.isSelected ? Color.blueMain : .black)
                        Spacer()
                        Text(patternViewData.dateInterval)
                            .font(Font.subheadline)
                            .foregroundColor(patternViewData.isSelected ? Color.blueMain : .gray500)
                    }
                    Spacer()
                    Button(action: infoAction, label: {
                        Image(systemName: "questionmark.circle")
                            .imageScale(.large)
                            .foregroundColor(patternViewData.isSelected ? Color.blueMain : .gray500)
                    }).buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 16.0)
                .stroke(patternViewData.isSelected ? Color.blueMain : Color.stroke, lineWidth: 1)
        )
        .addBorder(patternViewData.isSelected ? Color.blueMain : Color.stroke, width: 1, cornerRadius: 16.0)
        .shadow(color: .shadow, radius: 8, y: 4)
        .padding(.horizontal, 16.0)
    }
}

private extension PatternViewData {
    var formatedProbability: String {
        " \(Int(prediction.probability * 100))%"
    }
}
