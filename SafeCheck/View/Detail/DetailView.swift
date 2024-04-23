import SwiftUI

struct DetailView: View {
    @EnvironmentObject var vision: Vision
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            Color("mainColor")
                .ignoresSafeArea()
            HStack {
                VStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image("back")
                    }
                    Spacer()
                }
                Spacer()
            }
            .padding()
            
            VStack(spacing: 0) {
                InfoRow(title: "한국어 이름", value: vision.information?.chemical_substance.korean_name ?? "__empty__")
                InfoRow(title: "영어 이름", value: vision.information?.chemical_substance.english_name ?? "__empty__")
                InfoRow(title: "CAS 번호", value: vision.casNumber ?? "__empty__")
                InfoRow(title: "UN 번호", value: vision.unNumber ?? "__empty__")
                InfoRow(title: "기존 코드", value: vision.information?.chemical_id ?? "__empty__")
            }
            .padding(.horizontal, 15)
            .padding(.bottom, 200)
            
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
                    .padding(.horizontal, 15)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .overlay(
                RoundedRectangle(cornerRadius: 0)
                    .stroke(Color.gray, lineWidth: 0.3)
            )
    }
}
