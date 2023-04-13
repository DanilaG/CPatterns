import SwiftUI

struct SplashView: View {
    @State var isActive: Bool = false

    var body: some View {
        VStack {
            if isActive {
                ListScreen()
            } else {
                Image("logo.splash")
                    .resizable()
                    .scaledToFit()
                    .padding(32)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation {
                    isActive = true
                }
            }
        }
    }
}
