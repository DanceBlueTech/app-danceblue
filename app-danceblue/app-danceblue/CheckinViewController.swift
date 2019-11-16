//
//  CheckinViewController.swift
//  app-danceblue
//
//  Created by David Mercado on 11/16/19.
//  Copyright © 2019 DanceBlue. All rights reserved.
//

import Foundation
import UIKit

class CheckinViewController: UIViewController{
    
    @IBOutlet weak var teamTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var linkBlueTextField: UITextField!
    @IBOutlet weak var fullnameTextField: UITextField!
    
    let teams = ["FTK", "FTK2", "For The Kode"]
    let names = ["David Mercado", "Kye Miller", "Joe Clements", "Kendall Conley"]
    var selectedTeam: String?
    var selectedName: String?
    
    // MARK: - Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        linkBlueTextField.isHidden = true
        fullnameTextField.isHidden = true
        createTeamPicker()
        createTeamPicker2()
        //createToolBar()
    }
    
    // MARK: - custom UIPicker for master teams
    func createTeamPicker(){
        let teamPicker = UIPickerView()
        teamPicker.delegate = self
        
        teamTextField.inputView = teamPicker
    }
    // MARK: - custom UIPicker for master teams
    func createTeamPicker2(){
        let teamPicker2 = UIPickerView()
        teamPicker2.delegate = self
        
        fullnameTextField.inputView = teamPicker2
    }
    // MARK: - custom toolbar for UIpicker
    /*func createToolBar() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(CheckinViewController.dismissKeyboard(_:)))
        
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        teamTextField.inputAccessoryView = toolBar
    }
    
    func dismissKeyboard(_sender: UIBarButtonItem) {
        view.endEditing(true)
    }*/
}

// MARK: -Date picker for master roster and master teams
extension CheckinViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        print("UIpickerView \(UIPickerView.self)")
        return teams.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        print("UIpickerView \(UIPickerView.self)")

        return teams[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("UIpickerView \(UIPickerView.self)")

        selectedTeam = teams[row]
        teamTextField.text = selectedTeam
    }
}
