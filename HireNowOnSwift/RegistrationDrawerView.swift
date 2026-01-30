import SwiftUI

// MARK: - Registration Drawer View (Fixed: English input supported)
struct RegistrationDrawerView: View {
    @State private var isExpanded = false

    @State private var fullName = ""
    @State private var email = ""
    @State private var phone = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var userType: UserType = .jobSeeker
    @State private var agreedToTerms = false

    @State private var alertItem: AlertItem?

    enum UserType: String, CaseIterable, Identifiable {
        case jobSeeker = "Шукаю роботу"
        case employer  = "Роботодавець"
        var id: String { rawValue }
    }

    private enum Drawer {
        static let collapsedHeight: CGFloat = 100
        static let expandedRatio: CGFloat = 0.92
        static let cornerRadius: CGFloat = 20
        static let openThreshold: CGFloat = -60
        static let closeThreshold: CGFloat = 120
        static let animation = Animation.spring(response: 0.4, dampingFraction: 0.8)
    }

    // MARK: - Normalized values
    private var trimmedName: String { fullName.trimmingCharacters(in: .whitespacesAndNewlines) }
    private var trimmedEmail: String { email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() }

    private var normalizedPhone: String {
        // allow "+" and digits only
        let allowed = CharacterSet(charactersIn: "+0123456789")
        return phone.unicodeScalars.filter { allowed.contains($0) }.map(String.init).joined()
    }

    // MARK: - Quick form gate
    private var formIsValid: Bool {
        isValidName(trimmedName) &&
        isValidEmail(trimmedEmail) &&
        isValidPhone(normalizedPhone) &&
        password.count >= 6 &&
        password == confirmPassword &&
        agreedToTerms
    }

