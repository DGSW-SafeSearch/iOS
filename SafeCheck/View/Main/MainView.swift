import SwiftUI

struct MainView: View {
    @ObservedObject private var vision = Vision()
    @ObservedObject private var google = Google()
    @State var isPresented: Bool = false
    @State var isPresent: Bool = false
    @State var image: UIImage?
    
    var body: some View {
        if let image = image {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .onAppear {
                    vision.reText(image: image)
                }
        }
        Text(vision.ocrString ?? "__empty__")
        Text(vision.casNumber ?? "__empty__")
        Text(vision.unNumber ?? "__empty__")
        
        HStack {
            Button("사진 찍기") {
                isPresented.toggle()
            }
            .fullScreenCover(isPresented: $isPresented) {
                CameraView($image)
            }
            .onChange(of: image) { _ in
                if let image = image {
                    vision.reText(image: image)
                }
            }
            .padding()
            
            Button("서버 통신") {
                vision.informationed()
            }
            .padding()
        }
        
        Button("돌아가기") {
            UserDefaults.standard.removeObject(forKey: "user_id")
            isPresent.toggle()
        }
        .padding()
        .fullScreenCover(isPresented: $isPresent) {
            LoginView()
        }
    }
}