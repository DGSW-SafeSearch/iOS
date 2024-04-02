import SwiftUI
import PhotosUI
import Camera_SwiftUI
import Combine

public struct CameraView: View {
    
    @Binding private var image: UIImage?
    
    public init(_ image: Binding<UIImage?>) {
        self._image = image
        self.session = service.session
    }
    
    private let service = CameraService()
    private var session: AVCaptureSession
    
    @Environment(\.dismiss) private var dismiss
    @State private var zoom = 1.0
    @State private var isFlashOn = false
    @State private var imageSelection: PhotosPickerItem?
    @State private var subscriptions = [AnyCancellable]()
    
    private func subscribe() {
        subscriptions = [
            service.$photo.sink { [self] (photo) in
                guard let pic = photo else { return }
                self.image = pic.image!
                dismiss()
            },
            service.$flashMode.sink { [self] (mode) in
                self.isFlashOn = mode == .on
            }
        ]
    }
    
    private func loadTransferable(from imageSelection: PhotosPickerItem) {
        imageSelection.loadTransferable(type: Data.self) { result in
            DispatchQueue.main.async {
                guard imageSelection == self.imageSelection else { return }
                if case let .success(image) = result {
                    self.image = UIImage(data: image!)
                    dismiss()
                }
            }
        }
    }
    
    public var body: some View {
        VStack(spacing: 20) {
            Button {
                service.flashMode = service.flashMode == .on ? .off : .on
            } label: {
                Image(systemName: "bolt\(isFlashOn ? "" : ".slash").fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(isFlashOn ? .yellow : .white)
                    .frame(width: 24, height: 24)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 16)
            CameraPreview(session: session)
                .aspectRatio(3/4, contentMode: .fit)
                .gesture(
                    MagnificationGesture()
                        .onChanged { value in
                            let zoomValue = (value - 1) / 5
                            if (zoom > -1 || zoomValue > 0) &&
                                (zoom < 5 || zoomValue < 0) {
                                zoom += zoomValue
                            }
                            service.set(zoom: zoom)
                        }
                )
                .onAppear {
                    subscribe()
                    service.checkForPermissions()
                    service.configure()
                }
            ZStack {
                Button(action: service.capturePhoto) {
                    Circle()
                        .fill(.white)
                        .frame(width: 80, height: 80, alignment: .center)
                        .overlay(
                            Circle()
                                .stroke(Color.black.opacity(0.8), lineWidth: 2)
                                .frame(width: 65, height: 65)
                        )
                }
                HStack {
                    Button("취소") {
                        dismiss()
                    }
                    .font(.system(size: 18))
                    .foregroundStyle(Color.white)
                    Spacer()
                    PhotosPicker(selection: $imageSelection,
                                 matching: .images,
                                 photoLibrary: .shared()) {
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 22.4, height: 22.4)
                            .foregroundStyle(Color.white)
                            .padding(16.8)
                            .background(Color.white.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
                .padding(.horizontal, 16)
            }
        }
        .frame(maxHeight: .infinity)
        .background(Color.black.ignoresSafeArea())
        .onChange(of: imageSelection) { newValue in
            if let newValue {
                loadTransferable(from: newValue)
            }
        }
    }
}
