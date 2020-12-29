//
//  NewToDoTableViewController.swift
//  Do_Did_List
//
//  Created by 강민석 on 2020/03/08.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import UIKit
import Cosmos
import RealmSwift
import UserNotifications

class NewToDoTableViewController: UITableViewController {
    
    let modelManager = ModelManager()
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var iconButton: UIButton!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var starRatingView: CosmosView!
    @IBOutlet weak var contentTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleField.delegate = self
        self.contentTextView.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        
        onDidChangeDate(timePicker)
        
        timePicker.isHidden = true
        arrowDirection()
        
        starRatingView.settings.fillMode = .half
        
        setNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setObserver()
    }
    
    @IBAction func addButton(_ sender: Any) {
        
        guard let titleText = titleField.text.nilIfEmpty else {
            let alert = UIAlertController(title: "Empty Title", message: "Please Set Title Name", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alert.addAction(okButton)
            
            present(alert, animated: true)
            
            return
        }
        
        guard let colorOne = firstColorData, let colorTwo = secondColorData, let image = imageData else {
            let alert = UIAlertController(title: "Please Set Icon", message: "", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alert.addAction(okButton)
            
            present(alert, animated: true)
            
            return
        }
        
        let item = ToDoItem(title: titleText,
                            firstColor: colorOne,
                            secondColor: colorTwo,
                            imageData: image,
                            timestamp: timePicker.date,
                            importance: starRatingView.rating,
                            content: contentTextView.text,
                            isDone: false)
        
        modelManager.add(item)
        
        setLocalNotification(title: titleText, body: contentTextView.text, date: timePicker.date)
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onDidChangeDate(_ sender: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd-hh:mm a"
        
        let selectDate = dateFormatter.string(from: sender.date)
        
        timeLabel.text = selectDate
    }
    
    @objc func tapDone(sender: Any) {
        self.view.endEditing(true)
    }
    
    @objc private func handleIcon(notification: Notification) {
        guard let iconDict = notification.userInfo else { return }
        guard let icon = iconDict["finalIcon"] as? UIImage else { return }
        iconButton.setBackgroundImage(icon, for: .normal)
    }
    
    func setLocalNotification(title: String, body: String, date: Date) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.badge = 1
        content.sound = UNNotificationSound.default
        
         let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        let request = UNNotificationRequest(identifier: "ToDo", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print(error)
            } else {
                print("Add LocalNotification Success!")
            }
        }
    }
    
    func setNavigationBar() {
        let appearance = UINavigationBarAppearance()
        
        appearance.configureWithDefaultBackground()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        
        self.navigationController?.navigationBar.tintColor = UIColor(red: 76 / 255, green: 217 / 255, blue: 100 / 255, alpha: 1)
        
        self.navigationItem.standardAppearance = appearance
        self.navigationItem.compactAppearance = appearance
        self.navigationItem.scrollEdgeAppearance = appearance
    }
    
    func arrowDirection() {
        let imageName = timePicker.isHidden ? "Popover Arrow Down" : "Popover Arrow Up"
        arrowImageView.image = UIImage(named: imageName)
    }
    
    func setObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleIcon), name: NSNotification.Name(rawValue: "finalIcon"), object: nil)
    }
}


// MARK: - UITableViewDelegate
extension NewToDoTableViewController {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 && indexPath.row == 1 {
            let height: CGFloat = timePicker.isHidden ? 0.0 : 216.0
            return height
        }
        
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let timeIndexPath1 = NSIndexPath(row: 0, section: 1) as IndexPath
        let timeIndexPath2 = NSIndexPath(row: 2, section: 1) as IndexPath
        
        if timeIndexPath1 == indexPath || timeIndexPath2 == indexPath {
            
            timePicker.isHidden = !timePicker.isHidden
            
            UIView.animate(withDuration: 0.25) {
                self.tableView.beginUpdates()
                // apple bug fix - some TV lines hide after animation
                self.tableView.deselectRow(at: indexPath, animated: true)
                self.tableView.endUpdates()
            }
            
            arrowDirection()
        }
    }
}

// MARK: - UITextFieldDelegate

extension NewToDoTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.isEqual(self.titleField){
            self.titleField.resignFirstResponder()
        }
        return true
    }
}

extension Optional where Wrapped == String {
    var nilIfEmpty: String? {
        guard let strongSelf = self else {
            return nil
        }
        return strongSelf.isEmpty ? nil : strongSelf
    }
}
