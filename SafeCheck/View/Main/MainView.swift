import SwiftUI

struct MainView: View {
    @ObservedObject private var vision = Vision()
    @State var isPresented: Bool = false
    @State var isPresent: Bool = false
    @State var isPresen: Bool = false
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
                if let image = image, vision.casNumber == nil {
                    Text("정보가 없습니다")
                        .font(.title2)
                        .padding(.top,20)
                } else {
                    Text("CAS번호 검색")
                        .font(.title2)
                        .padding(.top,20)
                }
                
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
                
                if let image = image, vision.casNumber == nil {
                    Text("재촬영을 진행해주세요")
                } else {
                    Text("* 세이프서치의 CAS 번호 정보는")
                    Text("화학물질정보처리시스템에서 제공하는 내용입니다.")
                }
                
                // MARK: - 로그아웃
                Button("로그아웃") {
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
