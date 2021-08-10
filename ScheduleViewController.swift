//
//  ScheduleViewController.swift
//  SecondApp
//
//  Created by Sheela Ravindran on 7/23/21.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
class ScheduleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    var AssignmentNames: [String] = []
    var AssignmentDates: [Date] = []
    var CompletionTime: [Int] = []
    var ECTime: [Int] = []
    var totalElements = 0
    @IBOutlet weak var TableView: UITableView!
    var ref: DatabaseReference!
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        ref.child(Auth.auth().currentUser!.uid).child("schedule").child("Assignments").observeSingleEvent(of: .value, with: { (snapshot) in
            for rest in snapshot.children.allObjects as! [DataSnapshot]{
                self.totalElements += 1
                self.AssignmentNames.append(rest.key)
                self.ref.child(Auth.auth().currentUser!.uid).child("schedule").child("Assignments").child(rest.key).observeSingleEvent(of: .value, with: { (snapshot) in
                    let value = snapshot.value as? NSDictionary
                    let date = value?["Date"] as? String ?? ""
                    let ECTime = value?["ECTime"] as? Int ?? 0
                    let CompletionTime = value?["CompleteTime"] as? Int ?? 0
                    self.ECTime.append(ECTime)
                    self.CompletionTime.append(CompletionTime)
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateStyle = DateFormatter.Style.short
                    self.AssignmentDates.append(dateFormatter.date(from: date)!)
                })
            }
            for i in 0..<self.totalElements{
                self.createSchedule(currentIndex: i)
            }
        })
        
        
        
        // Do any additional setup after loading the view.
    }
    func createSchedule(currentIndex: Int) {
        let dateFormatter = DateFormatter()
        let date = Date()
        dateFormatter.dateStyle = DateFormatter.Style.short
        let currentDate = dateFormatter.string(from: date)
        let difference = Calendar.current.dateComponents([.day], from: dateFormatter.date(from: currentDate)!, to: AssignmentDates[currentIndex])
        var daysDifference = difference.day
        let initialDaysDifference = daysDifference! - 1
        var timePerDay = Double(CompletionTime[currentIndex])/Double(daysDifference!)
        
        while(timePerDay < 10){
            daysDifference = daysDifference!/2
            timePerDay = Double(CompletionTime[currentIndex])/Double(daysDifference!)
            
        }
        let spaceBetweenStudying = initialDaysDifference/daysDifference!
        let schedule = daysToStudy(space: spaceBetweenStudying, currentDate: currentDate, daysDifference: daysDifference!)
        var scheduleDOW: [String] = []
        for i in schedule {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE"
            scheduleDOW.append(dateFormatter.string(from: i))
        }
    }
    func daysToStudy(space: Int, currentDate: String, daysDifference: Int) -> [Date]{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        let date = dateFormatter.date(from: currentDate)
        dateFormatter.dateFormat = "dd"
        let day = dateFormatter.string(from: date!)
        var intDay = 0
        if let number = Int(day){
            intDay = number
        }
        var allDates: [Date] = []
        intDay+=1
        dateFormatter.dateFormat = "dd"
        let day = dateFormatter.string(from: date!)
        var intDay = 0
        if let number = Int(day){
            intDay = number
        }
        dateFormatter.dateFormat = "MM"
        let month = dateFormatter.string(from: date!)
        var intMonth = 0
        if let number = Int(month){
            intMonth = number
        }
        dateFormatter.dateFormat = "yy"
        let year = dateFormatter.string(from: date!)
        var intYear = 0
        if let number = Int(year){
            intYear = number
        }
        var updatedDate = checkDate(day: intDay, month: intMonth, year: intYear, spacing: 1)
        intDay = updatedDate.0
        intMonth = updatedDate.1
        intYear = updatedDate.2
        
        for i in 0...daysDifference {
            intDay += i*space
            updatedDate = checkDate(day: intDay, month: intMonth, year: intYear, spacing: 1)
            intDay = updatedDate.0
            intMonth = updatedDate.1
            intYear = updatedDate.2
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/YY"
            let date = dateFormatter.date(from: "\(intMonth)/\(intDay)/\(intYear)")
            allDates.append(date!)
            
        }
       return allDates
        
    }
    func checkDate(day: Int, month: Int, year: Int, spacing: Int)
    -> (Int, Int, Int){
        var localDay = day
        var localMonth = month
        var localYear = year
            if day > 30 && (month == 4 || month == 6 || month == 9 || month == 11) {
                localMonth+=1
                localDay = spacing
                
                
            }
            else if day > 31 && (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12){
                localMonth += 1
                localDay = spacing
                if localMonth == 13{
                    localMonth = 1
                    localYear += 1
                    
                }
            }
            else if day > 29 && month == 2{
                localMonth += 1
                localDay = spacing - (day - 29)
            }
        return (localDay, localMonth, localYear)
        }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
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
