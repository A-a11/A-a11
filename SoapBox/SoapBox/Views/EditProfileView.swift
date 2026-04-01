import SwiftUI

struct EditProfileView: View {
    @Environment(\.dismiss) private var dismiss

    let user: User

    @State private var accountName: String = ""
    @State private var handle: String = ""
    @State private var description: String = ""
    @State private var urlLink: String = ""
    @State private var fullName: String = ""
    @State private var email: String = ""
    @State private var phone: String = ""
    @State private var birthday: String = ""
    @State private var locationPrivacy: User.LocationPrivacy = .publicVisible

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Edit Profile header
            Text("Edit Profile")
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(Color("AccentColor"))
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 24)

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    profileField(label: "Account Name", value: $accountName, placeholder: "Account Name")
                    profileField(label: "Handle", value: $handle, placeholder: "Handle")

                    // Description with character count
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text("Description")
                                .font(.system(size: 16))
                                .foregroundStyle(Color("AccentColor").opacity(0.7))
                            Text("(\(120 - description.count) characters)")
                                .font(.system(size: 14))
                                .foregroundStyle(.gray)
                        }
                        TextField("", text: $description)
                            .font(.system(size: 16))
                            .foregroundStyle(.white)
                            .onChange(of: description) { _, newValue in
                                if newValue.count > 120 {
                                    description = String(newValue.prefix(120))
                                }
                            }
                        Divider().background(Color.gray.opacity(0.3))
                    }

                    profileField(label: "URL Link", value: $urlLink, placeholder: "")
                    profileField(label: "Full name", value: $fullName, placeholder: "")
                    profileField(label: "Email", value: $email, placeholder: "")
                    profileFieldWithDefault(label: "Phone number", value: $phone, defaultText: "(000) 000-000")
                    profileFieldWithDefault(label: "Birthday", value: $birthday, defaultText: "00 / 00 / 0000")

                    // Location with privacy toggle
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Location")
                            .font(.system(size: 16))
                            .foregroundStyle(Color("AccentColor").opacity(0.7))

                        HStack(spacing: 12) {
                            // Followers Only label (left of toggle)
                            Text("Followers Only")
                                .font(.system(size: 13))
                                .foregroundStyle(.white.opacity(0.7))

                            // Public / Toggle / Do Not Show
                            HStack(spacing: 8) {
                                Text("Public")
                                    .font(.system(size: 13))
                                    .foregroundStyle(locationPrivacy == .publicVisible ? .white : .gray)

                                // Custom toggle
                                ZStack {
                                    Capsule()
                                        .fill(toggleColor)
                                        .frame(width: 50, height: 28)

                                    Circle()
                                        .fill(.white)
                                        .frame(width: 22, height: 22)
                                        .offset(x: toggleOffset)
                                }
                                .onTapGesture {
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        cyclePrivacy()
                                    }
                                }

                                Text("Do")
                                    .font(.system(size: 13))
                                    .foregroundStyle(locationPrivacy == .doNotShow ? .white : .gray)
                                Text("Not Show")
                                    .font(.system(size: 13))
                                    .foregroundStyle(locationPrivacy == .doNotShow ? .white : .gray)
                            }
                        }
                    }
                    .padding(.top, 8)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
        }
        .background(.black)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("SoapBox")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundStyle(Color("AccentColor"))
            }
            ToolbarItem(placement: .navigationBarLeading) {
                Button { dismiss() } label: {
                    Image(systemName: "arrow.left")
                        .foregroundStyle(.white)
                }
            }
        }
        .toolbarColorScheme(.dark, for: .navigationBar)
        .onAppear {
            accountName = user.name
            handle = user.handle
            description = user.bio
            urlLink = user.website
            email = user.email
            phone = user.phone
            birthday = user.birthday
            locationPrivacy = user.locationPrivacy
        }
    }

    // MARK: - Field Components

    private func profileField(label: String, value: Binding<String>, placeholder: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.system(size: 16))
                .foregroundStyle(Color("AccentColor").opacity(0.7))
            TextField(placeholder, text: value)
                .font(.system(size: 16))
                .foregroundStyle(.white)
            Divider().background(Color.gray.opacity(0.3))
        }
    }

    private func profileFieldWithDefault(label: String, value: Binding<String>, defaultText: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(label)
                    .font(.system(size: 16))
                    .foregroundStyle(Color("AccentColor").opacity(0.7))
                if value.wrappedValue.isEmpty {
                    Text(defaultText)
                        .font(.system(size: 16))
                        .foregroundStyle(.gray.opacity(0.5))
                } else {
                    Text(value.wrappedValue)
                        .font(.system(size: 16))
                        .foregroundStyle(.white)
                }
            }
            Divider().background(Color.gray.opacity(0.3))
        }
    }

    // MARK: - Toggle Helpers

    private var toggleColor: Color {
        switch locationPrivacy {
        case .publicVisible: return .green
        case .followersOnly: return .orange
        case .doNotShow: return .gray
        }
    }

    private var toggleOffset: CGFloat {
        switch locationPrivacy {
        case .publicVisible: return -11
        case .followersOnly: return 0
        case .doNotShow: return 11
        }
    }

    private func cyclePrivacy() {
        switch locationPrivacy {
        case .publicVisible: locationPrivacy = .followersOnly
        case .followersOnly: locationPrivacy = .doNotShow
        case .doNotShow: locationPrivacy = .publicVisible
        }
    }
}

#Preview {
    NavigationStack {
        EditProfileView(user: .currentUser)
    }
    .preferredColorScheme(.dark)
}
