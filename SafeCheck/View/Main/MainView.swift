import SwiftUI

struct MainView: View {
    @ObservedObject private var vision = Vision()
    @ObservedObject private var google = Google()
    @State var isPresented: Bool = false
    @State var isPresent: Bool = false
    @State var a: Bool = false
    @State var image: UIImage?
    
    var body: some View {
        // MARK: - 배경
        ZStack {
            Color("mainColor")
                .ignoresSafeArea()
            
            // MARK: - 로고
            VStack {
                Image("main")
                    .padding(20)
                Text("CAS번호 검색")
                    .font(.title2)
                    .padding(.top,20)
                
                // MARK: - 사진 버튼
                Button(action: {
                    isPresented.toggle()
                }) {
                    VStack {
                        Image("camera")
                            .padding(10)
                        Text("사진 촬영")
                            .font(.title3)
                    }
                    .frame(maxWidth: .infinity, maxHeight: 170)
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 3)
                            .stroke(Color.gray, lineWidth: 0.5)
                    )
                }
                .buttonStyle(PlainButtonStyle())
                .fullScreenCover(isPresented: $isPresented) {
                    CameraView($image)
                }
                .onChange(of: image) { _ in
                    if let image = image {
                        vision.reText(image: image)
                    }
                }
                .padding()
                
                // MARK: - 밑
                Image("logo")
                
                Text("* 세이프서치의 CAS 번호 정보는\n화학물질정보처리시스템에서 제공하는 내용입니다.")
                
                // MARK: - 로그아웃
                Button("돌아가기") {
                    UserDefaults.standard.removeObject(forKey: "user_id")
                    isPresent.toggle()
                }
                .padding()
                .fullScreenCover(isPresented: $isPresent) {
                    LoginView()
                }
                Spacer()
                
                // MARK: - footer
                Image("footer")
                    .padding()
            }
        }
    }
}

//        if let image = image {
//            Image(uiImage: image)
//                .resizable()
//                .scaledToFit()
//                .onAppear {
//                    vision.reText(image: image)
//                }
//        }

//            Button("서버 통신") {
//                vision.informationed()
//                vision.informationedImage(image: image!)
//            }
//            .padding()