    var body: some View {
        GeometryReader { geometry in
            let expandedHeight = geometry.size.height * Drawer.expandedRatio
            let collapsedOffset = expandedHeight - Drawer.collapsedHeight

            ZStack(alignment: .bottom) {
                VStack(spacing: 0) {

                    // Handle (tap to toggle)
                    Capsule()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 40, height: 5)
                        .padding(.top, 12)
                        .padding(.bottom, 8)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            withAnimation(Drawer.animation) { isExpanded.toggle() }
                        }

                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 24) {

                            // Header
                            VStack(spacing: 8) {
                                Text("HireNow")
                                    .font(.system(size: 32, weight: .bold))
                                    .foregroundColor(.blue)

                                Text("Створити обліковий запис")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(.primary)
                            }
                            .padding(.top, 8)

                            // User Type Selector
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Тип облікового запису")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.secondary)

                                HStack(spacing: 12) {
                                    ForEach(UserType.allCases) { type in
                                        UserTypeButton(
                                            title: type.rawValue,
                                            isSelected: userType == type
                                        ) { userType = type }
                                    }
                                }
                            }

                            // Form Fields
                            VStack(spacing: 16) {

                                // ✅ Name supports UA + EN
                                CustomTextField(
                                    placeholder: "Повне ім'я (можна англійською)",
                                    text: $fullName,
                                    icon: "person.fill",
                                    keyboardType: .default,
                                    textContentType: .name,
                                    disableAuto: true
                                )

                                CustomTextField(
                                    placeholder: "Email",
                                    text: $email,
                                    icon: "envelope.fill",
                                    keyboardType: .emailAddress,
                                    textContentType: .emailAddress,
                                    disableAuto: true
                                )
                                .textInputAutocapitalization(.never)

                                CustomTextField(
                                    placeholder: "Телефон",
                                    text: $phone,
                                    icon: "phone.fill",
                                    keyboardType: .phonePad,
                                    textContentType: .telephoneNumber,
                                    disableAuto: true
                                )

                                CustomTextField(
                                    placeholder: "Пароль",
                                    text: $password,
                                    icon: "lock.fill",
                                    keyboardType: .default,
                                    isSecure: true,
                                    textContentType: .newPassword,
                                    disableAuto: true
                                )
                                .textInputAutocapitalization(.never)

                                CustomTextField(
                                    placeholder: "Підтвердити пароль",
                                    text: $confirmPassword,
                                    icon: "lock.fill",
                                    keyboardType: .default,
                                    isSecure: true,
                                    textContentType: .newPassword,
                                    disableAuto: true
                                )
                                .textInputAutocapitalization(.never)
                            }

                            // Terms and Conditions
                            Button {
                                agreedToTerms.toggle()
                            } label: {
                                HStack(alignment: .top, spacing: 12) {
                                    Image(systemName: agreedToTerms ? "checkmark.square.fill" : "square")
                                        .foregroundColor(agreedToTerms ? .blue : .gray)
                                        .font(.system(size: 22))

                                    Text("Я погоджуюсь з умовами використання та політикою конфіденційності")
                                        .font(.system(size: 13))
                                        .foregroundColor(.secondary)
                                        .multilineTextAlignment(.leading)
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                            }
                            .buttonStyle(.plain)

                            // Register Button
                            Button(action: handleRegistration) {
                                Text("Зареєструватися")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 54)
                                    .background(formIsValid ? Color.blue : Color.gray)
                                    .cornerRadius(12)
                            }
                            .disabled(!formIsValid)

                            // Divider
                            HStack(spacing: 12) {
                                Rectangle().fill(Color.gray.opacity(0.3)).frame(height: 1)
                                Text("або").font(.system(size: 14)).foregroundColor(.secondary)
                                Rectangle().fill(Color.gray.opacity(0.3)).frame(height: 1)
                            }

                            // Social Login
                            VStack(spacing: 12) {
                                SocialLoginButton(
                                    title: "Продовжити з Google",
                                    icon: "g.circle.fill",
                                    color: .red
                                )

                                SocialLoginButton(
                                    title: "Продовжити з Apple",
                                    icon: "apple.logo",
                                    color: .black
                                )
                            }

                            // Login Link
                            HStack(spacing: 4) {
                                Text("Вже маєте обліковий запис?")
                                    .font(.system(size: 14))
                                    .foregroundColor(.secondary)

                                Button(action: {
                                    // TODO: navigate to login
                                }) {
                                    Text("Увійти")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(.blue)
                                }
                            }
                            .padding(.bottom, 40)
                        }
                        .padding(.horizontal, 24)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: isExpanded ? geometry.size.height * Drawer.expandedRatio : Drawer.collapsedHeight)
                .background(
                    RoundedRectangle(cornerRadius: Drawer.cornerRadius, style: .continuous)
                        .fill(Color(UIColor.systemBackground))
                        .shadow(color: Color.black.opacity(0.15), radius: 30, y: -10)
                )
                .offset(y: isExpanded ? 0 : collapsedOffset)
                .gesture(
                    DragGesture()
                        .onEnded { value in
                            withAnimation(Drawer.animation) {
                                if value.translation.height > Drawer.closeThreshold {
                                    isExpanded = false
                                } else if value.translation.height < Drawer.openThreshold {
                                    isExpanded = true
                                }
                            }
                        }
                )
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .alert(item: $alertItem) { item in
            Alert(
                title: Text(item.title),
                message: Text(item.message),
                dismissButton: .default(Text("OK"))
            )
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                withAnimation(Drawer.animation) { isExpanded = true }
            }
        }
    }

    // MARK: - Registration Logic
    private func handleRegistration() {
        if let error = validate() {
            alertItem = AlertItem(title: "Помилка", message: error)
            return
        }

        alertItem = AlertItem(title: "Готово", message: "Реєстрація успішна! Ласкаво просимо до HireNow 🎉")

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            resetForm()
            withAnimation(Drawer.animation) { isExpanded = false }
        }
    }

    private func validate() -> String? {
        if !isValidName(trimmedName) { return "Введіть коректне ім'я (можна українською або англійською)." }
        if !isValidEmail(trimmedEmail) { return "Введіть коректний email." }
        if !isValidPhone(normalizedPhone) { return "Введіть коректний номер телефону." }
        if password.count < 6 { return "Пароль має містити мінімум 6 символів." }
        if password != confirmPassword { return "Паролі не співпадають." }
        if !agreedToTerms { return "Потрібно погодитись з умовами." }
        return nil
    }

    private func resetForm() {
        fullName = ""
        email = ""
        phone = ""
        password = ""
        confirmPassword = ""
        agreedToTerms = false
        userType = .jobSeeker
    }

    // MARK: - Validators
    private func isValidName(_ value: String) -> Bool {
        let v = value.trimmingCharacters(in: .whitespacesAndNewlines)
        guard v.count >= 2 else { return false }

        // ✅ UA + EN letters, spaces, apostrophe, hyphen
        // Examples: Mark Bernsten, Jean-Luc, O'Connor, Іван Петренко
        let pattern = #"^[A-Za-zА-Яа-яІіЇїЄєҐґ\s'\-]+$"#
        return v.range(of: pattern, options: .regularExpression) != nil
    }

    private func isValidEmail(_ value: String) -> Bool {
        // simple baseline check
        let parts = value.split(separator: "@")
        guard parts.count == 2 else { return false }
        let local = parts[0]
        let domain = parts[1]
        return !local.isEmpty && domain.contains(".") && !domain.hasSuffix(".")
    }

    private func isValidPhone(_ value: String) -> Bool {
        let digits = value.filter { $0.isNumber }
        return digits.count >= 9
    }
}

// MARK: - AlertItem
private struct AlertItem: Identifiable {
    let id = UUID()
    let title: String
    let message: String
}

// MARK: - Custom TextField
struct CustomTextField: View {
    let placeholder: String
    @Binding var text: String
    let icon: String

    var keyboardType: UIKeyboardType = .default
    var isSecure: Bool = false
    var textContentType: UITextContentType? = nil
    var disableAuto: Bool = false

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 20)

            if isSecure {
                SecureField(placeholder, text: $text)
                    .textContentType(textContentType)
                    .applyAutoSettings(disableAuto)
            } else {
                TextField(placeholder, text: $text)
                    .keyboardType(keyboardType)
                    .textContentType(textContentType)
                    .applyAutoSettings(disableAuto)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}

// MARK: - Helpers for auto settings
private extension View {
    @ViewBuilder
    func applyAutoSettings(_ disable: Bool) -> some View {
        if disable {
            self
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
        } else {
            self
        }
    }
}

// MARK: - User Type Button
struct UserTypeButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(isSelected ? .white : .primary)
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .background(isSelected ? Color.blue : Color.gray.opacity(0.1))
                .cornerRadius(10)
        }
    }
}

// MARK: - Social Login Button
struct SocialLoginButton: View {
    let title: String
    let icon: String
    let color: Color

    var body: some View {
        Button(action: {
            // TODO: Handle social login
        }) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(color)

                Text(title)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.primary)

                Spacer()
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            )
        }
    }
}

// MARK: - Preview
struct RegistrationDrawerView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationDrawerView()
    }
}

