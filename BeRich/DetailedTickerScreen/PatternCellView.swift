import SwiftUI

struct PatternCellView: View {
    @State var patternViewData: PatternViewData

    var body: some View {
        Group {
            HStack {
                VStack(alignment: .leading) {
                    Text(patternViewData.detectedPattern.title)
                        .font(.title2)
                        .foregroundColor(.black)
                    Text(DateFormatting.patternCellDate.string(from: patternViewData.detectedPattern.startDate))
                        .font(Font.subheadline)
                        .foregroundColor(.gray500)
                }
                Spacer()
                Rectangle()
                    .foregroundColor(patternViewData.color)
                    .padding([.trailing, .top, .bottom], -30)
                    .frame(width: 52)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 16.0)
                .stroke(Color.stroke, lineWidth: 1)
        )
        .addBorder(Color.stroke, width: 0.5, cornerRadius: 16.0)
        .shadow(color: .shadow, radius: 8, y: 4)
        .padding(.horizontal, 16.0)
    }
}
