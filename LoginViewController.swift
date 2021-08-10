//
//  LoginViewController.swift
//  SecondApp
//
//  Created by Sheela Ravindran on 7/9/21.
//

import UIKit
import FirebaseAuth
class LoginViewController: UIViewController {

    @IBOutlet weak var BackButton: UIButton!
    @IBOutlet weak var NextButton: UIButton!

    @IBOutlet weak var PasswordTextBox: UITextField!
    @IBOutlet weak var EmailTextBox: UITextField!
    @IBOutlet weak var TitleLabel: UILabel!
    var isEmail = false
    var isPassword = false
    override func viewDidLoad() {
        super.viewDidLoad()
        setConstraints()
        // Do any additional setup after loading the view.
    }
    
  
       
  

    func setConstraints(){
        TitleLabel.frame = CGRect(x: 0, y: 114.0/896.0*self.view.frame.height, width: self.view.frame.width, height: 40)
        EmailTextBox.frame = CGRect(x: self.view.frame.width*1.0/6.0, y: 264.0/896.0*self.view.frame.height, width: self.view.frame.width*4.0/6.0, height: EmailTextBox.frame.height)
        PasswordTextBox.frame = CGRect(x: self.view.frame.width*1.0/6.0, y: 340.0/896.0*self.view.frame.height, width: self.view.frame.width*4.0/6.0, height: PasswordTextBox.frame.height)
       
        let x = 112.0/414.0*self.view.frame.width
        NextButton.frame = CGRect(x: x, y: 521.0/896.0*self.view.frame.height, width: self.view.frame.width-(x*2), height: ((self.view.frame.width-(x*2))/4))
        BackButton.frame = CGRect(x: x, y: 616.0/896.0*self.view.frame.height, width: self.view.frame.width-(x*2), height: ((self.view.frame.width-(x*2))/4))
    }
    
    @IBAction func OnNext(_ sender: Any) {
        if verification(){
            Auth.auth().signIn(withEmail: EmailTextBox.text!, password: PasswordTextBox.text!) { (user,error) in
                if error == nil{
                    self.performSegue(withIdentifier: "LoginToHome", sender: nil)
                }
                else {
                    self.alert(message: "Your email/password is badly formatted or that information is not in our system.")
                }}
        }
        else {
            alert(message: "Make sure you fill in all the textboxes.")
        }
    }
    func verification() -> Bool {
        if let emailtext = EmailTextBox.text{
            if let passwordtext = PasswordTextBox.text {
                
                if emailtext.count != 0 && passwordtext.count != 0 {
                    return true
                }
                
            }
        }
        return false
    }
    @IBAction func OnBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
