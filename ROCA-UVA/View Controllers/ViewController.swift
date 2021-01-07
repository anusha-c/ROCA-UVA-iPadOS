//
//  ViewController.swift
//  ROCA-UVA
//
//  Created by Anusha Choudhary on 12/17/20.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var activityTitle: UILabel!
    @IBOutlet weak var feedBackLabel: UILabel!
    @IBOutlet weak var classroomDataLabel: UIButton!
    @IBOutlet weak var startStopButton: UIButton!
    @IBOutlet weak var startStopLabel: UILabel!
    
    var sessionStarted = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func selectClassroom(_ sender: UIButton) {
        self.performSegue(withIdentifier: "selectClassroomSegue", sender: self)
    }
    
    @IBAction func selectActivity(_ sender: UIButton) {
        self.performSegue(withIdentifier: "selectActivitySegue", sender: self)
    }
    
    @IBAction func startStopButtonSelected(_ sender: UIButton) {
        //handle starting/stopping of an activity
        // Note the timestamp of start/stop
        
        if !sessionStarted {
            sessionStarted = true;
            startStopButton.backgroundColor = UIColor.red;
            startStopLabel.text = "Stop";
        }
        else if sessionStarted {
            sessionStarted = false;
            startStopButton.backgroundColor = UIColor(red: 0, green: 0.82, blue: 0, alpha: 1);
            startStopLabel.text = "Start";
        }
    }
    
    @IBAction func resetButtonPressed(_ sender: UIButton) {
        //TODO: Reset all displays
        
        activityTitle.text = "Select An Activity"
        feedBackLabel.text = ""
        sessionStarted = false;
        startStopButton.backgroundColor = UIColor(red: 0, green: 0.82, blue: 0, alpha: 1);
        startStopLabel.text = "Start";
    }
    
    @IBAction func commentButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "commentSegue", sender: self)
    }
}
