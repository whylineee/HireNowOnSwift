import SwiftUI

struct RegistrationView: View{
    @Environment(\.dismiss) private var dismiss
    
    @State private var fullName = ""
    @State private var email = ""
    @State private var phone = ""          // optional
    @State private var password = ""
    @State private var confirmPassword = ""
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var navigateToHome = false

    
    private var isPasswordValid: Bool {
        password.count >= 8
    }
    
    private var isEmailValid: Bool {
        // проста перевірка
        email.contains("@") && email.contains(".")
    }
    
    private var formIsValid: Bool {
        !fullName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        isEmailValid &&
        isPasswordValid &&
        password == confirmPassword
        // phone не перевіряємо — він optional
    }
    
    var body: some View {
        ZStack {
            // Background
            Color.blue.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    // Title
                    VStack(spacing: 6) {
                        Text("Реєстрація")
                            .font(.system(size: 32, weight: .black))
                            .foregroundStyle(.white)
                        
                        Text("Створи акаунт за хвилину")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(.white.opacity(0.85))
                    }
                    .padding(.top, 24)
                    .padding(.bottom, 10)
                    
                    // Google
                    Button {
                        // TODO: тут підключиш Google Sign-In
                        alertMessage = "Google Sign-In ще не підключений."
                        showAlert = true
                    } label: {
                        HStack(spacing: 10) {
                            Image(systemName: "g.circle.fill")
                                .font(.system(size: 18, weight: .bold))
                            Text("Зареєструватися через Google")
                                .font(.system(size: 16, weight: .black))
                        }
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity, minHeight: 52)
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    }
                    
                    // Divider
                    HStack {
                        Rectangle().frame(height: 1).foregroundStyle(.white.opacity(0.35))
                        Text("або")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundStyle(.white.opacity(0.9))
                            .padding(.horizontal, 10)
                        Rectangle().frame(height: 1).foregroundStyle(.white.opacity(0.35))
                    }
                    .padding(.vertical, 6)
                    
                    // Inputs
                    VStack(spacing: 12) {
                        inputField(title: "Ім’я та прізвище", text: $fullName, keyboard: .default)
                        inputField(title: "Email", text: $email, keyboard: .emailAddress)
                        inputField(title: "Телефон (необов’язково)", text: $phone, keyboard: .phonePad)
                        
                        secureField(title: "Пароль (мін. 8 символів)", text: $password)
                        secureField(title: "Повтори пароль", text: $confirmPassword)
                        
                        // Password hint
                        HStack(spacing: 8) {
                            Image(systemName: isPasswordValid ? "checkmark.circle.fill" : "xmark.circle.fill")
                                .foregroundStyle(isPasswordValid ? .green : .red)
                            Text("Пароль має бути мінімум 8 символів")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundStyle(.white.opacity(0.9))
                            Spacer()
                        }
                        .padding(.top, 2)
                    }
                    
                    // Register button
                    Button {
                        navigateToHome = true
                        if !formIsValid {
                            alertMessage = "Перевір дані: ім’я, email і паролі (мін. 8 символів, мають збігатися)."
                            showAlert = true
                            return
                        }
                        // TODO: твоя логіка реєстрації
                        alertMessage = "Успішна валідація ✅ (далі підключиш бекенд/автентифікацію)."
                        showAlert = true
                    } label: {
                        Text("Створити акаунт")
                            .font(.system(size: 16, weight: .black))
                            .foregroundStyle(.black)
                            .frame(maxWidth: .infinity, minHeight: 54)
                            .background(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                            .opacity(formIsValid ? 1 : 0.7)
                    }
                    .disabled(!formIsValid)
                    .padding(.top, 6)
                    
                    // Bottom text
                    Button {
                        dismiss()
                    } label: {
                        Text("Вже є акаунт? Увійти")
                            .font(.system(size: 14, weight: .black))
                            .foregroundStyle(.white)
                            .underline()
                    }
                    .padding(.top, 4)
                    .padding(.bottom, 28)
                }
                .padding(.horizontal, 20)
            }
            .navigationDestination(isPresented: $navigateToHome) {
                HomeScreenView()
            }
            
        }
        
        .alert("Повідомлення", isPresented: $showAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
        
    }
    
    
    // MARK: - UI Components
    
    private func inputField(title: String, text: Binding<String>, keyboard: UIKeyboardType) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 13, weight: .black))
                .foregroundStyle(.white.opacity(0.9))
            
            TextField("", text: text)
                .keyboardType(keyboard)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .padding(.horizontal, 14)
                .frame(height: 50)
                .background(.white)
                .foregroundStyle(.black)
                .font(.system(size: 15, weight: .bold))
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        }
    }
    
    private func secureField(title: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 13, weight: .black))
                .foregroundStyle(.white.opacity(0.9))
            
            SecureField("", text: text)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .padding(.horizontal, 14)
                .frame(height: 50)
                .background(.white)
                .foregroundStyle(.black)
                .font(.system(size: 15, weight: .bold))
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        }
    }
}

#Preview {
    RegistrationView()
}

