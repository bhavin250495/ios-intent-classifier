//
//  ViewController.swift
//  SpeechBot
//
//  Created by Suthar, Bhavin Udavji on 04/10/19.
//  Copyright © 2019 Suthar, Bhavin Udavji. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
     let manager = MLManager()
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var actionBtn: UIButton!
    @IBOutlet weak var inferanceLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        manager.delegate = self
        
    }
    
    @IBAction func actionTap(_ sender: UIButton) {
        let text = textField.text?.trimmingCharacters(in: .whitespaces)
        manager.classifyTheIntent(text: text!)
    }
}
extension ViewController: Results{
    func predicted_label(text: String) {
        inferanceLabel.text = text
    }
    
}
