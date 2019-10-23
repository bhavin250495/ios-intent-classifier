//
//  ViewController.swift
//  SpeechBot
//
//  Created by Suthar, Bhavin Udavji on 04/10/19.
//  Copyright © 2019 Suthar, Bhavin Udavji. All rights reserved.
//

import UIKit
import Speech
import AVFoundation

class ViewController: UIViewController {
    
    let manager = MLManager()
    let speechManager = SpeechManager()
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var actionBtn: UIButton!
    @IBOutlet weak var inferanceLabel: UILabel!
    @IBOutlet weak var recordBtn: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        speechManager.speechDelegate = self
        speechManager.askForPermission()
        manager.delegate = self
        
    }
    
    
    @IBAction func auto_correctTap(_ sender: UIButton) {
        let text = textField.text?.trimmingCharacters(in: .whitespaces)
        textField.text = manager.autoCorrect(text: text!)
    }
    @IBAction func recordBtnTap(_ sender: UIButton) {
        if recordBtn.titleLabel?.text == "Record"{
            speechManager.start()
            recordBtn.setTitle("Stop", for: .normal)
        }
        else {
            recordBtn.setTitle("Record", for: .normal)
            speechManager.stop()
        }
        
    }
    @IBAction func actionTap(_ sender: UIButton) {
        let text = textField.text?.trimmingCharacters(in: .whitespaces)
        manager.classifyTheIntent(text: text!)
        
    }
}
extension ViewController: Results{
    
    func predicted_label(text: String) {
        inferanceLabel.text = "Prediction -> \(text.uppercased())"
    }
    
}
extension ViewController: SpeechDelegate{
    func textFromSpeech(text: String) {
        textField.text = text
        print(text)
    }
}
