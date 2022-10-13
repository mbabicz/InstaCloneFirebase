//
//  UploadViewController.swift
//  InstaCloneFirebase
//
//  Created by kz on 01/10/2022.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseFirestore

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var selectImage: UIImageView!
    @IBOutlet weak var commentText: UITextField!
    @IBOutlet weak var uploadButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        selectImage.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        selectImage.addGestureRecognizer(gestureRecognizer)
        
    }
    
    @objc func chooseImage(){
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        selectImage.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    

    @IBAction func uploadButtonClicked(_ sender: Any) {
        
        let storage = Storage.storage()
        let storageReference = storage.reference()
        let mediaFolder = storageReference.child("media")
        
        if let data = selectImage.image?.jpegData(compressionQuality: 0.5){
            
            let uuid = UUID().uuidString
            let imageReference = mediaFolder.child("\(uuid).jpeg")
            imageReference.putData(data) { (metadata, error) in
                if error != nil {
                    self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error")
                } else {
                    imageReference.downloadURL { (url, error) in
                        if error == nil {
                            
                            let imageUrl = url?.absoluteString
                            
                            //DATABASE
                            
                            let firestoreDatabase = Firebase.Firestore.firestore()
                            var firestoreReference : DocumentReference? = nil
                            
                            var username = String()
                            
                            let userID = Auth.auth().currentUser?.uid
                            
                            let docRef = firestoreDatabase.collection("Users").document(userID ?? "")
                            
                            docRef.getDocument { (document, error) in
                                guard let document = document, document.exists else{
                                    print("doc does not exist")
                                    return
                                }
                                let dataDescription = document.data()
                                print(dataDescription?["username"] as! String)
                                username = dataDescription?["username"] as! String
                                
                                let firestorePost = ["imageUrl" : imageUrl!, "postedBy" :  username, "commentText" : self.commentText.text!, "date" : FieldValue.serverTimestamp(), "likes" : 0] as [String : Any]
                                
                                firestoreReference = firestoreDatabase.collection("Posts").addDocument(data: firestorePost, completion: { (error) in
                                    if error != nil {
                                        self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                                    }
                                    else {
                                        self.selectImage.image = UIImage(named: "select.png")
                                        self.commentText.text = ""
                                        self.tabBarController?.selectedIndex = 0
                                        self.makeAlert(titleInput: "DONE!", messageInput: " ")
                                    }
                                })
                                
                            }
                        }
                    }
                }
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
