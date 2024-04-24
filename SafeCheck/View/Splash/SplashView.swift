import SwiftUI

struct SplashView: View {
    @State var isLoding = false
    
    var body: some View {
        ZStack(alignment: .center) {
            Color("logoColor")
                .ignoresSafeArea()
            
            VStack {
                Image("splash")
                    .padding(.top, 150)
                Spacer()
            }
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
