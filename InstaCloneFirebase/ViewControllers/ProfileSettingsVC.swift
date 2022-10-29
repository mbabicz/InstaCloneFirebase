//
//  ProfileSettingsVC.swift
//  InstaCloneFirebase
//
//  Created by kz on 13/10/2022.
//

import UIKit
import Firebase
import FirebaseStorage
import SDWebImage

class ProfileSettingsVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    @IBOutlet weak var changeProfilePictureLabel: UILabel!
    
    let firestoreDatabase = Firestore.firestore()

    let userID = Auth.auth().currentUser!.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadProfileImage()

        changeProfilePictureLabel.isUserInteractionEnabled = true
        profileImage.isUserInteractionEnabled = true
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        changeProfilePictureLabel.addGestureRecognizer(gestureRecognizer)
        profileImage.addGestureRecognizer(gestureRecognizer)
    }
    
    @IBAction func logOutClicked(_ sender: Any) {
        do{
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "toViewController", sender: nil)

            } catch{
                print("error")
            }
    }
    
    @IBAction func saveButton(_ sender: Any) {
        let description = ["description" : descriptionTextField.text!] as [String : Any]
        firestoreDatabase.collection("Users").document(userID).setData(description, merge: true)
        saveNewProfilePicture()

        performSegue(withIdentifier: "toProfileVC", sender: nil)
    }
    
    @objc func chooseImage(){
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        profileImage.image = info[.originalImage] as? UIImage
        self.makeRounded(picture: self.profileImage)

        self.dismiss(animated: true, completion: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toProfileVC"{
            if let destVC = segue.destination as? UITabBarController{
                destVC.selectedIndex = 4
            }
        }
    }
    func loadProfileImage(){
        let ref = firestoreDatabase.collection("Users").document(userID)
        ref.getDocument { document, error in
            guard let document = document, document.exists else { return }
            let transformer = SDImageResizingTransformer(size: CGSize(width: 180,height: 180), scaleMode: .fill)
            let dataDescription = document.data()
            if let userImage = dataDescription?["profile picture"] as? String{
                self.profileImage.sd_setImage(with:URL(string: userImage), placeholderImage: nil, context: [.imageTransformer: transformer])
                self.makeRounded(picture: self.profileImage)
            }
        }
    }
    
    
    func makeRounded(picture : UIImageView){
        picture.layer.borderWidth = 1.0
        picture.layer.masksToBounds = false
        picture.layer.borderColor = UIColor.white.cgColor
        picture.layer.cornerRadius = picture.frame.size.width / 2
        picture.clipsToBounds = true
    }

    func saveNewProfilePicture(){
        let storage = Storage.storage()
        let storageReference = storage.reference()
        let mediaFolder = storageReference.child("profile-pictures")
        
        
        if let data = profileImage.image?.jpegData(compressionQuality: 0.5){
            let imageReference = mediaFolder.child("\(userID).jpeg")
            imageReference.putData(data) { (metadata, error) in
                if error != nil {
                    self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error")
                } else {
                    imageReference.downloadURL { (url, error) in
                        if error == nil {
                            let imageUrl = url?.absoluteString
                            let docRef = self.firestoreDatabase.collection("Users").document(self.userID)
                            let newImageURL = ["profile picture" : imageUrl!] as [String : Any]
                            docRef.setData(newImageURL, merge: true)
                            
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
