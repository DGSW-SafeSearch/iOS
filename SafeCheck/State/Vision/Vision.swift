import SwiftUI
import Vision
import VisionKit
import Alamofire

class Vision: ObservableObject {
//    @Published var login: logined?
    @Published var information: informations?
    @Published var isPresented: Bool = false
    @Published var isProgress: Bool = false
    @Published var ocrString: String?
    @Published var casNumber: String?
    @Published var a: String = "1"
    
    func reText(image: UIImage) {
        guard let Image = image.cgImage else { fatalError("이미지 오류") }
        let handler = VNImageRequestHandler(cgImage: Image, options: [:])
        let request = VNRecognizeTextRequest { [weak self] request, error in
            guard let result = request.results as? [VNRecognizedTextObservation],
                  error == nil else { return }
            let text = result.compactMap { $0.topCandidates(1).first?.string }
                .joined(separator: "\n")
            self?.ocrString = text
            self?.discriminatorCas()
        }
        do {
            print(try request.supportedRecognitionLanguages())
            try handler.perform([request])
        } catch {
            print(error)
        }
    }
    
    func discriminatorCas() {
        guard let ocrString = ocrString else { return }
        let pattern = "\\b\\d{1,}-\\d{2}-\\d{1}\\b"
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
            fatalError("dmdi")
        }
        let matches = regex.matches(in: ocrString, options: [], range: NSRange(location: 0, length: ocrString.utf16.count))
        if let match = matches.first, let range = Range(match.range, in: ocrString) {
            let casNumber = String(ocrString[range])
            self.casNumber = casNumber
        } else {
            print("dmdi")
        }
    }
    
    func informationed() {
        let query : Parameters = [
//            "requestUserId" : UserDefaults.standard.string(forKey: "user_id") ?? "__empty__",
            "requestUserId" : a,
            "ocr_text" : ocrString ?? "__empty__",
            "ocr_cas" : casNumber ?? "__empty__"
        ]
        
        AF.request("\(url)/ocr/process",
                   method: .post,
                   parameters: query,
                   encoding: JSONEncoding.default)
        .responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    print(String(decoding: data, as: UTF8.self))
                    let responseData = try JSONDecoder().decode(informations.self, from: data)
                    self.information = responseData
                    DispatchQueue.main.async {
                        self.isProgress.toggle()
                        if self.information?.res == "200" {
                            self.isPresented.toggle()
                        }
                    }
                } catch {
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
