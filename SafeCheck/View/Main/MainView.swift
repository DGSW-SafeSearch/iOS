import SwiftUI

struct MainView: View {
    @ObservedObject var vision = Vision()
    @State var isPresented: Bool = false
    @State var isPresent: Bool = false
    @State var image: UIImage?
    
    var body: some View {
        // MARK: - 배경
        ZStack(alignment: .center) {
            Color("mainColor")
                .ignoresSafeArea()
            
            // MARK: - ProgressView
            if vision.isProgress == true {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                    .scaleEffect(2.0)
            }
            
            // MARK: - 로고
            VStack {
                Image("main")
                    .padding(20)
                
                if vision.information?.res == "0" {
                    Text("정보가 없습니다")
                        .foregroundColor(.black)
                        .font(.title2)
                        .padding(.top, 20)
                } else {
                    Text("CAS번호 검색")
                        .foregroundColor(.black)
                        .font(.title2)
                        .padding(.top, 20)
                }
                
                // MARK: - 사진 버튼
                Button(action: {
                    vision.information = nil
                    isPresented.toggle()
                }) {
                    VStack {
                        Image("camera")
                            .padding(10)
                        Text("사진 촬영")
                            .foregroundColor(.black)
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
                .onChange(of: image) { newImage in
                    if let newImage = newImage {
                        vision.isProgress.toggle()
                        vision.reText(image: newImage)
                        vision.informationed()
                    }
                }
                .padding()
                
                // MARK: - 밑
                if vision.information?.res == "100" {
                    Text("재촬영을 진행해주세요")
                        .foregroundColor(.black)
                } else {
                    Image("logo")
                        .padding()
                    Text("* 세이프서치의 CAS 번호 정보는")
                        .foregroundColor(.black)
                    Text("화학물질정보처리시스템에서 제공하는 내용입니다.")
                        .foregroundColor(.black)
                }
                Spacer()
                
                // MARK: - 로그아웃
//                Button("로그아웃") {
//                    UserDefaults.standard.removeObject(forKey: "user_id")
//                    isPresent.toggle()
//                }
//                .padding()
//                .fullScreenCover(isPresented: $isPresent) {
//                    LoginView()
//                }
                
                // MARK: - footer
                Image("footer")
                    .padding()
            }
            .fullScreenCover(isPresented: $vision.isPresented) {
                DetailView()
                    .environmentObject(vision)
            }
        }
    }
}
