//
//  ViewController.swift
//  InstaCloneFirebase
//
//  Created by kz on 27/09/2022.
//

import UIKit
import Firebase
import FirebaseAuth

class ViewController: UIViewController {
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
       
   }
   
   @objc func dismissKeyboard() {
       view.endEditing(true)
   }
    
    @IBAction func signInClicked(_ sender: Any) {
        if(emailText.text != "" && passwordText.text != ""){
            Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!) { (authData, error) in
                if error != nil {
                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                } else {
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)

                } 
            }
        }
        else{
            makeAlert(titleInput: "Error", messageInput: "Fields cannot be empty!")
        }
    }
    
    
    @IBAction func signUpClicked(_ sender: Any) {
        self.performSegue(withIdentifier: "toSignUpVC", sender: nil)

    }
    
    func makeAlert(titleInput:String, messageInput:String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated:true, completion: nil)
    }


}

