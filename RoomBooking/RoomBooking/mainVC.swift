//
//  ViewController.swift
//  RoomBooking
//
//  Created by Fareed Quraishi on 2017-11-17.
//  Copyright © 2017 Treefrog Inc. All rights reserved.
//

import UIKit

class mainVC: UIViewController {

    var timer: Timer?
    
    @IBOutlet weak var vwFadeToBlack: UIView!

    @IBOutlet weak var lblInUse: UILabel!
    @IBOutlet weak var vwTintBackground: UIView!
    @IBOutlet weak var vwStatus: UIView!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var tblBookings: UITableView!
    
    @IBOutlet weak var cstPopUpLocation: NSLayoutConstraint!
    @IBOutlet weak var txtPopupEventAttendees: UITextView!
    @IBOutlet weak var lblPopupEventTime: UILabel!
    @IBOutlet weak var lblPopupEventName: UILabel!
    @IBOutlet weak var btnPopupDelete: UIButton!
    
    fileprivate var events = [[Event]]()
    fileprivate var inUse = false
    fileprivate var currentlySelectedEvent = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        events = APILayer.shared.getEvents()
        
        updateScreen()
        timer = Timer.scheduledTimer(timeInterval: 20, target: self, selector: #selector(self.updateScreen), userInfo: nil, repeats: true)
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

    @objc func updateScreen() {
        removePastEvents()
        lblTime.text = Date().toString()
        inUse = checkInUse(Date())
        if inUse {
            lblInUse.text = "IN USE"
            vwStatus.backgroundColor = colours.red1
            vwTintBackground.isHidden = false
            tblBookings.reloadData()
        } else {
            lblInUse.text = "OPEN"
            vwStatus.backgroundColor = colours.green2
            vwTintBackground.isHidden = true
            tblBookings.reloadData()
        }
    }
    
    func removePastEvents() {
        if events[0].count == 0 {
            return
        }
        repeat {
            if events[0].isEmpty { return }
            if Date() > events[0][0].end {
                events[0].remove(at: 0)
            } else {
                return
            }
        } while true
    }
    
    func checkInUse(_ given:Date) -> Bool {
        for i in 0 ..< events[0].count {
            if given > events[0][i].start && given < events[0][i].end {
                return true
            }
        }
        return false
    }
    
    @IBAction func btnCloseClicked(_ sender: Any) {
        closePopUp()
    }
    
    @IBAction func btnDeleteEventClicked(_ sender: Any) {
        if Date() > events[0][currentlySelectedEvent].start && Date() < events[0][currentlySelectedEvent].end {
            inUse = false
        }
        events[0].remove(at: currentlySelectedEvent)
        updateScreen()
        closePopUp()
    }
    
    func closePopUp(){
        UIView.animate(withDuration: 0.6) {
            self.vwFadeToBlack.alpha = 0
            self.cstPopUpLocation.constant = 800
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func btnImpromtuMeetingClicked(_ sender: Any) {

        if inUse {
            alertRoomInUse()
            return
        }

        let alert = UIAlertController(title: "Impromptu Meeting", message: "How long do you need the room?", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Enter your name"
        }
        if events[0].count != 0 {
            let untilNextMeetingAction = UIAlertAction(title: "Until Next Meeting", style: .default) {
                (a:UIAlertAction) -> Void in
                let textField = alert.textFields![0]
                let name = self.extractName(textField)
                self.addMeeting(until: self.events[0][0].start, by: name)

            }
            alert.addAction(untilNextMeetingAction)
        }
        let min15Action = UIAlertAction(title: "15 mins", style: .default) {
            (a:UIAlertAction) -> Void in
            let textField = alert.textFields![0]
            let name = self.extractName(textField)
            self.addMeeting(length:15, by: name)
        }
        alert.addAction(min15Action)
        let min30Action = UIAlertAction(title: "30 mins", style: .default) {
            (a:UIAlertAction) -> Void in
            let textField = alert.textFields![0]
            let name = self.extractName(textField)
            self.addMeeting(length:30, by: name)
        }
        alert.addAction(min30Action)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {
            (a:UIAlertAction) -> Void in
        }
        alert.addAction(cancelAction)

        self.present(alert, animated: true) { }
    }
    
    func extractName(_ textField:UITextField) -> String {
        var name = "Someone"
        if let givenName = textField.text, !givenName.isEmpty {
            name = givenName
        }
        return name
    }
    
    func addMeeting(length:Int, by:String) {
        let calendar = Calendar.current
        let date = calendar.date(byAdding: .minute, value: length, to: Date())!
        if checkInUse(date) || inUse {
            self.alertImproptuBookingFailed()
        } else {
            let newEvent = Event(name: "Impromptu Event", start: Date().toStringFromInput(), end: date.toStringFromInput(), attendees: "")
            slackRequest(message: "\(by) has made a \(length) improptu booking of the Think Tank")
            events[0].insert(newEvent, at: 0)
            self.updateScreen()
        }
    }
    
    func addMeeting(until:Date, by: String) {
        let newEvent = Event(name: "Impromptu Event", start: Date().toStringFromInput(), end: until.toStringFromInput(), attendees: "")
        slackRequest(message: "\(by) has made an improptu booking of the Think Tank until \(until.toString())")
        events[0].insert(newEvent, at: 0)
        self.updateScreen()
    }
}

extension mainVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vw = UIView()
        
        // Set label style
        let headerLabel = UILabel(frame: CGRect(x: 30, y: 5, width:
            tableView.bounds.size.width, height: tableView.bounds.size.height))
        headerLabel.font = UIFont(name: "Aller", size: 20)
        headerLabel.textColor = UIColor.black
        
        // Set in use
        if inUse {
            vw.backgroundColor = colours.red2
        } else {
            vw.backgroundColor = colours.green4
        }
        
        // Depending upon section
        if section == 0 && events[0].count > 0 {
            headerLabel.text = "Todays events"
        } else if section == 0 && events[0].count == 0 {
            headerLabel.text = "No more events today"
        } else if section == 1 && events[0].count > 0  {
            headerLabel.text = "Upcomming events"
        } else if section == 1 && events[0].count == 0  {
            headerLabel.text = "No upcomming events"
        }
        
        // Apply view
        headerLabel.sizeToFit()
        vw.addSubview(headerLabel)
        return vw
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events[section].count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return events.count
    }
    
    func convertsToTimeRangeString(event:Event) -> String {
        return "\(event.start.toString()) - \(event.end.toString())"
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "bookingCell", for: indexPath) as? bookingCell else { return UITableViewCell() }
        cell.lblName.text = events[indexPath.section][indexPath.row].name
        cell.lblTime.text = convertsToTimeRangeString(event: events[indexPath.section][indexPath.row])
        if inUse {
            cell.backgroundColor = colours.red1
        } else {
            cell.backgroundColor = colours.green2
        }
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        lblPopupEventName.text = events[indexPath.section][indexPath.row].name
        lblPopupEventTime.text = convertsToTimeRangeString(event: events[indexPath.section][indexPath.row])
        txtPopupEventAttendees.text = events[indexPath.section][indexPath.row].attendees
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
