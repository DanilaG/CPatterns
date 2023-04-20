import SwiftUI

struct PatternCellView: View {
    var detectedPattern: DetectedPattern
    let patternColors: [Color] = [.patternDarkGreen, .patternPink, .patternBlue]
    @State private var isFavourite = false

    var body: some View {
        Group {
            HStack {
                Text(detectedPattern.pattern.title)
                    .font(.title2)
                    .foregroundColor(.black)
                Spacer()
                Rectangle()
                    .foregroundColor(patternColors.randomElement())
                    .padding([.trailing, .top, .bottom], -20)
                    .frame(width: 52)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(Color.stroke,
                        lineWidth: 1)
        )
        .addBorder(Color.stroke,
                   width: 0.5,
                   cornerRadius: 24)
        .shadow(color: .shadow,
                radius: 8,
                y: 4)
        .frame(height: 42)
    }
}
