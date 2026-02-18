import SwiftUI

struct SignupView: View {
    
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var email: String = ""
    @State var password: String = ""
    
    var body: some View {
        NavigationStack{
            
            ZStack{
                
                Backgrounds.gradient1.ignoresSafeArea()
                
                VStack{
                    //Title Section
                    VStack{
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width:60 , height: 60)
                            .foregroundStyle(Color(.white))
                        
                        Text("Sign Up")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundStyle(Color(.white))
                        
                        Text("Create an account to continue")
                            .font(.subheadline)
                            .foregroundStyle(Color(hex:"#fcfcfa"))
                    }
                    .padding(.bottom, 30)
                    
                    //Form
                    VStack (spacing: 20){
                        
                        //first name
                        VStack (alignment: .leading){
                            Text("First Name")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundStyle(.white)
                            
                            TextField("Your Name", text: $firstName)
                                .textFieldStyle(.plain)
                                .padding()
                                .background(Color(.white).opacity(0.8))
                                .cornerRadius(10)
                                
                        }
                        
                        //last name
                        VStack (alignment: .leading){
                            Text("Last Name")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundStyle(.white)
                            
                            TextField("Your Last Name", text: $lastName)
                                .textFieldStyle(.plain)
                                .padding()
                                .background(Color(.white).opacity(0.8))
                                .cornerRadius(10)
                                
                        }
                        
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
                            Text("Sign Up")
                                .frame(maxWidth: .infinity)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                        .padding(.top, 20)
                        .padding(.horizontal, 50)
                        
                        Spacer()
                    }
                    .padding(20)
                }
            }
        }
    }
}

#Preview {
    SignupView()
}
