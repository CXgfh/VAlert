//
//  DateFormatter.swift
//  Countdown
//
//  Created by flow on 2020/10/27.
//

import Foundation

//MARK: -时间显示
public extension Date {
    /*
     年 yyyy
     月 MM
     日 dd
     星期 EEEE
     时 HH
     分 mm
     秒 ss
     Wednesday, Sep 12, 2018           --> EEEE, MMM d, yyyy
     09/12/2018                        --> MM/dd/yyyy
     09-12-2018 14:11                  --> MM-dd-yyyy HH:mm
     Sep 12, 2:11 PM                   --> MMM d, h:mm a
     September 2018                    --> MMMM yyyy
     Sep 12, 2018                      --> MMM d, yyyy
     Wed, 12 Sep 2018 14:11:54 +0000   --> E, d MMM yyyy HH:mm:ss Z
     2018-09-12T14:11:54+0000          --> yyyy-MM-dd'T'HH:mm:ssZ
     12.09.18                          --> dd.MM.yy
     10:41:02.112                      --> HH:mm:ss.SSS
    */
    var timeString: String {
        let dateF = DateFormatter()
        dateF.dateFormat = "HH:mm"
        dateF.locale = .init(identifier: identifier)
        return dateF.string(from: self)
    }
    
    var weekString: String {
        let dateF = DateFormatter()
        dateF.dateFormat = "EEEE"
        dateF.locale = .init(identifier: identifier)
        return dateF.string(from: self)
    }
    
    var monthString: String {
        let dateF = DateFormatter()
        dateF.dateFormat = "EEEE,MM,dd"
        dateF.locale = .init(identifier: identifier)
        return dateF.string(from: self)
    }
    
    var yearString: String {
        let dateF = DateFormatter()
        dateF.dateFormat = "yyyy/MM/dd EEEE"
        dateF.locale = .init(identifier: identifier)
        return dateF.string(from: self)
    }
}



