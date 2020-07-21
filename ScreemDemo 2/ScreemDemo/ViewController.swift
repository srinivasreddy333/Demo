//
//  ViewController.swift
//  ScreemDemo
//
//  Created by Vivek Dharmani on 08/05/19.
//  Copyright © 2019 Vivek Dharmani. All rights reserved.
//

import UIKit
import IntentsUI


class ViewController: UIViewController {
  
    @IBOutlet weak var view1: UIView!
    
    
    public let kNewArticleActivityType = "hello"
    override func viewDidLoad() {
        super.viewDidLoad()
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
extension ViewController {
    public var intent: IntentIntent {
        let testIntent = IntentIntent()
        testIntent.myTestPerameter = "my test intent"
        return testIntent
    }
}
