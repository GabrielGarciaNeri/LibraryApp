
import SwiftUI


struct LoginView: View {
    @State var email: String = ""
    @State var password: String = ""
    
    var body: some View {
        NavigationStack{
            
            ZStack{
                
                Backgrounds.gradient1.ignoresSafeArea()
                
                VStack(spacing: 20){
                    
                    //Title Section
                    VStack{
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width:60 , height: 60)
                            .foregroundStyle(Color(.white))
                        
                        Text("Login")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundStyle(Color(.white))
                        
                        Text("Enter your credentials to continue")
                            .font(.subheadline)
                            .foregroundStyle(Color(hex:"#fcfcfa"))
                    }
                    .padding(.bottom, 30)
                    
                    //email
                    VStack (alignment: .leading){
                        Text("Email")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundStyle(.white)
                        
                        TextField("Your Email", text: $email)
                            .textFieldStyle(.plain)
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            .padding()
                            .background(Color(.white).opacity(0.8))
                            .cornerRadius(10)
                        
                    }
                    //password
                    VStack (alignment: .leading){
                        Text("Password")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundStyle(.white)
                        
                        SecureField("Your Password", text: $password)
                            .textFieldStyle(.plain)
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .padding()
                            .background(Color(.white).opacity(0.8))
                            .cornerRadius(10)
                        
                    }
                    
                    //button
                    Button(action:{})
                    {
                        Text("Login")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding(.top, 20)
                    .padding(.horizontal, 50)
                  
                 
                    //sign up button
                    VStack{
                        Divider()
                            .padding(.vertical, 10)
                        Text("Don't have an account?")
                            .font(.caption)
                            .foregroundStyle(.white)
                       
                        Button(action:{}){
                            Text("Sign Up")
                                .font(.caption)
                                .foregroundStyle(.blue)
                        }
                    }
                    
                    Spacer()
                    
                }
                .padding(50)
                
               
                
            }
            
        }
    }
}


#Preview {
    LoginView()
}
