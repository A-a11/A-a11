import SwiftUI

struct CommentRecorderView: View {
    @EnvironmentObject var postStore: PostStore
    @Environment(\.dismiss) private var dismiss
    @StateObject private var camera = CameraService()

    let postId: UUID
    @State private var isRecording = false
    @State private var recordingTime: TimeInterval = 0
    @State private var timer: Timer?

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            if camera.cameraPermissionGranted {
                ZStack {
                    CameraPreview(session: camera.captureSession)
                        .ignoresSafeArea()

                    VStack {
                        // Header
                        HStack {
                            Button { dismiss() } label: {
                                Image(systemName: "xmark")
                                    .font(.system(size: 20, weight: .medium))
                                    .foregroundStyle(.white)
                                    .padding(10)
                                    .background(.black.opacity(0.5))
                                    .clipShape(Circle())
                            }

                            Spacer()

                            Text("Video Reply")
                                .font(.system(size: 17, weight: .bold))
                                .foregroundStyle(Color("AccentColor"))

                            Spacer()

                            Button { camera.switchCamera() } label: {
                                Image(systemName: "camera.rotate.fill")
                                    .font(.system(size: 18))
                                    .foregroundStyle(.white)
                                    .padding(10)
                                    .background(.black.opacity(0.5))
                                    .clipShape(Circle())
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 8)

                        if isRecording {
                            HStack(spacing: 6) {
                                Circle()
                                    .fill(.red)
                                    .frame(width: 8, height: 8)
                                Text(formatTime(recordingTime))
                                    .font(.system(size: 14, weight: .semibold, design: .monospaced))
                                    .foregroundStyle(.white)
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(.black.opacity(0.6))
                            .clipShape(Capsule())
                        }

                        Spacer()

                        Text("Camera Only — No Uploads")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundStyle(.orange)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 4)
                            .background(.black.opacity(0.5))
                            .clipShape(Capsule())

                        Spacer()

                        // Record button
                        Button {
                            if isRecording {
                                camera.stopRecording()
                                timer?.invalidate()
                                isRecording = false
                                // In a real app, save the comment video
                                dismiss()
                            } else {
                                camera.startRecording()
                                isRecording = true
                                recordingTime = 0
                                timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                                    recordingTime += 1
                                }
                            }
                        } label: {
                            ZStack {
                                Circle()
                                    .strokeBorder(.white, lineWidth: 3)
                                    .frame(width: 72, height: 72)
                                if isRecording {
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(.red)
                                        .frame(width: 28, height: 28)
                                } else {
                                    Circle()
                                        .fill(.red)
                                        .frame(width: 58, height: 58)
                                }
                            }
                        }
                        .padding(.bottom, 40)
                    }
                }
            } else {
                VStack(spacing: 16) {
                    Image(systemName: "video.fill")
                        .font(.system(size: 40))
                        .foregroundStyle(.gray)
                    Text("Camera access needed to reply")
                        .foregroundStyle(.gray)
                }
            }
        }
        .onAppear {
            camera.setupSession()
            camera.startSession()
        }
        .onDisappear {
            camera.stopSession()
            timer?.invalidate()
        }
    }

    private func formatTime(_ seconds: TimeInterval) -> String {
        let mins = Int(seconds) / 60
        let secs = Int(seconds) % 60
        return String(format: "%02d:%02d", mins, secs)
    }
}

#Preview {
    CommentRecorderView(postId: UUID())
        .environmentObject(PostStore())
        .preferredColorScheme(.dark)
}
