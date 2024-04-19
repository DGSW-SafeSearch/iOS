import SwiftUI

struct MainView: View {
    @ObservedObject var vision = Vision()
    @State var information: informations?
    @State var isPresented: Bool = false
    @State var isPresent: Bool = false
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
                if image != nil, vision.casNumber == nil {
                    Text("정보가 없습니다")
                        .foregroundColor(.black)
                        .font(.title2)
                        .padding(.top,20)
                } else {
                    Text("CAS번호 검색")
                        .foregroundColor(.black)
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
                .onChange(of: image) { _ in
                    if let image = image {
                        vision.casNumber = nil
                        vision.reText(image: image)
                        vision.informationed()
                    }
                }
                .padding()
                
                // MARK: - 밑
                if image != nil, vision.casNumber == nil {
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
            .fullScreenCover(isPresented: $vision.isPresented) {
                DetailView()
                    .environmentObject(vision)
            }
        }
    }
}
