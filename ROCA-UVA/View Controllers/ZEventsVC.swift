//
//  ZEventsVC.swift
//  ROCA-UVA
//
//  Created by Anusha Choudhary on 12/23/20.
//

import UIKit

protocol ZEventsVCDelegate : AnyObject {
    func zEventButtonPressed(button: EventButton)
}

class ZEventsVC : UIViewController, PrimaryViewControllerDelegate {
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    weak var delegate : ZEventsVCDelegate? = nil;
    var database : Database? = nil;
    let databaseManager = DatabaseManager();
    var zButtons: [UIButton] = []
    var selectedActivity:ActivityItem?=nil;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        database = databaseManager.getDatabaseContents()
        scrollView.contentSize = self.view.frame.size
        scrollView.isScrollEnabled = false;
    }
    
    func loadButton(eventItem: EventItem, activity: ActivityItem? , origin: CGPoint){
        if(activity != nil){
    if eventItem.dependencies.contains(activity!.key){
        let myButton = EventButton(type: .system)
        myButton.event = eventItem
        if (myButton.event!.type == "durational"){
            myButton.durationalStatus = false
            }
        myButton.titleLabel!.font = UIFont(name: "HelveticaNeue", size: 19)
        myButton.setTitle(eventItem.title, for: .normal)
        myButton.setTitleColor(UIColor.white, for: .normal)
        myButton.backgroundColor = UIColor.lightGray
        scrollView.addSubview(myButton)
        myButton.frame = CGRect(origin: origin, size: CGSize(width: 215, height: 50))
        myButton.layer.cornerRadius = 20;
        myButton.isEnabled = false;
        myButton.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        myButton.addTarget(self, action: #selector(buttonHighlighted(_:)), for: .touchDown)
        myButton.addTarget(self, action: #selector(buttonHighlighted(_:)), for: .touchDragExit)
        zButtons.append(myButton)
    }
        }
    }
    
    func loadButtons(){
        //adding Z-Event Buttons:
        let instructorEvents = database?.z_events.Instructor
        var X = 0;
        var Y = 30;
        var counter = 0;
        for event in instructorEvents! {
            loadButton(eventItem:event, activity: selectedActivity, origin:CGPoint(x: X, y: Y))
            if (counter%2 == 0){
                Y += 70
            }
            else
            { X += 217
              Y -= 70
            }
            counter += 1;

        }
    }
    
    @objc func buttonAction(_ sender:EventButton!) {
        delegate?.zEventButtonPressed(button: sender)
        if(sender.event!.type=="instantaneous"){
            sender.backgroundColor = UIColor.darkGray}
        else if (sender.event!.type=="durational"){
            if (sender.durationalStatus! == true){
                sender.durationalStatus! = false
                sender.backgroundColor = UIColor.darkGray
            }
            else if (sender.durationalStatus! == false){
                sender.durationalStatus! = true
            }
        }
        
    }
    
    @objc func buttonHighlighted(_ sender:UIButton!) {
        sender.backgroundColor = UIColor.systemOrange
    }
    
    
    func startButtonPressed(_ start: Bool){
        if(start){
            for button in zButtons {
                button.isEnabled = true;
                button.backgroundColor = UIColor.darkGray
                scrollView.isScrollEnabled = true;
            }
        }
        else {
            for button in zButtons {
                button.isEnabled = false;
                button.backgroundColor = UIColor.lightGray
                scrollView.isScrollEnabled = false;
            }
        }
    }
    
    func activitySelected(_ activity:ActivityItem!){
        self.selectedActivity = activity
        zButtons.map(resetButton(_:))
        loadButtons()
    }
    
    func resetButton(_ button:UIButton){
        button.removeFromSuperview()
    }


}
