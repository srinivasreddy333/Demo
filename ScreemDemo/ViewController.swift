//
//  ViewController.swift
//  ScreemDemo
//
//  Created by Vivek Dharmani on 08/05/19.
//  Copyright © 2019 Vivek Dharmani. All rights reserved.
//

import UIKit
import IntentsUI


class ViewController: UIViewController{
  
    @IBOutlet weak var view1: UIView!
    
    
    public let kNewArticleActivityType = "hello"
    override func viewDidLoad() {
        super.viewDidLoad()
        INPreferences.requestSiriAuthorization { (status) in
            INPreferences.requestSiriAuthorization { (status) in
                
                if status == .authorized {
                    print("Siri access allowed")
                } else {
                    print("Siri access denied")
                }
           }
            
            DataManager.sharedManager.saveContacts(contacts: [["name": "Thor", "number": "1800-THUNDER"], ["name": "Tony Stark", "number": "1800-IRONMAN"], ["name": "Bruce Banner", "number": "1800-HULKSMASH"], ["name": "Bruce Wayne", "number": "1800-BATMAN"]])
            
        }
        
        addSiriButton(to: view1)
        setupIntents()
        // Do any additional setup after loading the view.
    }
    func addSiriButton(to view: UIView) {
        let button = INUIAddVoiceShortcutButton(style: .whiteOutline)
        button.shortcut = INShortcut(intent: intent )
        button.delegate = self
        button.translatesAutoresizingMaskIntoConstraints = false
        view1.addSubview(button)
        view.centerXAnchor.constraint(equalTo: button.centerXAnchor).isActive = true
        view.centerYAnchor.constraint(equalTo: button.centerYAnchor).isActive = true
    }
    func setupIntents() {
        let activity = NSUserActivity(activityType: "com.iApple.ScreemDemo.SiriSortcut.sayHi") // 1
        activity.title = "Say hello" // 2
        activity.userInfo = ["speech" : "hello"] // 3
        activity.isEligibleForSearch = true // 4
        if #available(iOS 12.0, *) {
            activity.isEligibleForPrediction = true
        } else {
            // Fallback on earlier versions
        } // 5
        if #available(iOS 12.0, *) {
            activity.persistentIdentifier = NSUserActivityPersistentIdentifier("com.iApple.ScreemDemo.SiriSortcut.sayHi")
        } else {
            // Fallback on earlier versions
        }
        view.userActivity = activity // 7
        activity.becomeCurrent() // 8
    }
    public func sayHi() {
        let alert = UIAlertController(title: "Hi There!", message: "Hey there! Glad to see you got this working!", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        
       // UIApplication.shared.openURL(NSURL(string: "tel://9809088798")! as URL)
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }
    @IBAction func addContect(_ sender: UIButton) {
        
  
    }
    
    
}
/////
extension ViewController: INUIAddVoiceShortcutButtonDelegate {
    @available(iOS 12.0, *)
    func present(_ addVoiceShortcutViewController: INUIAddVoiceShortcutViewController, for addVoiceShortcutButton: INUIAddVoiceShortcutButton) {
        addVoiceShortcutViewController.delegate = self
        addVoiceShortcutViewController.modalPresentationStyle = .formSheet
        present(addVoiceShortcutViewController, animated: true, completion: nil)
    }
    
    @available(iOS 12.0, *)
    func present(_ editVoiceShortcutViewController: INUIEditVoiceShortcutViewController, for addVoiceShortcutButton: INUIAddVoiceShortcutButton) {
        editVoiceShortcutViewController.delegate = self
        editVoiceShortcutViewController.modalPresentationStyle = .formSheet
        present(editVoiceShortcutViewController, animated: true, completion: nil)
    }
    
    
}

