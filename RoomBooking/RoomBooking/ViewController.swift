//
//  ViewController.swift
//  RoomBooking
//
//  Created by Fareed Quraishi on 2017-11-17.
//  Copyright © 2017 Treefrog Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var timer: Timer?
    
    @IBOutlet weak var vwFadeToBlack: UIView!

    @IBOutlet weak var lblInUse: UILabel!
    @IBOutlet weak var vwStatus: UIView!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var tblBookings: UITableView!
    
    @IBOutlet weak var cstPopUpLocation: NSLayoutConstraint!
    @IBOutlet weak var txtPopupEventAttendees: UITextView!
    @IBOutlet weak var lblPopupEventTime: UILabel!
    @IBOutlet weak var lblPopupEventName: UILabel!
    @IBOutlet weak var btnPopupDelete: UIButton!
    
    fileprivate var inUse = false
    fileprivate var currentlySelectedEvent = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getTimeOfDate()
        timer = Timer.scheduledTimer(timeInterval: 20, target: self, selector: #selector(self.getTimeOfDate), userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    @objc func getTimeOfDate() {
        removePastEvents()
        lblTime.text = Date().toString()
        inUse = checkInUse(Date())
        if inUse {
            lblInUse.text = "IN USE"
            vwStatus.backgroundColor = colours.red1
            tblBookings.reloadData()
        } else {
            lblInUse.text = "OPEN"
            vwStatus.backgroundColor = colours.green2
            tblBookings.reloadData()
        }
    }
    
    func removePastEvents() {
        if appSession.shared.events[0].count == 0 {
            return
        }
        repeat {
            if Date() > appSession.shared.events[0][0].end {
                appSession.shared.events[0].remove(at: 0)
            } else {
                return
            }
        } while true
    }
    
    func checkInUse(_ given:Date) -> Bool {
        for i in 0 ..< appSession.shared.events[0].count {
            if given > appSession.shared.events[0][i].start && given < appSession.shared.events[0][i].end {
                return true
            }
        }
        return false
    }
    
    @IBAction func btnCloseClicked(_ sender: Any) {
        closePopUp()
    }
    
    @IBAction func btnDeleteEventClicked(_ sender: Any) {
        if Date() > appSession.shared.events[0][currentlySelectedEvent].start && Date() < appSession.shared.events[0][currentlySelectedEvent].end {
            inUse = false
        }
        appSession.shared.events[0].remove(at: currentlySelectedEvent)
        getTimeOfDate()
        closePopUp()
    }
    
    func closePopUp(){
        UIView.animate(withDuration: 0.6) {
            self.vwFadeToBlack.alpha = 0
            self.cstPopUpLocation.constant = 800
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func btnReserveClicked(_ sender: Any) {
        if inUse {
            alertRoomInUse()
            return
        }
        
        let alert = UIAlertController(title: "Impromptu Meeting", message: "How long do you need the room?", preferredStyle: .alert)
        let min15Action = UIAlertAction(title: "15 mins", style: .default) {
            (a:UIAlertAction) -> Void in
            self.addMeeting(length:15)
        }
        alert.addAction(min15Action)
        let min30Action = UIAlertAction(title: "30 mins", style: .default) {
            (a:UIAlertAction) -> Void in
            self.addMeeting(length:30)
        }
        alert.addAction(min30Action)
        let min60Action = UIAlertAction(title: "60 mins", style: .default) {
            (a:UIAlertAction) -> Void in
            self.addMeeting(length:60)
        }
        alert.addAction(min60Action)
        if appSession.shared.events[0].count != 0 {
            let untilNextMeetingAction = UIAlertAction(title: "Until Next Meeting", style: .default) {
                (a:UIAlertAction) -> Void in
                self.addMeeting(until: appSession.shared.events[0][0].start)
                
            }
            alert.addAction(untilNextMeetingAction)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {
            (a:UIAlertAction) -> Void in
        }
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true) { }
    }
    
    func addMeeting(length:Int) {
        let calendar = Calendar.current
        let date = calendar.date(byAdding: .minute, value: length, to: Date())!
        if checkInUse(date) || inUse {
            self.alertImproptuBookingFailed()
        } else {
            let newEvent = Event(name: "Impromptu Event", start: Date().toStringFromInput(), end: date.toStringFromInput(), attendies: "")
            appSession.shared.events[0].insert(newEvent, at: 0)
            self.getTimeOfDate()
        }
    }
    
    func addMeeting(until:Date) {
        let newEvent = Event(name: "Impromptu Event", start: Date().toStringFromInput(), end: until.toStringFromInput(), attendies: "")
        appSession.shared.events[0].insert(newEvent, at: 0)
        self.getTimeOfDate()
    }
}

extension ViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Upcomming events"
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vw = UIView()
        if inUse {
            vw.backgroundColor = colours.red2
        } else {
            vw.backgroundColor = colours.green4
        }
        let headerLabel = UILabel(frame: CGRect(x: 30, y: 5, width:
            tableView.bounds.size.width, height: tableView.bounds.size.height))
        headerLabel.font = UIFont(name: "Verdana", size: 20)
        headerLabel.textColor = UIColor.black
        if section == 0 {
            headerLabel.text = "Todays events"
        } else {
            headerLabel.text = "Upcomming events"
        }
        headerLabel.sizeToFit()
        vw.addSubview(headerLabel)
        return vw
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appSession.shared.events[section].count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return appSession.shared.events.count
    }
    
    func convertsToTimeRangeString(event:Event) -> String {
        return "\(event.startString) - \(event.endString)"
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "bookingCell", for: indexPath) as? bookingCell else { return UITableViewCell() }
        cell.lblName.text = appSession.shared.events[indexPath.section][indexPath.row].name
        cell.lblTime.text = convertsToTimeRangeString(event: appSession.shared.events[indexPath.section][indexPath.row])
        if inUse {
            cell.backgroundColor = colours.red1
        } else {
            cell.backgroundColor = colours.green2
        }
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        lblPopupEventName.text = appSession.shared.events[indexPath.section][indexPath.row].name
        lblPopupEventTime.text = convertsToTimeRangeString(event: appSession.shared.events[indexPath.section][indexPath.row])
        txtPopupEventAttendees.text = appSession.shared.events[indexPath.section][indexPath.row].attendies
        currentlySelectedEvent = indexPath.row
        if indexPath.section == 0 {
            btnPopupDelete.isHidden = false
        } else {
            btnPopupDelete.isHidden = true
        }
        UIView.animate(withDuration: 0.6) {
            self.vwFadeToBlack.alpha = 1
            self.cstPopUpLocation.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
}
