//
//  ViewController.swift
//  FullClock
//
//  Created by sasama on 2015/10/01.
//  Copyright (c) 2015年 sasama. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    @IBOutlet weak var dateLabel: NSTextField!
    @IBOutlet weak var timeLabel: NSTextField!
    @IBOutlet weak var dateTopSpace: NSLayoutConstraint!
    @IBOutlet weak var timeTopSpace: NSLayoutConstraint!
    @IBOutlet weak var dateLeftSpace: NSLayoutConstraint!
    @IBOutlet weak var TimeRightSpace: NSLayoutConstraint!
    @IBOutlet weak var dateWidth: NSLayoutConstraint!
    @IBOutlet weak var timeWidth: NSLayoutConstraint!
    @IBOutlet weak var dateHeight: NSLayoutConstraint!
    @IBOutlet weak var timeHeight: NSLayoutConstraint!

    var flagTime = true
    var width : CGFloat = 0
    var height : CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        //= black background color
        self.view.wantsLayer = true
        let color : CGColorRef = CGColorCreateGenericRGB(0.0, 0.0, 0.0, 1.0)
        self.view.layer?.backgroundColor = color

        //= 1sec clock
        var timer = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: "clockWork", userInfo: nil, repeats: true)
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    override func viewWillLayout() {
        super.viewWillLayout()

        //= resize
        width = self.view.bounds.width
        height = self.view.bounds.height
        var length = width
        if width > height / 2 {
            length = height / 2
        }
        var dateFontSize = length * 0.4
        var timeFontSize = length * 0.9
        self.dateLabel.font = NSFont.systemFontOfSize(dateFontSize)
        self.timeLabel.font = NSFont.systemFontOfSize(timeFontSize)
        var dateFrame = CGSizeMake(width * 0.8, 1)
        var dateRect = dateLabel.sizeThatFits(dateFrame)
        self.dateWidth.constant = dateRect.width
        self.dateHeight.constant = dateRect.height
        var timeFrame = CGSizeMake(width * 0.8, 1)
        var timeRect = timeLabel.sizeThatFits(timeFrame)
        self.timeWidth.constant = timeRect.width
        self.timeHeight.constant = timeRect.height

        //= position
        //self.dateTopSpace.constant = (height - dateHeight.constant) / 2
        //self.timeTopSpace.constant = (height - timeHeight.constant) / 2
        var dateSpace = (UInt32)(height - dateHeight.constant)
        self.dateTopSpace.constant = (CGFloat)(arc4random_uniform(dateSpace))
        var timeSpace = (UInt32)(height - timeHeight.constant)
        self.timeTopSpace.constant = (CGFloat)(arc4random_uniform(timeSpace))
        var sideSpace = (UInt32)(width / 4)
        self.dateLeftSpace.constant = (CGFloat)(arc4random_uniform(sideSpace))
        self.TimeRightSpace.constant = (CGFloat)(arc4random_uniform(sideSpace))

    }

    func clockWork() {
        //= time
        var now = NSDate()
        var calendar = NSCalendar.currentCalendar()
        var components = calendar.components(
            NSCalendarUnit.CalendarUnitYear   |
            NSCalendarUnit.CalendarUnitMonth  |
            NSCalendarUnit.CalendarUnitDay    |
            NSCalendarUnit.CalendarUnitHour   |
            NSCalendarUnit.CalendarUnitMinute |
            NSCalendarUnit.CalendarUnitSecond |
            NSCalendarUnit.CalendarUnitWeekday,
            fromDate: now)
        var weekdayString = ["", "日", "月", "火", "水", "木", "金", "土"][components.weekday]
        var nowMinute = components.hour * 60 + components.minute
        var periodString = ""
        var timings = [
            "1限": [
                 8 * 60 + 45,
                10 * 60 + 15
            ],
            "2限": [
                10 * 60 + 30,
                12 * 60 + 0
            ],
            "3限": [
                13 * 60 + 0,
                14 * 60 + 30
            ],
            "4限": [
                14 * 60 + 45,
                16 * 60 + 15
            ],
            "5限": [
                16 * 60 + 30,
                17 * 60 + 0
            ]
        ]
        for (key, minutes) in timings {
            if minutes[0] <= nowMinute && nowMinute <= minutes[1] {
                periodString = key
            }
        }
        var dateText = String(format: "H%d %d\n%d/%d\n(\(weekdayString)) \(periodString)", components.year - 1988, components.year, components.month, components.day)
        self.dateLabel.stringValue = dateText
        var timeString = String(format: "%02d:%02d", components.hour, components.minute)
        self.timeLabel.stringValue = timeString
        
        //= color
        var red = (CGFloat)(arc4random_uniform(90)) * 0.1
        var green = (CGFloat)(arc4random_uniform(90)) * 0.1
        var blue = (CGFloat)(arc4random_uniform(90)) * 0.1
        self.dateLabel.textColor = NSColor(calibratedRed: 0.1 + red, green: 0.1 + green, blue: 0.1 + blue, alpha: 1.0)
        red = (CGFloat)(arc4random_uniform(90)) * 0.1
        green = (CGFloat)(arc4random_uniform(90)) * 0.1
        blue = (CGFloat)(arc4random_uniform(90)) * 0.1
        self.timeLabel.textColor = NSColor(calibratedRed: 0.1 + red, green: 0.1 + green, blue: 0.1 + blue, alpha: 1.0)

        //= visible(toggle)
        if flagTime {
            self.dateLabel.hidden = true
            self.timeLabel.hidden = false
            flagTime = false
        } else {
            self.dateLabel.hidden = false
            self.timeLabel.hidden = true
            flagTime = true
        }

        //= hide cursor
        NSCursor.hide()
        
        //= position(rand)
        viewWillLayout()
    }

    //override func mouseMoved(theEvent: NSEvent) {
    //    //= visible cursor
    //    NSCursor.unhide()
    //}
}
