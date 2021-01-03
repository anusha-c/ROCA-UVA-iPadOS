//
//  AEventsVC.swift
//  ROCA-UVA
//
//  Created by Anusha Choudhary on 12/27/20.
//


import UIKit

protocol AEventsVCDelegate : AnyObject {
    func aEventButtonPressed(button: EventButton)
}

class AEventsVC : UIViewController, SecondViewControllerDelegate {
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    weak var delegate : AEventsVCDelegate? = nil;
    var database : Database? = nil;
    let databaseManager = DatabaseManager();
    var aButtons: [UIButton] = []
    var labels: [UILabel] = []
    var selectedActivity:ActivityItem?=nil;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        database = databaseManager.getDatabaseContents()
        scrollView.addSubview(contentView)
        scrollView.contentSize = self.view.frame.size
        scrollView.isScrollEnabled = false;
    }
    
    func loadButton(eventItem: EventItem, activity: ActivityItem? , origin: CGPoint){
        if(activity != nil){
        let myButton = EventButton(type: .system)
        myButton.event = eventItem
        if (myButton.event!.type == "durational"){
            myButton.durationalStatus = false
            }
        myButton.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 20.0)
        myButton.setTitle(eventItem.title, for: .normal)
        myButton.setTitleColor(UIColor.white, for: .normal)
        myButton.backgroundColor = UIColor.lightGray
        contentView.addSubview(myButton)
        myButton.frame = CGRect(origin: origin, size: CGSize(width: 300, height: 40))
        myButton.layer.cornerRadius = 20;
        myButton.isEnabled = false;
        myButton.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        myButton.addTarget(self, action: #selector(buttonHighlighted(_:)), for: .touchDown)
        myButton.addTarget(self, action: #selector(buttonHighlighted(_:)), for: .touchDragExit)
        aButtons.append(myButton)
        }
    }
    
    func loadLabel(title:String?,origin: CGPoint){
        let myLabel = UILabel();
        myLabel.text = title;
        contentView.addSubview(myLabel)
        myLabel.frame = CGRect(origin: origin, size: CGSize(width: 300, height: 40))
        self.labels.append(myLabel)
        }
    
    
    func loadButtons(){
        //adding Z-Event Buttons:
        let aInstructorEvents = database?.a_events.Instructor
        let aStudentEvents = database?.a_events.Student
        let aTechEvents = database?.a_events.Technology
        let X = 20;
        var Y = 22;
        loadLabel(title: "Instructor", origin:CGPoint(x: 0, y: 0))
        Y += 22;
        for event in aInstructorEvents! {
            if event.dependencies.contains(selectedActivity!.key){
            loadButton(eventItem:event, activity: selectedActivity, origin:CGPoint(x: X, y: Y))
            Y += 45;
            }}
        loadLabel(title: "Technology", origin:CGPoint(x:0,y:Y))
        Y += 45;
        for event in aTechEvents! {
            if event.dependencies.contains(selectedActivity!.key){
            loadButton(eventItem:event, activity: selectedActivity, origin:CGPoint(x: X, y: Y))
            Y += 45;
            }}
        loadLabel(title: "Student", origin:CGPoint(x:0,y:Y))
        Y += 45;
        for event in aStudentEvents! {
            if event.dependencies.contains(selectedActivity!.key){
            loadButton(eventItem:event, activity: selectedActivity, origin:CGPoint(x: X, y: Y))
            Y += 45;
            }}
    }
    
    @objc func buttonAction(_ sender:EventButton!) {
        delegate?.aEventButtonPressed(button: sender)
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
            for button in aButtons {
                button.isEnabled = true;
                button.backgroundColor = UIColor.darkGray
                scrollView.isScrollEnabled = true;
            }
        }
        else {
            for button in aButtons {
                button.isEnabled = false;
                button.backgroundColor = UIColor.lightGray
                scrollView.isScrollEnabled = false;
            }
        }
    }
    
    func activitySelected(_ activity:ActivityItem!){
        self.selectedActivity = activity
        aButtons.map(resetButton(_:))
        aButtons.removeAll()
        labels.map(resetLabel(_:))
        labels.removeAll()
        loadButtons()
    }
    
    func resetButton(_ button:UIButton){
        button.removeFromSuperview()
    }
    
    func resetLabel(_ label: UILabel){
            label.removeFromSuperview()
    }


}

