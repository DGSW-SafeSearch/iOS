import SwiftUI

struct SplashView: View {
    @State var isLoding = false
    
    var body: some View {
        ZStack(alignment: .center) {
            Image("splash")
                .resizable()
                .ignoresSafeArea()
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.isLoding.toggle()
            }
        }
        .fullScreenCover(isPresented: $isLoding) {
            LoginView()
        }
        
    }
}
