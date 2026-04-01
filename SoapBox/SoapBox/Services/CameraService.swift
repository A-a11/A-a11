import Foundation
import AVFoundation
import SwiftUI

class CameraService: NSObject, ObservableObject {
    @Published var isRecording = false
    @Published var recordedVideoURL: URL?
    @Published var isFrontCamera = false
    @Published var cameraPermissionGranted = false
    @Published var microphonePermissionGranted = false

    let captureSession = AVCaptureSession()
    private var videoOutput = AVCaptureMovieFileOutput()
    private var currentCameraInput: AVCaptureDeviceInput?

    override init() {
        super.init()
        checkPermissions()
    }

    func checkPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            cameraPermissionGranted = true
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                DispatchQueue.main.async {
                    self?.cameraPermissionGranted = granted
                }
            }
        default:
            cameraPermissionGranted = false
        }

        switch AVCaptureDevice.authorizationStatus(for: .audio) {
        case .authorized:
            microphonePermissionGranted = true
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .audio) { [weak self] granted in
                DispatchQueue.main.async {
                    self?.microphonePermissionGranted = granted
                }
            }
        default:
            microphonePermissionGranted = false
        }
    }

    func setupSession() {
        guard cameraPermissionGranted else { return }

        captureSession.beginConfiguration()
        captureSession.sessionPreset = .high

        // Add video input
        let position: AVCaptureDevice.Position = isFrontCamera ? .front : .back
        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: position),
              let videoInput = try? AVCaptureDeviceInput(device: camera) else {
            captureSession.commitConfiguration()
            return
        }

        if let existing = currentCameraInput {
            captureSession.removeInput(existing)
        }

        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
            currentCameraInput = videoInput
        }

        // Add audio input
        if let microphone = AVCaptureDevice.default(for: .audio),
           let audioInput = try? AVCaptureDeviceInput(device: microphone),
           captureSession.canAddInput(audioInput) {
            captureSession.addInput(audioInput)
        }

        // Add output
        if captureSession.canAddOutput(videoOutput) {
            captureSession.addOutput(videoOutput)
        }

        captureSession.commitConfiguration()
    }

    func startSession() {
        guard !captureSession.isRunning else { return }
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.captureSession.startRunning()
        }
    }

    func stopSession() {
        guard captureSession.isRunning else { return }
        captureSession.stopRunning()
    }

    func switchCamera() {
        isFrontCamera.toggle()
        setupSession()
    }

    func startRecording() {
        let tempURL = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
            .appendingPathExtension("mov")

        videoOutput.startRecording(to: tempURL, recordingDelegate: self)
        DispatchQueue.main.async {
            self.isRecording = true
        }
    }

    func stopRecording() {
        videoOutput.stopRecording()
        DispatchQueue.main.async {
            self.isRecording = false
        }
    }
}

extension CameraService: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(
        _ output: AVCaptureFileOutput,
        didFinishRecordingTo outputFileURL: URL,
        from connections: [AVCaptureConnection],
        error: Error?
    ) {
        if error == nil {
            DispatchQueue.main.async {
                self.recordedVideoURL = outputFileURL
            }
        }
    }
}

// Camera preview UIViewRepresentable
struct CameraPreview: UIViewRepresentable {
    let session: AVCaptureSession

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)

        DispatchQueue.main.async {
            previewLayer.frame = view.bounds
        }

        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        if let layer = uiView.layer.sublayers?.first as? AVCaptureVideoPreviewLayer {
            layer.frame = uiView.bounds
        }
    }
}
