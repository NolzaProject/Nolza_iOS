//
//  SettingDurationVC.swift
//  Nolza
//
//  Created by 전한경 on 2017. 7. 16..
//  Copyright © 2017년 jeon. All rights reserved.
//

import UIKit
import FSCalendar

enum WeekDay : Int{
    case sun = 1
    case mon
    case tue
    case wed
    case thr
    case fri
    case sat
    
    var name: String{
        switch self {
        case .sun:
            return "Sun"
        case .mon:
            return "Mon"
        case .tue:
            return "Tue"
        case .wed:
            return "Wed"
        case .thr:
            return "Thr"
        case .fri:
            return "Fri"
        case .sat:
            return "Sat"
        default: break
            
        }
    }
}

class SettingDurationVC : UIViewController,FSCalendarDelegate,FSCalendarDataSource{
    
    
    @IBOutlet weak var fromDay: UILabel!
    @IBOutlet weak var toDay: UILabel!

    @IBOutlet weak var fromWeekDay: UILabel!
    @IBOutlet weak var toWeekDay: UILabel!

    fileprivate let gregorian = Calendar(identifier: .gregorian)
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    fileprivate weak var calendar: FSCalendar!
    
    var dates : [Date] = []
    var chooseDate : Date?
    var count = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.revealNavigationBar()
        let calendar = FSCalendar(frame: CGRect(x: 20, y: 300, width: 320, height: 300))
        calendar.dataSource = self
        calendar.delegate = self
        calendar.allowsMultipleSelection = true
    
        view.addSubview(calendar)
        self.calendar = calendar
        
        }
    
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("did select date \(self.formatter.string(from: date))")
        
        
        print("\(gregorian.component(.weekday, from: date))")
        
        let weekDay = gregorian.component(.weekday, from: date)
        
        //self.configureVisibleCells()
        
        if count % 2 == 0{
            chooseDate = date
            let converted = self.formatter.string(from: date)
            
            fromDay.text = converted.substring(from: converted.index(converted.endIndex, offsetBy: -2))
            fromWeekDay.text = WeekDay(rawValue:weekDay)?.name
        }else{
            
            between(from: chooseDate!, to: date)
            let converted = self.formatter.string(from: date)
            
            toDay.text = converted.substring(from: converted.index(converted.endIndex, offsetBy: -2))
            toWeekDay.text = WeekDay(rawValue:weekDay)?.name
        }
        
        count += 1
        
        //사이값을 구해서 value를 1씩늘려가면서 datesArray에 추가하고
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date) {
        print("did deselect date \(self.formatter.string(from: date))")
        //self.configureVisibleCells()
    }
    
    func between(from : Date, to : Date){
        let current = NSCalendar.current
        let components = current.dateComponents([.day], from: from, to: to)

        for i in 1..<components.day!+1 {
            let day = self.gregorian.date(byAdding: .day, value: i, to: from)

            self.calendar.select(day, scrollToDate: false)
        }
        
        
    }
    
    

}
