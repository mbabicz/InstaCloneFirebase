//
//  SignUpViewController.swift
//  InstaCloneFirebase
//
//  Created by kz on 10/10/2022.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {
    
    
    @IBOutlet weak var usernameText: UITextField!
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
    
    
    
    @IBAction func signUpButton(_ sender: Any) {
        if(emailText.text != "" && passwordText.text != "" && usernameText.text != ""){
            
            //check username
            Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!) { (authdata, error) in
                if(error != nil){
                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                    
                } else{
                    
                    let userID = Auth.auth().currentUser!.uid
                    print(userID)
                    let firestoreDatabase = Firebase.Firestore.firestore()
                    var firestoreReference : DocumentReference? = nil

                    firestoreDatabase.collection("Users").document(userID).setData([
                        "username" : self.usernameText.text!,
                        "email" : self.emailText.text!,
                        "date of registration" : FieldValue.serverTimestamp(),
                        "description" : "",
                        "profile picture" : "https://firebasestorage.googleapis.com/v0/b/instaclonefirebase-2b29a.appspot.com/o/media%2Fprofile-picture.png?alt=media&token=bf026256-7466-43fb-8ede-c57163f3391a"
                    
                    ]){ err in
                        if err != nil{
                            //error
                            self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                        } else{
                            self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                            self.makeAlert(titleInput: "DONE", messageInput: " ")
                        }
                    }
                }
            }
        }
        else{
            makeAlert(titleInput: "Error", messageInput: "Fields cannot be empty!")
        }
    }
    

    @IBAction func signInButton(_ sender: Any) {
        self.performSegue(withIdentifier: "toViewController", sender: nil)
    }
    
    
    func makeAlert(titleInput:String, messageInput:String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated:true, completion: nil)
    }

}
