//
//  InfoViewController.swift
//  app-danceblue
//
//  Created by Skye Brown on 2/7/19.
//  Copyright © 2019 DanceBlue. All rights reserved.
//

import UIKit
import SAConfettiView
import Alamofire
import SwiftyJSON
import CoreData

class InfoViewController: UIViewController {

    // MARK: Variables
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var teamTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    let pickerView = UIPickerView()
    
    var confettiView: SAConfettiView!
    var URL: String?
    
    var teams = [Team]()
    var selectedTeam: Team?
    
    
    // MARK: View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.delegate = self
        teamTextField.delegate = self
        signInButton.layer.cornerRadius = 5;
        createPickerView()
        createToolbar()
        
        modalPresentationCapturesStatusBarAppearance = true
        var preferredStatusBarStyle: UIStatusBarStyle {
            return .lightContent
        }
        
        NetworkService.instance.getTeams()
        pickerView.reloadAllComponents()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print(URL as Any)
        
        // set up confetti view
        confettiView = SAConfettiView(frame: self.view.bounds)
        self.view.addSubview(confettiView)
        self.view.sendSubviewToBack(confettiView)
        confettiView.colors = [UIColor(red:0.02, green:0.22, blue:0.62, alpha:1.0), UIColor(red:0.95, green:0.74, blue:0.27, alpha:1.0)]
        confettiView.intensity = 1.0
        confettiView.startConfetti()
        
        // instantiate back button
        let button = UIButton(frame: CGRect(x: 20, y: 40, width: 80, height: 40))
        button.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        button.setTitle("BACK", for: .normal)
        button.layer.cornerRadius = 0.5 * button.frame.height
        button.addTarget(self, action: #selector(newButtonAction), for: .touchUpInside)
        self.view.addSubview(button)
        
        // load items from core data
        NetworkService.instance.loadCoreDataTeams()
        pickerView.reloadAllComponents()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    // back button selector function
    @objc func newButtonAction() {
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        createCALayer()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    func createPickerView() {
        pickerView.delegate = self
        teamTextField.inputView = pickerView
    }
    
    func createToolbar() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissKeyboard))
        toolbar.setItems([doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        
        teamTextField.inputAccessoryView = toolbar
    }
    
    // done button selector function
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // creates the blue top overlay
    func createCALayer() {
        let layer = CALayer()
        layer.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: self.view.frame.height * 2, height: self.view.frame.height * 2))
        
        let delta = self.view.frame.height - 0.5 * self.view.frame.width
        layer.frame.origin.x -= delta
        layer.frame.origin.y -= 1.6 * self.view.frame.height
        layer.cornerRadius = 0.5 * layer.frame.height
        layer.backgroundColor = #colorLiteral(red: 0.004859850742, green: 0.09608627111, blue: 0.5749928951, alpha: 1)
        self.view.layer.insertSublayer(layer, at: 0)
        self.view.clipsToBounds = true
    }
    
    // MARK: Network Methods
    
    // sends back the necessary information to backend
    @IBAction func signInPressed(_ sender: Any) {
        guard var receivedURL = URL else { return }
        print(receivedURL)
        guard let team = selectedTeam else { return }
        guard let name = nameTextField.text?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        let appendString: String = "&teamId=\(String(describing: team.uid))&name=\(name)";
        
        receivedURL += appendString
        print("With extension: " + receivedURL)
        Alamofire.request(receivedURL)
        
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}

// MARK: Picker View Methods
extension InfoViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return NetworkService.instance.teams.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return NetworkService.instance.teams[row].teamName
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        teamTextField.text = NetworkService.instance.teams[row].teamName
        selectedTeam = NetworkService.instance.teams[row]
    }
}

// MARK: Text Field Methods
extension InfoViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        confettiView.stopConfetti()
    }
}
