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
    
    @IBOutlet weak var usernameText: UITextField!
    
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
                    //let firestorePost = ["username" : self.usernameText.text!, "email" : //self.emailText.text!, "date" : FieldValue.serverTimestamp()]  as [String : Any]
                    
                    firestoreDatabase.collection("Users").document(userID).setData([
                        "username" : self.usernameText.text!,
                        "email" : self.emailText.text!,
                        "date of registration" : FieldValue.serverTimestamp()
                    
                    ]){ err in
                        if err != nil{
                            //error
                            self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                        } else{
                            self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                            self.makeAlert(titleInput: "DONE", messageInput: " ")
                        }
                        
                    }
                    
//                    firestoreReference = firestoreDatabase.collection("Users").addDocument(data: firestorePost, completion: { (error) in
//                        if error != nil {
//                            self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
//                        }
//                        else{
//                            self.performSegue(withIdentifier: "toFeedVC", sender: nil)
//                            self.makeAlert(titleInput: "DONE", messageInput: " ")
//
//                        }
//                    })
                }
            }
        }
        else{
            makeAlert(titleInput: "Error", messageInput: "Fields cannot be empty!")
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        

    }
    
    func makeAlert(titleInput:String, messageInput:String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated:true, completion: nil)
    }


}

