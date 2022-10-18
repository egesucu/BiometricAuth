//
//  ContentView.swift
//  BiometricAuth
//
//  Created by Ege Sucu on 18.10.2022.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var authController = AuthController()
    @State private var status = "Status:"
    @State private var biometricAvailable = true
    
    var body: some View {
        VStack{
            Text(status)
                .foregroundColor(biometricAvailable ? .primary : .red)
                .font(.largeTitle)
                .multilineTextAlignment(.center)
                .padding(.top, 100)
                .padding(.bottom, 50)
            
            if authController.biometricType == .faceID{
                Button {
                    authenticate()
                } label: {
                    Label("Use FaceID", systemImage: "faceid")
                }
                .buttonStyle(.bordered)
            } else if authController.biometricType == .touchID{
                Button {
                    authenticate()
                } label: {
                    Label("Use TouchID", systemImage: "touchid")
                }
                .buttonStyle(.bordered)
            } else {
                Text("No Biometric Option Available")
            }
            
            Spacer()
        }.onAppear(perform: checkPermission)
    }
    
    func checkPermission(){
        authController.askBiometricAvailability { error in
            if let error{
                status = "Status: " + "\n" + error.localizedDescription
                biometricAvailable = false
            } else {
                biometricAvailable = true
            }
        }
    }
    
    func authenticate(){
        authController.authenticate { result in
            switch result {
            case .success(_):
                status = "Status:" + "\n Logged In."
            case .failure(let failure):
                status = "Status:" + failure.localizedDescription
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
