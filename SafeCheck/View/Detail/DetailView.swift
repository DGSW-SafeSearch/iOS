import SwiftUI

struct DetailView: View {
    @EnvironmentObject var vision: Vision
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        // MARK: - 배경
        ZStack {
            Color("mainColor")
                .ignoresSafeArea()
            
            // MARK: - 뷰
            VStack {
                ScrollView {
                    Image("main")
                        .padding(30)
                    Spacer()
                    if let cas_number = vision.information?.chemical_substance {
                        ForEach(cas_number, id: \.self) { row in
                            Button (action : {
                                if let url = URL(string: "https://kreach.me.go.kr/repwrt/mttr/kr/mttrList.do?recordCountPerPage=10&searchOper=AND&searchExcelYn=N&searchKeyword=\(row.cas_number!)") {
                                    UIApplication.shared.open(url)
                                }
                            }) {
                                VStack(spacing: 0) {
                                    InfoRow(title: "한국어 이름", value: row.korean_name ?? "__empty__")
                                    InfoRow(title: "영어 이름", value: row.english_name ?? "__empty__")
                                    InfoRow(title: "CAS 번호", value: row.cas_number ?? "__empty__")
                                    InfoRow(title: "UN 번호", value: row.un_number ?? "__empty__")
                                    InfoRow(title: "기존 코드", value: String(row.chemical_id?.description ?? "__empty__"))
                                }
                                .padding(.horizontal, 15)
                                .padding(.bottom)
                            }
                        }
                    }
                    Spacer()
                }
            }
            
            GeometryReader { geometry in
                Button(action: {
                    vision.casNumber.removeAll()
                    dismiss()
                }) {
                    Image("back")
                        .padding()
                }
                .position(x: geometry.size.width * 0.06, y: geometry.size.height * 0.05)
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
                .frame(width: 120, height: 100)
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
