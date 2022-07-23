//
//  AddClassViewController.swift
//  SecondApp
//
//  Created by Sheela Ravindran on 7/23/21.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
class AddClassViewController: UIViewController {

    @IBOutlet weak var NextButton: UIButton!
    @IBOutlet weak var Answer: UITextField!
    @IBOutlet weak var Question: UILabel!
    @IBOutlet weak var DatePicker: UIDatePicker!
    var QuestionArray = ["What is the name of your class?", "When is your assignment's due date?", "What is the Approximate Time you Need to Complete the Assignment in(in Minutes)?", "Enter the amount of extracurricular time you need for yourself everyday(in Minutes)", "What is the Name of your Assignment?"]
    var ref: DatabaseReference!
    var AnswerArray: [String] = []
    var dateTemplate = "__/__/__"
    let dateFormatter = DateFormatter()
    var currentIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        DatePicker.isHidden = true
        setConstraints()
        Question.text = QuestionArray[currentIndex]
        dateFormatter.dateStyle = DateFormatter.Style.short
        
        // Do any additional setup after loading the view.
    }
    @IBAction func OnChangeDatePicker(_ sender: Any) {
        dateTemplate = dateFormatter.string(from: DatePicker.date)
        Answer.text = dateTemplate
        
    }
    func setConstraints(){
        Question.frame = CGRect(x: 0, y: 120.0/896.0*self.view.frame.height, width: self.view.frame.width, height: self.view.frame.width/2)
        Answer.frame = CGRect(x: self.view.frame.width/6.0, y: Question.frame.maxY+30.0, width: self.view.frame.width*4.0/6.0, height: Answer.frame.height)
        NextButton.frame = CGRect(x: 168.0/414.0*self.view.frame.width, y: 410.0/896.0*self.view.frame.height, width: 78.0/414.0*self.view.frame.width, height: 75.0)
        Question.textAlignment = .center
    }
    @IBAction func OnNext(_ sender: Any) {
        if verification(){
            AnswerArray.append(Answer.text!)
            currentIndex+=1
            if currentIndex < QuestionArray.count{
                Question.text = QuestionArray[currentIndex]
                if currentIndex != 1{
                    Answer.text = ""
                    Answer.isEnabled = true
                    DatePicker.isHidden = true
                }
                else {
                    Answer.text = dateTemplate
                    DatePicker.isHidden = false
                    Answer.isEnabled = false
                }
            }
            else {
                let CompleteTime = Int(AnswerArray[2])
                let ECTime = Int(AnswerArray[3])
                let UID = Auth.auth().currentUser!.uid
                print(AnswerArray)
                ref.child(UID).child("schedule").child("Assignments").child(AnswerArray[4]).child("ClassName").setValue(AnswerArray[0])
                ref.child(UID).child("schedule").child("Assignments").child(AnswerArray[4]).child("Date").setValue(AnswerArray[1])
                ref.child(UID).child("schedule").child("Assignments").child(AnswerArray[4]).child("CompleteTime").setValue(CompleteTime)
                ref.child(UID).child("schedule").child("Assignments").child(AnswerArray[4]).child("ECTime").setValue(ECTime)
                
                self.dismiss(animated: true, completion: nil)
            }
        }
        else{
            alert(message: "Fill in Textfield")
        }
    }
    func alert(message: String){
        var alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        let okay = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default)
            
        
        alert.addAction(okay)
        self.present(alert, animated: true)
    }
   
    func verification() -> Bool{
        if let text = Answer.text{
            if text.count > 0{
                if let answer = Int(text){
        
                    return true
                }
                else if(currentIndex==0||currentIndex==1 || currentIndex==4){
                    return true
                }
                else{
                    alert(message: "Please enter an Integer Value")
                }
                
                return false
                
            }
            else {
                return false
            }
        }
        return false
        
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
