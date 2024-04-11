import SwiftUI

struct MainView: View {
    @ObservedObject private var vision = Vision()
    @State var isPresented: Bool = false
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
            Button("사진") {
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
            Button("으야") {
                vision.informationed()
            }
        }
    }
}
