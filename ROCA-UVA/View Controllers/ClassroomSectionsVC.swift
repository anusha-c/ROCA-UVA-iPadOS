//
//  ClassroomSectionsVC.swift
//  ROCA-UVA
//
//  Created by Anusha Choudhary on 1/3/21.
//

import UIKit

protocol ClassroomSectionDelegate: AnyObject {
    func sectionSelected(sender: SectionButton)
}


class ClassroomSectionsVC: UIViewController, ClassroomSelectedDelegate,
                           ViewControllerClassroomSectionsDelegate{
    
    var myButtons:[UIButton]=[]
    var myLabels:[UILabel]=[]
    var selectedClassroom:ClassRoom?=nil
    weak var delegate:ClassroomSectionDelegate?=nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func loadAllSections(classroom:ClassRoom){
        var counter = 1;
        
        //load sections according to the selected classroom
        for section in classroom.sections! {
            loadSection(sectionNum: counter, frame:section)
            counter += 1;
        }
        
        self.selectAllSections()
    }
    
    func loadSection(sectionNum:Int, frame: CGRect){
        loadSectionButton(view:self.view, frame: frame, section: sectionNum)
        loadLabel(view: self.view, text: "Section \(sectionNum)", origin:frame.origin)
    }
    
    func loadSectionButton(view:UIView,frame:CGRect, section:Int){
        let myButton = SectionButton(type:.system)
        myButton.section = section
        myButton.backgroundColor = .darkGray
        myButton.alpha = 0.4
        myButton.setTitle("", for: .normal)
        myButton.frame = frame
        myButton.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        myButton.layer.borderWidth = 5
        myButton.isEnabled = true;
        myButton.isUserInteractionEnabled = true;
        myButton.addTarget(self, action: #selector(buttonClicked(sender:)), for: .touchUpInside)
        myButton.addTarget(self, action: #selector(buttonHighlighted(_:)), for: .touchDown)
        myButton.addTarget(self, action: #selector(buttonHighlighted(_:)), for: .touchDragExit)
        view.addSubview(myButton)
        myButtons.append(myButton)
    }
    
    @objc func buttonClicked(sender: SectionButton){
        self.buttonPressed(sender: sender)
        delegate?.sectionSelected(sender: sender)
    }
    
    @objc func buttonHighlighted(_ sender: SectionButton){
        sender.backgroundColor = .black
        sender.alpha = 0.8
    }
    
    func loadLabel(view:UIView, text:String, origin:CGPoint){
        let myLabel = UILabel()
        myLabel.text = text
        myLabel.textColor = .white
        myLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        myLabel.frame = CGRect(origin: origin, size: CGSize(width: 100, height: 30))
        view.addSubview(myLabel)
        myLabels.append(myLabel)
    }
    
    func userDidSelectClassroom(number: String, classroom: ClassRoom?, index: Int?) {
        resetAll()
        if classroom != nil{
            self.selectedClassroom = classroom
            loadAllSections(classroom: selectedClassroom!)
        }
    }
    
    func resetButton(_ button:UIButton){
        button.removeFromSuperview()
    }
    
    func resetLabel(_ label:UILabel){
        label.removeFromSuperview()
    }
    
    func resetAll(){
        myButtons.map(resetButton(_:))
        myLabels.map(resetLabel(_:))
        myButtons.removeAll()
        myLabels.removeAll()
    }
    
    func buttonPressed(sender: SectionButton){
        sender.alpha = 0.4
        sender.backgroundColor = .darkGray
        if sender.layer.borderColor == CGColor(red: 0, green: 0, blue: 0, alpha: 1){
            sender.layer.borderColor = CGColor(red: 0.1, green: 1, blue: 0.2, alpha: 1)
        }
        else if (sender.layer.borderColor == CGColor(red: 0.1, green: 1, blue: 0.2, alpha: 1)){
            sender.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        }
    }
    
    func selectAllSections(){
        for sender in myButtons {
            sender.alpha = 0.4
            sender.backgroundColor = .darkGray
            if sender.layer.borderColor == CGColor(red: 0, green: 0, blue: 0, alpha: 1){
                sender.layer.borderColor = CGColor(red: 0.1, green: 1, blue: 0.2, alpha: 1)
            }
            else if (sender.layer.borderColor == CGColor(red: 0.1, green: 1, blue: 0.2, alpha: 1)){
                sender.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
            }
        }
    }
    
    func sectionCheckBoxSelected(sectionNum: Int) {
        self.buttonPressed(sender:myButtons[sectionNum-1] as! SectionButton)
    }
    
}
