//
//  ViewController.swift
//  BiometricAuth
//
//  Created by Ege Sucu on 17.10.2022.
//

import UIKit
import LocalAuthentication
import SwiftUI

class ViewController: UIViewController {
    
    @IBOutlet weak var statusLabel : UILabel!
    @IBOutlet weak var authenticateButton: UIButton!
    
    
    var statusTitle = "Status:"
    let authController = AuthController()

    override func viewDidLoad() {
        super.viewDidLoad()
        statusLabel.text = statusTitle
        
        authController.askBiometricAvailability { [weak self] (error) in
            if let error,
               let strongSelf = self{
                strongSelf.statusLabel.text = "Status: \n" + error.localizedDescription
                strongSelf.statusLabel.textColor = .red
            }
        }
        
        switch authController.biometricType{
        case .touchID:
            authenticateButton.setImage(UIImage(named: "touchid"), for: .normal)
            authenticateButton.setTitle("Use TouchID", for: .normal)
        case .faceID:
            authenticateButton.setImage(UIImage(named: "faceid"), for: .normal)
            authenticateButton.setTitle("Use FaceID", for: .normal)
        case .none:
            authenticateButton.isHidden = true
        @unknown default:
            authenticateButton.isHidden = true
        }

        
    }
    
    @IBAction func buttonPressed(){
        authController.authenticate { [weak self] (result) in
            if let strongSelf = self{
                switch result {
                case .success(_):
                    strongSelf.printStatement(value: strongSelf.statusTitle + "\n Logged In.")
                case .failure(let failure):
                    strongSelf.printStatement(value: strongSelf.statusTitle + "\n\(failure.localizedDescription)")
                }
            }
            
        }
    }
    
    func printStatement(value: String) {
        DispatchQueue.main.async {
            self.statusLabel.text = value
        }
    }
    
    @IBAction func swiftUIButtonPressed(){
        let hostController = UIHostingController(rootView: ContentView())
        self.navigationController?.pushViewController(hostController, animated: true)
    }

}

