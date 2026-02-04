import SwiftUI

struct RegistrationView: View {
    // MARK: - Form state
    @State private var username = ""
    @State private var email = ""
    @State private var phone = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isPasswordVisible = false
    @State private var agreed = false

    // MARK: - Navigation
    @State private var navigateToHome = false

    // MARK: - Validation
    private var isEmailValid: Bool {
        let trimmed = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let pattern = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        return trimmed.range(of: pattern, options: .regularExpression) != nil
    }

    private var isPasswordValid: Bool { password.count >= 8 }
    private var isConfirmValid: Bool { !confirmPassword.isEmpty && confirmPassword == password }

    private var formIsValid: Bool {
        !username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        isEmailValid &&
        isPasswordValid &&
        isConfirmValid &&
        agreed
    }

    private var disabledButtonColor: Color { Color(red: 0.12, green: 0.12, blue: 0.45) }
    private var activeButtonColor: Color { Color(red: 0.18, green: 0.18, blue: 0.70) }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                // Background
                LinearGradient(
                    colors: [
                        Color(red: 0.16, green: 0.20, blue: 0.78),
                        Color(red: 0.12, green: 0.12, blue: 0.62)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                // White card (опущена нижче)
                VStack {
                    VStack(alignment: .leading, spacing: 18) {
                        titleBlock
                        illustrationBlock
                        fieldsBlock
                        termsBlock
                        signUpButton
                        bottomSignIn
                    }
                    .padding(.top, 22)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 22)
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
                    .padding(.top, 80) // ⬅️ опускає білий блок нижче

                    Spacer(minLength: 0)
                }
            }
            .navigationBarHidden(true)
            // ✅ ПЕРЕХІД НА ТВОЄ HOME
            .navigationDestination(isPresented: $navigateToHome) {
                HomeScreenView()
                    .navigationBarBackButtonHidden(true)
            }
        }
    }

    // MARK: - UI blocks
    private var titleBlock: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Welcome to us,")
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(Color(red: 0.18, green: 0.18, blue: 0.70))

            Text("Hello there, create New account")
                .font(.system(size: 14))
                .foregroundStyle(.gray)
        }
    }

    private var illustrationBlock: some View {
        VStack(spacing: 10) {
            Circle()
                .fill(Color(red: 0.16, green: 0.20, blue: 0.78))
                .frame(width: 8, height: 8)

            ZStack {
                Circle()
                    .fill(Color(.systemGray6))
                    .frame(width: 150, height: 150)

                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(Color(red: 0.20, green: 0.22, blue: 0.76))
                    .frame(width: 58, height: 86)
                    .overlay(
                        VStack(spacing: 8) {
                            Image(systemName: "person.circle")
                                .foregroundStyle(.white)
                                .font(.system(size: 18, weight: .semibold))
                            Image(systemName: "briefcase")
                                .foregroundStyle(.white.opacity(0.9))
                                .font(.system(size: 16, weight: .semibold))
                        }
                    )

                Circle().fill(Color.red.opacity(0.85)).frame(width: 16, height: 16).offset(x: 75, y: -35)
                Circle().fill(Color.blue.opacity(0.85)).frame(width: 10, height: 10).offset(x: 70, y: 45)
                Circle().fill(Color.green.opacity(0.75)).frame(width: 10, height: 10).offset(x: -80, y: -15)
                Circle().fill(Color.orange.opacity(0.85)).frame(width: 14, height: 14).offset(x: -70, y: 50)
                Circle().fill(Color.purple.opacity(0.75)).frame(width: 8, height: 8).offset(x: -10, y: -75)
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.top, 6)
        .padding(.bottom, 2)
    }

    private var fieldsBlock: some View {
        VStack(spacing: 12) {
            AppTextField(placeholder: "Username", text: $username)
            AppTextField(placeholder: "Email", text: $email, keyboard: .emailAddress)

            AppTextField(placeholder: "Phone (optional)", text: $phone, keyboard: .phonePad)

            // Password
            HStack {
                Group {
                    if isPasswordVisible {
                        TextField("", text: $password)
                    } else {
                        SecureField("", text: $password)
                    }
                }
                .placeholder("Password (min 8 chars)", when: password.isEmpty)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true)

                Button {
                    isPasswordVisible.toggle()
                } label: {
                    Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                        .foregroundStyle(.gray)
                        .font(.system(size: 16, weight: .medium))
                        .padding(.leading, 8)
                }
            }
            .padding(.horizontal, 14)
            .frame(height: 52)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(Color(.systemGray4), lineWidth: 1)
            )

            // Confirm password
            HStack {
                SecureField("", text: $confirmPassword)
                    .placeholder("Confirm password", when: confirmPassword.isEmpty)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)

                Image(systemName: isConfirmValid ? "checkmark.circle.fill" : "xmark.circle")
                    .foregroundStyle(isConfirmValid ? .green : .gray.opacity(0.6))
                    .font(.system(size: 18, weight: .semibold))
                    .padding(.leading, 8)
                    .accessibilityHidden(true)
            }
            .padding(.horizontal, 14)
            .frame(height: 52)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(Color(.systemGray4), lineWidth: 1)
            )
        }
        .padding(.top, 6)
    }

    private var termsBlock: some View {
        HStack(alignment: .top, spacing: 10) {
            Button { agreed.toggle() } label: {
                RoundedRectangle(cornerRadius: 5, style: .continuous)
                    .stroke(Color(red: 0.18, green: 0.18, blue: 0.70), lineWidth: 2)
                    .frame(width: 22, height: 22)
                    .overlay {
                        if agreed {
                            Image(systemName: "checkmark")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundStyle(Color(red: 0.18, green: 0.18, blue: 0.70))
                        }
                    }
            }

            VStack(alignment: .leading, spacing: 3) {
                Text("By creating an account you agree")
                    .font(.system(size: 13))
                    .foregroundStyle(.gray)

                HStack(spacing: 4) {
                    Text("to our")
                        .font(.system(size: 13))
                        .foregroundStyle(.gray)

                    Button { } label: {
                        Text("Term and Conditions")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(Color(red: 0.18, green: 0.18, blue: 0.70))
                    }
                }
            }

            Spacer()
        }
        .padding(.top, 2)
    }

    // ✅ Кнопка темніша, поки форма не валідна
    private var signUpButton: some View {
        Button {
            // ✅ якщо валідно — переходимо на Home
            navigateToHome = true
        } label: {
            Text("Зареєструватись")
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(formIsValid ? activeButtonColor : disabledButtonColor)
                )
                .opacity(formIsValid ? 1.0 : 0.85)
        }
        .disabled(!formIsValid)
        .padding(.top, 6)
    }

    private var bottomSignIn: some View {
        HStack(spacing: 6) {
            Text("Have an account?")
                .font(.system(size: 13))
                .foregroundStyle(.gray)

            Button { } label: {
                Text("Sign In")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color(red: 0.18, green: 0.18, blue: 0.70))
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 2)
    }
}

// MARK: - Reusable text field
private struct AppTextField: View {
    let placeholder: String
    @Binding var text: String
    var keyboard: UIKeyboardType = .default

    var body: some View {
        TextField("", text: $text)
            .placeholder(placeholder, when: text.isEmpty)
            .keyboardType(keyboard)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled(true)
            .padding(.horizontal, 14)
            .frame(height: 52)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(Color(.systemGray4), lineWidth: 1)
            )
    }
}

// MARK: - Placeholder helper
private extension View {
    func placeholder(_ text: String, when shouldShow: Bool) -> some View {
        ZStack(alignment: .leading) {
            if shouldShow {
                Text(text)
                    .foregroundStyle(Color(.systemGray2))
                    .padding(.horizontal, 14)
            }
            self
        }
    }
}

#Preview {
    RegistrationView()
}

