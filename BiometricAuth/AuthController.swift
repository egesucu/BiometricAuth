//
//  File.swift
//  BiometricAuth
//
//  Created by Ege Sucu on 18.10.2022.
//

import Foundation
import LocalAuthentication


class AuthController : ObservableObject{
    
    fileprivate var isBiometricAvailable = false
    @Published var biometricType : LABiometryType = .none
    fileprivate var context : LAContext?
    
    
    init() {
        context = LAContext()
        context?.localizedCancelTitle = "Use Password" //Asked on the first/second fail biometric auth, default is cancel.
        context?.localizedFallbackTitle = "Use Password" //Asked on the second fail biometric auth. Default is Enter Password
    }
    
    deinit {
        context = nil
    }
    
    func askBiometricAvailability(completion: @escaping (Error?) -> Void){
        if let context{
            var failureReason : NSError?
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &failureReason){
                biometricType = context.biometryType
            } else {
                completion(failureReason)
            }
        }
    }
    
    func authenticate(completion : @escaping (Result<Bool, LAError>) -> Void){
        if let context{
            let reason = "Scan your face to log in."
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, error in
                if success{
                    completion(.success(true))
                } else if let error = error as? LAError{
                    switch error.code{
                    case .authenticationFailed:
                        completion(.failure(error))
//                        The user failed to provide valid credentials.
                    case .userCancel:
                        completion(.failure(error))
//                        The user tapped the cancel button in the authentication dialog.
                    case .userFallback:
                        completion(.failure(error))
//                        The user tapped the fallback button in the authentication dialog, but no fallback is available for the authentication policy.
                    case .systemCancel:
                        completion(.failure(error))
//                            The system canceled authentication.
                    case .passcodeNotSet:
                        completion(.failure(error))
//                        A passcode isn’t set on the device.
                    case .biometryNotAvailable:
                        completion(.failure(error))
//                        Biometry is not available on the device.
                    case .biometryNotPaired:
                        completion(.failure(error))
//                        The device supports biometry only using a removable accessory, but no accessory is paired.
                    case .biometryDisconnected:
//                        The device supports biometry only using a removable accessory, but the paired accessory isn’t connected.
                        completion(.failure(error))
                    case .biometryLockout:
                        completion(.failure(error))
//                        Biometry is locked because there were too many failed attempts.
                    case .biometryNotEnrolled:
//                        The user has no enrolled biometric identities.
                        completion(.failure(error))
                    case .appCancel:
                        //The app canceled authentication.
                        completion(.failure(error))
                    case .invalidContext:
//                        The context was previously invalidated.
                        completion(.failure(error))
                    case .notInteractive:
//                        Displaying the required authentication user interface is forbidden.
                        completion(.failure(error))
                    case .watchNotAvailable:
//                        An attempt to authenticate with Apple Watch failed.
                        completion(.failure(error))
//                  case .touchIDNotAvailable,touchIDNotEnrolled,touchIDLockout:
//                  TODO: Apple shows those errors altaught they're deprecated in iOS 11
                    default:
                        completion(.failure(error))
                    }
                }
            }
        }
    }
    
    
    
}
