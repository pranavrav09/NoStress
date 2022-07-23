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
    var Monday: [String] = []
    var Tuesday: [String] = []
    var Wednesday: [String] = []
    var Thursday: [String] = []
    var Friday: [String] = []
    var Saturday: [String] = []
    var Sunday: [String] = []
    
    var MondayTime: [Int] = []
    var TuesdayTime: [Int] = []
    var WednesdayTime: [Int] = []
    var ThursdayTime: [Int] = []
    var FridayTime: [Int] = []
    var SaturdayTime: [Int] = []
    var SundayTime: [Int] = []
    var AssignmentSchedule: [[String]] = []
    var AssignmentTimes: [Int] = []
    
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
                    self.runAfterFirebase()
                })
                
            }
            
        })
        
        
        
        // Do any additional setup after loading the view.
    }
    func runAfterFirebase() {
        for i in 0..<self.totalElements{
            self.createSchedule(currentIndex: i)
        }
        self.separateDays()
        self.TableView.dataSource = self
        self.TableView.delegate = self
        self.TableView.reloadData()
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
        //works till here
        let schedule = daysToStudy(space: spaceBetweenStudying, currentDate: currentDate, daysDifference: daysDifference!)
        print(schedule)
        var scheduleDOW: [String] = []
        for i in schedule {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE"
            scheduleDOW.append(dateFormatter.string(from: i))
        }
        
        var daysOfWeek = convertDaysOfWeek(daysOfWeek: scheduleDOW)
        daysOfWeek.insert(AssignmentNames[currentIndex], at: 0)
        
        AssignmentSchedule.append(daysOfWeek)
        AssignmentTimes.append(Int(timePerDay))
        print(AssignmentTimes)
        print(AssignmentSchedule)
        print(AssignmentNames)
        print(AssignmentDates)
    }
    func separateDays() {
        for i in 0..<AssignmentSchedule.count{
            for j in 0..<AssignmentSchedule[i].count {
                if AssignmentSchedule[i][j] == "Monday"{
                    
                    self.Monday.append(AssignmentSchedule[i][0])
                    self.MondayTime.append(AssignmentTimes[i])
                }
                if AssignmentSchedule[i][j] == "Tuesday"{
                    self.Tuesday.append(AssignmentSchedule[i][0])
                    self.TuesdayTime.append(AssignmentTimes[i])
                }
                if AssignmentSchedule[i][j] == "Wednesday"{
                    self.Wednesday.append(AssignmentSchedule[i][0])
                    self.WednesdayTime.append(AssignmentTimes[i])
                }
                if AssignmentSchedule[i][j] == "Thursday"{
                    self.Thursday.append(AssignmentSchedule[i][0])
                    self.ThursdayTime.append(AssignmentTimes[i])
                }
                if AssignmentSchedule[i][j] == "Friday"{
                    self.Friday.append(AssignmentSchedule[i][0])
                    self.FridayTime.append(AssignmentTimes[i])
                }
                if AssignmentSchedule[i][j] == "Saturday"{
                    self.Saturday.append(AssignmentSchedule[i][0])
                    self.SaturdayTime.append(AssignmentTimes[i])
                }
                if AssignmentSchedule[i][j] == "Sunday"{
                    self.Sunday.append(AssignmentSchedule[i][0])
                    self.SundayTime.append(AssignmentTimes[i])
                }
                
            }
        }
    }
    func convertDaysOfWeek(daysOfWeek: [String]) -> [String]{
        var weekArray: [String] = []
        
        for i in 0..<daysOfWeek.count{
            if i == 0{
                continue
            }
            else if daysOfWeeksNumber(currentDay: daysOfWeek[i]) > daysOfWeeksNumber(currentDay: daysOfWeek[i-1]){
                weekArray.append(daysOfWeek[i])
           
            }
            else {
                break
            }
            
            
        }
        return weekArray
    }
    func daysOfWeeksNumber(currentDay: String) -> Int{
        if currentDay == "Sunday"{
            return 1
        }
        else if currentDay == "Monday"{
            return 2
        }
        else if currentDay == "Tuesday"{
            return 3
        }
        else if currentDay == "Wednesday"{
            return 4
        }
        else if currentDay == "Thursday"{
            return 5
        }
        else if currentDay == "Friday"{
            return 6
        }
        else if currentDay == "Saturday"{
            return 7
        }
        return 0
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
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        return cell
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
