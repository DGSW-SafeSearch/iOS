import Vision
import VisionKit
import Alamofire

class Vision: ObservableObject {
    @Published var information: Information?
    @Published var ocrString: String?
    @Published var casNumber: String?
    @Published var unNumber: String?
    @Published var user_id: String = "user_id"
    
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
}
