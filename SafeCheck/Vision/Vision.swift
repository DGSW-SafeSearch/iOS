import Vision
import VisionKit

class Vision: ObservableObject {
    @Published var OCRString: String?
    
    func reText(image: UIImage) {
        guard let Image = image.cgImage else { fatalError("이미지 오류") }
        
        let handler = VNImageRequestHandler(cgImage: Image, options: [:])
        
        let request = VNRecognizeTextRequest { [weak self] request, error in
            guard let result = request.results as? [VNRecognizedTextObservation],
                  error == nil else { return }
            let text = result.compactMap { $0.topCandidates(1).first?.string }
                .joined(separator: "\n")
            self?.OCRString = text
        }
        
        do {
            print(try request.supportedRecognitionLanguages())
            try handler.perform([request])
        } catch {
            print(error)
        }
    }
}
