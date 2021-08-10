//
//  SignUpViewController.swift
//  SecondApp
//
//  Created by Sheela Ravindran on 7/9/21.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
class SignUpViewController: UIViewController {
    @IBOutlet weak var emailTextBox: UITextField!
    
    @IBOutlet weak var BackButton: UIButton!
    @IBOutlet weak var NextButton: UIButton!
    @IBOutlet weak var NameTextBox: UITextField!
    @IBOutlet weak var PasswordTextBox: UITextField!
    @IBOutlet weak var SignUpLabel: UILabel!
    var ref: DatabaseReference!
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        // Do any additional setup after loading the view.
    }
    func verification() -> Bool {
        if let emailtext = emailTextBox.text{
            if let passwordtext = PasswordTextBox.text {
                if let nametext = NameTextBox.text{
                    if emailtext.count != 0 && passwordtext.count != 0 && nametext.count != 0{
                        return true
                    }
                }
            }
        }
        return false
    }

    @IBAction func OnBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func OnNext(_ sender: Any) {
        
        if verification(){
            Auth.auth().createUser(withEmail: emailTextBox.text!, password: PasswordTextBox.text!){ (user,error) in
                if error == nil{
                    let UID = Auth.auth().currentUser!.uid
                    self.ref.child(UID).child("Name").setValue(self.NameTextBox.text!)
                    self.performSegue(withIdentifier: "SignUpToHome", sender: nil)
                }else {
                    self.alert(message: "Make sure you have a correctly formatted email or password.")
                }
            }
        }
        else {
            alert(message: "Make sure you fill in all the textboxes.")
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func alert(message: String){
        var myAlert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
        myAlert.addAction(ok)
        self.present(myAlert, animated: true)
    }
}
