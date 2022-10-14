//
//  ProfileSettingsVC.swift
//  InstaCloneFirebase
//
//  Created by kz on 13/10/2022.
//

import UIKit
import Firebase

class ProfileSettingsVC: UIViewController {

    @IBOutlet weak var descriptionTextField: UITextField!
    let userID = Auth.auth().currentUser!.uid
    
    @IBAction func saveButton(_ sender: Any) {
        var firestoreDatabase = Firestore.firestore()
        let description = ["description" : descriptionTextField.text!] as [String : Any]
        firestoreDatabase.collection("Users").document(userID).setData(description, merge: true)

        performSegue(withIdentifier: "toProfileVC", sender: nil)
        //makeAlert(titleInput: "DONE", messageInput: "")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toProfileVC"{
            if let destVC = segue.destination as? UITabBarController{
                destVC.selectedIndex = 3
            }
        }
    }
    
    
    func makeAlert(titleInput:String, messageInput:String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated:true, completion: nil)
    }
    

}