extension ViewController: INUIAddVoiceShortcutViewControllerDelegate {
    @available(iOS 12.0, *)
    func addVoiceShortcutViewController(_ controller: INUIAddVoiceShortcutViewController, didFinishWith voiceShortcut: INVoiceShortcut?, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    @available(iOS 12.0, *)
    func addVoiceShortcutViewControllerDidCancel(_ controller: INUIAddVoiceShortcutViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
}

extension ViewController: INUIEditVoiceShortcutViewControllerDelegate {
    @available(iOS 12.0, *)
    func editVoiceShortcutViewController(_ controller: INUIEditVoiceShortcutViewController, didUpdate voiceShortcut: INVoiceShortcut?, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    @available(iOS 12.0, *)
    func editVoiceShortcutViewController(_ controller: INUIEditVoiceShortcutViewController, didDeleteVoiceShortcutWithIdentifier deletedVoiceShortcutIdentifier: UUID) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    @available(iOS 12.0, *)
    func editVoiceShortcutViewControllerDidCancel(_ controller: INUIEditVoiceShortcutViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}

class IntentHandler: INExtension, INStartAudioCallIntentHandling {
    
    func handle(intent: INStartAudioCallIntent, completion: @escaping (INStartAudioCallIntentResponse) -> Void) {
        
        let userActivity = NSUserActivity(activityType: NSStringFromClass(INStartAudioCallIntent.self))
        let response = INStartAudioCallIntentResponse(code: .continueInApp, userActivity: userActivity)
        completion(response)
    }
    
    func resolveContacts(for intent: INStartAudioCallIntent, with completion: @escaping ([INPersonResolutionResult]) -> Void) {
        
        var contactName: String?
        
        if let contacts = intent.contacts {
            contactName = contacts.first?.displayName
        }
        
        DataManager.sharedManager.findContact(contactName: contactName, with: { (contacts) in
            switch contacts.count {
                
            case 1:
                completion([INPersonResolutionResult.success(with: contacts.first!)])
            case 2 ... Int.max:
                completion([INPersonResolutionResult.disambiguation(with: contacts)])
            default:
                completion([INPersonResolutionResult.unsupported()])
            }
        })
    }
    
    func confirm(intent: INStartAudioCallIntent, completion: @escaping (INStartAudioCallIntentResponse) -> Void) {
        
        let userActivity = NSUserActivity(activityType: NSStringFromClass(INStartAudioCallIntent.self))
        let response = INStartAudioCallIntentResponse(code: .ready, userActivity: userActivity)
        completion(response)
    }
    
}
class DataManager {
    
    static let sharedManager = DataManager()
    static let sharedSuiteName = "group.com.akdsouza.SiriDemo"
    
    let userDefaults  = UserDefaults(suiteName: sharedSuiteName)
    
    func findContact(contactName: String?, with completion: ([INPerson]) -> Void) {
        
        let savedContacts = userDefaults?.value(forKey: DataManager.sharedSuiteName) as? [[String: String]]
        
        var matchingContacts = [INPerson]()
        
        if let contacts = savedContacts {
            
            for contact in contacts {
                
                if let name = contact["name"]?.lowercased(), name.contains(contactName!.lowercased()) {
                    
                    let personHandle  = INPersonHandle(value: contact["number"], type: .phoneNumber)
                    matchingContacts.append(INPerson(personHandle: personHandle, nameComponents: nil, displayName: name, image: nil, contactIdentifier: nil, customIdentifier: personHandle.value))
                }
            }
        }
        
        completion(matchingContacts)
    }
    
    func saveContacts(contacts: [[String: String]]) {
        userDefaults?.set(contacts, forKey: DataManager.sharedSuiteName)
        userDefaults?.synchronize()
    }
}
extension ViewController {
    public var intent: IntentIntent {
        let testIntent = IntentIntent()
        testIntent.myTestPerameter = "my test intent"
        return testIntent
    }
}
extension AppDelegate {
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        
        guard let audioCallIntent = userActivity.interaction?.intent as? INStartAudioCallIntent else {
            return false
        }
        
        if let contact = audioCallIntent.contacts?.first {
            
            if let type = contact.personHandle?.type, type == .phoneNumber {
                
                guard let callNumber = contact.personHandle?.value else {
                    return false
                }
                
                let callUrl = URL(string: "tel://\(callNumber)")
                
                if UIApplication.shared.canOpenURL(callUrl!) {
                    UIApplication.shared.open(callUrl!, options: [:], completionHandler: nil)
                } else {
                    
                    let alertController = UIAlertController(title: nil , message: "Calling not supported", preferredStyle: .alert)
                    let okAlertAction = UIAlertAction(title: "Ok" , style: UIAlertAction.Style.default, handler:nil)
                    alertController.addAction(okAlertAction)
                    self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
                }
            }
        }
        
        return true
    }
}
