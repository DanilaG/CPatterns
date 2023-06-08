import SwiftUI

struct PatternCellView: View {
    var patternViewData: PatternViewData

    var body: some View {
        Group {
            HStack {
                VStack(alignment: .leading) {
                    Text(patternViewData.title)
                        .font(.title2)
                        .foregroundColor(patternViewData.isSelected ? Color.blueMain : .black)
                    Text(patternViewData.dateInterval)
                        .font(Font.subheadline)
                        .foregroundColor(patternViewData.isSelected ? Color.blueMain : .gray500)
                }
                Spacer()
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
