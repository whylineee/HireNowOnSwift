import SwiftUI

struct RegistrationView: View {
    enum UserType: String, CaseIterable, Identifiable {
        case jobSeeker = "Шукаю роботу"
        case employer = "Роботодавець"
        var id: String { rawValue }
    }

    @State private var fullName = ""
    @State private var email = ""
    @State private var phone = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var userType: UserType = .jobSeeker
    @State private var agreedToTerms = false

    @State private var showAlert = false
    @State private var alertMessage = ""

    private var formIsValid: Bool {
        !fullName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        isValidEmail(email) &&
        password.count >= 8 &&
        password == confirmPassword &&
        agreedToTerms
    }
    
    private let bg = Color(.systemGroupedBackground)
    private let card = Color(.secondarySystemGroupedBackground)
    private let accent = Color.black

    var body: some View {
        NavigationStack {
            Form {
                HStack {
                    Spacer()
                    Text("Реєстрація").bold()
                    Spacer()
                }

                Section {
                    TextField("Ім’я та прізвище", text: $fullName)
                        .textInputAutocapitalization(.words)

                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled(true)

                    TextField("Телефон", text: $phone)
                        .keyboardType(.phonePad)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled(true)

                    Picker("Тип користувача", selection: $userType) {
                        ForEach(UserType.allCases) { type in
                            Text(type.rawValue)
                                .tag(type)
                        }
                    }
                }

                Section("Пароль") {
                    SecureField("Пароль (мін. 8 символів)", text: $password)
                        .textContentType(.newPassword) // ✅ менше лагів + правильний autofill

                    SecureField("Повторіть пароль", text: $confirmPassword)
                        .textContentType(.password)

                    if !confirmPassword.isEmpty && password != confirmPassword {
                        Text("Паролі не співпадають")
                            .foregroundStyle(.red)
                    }
                }

                Section {
                    Toggle("Погоджуюсь з умовами", isOn: $agreedToTerms)
                    
                    
                    Button("Зареєструватись") {
                        // тимчасово
                        if !formIsValid {
                            alertMessage = "Перевір поля"
                            showAlert = true
                        } else {
                            alertMessage = "Успішно!"
                            showAlert = true
                        }
                    }
                    .disabled(!formIsValid)
                }
            }
            .navigationTitle("HireNow")
        }
        .alert("Повідомлення", isPresented: $showAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
    }

    private func isValidEmail(_ value: String) -> Bool {
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.contains("@") && trimmed.contains(".") && trimmed.count >= 6
    }
}

#Preview {
    RegistrationView()
}

