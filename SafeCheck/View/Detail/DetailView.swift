import SwiftUI

struct DetailView: View {
    @EnvironmentObject var vision: Vision
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        // MARK: - 배경
        ZStack {
            Color("mainColor")
                .ignoresSafeArea()
            
            // MARK: - 뒤로가기
            HStack {
                VStack {
                    Button(action: {
                        vision.casNumber.removeAll()
                        dismiss()
                    }) {
                        Image("back")
                    }
                    Spacer()
                }
                Spacer()
            }
            .padding()
            
            // MARK: - 뷰
            VStack(spacing: 0) {
                InfoRow(title: "한국어 이름", value: vision.information?.chemical_substance?.korean_name ?? "__empty__")
                InfoRow(title: "영어 이름", value: vision.information?.chemical_substance?.english_name ?? "__empty__")
                InfoRow(title: "CAS 번호", value: vision.information?.chemical_substance?.cas_number ?? "__empty__")
                InfoRow(title: "UN 번호", value: vision.information?.chemical_substance?.un_number ?? "__empty__")
                InfoRow(title: "기존 코드", value: vision.information?.chemical_id ?? "__empty__")
            }
            .padding(.horizontal, 15)
            .padding(.bottom, 200)
            
            // MARK: - footer
            VStack {
                Image("main")
                    .padding(20)
                Spacer()
                Image("footer")
                    .padding()
            }
        }
    }
}

// MARK: - 정보
struct InfoRow: View {
    var title: String
    var value: String
    
    var body: some View {
        HStack(spacing: 0) {
            Text(title)
                .foregroundColor(.white)
                .font(.title3)
                .frame(width: 120, height: 80)
                .background(Color("logoColor"))
            Text(value)
                .foregroundColor(.black)
                .padding(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .overlay(
            RoundedRectangle(cornerRadius: 0)
                .stroke(Color.gray, lineWidth: 0.3)
        )
    }
}
