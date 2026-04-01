import SwiftUI
import AVFoundation

struct RecordView: View {
    @EnvironmentObject var postStore: PostStore
    @Environment(\.dismiss) private var dismiss
    @StateObject private var camera = CameraService()

    @State private var domain = ""
    @State private var hashtag = ""
    @State private var showPostForm = false
    @State private var recordingTime: TimeInterval = 0
    @State private var timer: Timer?

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            if camera.cameraPermissionGranted {
                cameraView
            } else {
                permissionDeniedView
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
        .sheet(isPresented: $showPostForm) {
            postFormSheet
        }
    }

    private var cameraView: some View {
        ZStack {
            // Camera preview
            CameraPreview(session: camera.captureSession)
                .ignoresSafeArea()

            VStack {
                // Top bar
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 22, weight: .medium))
                            .foregroundStyle(.white)
                            .padding(12)
                            .background(.black.opacity(0.5))
                            .clipShape(Circle())
                    }

                    Spacer()

                    if camera.isRecording {
                        // Recording indicator
                        HStack(spacing: 6) {
                            Circle()
                                .fill(.red)
                                .frame(width: 10, height: 10)
                            Text(formatTime(recordingTime))
                                .font(.system(size: 15, weight: .semibold, design: .monospaced))
                                .foregroundStyle(.white)
                        }
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(.black.opacity(0.6))
                        .clipShape(Capsule())
                    }

                    Spacer()

                    // Switch camera
                    Button {
                        camera.switchCamera()
                    } label: {
                        Image(systemName: "camera.rotate.fill")
                            .font(.system(size: 20))
                            .foregroundStyle(.white)
                            .padding(12)
                            .background(.black.opacity(0.5))
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal)
                .padding(.top, 8)

                Spacer()

                // Camera indicator
                VStack(spacing: 8) {
                    Text(camera.isFrontCamera ? "Front Camera" : "Back Camera")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(.white.opacity(0.7))
                        .padding(.horizontal, 14)
                        .padding(.vertical, 6)
                        .background(.black.opacity(0.4))
                        .clipShape(Capsule())

                    Text("NO UPLOADS — Camera Only")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(.orange)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 4)
                        .background(.black.opacity(0.5))
                        .clipShape(Capsule())
                }

                Spacer()

                // Record button
                HStack {
                    Spacer()

                    Button {
                        if camera.isRecording {
                            camera.stopRecording()
                            timer?.invalidate()
                            showPostForm = true
                        } else {
                            camera.startRecording()
                            recordingTime = 0
                            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                                recordingTime += 1
                            }
                        }
                    } label: {
                        ZStack {
                            Circle()
                                .strokeBorder(.white, lineWidth: 4)
                                .frame(width: 80, height: 80)

                            if camera.isRecording {
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(.red)
                                    .frame(width: 30, height: 30)
                            } else {
                                Circle()
                                    .fill(.red)
                                    .frame(width: 64, height: 64)
                            }
                        }
                    }

                    Spacer()
                }
                .padding(.bottom, 40)
            }
        }
    }

    private var permissionDeniedView: some View {
        VStack(spacing: 20) {
            Image(systemName: "camera.fill")
                .font(.system(size: 48))
                .foregroundStyle(.gray)

            Text("Camera Access Required")
                .font(.title2.weight(.bold))
                .foregroundStyle(.white)

            Text("SoapBox requires camera access to record videos.\nNo uploads allowed — only live recordings.")
                .font(.subheadline)
                .foregroundStyle(.gray)
                .multilineTextAlignment(.center)

            Button("Open Settings") {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
            .font(.headline)
            .foregroundStyle(.black)
            .padding(.horizontal, 32)
            .padding(.vertical, 12)
            .background(Color("AccentColor"))
            .clipShape(Capsule())
        }
        .padding()
    }

    private var postFormSheet: some View {
        NavigationStack {
            Form {
                Section("What's this about?") {
                    TextField("Domain (e.g., Automotive/Road Safety)", text: $domain)
                    TextField("Hashtag (e.g., parkingproblems)", text: $hashtag)
                }

                Section {
                    Text("Your video was recorded live from the camera.\nNo edits or uploads — just raw truth.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Post to SoapBox")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Discard") {
                        showPostForm = false
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Post") {
                        let newPost = Post(
                            author: User.currentUser,
                            domain: domain.isEmpty ? "General" : domain,
                            hashtag: hashtag.isEmpty ? "soapbox" : hashtag,
                            thumbnailColor: ["blue", "orange", "purple", "green", "red"].randomElement()!,
                            sourceInfo: "Recorded live",
                            feedType: .home
                        )
                        postStore.addPost(newPost)
                        showPostForm = false
                        dismiss()
                    }
                    .fontWeight(.bold)
                }
            }
        }
    }

    private func formatTime(_ seconds: TimeInterval) -> String {
        let mins = Int(seconds) / 60
        let secs = Int(seconds) % 60
        return String(format: "%02d:%02d", mins, secs)
    }
}

#Preview {
    RecordView()
        .environmentObject(PostStore())
        .preferredColorScheme(.dark)
}
