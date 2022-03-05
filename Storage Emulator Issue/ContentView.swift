//
//  ContentView.swift
//  Storage Emulator Issue
//
//  Created by Stewart Lynch on 2021-10-20.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @StateObject var vm = ViewModel()
    var body: some View {
        VStack {
                if vm.isUserAuthenticated != .signedIn {
                    VStack {
                        TextField("Email Address", text: $vm.email)
                        SecureField("Password",text: $vm.password)
                        Button {
                            if vm.isUserAuthenticated == .signedIn {
                                vm.logOut()
                            } else {
                                vm.login()
                            }
                        } label: {
                            Text(Auth.auth().currentUser?.uid == nil ? "Log In" : "Log Out")
                        }
                        Text("OR")
                        Button {
                            vm.newAccount = true
                        } label: {
                            Text("Create Account")
                        }
                        .sheet(isPresented: $vm.newAccount) {
                            SignUpView()
                        }
                    }
                    .padding()
                    .textFieldStyle(.roundedBorder)
                    .autocapitalization(.none)
                } else {
                    Button {
                        vm.logOut()
                    } label: {
                        Text("Log Out")
                    }
                }
            Image(uiImage: vm.image)
                .resizable()
                .cornerRadius(50)
                .frame(width: 200, height: 200)
                .background(Color.black.opacity(0.2))
                .aspectRatio(contentMode: .fill)
                .clipShape(Circle())
            if vm.isUserAuthenticated == .signedIn {
                Button {
                    vm.showSheet = true
                } label: {
                    Text("Update Profile Image")
                }
            }
        }
        .padding(.horizontal, 20)
        .onChange(of: vm.image, perform: { image in
            vm.image = image
            vm.saveProfileImage()
            
        })
        .sheet(isPresented: $vm.showSheet) {
            ImagePicker(sourceType: .photoLibrary, selectedImage: self.$vm.image)
        }
        .onAppear {
            vm.configureFirebaseStateDidChange()
        }
        if vm.isUserAuthenticated == .signedIn {
            Button {
                vm.getMetadata()
            } label: {
                Text("Get Metadata")
            }
        }
        if vm.isUserAuthenticated == .signedIn {
            Button {
                vm.updateMetadata()
            } label: {
                Text("Update Metadata")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
