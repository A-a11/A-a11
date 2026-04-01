import SwiftUI

struct ProfileSideMenuView: View {
    @Binding var isOpen: Bool
    let user: User
    let onProfile: () -> Void
    let onSettings: () -> Void

    var body: some View {
        HStack(spacing: 0) {
            // Menu content
            VStack(alignment: .leading, spacing: 0) {
                // Profile avatar
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.red, .orange],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 100, height: 100)
                    .overlay(
                        Image(systemName: "person.fill")
                            .foregroundStyle(.white)
                            .font(.system(size: 40))
                    )
                    .padding(.top, 60)
                    .padding(.bottom, 12)
                    .onTapGesture { onProfile() }

                // Name & handle
                Text(user.name)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(.white)
                Text(user.handle)
                    .font(.system(size: 16))
                    .foregroundStyle(.gray)
                    .padding(.bottom, 24)

                // Stats
                VStack(alignment: .leading, spacing: 14) {
                    statRow(count: user.subjectsCount, label: "Subjects")
                    statRow(count: user.followersCount, label: "Followers")
                    statRow(count: user.followingCount, label: "Following")
                }
                .padding(.bottom, 30)

                // Settings
                Button(action: onSettings) {
                    Text("Settings")
                        .font(.system(size: 18))
                        .foregroundStyle(.gray)
                }

                Spacer()

                // Logout
                Button {
                    // logout action
                } label: {
                    Text("logout")
                        .font(.system(size: 16))
                        .foregroundStyle(.gray)
                }
                .padding(.bottom, 40)
            }
            .padding(.horizontal, 24)
            .frame(width: UIScreen.main.bounds.width * 0.6)
            .background(.black)

            // Tap-to-close area (shows feed behind)
            Color.black.opacity(0.3)
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        isOpen = false
                    }
                }
        }
        .ignoresSafeArea()
    }

    private func statRow(count: Int, label: String) -> some View {
        HStack(spacing: 8) {
            Text("\(count)")
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(.white)
            Text(label)
                .font(.system(size: 16))
                .foregroundStyle(.gray)
        }
    }
}

#Preview {
    ProfileSideMenuView(
        isOpen: .constant(true),
        user: .currentUser,
        onProfile: {},
        onSettings: {}
    )
    .preferredColorScheme(.dark)
}
