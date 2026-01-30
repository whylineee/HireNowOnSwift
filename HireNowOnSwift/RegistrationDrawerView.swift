import SwiftUI

// MARK: - Registration Drawer View
struct RegistrationDrawerView: View {
    @State private var isExpanded = false
    @State private var fullName = ""
    @State private var email = ""
    @State private var phone = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var userType: UserType = .jobSeeker
    @State private var agreedToTerms = false
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    enum UserType: String, CaseIterable {
        case jobSeeker = "Шукаю роботу"
        case employer = "Роботодавець"
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Background - completely transparent
            Color.clear
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                        isExpanded = false
                    }
                }
            
            // Drawer
            VStack(spacing: 0) {
                // Handle
                RoundedRectangle(cornerRadius: 3)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 40, height: 5)
                    .padding(.top, 12)
                
                // Content
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        // Header
                        VStack(spacing: 8) {
                            Text("HireNow")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(.blue)
                                .padding(.top, 20)
                            
                            Text("Створити обліковий запис")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.primary)
                        }
                        
                        // User Type Selector
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Тип облікового запису")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.secondary)
                            
                            HStack(spacing: 12) {
                                ForEach(UserType.allCases, id: \.self) { type in
                                    UserTypeButton(
                                        title: type.rawValue,
                                        isSelected: userType == type
                                    ) {
                                        withAnimation(.easeInOut(duration: 0.2)) {
                                            userType = type
                                        }
                                    }
                                }
                            }
                        }
                        
                        // Form Fields
                        VStack(spacing: 16) {
                            CustomTextField(
                                placeholder: "Повне ім'я",
                                text: $fullName,
                                icon: "person.fill"
                            )
                            
                            CustomTextField(
                                placeholder: "Email",
                                text: $email,
                                icon: "envelope.fill",
                                keyboardType: .emailAddress
                            )
                            
                            CustomTextField(
                                placeholder: "Телефон",
                                text: $phone,
                                icon: "phone.fill",
                                keyboardType: .phonePad
                            )
                            
                            CustomTextField(
                                placeholder: "Пароль",
                                text: $password,
                                icon: "lock.fill",
                                isSecure: true
                            )
                            
                            CustomTextField(
                                placeholder: "Підтвердити пароль",
                                text: $confirmPassword,
                                icon: "lock.fill",
                                isSecure: true
                            )
                        }
                        
                        // Terms and Conditions
                        HStack(spacing: 12) {
                            Button(action: {
                                agreedToTerms.toggle()
                            }) {
                                Image(systemName: agreedToTerms ? "checkmark.square.fill" : "square")
                                    .foregroundColor(agreedToTerms ? .blue : .gray)
                                    .font(.system(size: 22))
                            }
                            
                            Text("Я погоджуюсь з умовами використання та політикою конфіденційності")
                                .font(.system(size: 13))
                                .foregroundColor(.secondary)
                            
                            Spacer()
                        }
                        
                        // Register Button
                        Button(action: handleRegistration) {
                            Text("Зареєструватися")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 54)
                                .background(
                                    LinearGradient(
                                        colors: [Color.blue, Color.blue.opacity(0.8)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(12)
                        }
                        .disabled(!isFormValid())
                        .opacity(isFormValid() ? 1 : 0.5)
                        
                        // Divider
                        HStack {
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(height: 1)
                            
                            Text("або")
                                .font(.system(size: 14))
                                .foregroundColor(.secondary)
                                .padding(.horizontal, 12)
                            
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(height: 1)
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
                                // Navigate to login
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
                .background(Color(UIColor.systemBackground))
            }
            .frame(maxWidth: .infinity)
            .frame(height: isExpanded ? UIScreen.main.bounds.height * 0.9 : 100)
            .background(
                Color(UIColor.systemBackground)
                    .ignoresSafeArea()
            )
            .clipShape(
                RoundedRectangle(cornerRadius: 20)
            )
            .shadow(color: .black.opacity(0.1), radius: 20, y: -5)
            .offset(y: isExpanded ? 0 : UIScreen.main.bounds.height * 0.9 - 100)
            .gesture(
                DragGesture()
                    .onEnded { value in
                        if value.translation.height > 100 {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                isExpanded = false
                            }
                        } else if value.translation.height < -100 {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                isExpanded = true
                            }
                        }
                    }
            )
        }
        .alert("Повідомлення", isPresented: $showingAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
        .onAppear {
            // Auto-expand on appear
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                    isExpanded = true
                }
            }
        }
    }
    
    // MARK: - Helper Functions
    private func isFormValid() -> Bool {
        !fullName.isEmpty &&
        !email.isEmpty &&
        !phone.isEmpty &&
        !password.isEmpty &&
        password == confirmPassword &&
        password.count >= 6 &&
        agreedToTerms &&
        email.contains("@")
    }
    
    private func handleRegistration() {
        if password != confirmPassword {
            alertMessage = "Паролі не співпадають"
            showingAlert = true
            return
        }
        
        // Here you would implement actual registration logic
        alertMessage = "Реєстрація успішна! Ласкаво просимо до HireNow"
        showingAlert = true
        
        // Reset form
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            resetForm()
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                isExpanded = false
            }
        }
    }
    
    private func resetForm() {
        fullName = ""
        email = ""
        phone = ""
        password = ""
        confirmPassword = ""
        agreedToTerms = false
    }
}

// MARK: - Custom TextField
struct CustomTextField: View {
    let placeholder: String
    @Binding var text: String
    let icon: String
    var keyboardType: UIKeyboardType = .default
    var isSecure: Bool = false
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 20)
            
            if isSecure {
                SecureField(placeholder, text: $text)
                    .keyboardType(keyboardType)
            } else {
                TextField(placeholder, text: $text)
                    .keyboardType(keyboardType)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
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
            // Handle social login
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
