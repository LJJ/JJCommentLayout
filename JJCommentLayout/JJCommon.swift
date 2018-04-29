//
//  JJCommon.swift
//  JJCommentLayout
//
//  Created by Michael Lu on 4/22/18.
//  Copyright © 2018 Michael Lu. All rights reserved.
//

import Foundation
import UIKit

fileprivate var now = Date.init(timeIntervalSinceNow: 0)

func RGB(_ r:CGFloat, _ g:CGFloat, _ b:CGFloat) -> UIColor {
    return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1)
}

func updateCurrentTime() {
    now = Date(timeIntervalSinceNow: 0)
    
//    let dateFormatter = DateFormatter()
//    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//    let dateString = dateFormatter.string(from: now)
//    print(dateString)
}

func timeSince(created:Date) -> String {
    let duration = now.timeIntervalSince(created)
    if (duration<=15) {
        return String(format: "%.0f sec ago", duration)
    }
    else if (duration>15 && duration<=60) {
        return "15 sec ago"
    }
    else if (duration>60 && duration<=3600)
    {
        return String(format:"%.0f min ago",duration/60)
    }
    else if (duration>3600 && duration <= 3600*24)
    {
        return String(format:"%.0f hour ago",duration/3600)
    }
    else if (duration>3600*24 && duration<=3600*24*3)
    {
        return String(format:"%.0f day ago",duration/(3600*24))
    }
    else
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: created)
        return dateString;
    }
}
