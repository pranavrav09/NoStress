//
//  ViewController.swift
//  SecondApp
//
//  Created by Sheela Ravindran on 7/9/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var SignUp: UIButton!
    @IBOutlet weak var Login: UIButton!
    @IBOutlet weak var TitleLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        SetConstraints()
        // Do any additional setup after loading the view.
    }
    func SetConstraints(){
        TitleLabel.frame = CGRect(x: 0, y: (91.0/896.0)*self.view.frame.height, width: self.view.frame.width, height: TitleLabel.frame.height)
        Login.frame = CGRect(x: self.view.frame.width*0.25, y: 197.0/896.0*self.view.frame.height, width: self.view.frame.width*0.5, height: Login.frame.height)
        SignUp.frame = CGRect(x: self.view.frame.width*0.25, y: 259.0/896.0*self.view.frame.height, width: self.view.frame.width*0.5, height: SignUp.frame.height)
        Login.clipsToBounds = true
        SignUp.clipsToBounds = true
        Login.layer.cornerRadius = 20.0
        SignUp.layer.cornerRadius = 20.0
        Login.layer.borderWidth = 3.0
        SignUp.layer.borderWidth = 3.0
        Login.layer.borderColor = UIColor.black.cgColor
        SignUp.layer.borderColor = UIColor.black.cgColor
        Login.setTitleColor(UIColor.black, for: .normal)
        SignUp.setTitleColor(UIColor.black, for: .normal)
    }
    @IBAction func OnLogin(_ sender: Any) {
        self.performSegue(withIdentifier: "HomeToLogin", sender: nil)
    }
    
    @IBAction func OnSignUp(_ sender: Any) {
        self.performSegue(withIdentifier: "HomeToSignUp", sender: nil)
    }
}

