import Vision
import VisionKit
import Alamofire

class Vision: ObservableObject {
    @Published var googleLogin: Login?
    @Published var information: Information?
    @Published var ocrString: String?
    @Published var casNumber: String?
    @Published var unNumber: String?
    
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
            self?.discriminatorUn()
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
            let unNumber = String(ocrString[range])
            self.unNumber = unNumber
        } else {
            print("dmdi")
        }
    }
    
    func discriminatorUn() {
        guard let ocrString = ocrString else { return }
        let pattern = #"(?i)un\s?(\d{0,4})"#
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
            "requestUserId" : googleLogin?.userId ?? "__empty__",
            "ocr_text" : ocrString ?? "__empty__",
            "ocr_cas" : casNumber ?? "__empty__",
            "ocr_un" : unNumber ?? "__empty__",
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
                    let responseData = try JSONDecoder().decode(Information.self, from: data)
                    self.information = responseData
                    print(responseData)
                } catch {
                    print(error)
                }
            case .failure(let error): 
                print(error)
            }
        }
    }
}
