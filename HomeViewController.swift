//
//  HomeViewController.swift
//  SecondApp
//
//  Created by Sheela Ravindran on 7/21/21.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var ViewSchedule: UIButton!
    @IBOutlet weak var AddClass: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    func setConstraints()
    {
        AddClass.frame = CGRect(x: 156.0/414.0*self.view.frame.width, y: 134.0/896.0*self.view.frame.height, width: 102.0/414.0*self.view.frame.width, height:50 )
        ViewSchedule.frame = CGRect(x: 104.0/414.0*self.view.frame.width, y: 248.0/896.0*self.view.frame.height, width: 206.0/414.0*self.view.frame.width, height:50 )
    }
    @IBAction func OnAddClass(_ sender: Any) {
        self.performSegue(withIdentifier: "HomeToAddClass", sender: nil)
    }
    
    @IBAction func OnViewSchedule(_ sender: Any) {
        self.performSegue(withIdentifier: "HomeToSchedule", sender: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
