//
//  SectionsVC.swift
//  ROCA-UVA
//
//  Created by Anusha Choudhary on 1/2/21.
//

import UIKit

protocol SectionsVCDelegate: AnyObject {
    func userDidSelectSection(section:Int, sender:SectionButton?)
    func userDidSelectClassroomSection(section:Int)
    func userDidSelectSectionStudents(section:String,numStudents:Int)
}

class SectionsVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, ViewControllerSectionsDelegate
{
    
    weak var delegate:SectionsVCDelegate?=nil
    var myButtons:[SectionButton]=[]
    var myLabels:[UILabel]=[]
    var mySections:[UIView]=[]
    var myPickerViews:[SectionPickerView]=[]
    var mySteppers:[SectionStepper]=[]
    var selectedSections:[Int]=[]
    var startPressed:Bool=false
    var sectionStudents:[Int]=[0,0,0,0,0,0]
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSections()
        loadPickerViews()
        assignButtonPickers()
    }
    
    func loadDefaultView() {
        self.selectAllSections()
    }
    
    func loadSections(){
        var counter = 1;
        var x = 100;
        var y = 20;
        while (counter<7){
            loadSectionView(num: counter, origin: CGPoint(x:x,y:y))
            if counter%2 == 0{
                y += 70
                x -= 250
            }
            else {
                x+=250
            }
        counter += 1
        }
    }
    
    func loadSectionView(num:Int, origin: CGPoint){
        let myView = UIView()
        myView.backgroundColor = .white
        self.view.addSubview(myView)
        myView.frame = CGRect(origin: origin, size: CGSize(width: 150, height: 50))
        loadButton(view: myView, origin: CGPoint(x: 15, y: 15),section: num)
        loadLabel(view: myView, text: "Section \(num)", origin: CGPoint(x: 45, y: 15))
        mySections.append(myView)
    }
    
    func loadPickerViews(){
        var counter = 1;
        var x = 0;
        var y = 20;
        while (counter<7){
            loadPickerView(view: self.view, origin: CGPoint(x:x,y:y), section: "Section \(counter)")
            if counter%2 == 0{
                y += 70
                x -= 250
            }
            else {
                x+=250
            }
        counter += 1
        }
    }
    
    func loadPickerView(view: UIView, origin: CGPoint, section: String){
        //load stepper
        let myPicker = SectionPickerView()
        myPicker.dataSource = self
        myPicker.delegate = self
        self.view.addSubview(myPicker)
        myPicker.tintColor = .white
        myPicker.section = section
        myPicker.isUserInteractionEnabled = false
        myPicker.frame = CGRect(origin: origin, size: CGSize(width: 100, height: 80))
        view.addSubview(myPicker)
        myPickerViews.append(myPicker)
    }
    
    func loadSteppers(){
        var counter = 1;
        var x = 2;
        var y = 10;
        while (counter<7){
            let stepper = loadStepper(view: self.view, origin: CGPoint(x:x,y:y), section: "Section \(counter)", sectionNum: counter)
            stepper.value = Double(sectionStudents[counter-1])
            print(myPickerViews[counter-1])
            if counter%2 == 0{
                y += 70
                x -= 250
            }
            else {
                x+=250
            }
        counter += 1
        }
    }
    
    func loadStepper(view:UIView, origin:CGPoint, section:String,sectionNum:Int)->UIStepper{
        let myStepper = SectionStepper()
        self.view.addSubview(myStepper)
        myStepper.section = section
        myStepper.sectionNum = sectionNum
        myStepper.autorepeat = true
        myStepper.isUserInteractionEnabled = false
        myStepper.frame = CGRect(origin:origin, size: CGSize(width:30,height:20))
        myStepper.addTarget(self, action: #selector(stepperValueChanged), for: .valueChanged)
        view.addSubview(myStepper)
        self.mySteppers.append(myStepper)
        
        return myStepper
    }
    
    @objc func stepperValueChanged(sender: UIStepper){
        print(sender.value)
        let sectionStepper = sender as! SectionStepper
        sectionStudents[sectionStepper.sectionNum-1] = Int(sectionStepper.value)
        myPickerViews[sectionStepper.sectionNum-1].selectRow(Int(sectionStepper.value), inComponent: 0, animated: true)
        if startPressed==true{
            delegate?.userDidSelectSectionStudents(section: sectionStepper.section, numStudents: Int(sectionStepper.value))}
            }
    
    func loadButton(view: UIView, origin: CGPoint, section: Int){
        let myButton = SectionButton(type: .system)
        myButton.setBackgroundImage(UIImage(systemName: "square"), for: .normal)
        view.addSubview(myButton)
        myButton.frame = CGRect(origin: origin, size: CGSize(width: 20, height: 20))
        myButton.tintColor = UIColor.systemGray2
        myButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        myButtons.append(myButton)
    }
    
    @objc func buttonPressed(sender: UIButton){
        if sender.currentBackgroundImage == UIImage(systemName: "square")
        {sender.setBackgroundImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
            sender.tintColor = .link
            let button = sender as! SectionButton
            button.picker?.isUserInteractionEnabled = true
            button.stepper?.isUserInteractionEnabled = true
            let sectionNum = myButtons.firstIndex(of: button)! + 1;
            selectedSections.append(sectionNum)
            delegate?.userDidSelectSection(section: sectionNum, sender:button)
            delegate?.userDidSelectClassroomSection(section: sectionNum)
        }
        else
        {sender.setBackgroundImage(UIImage(systemName: "square"), for: .normal)
            sender.tintColor = .systemGray2
            let button = sender as! SectionButton
            button.picker?.isUserInteractionEnabled = false
            button.stepper?.isUserInteractionEnabled = false

            let sectionNum = myButtons.firstIndex(of: button)! + 1;
            
            if selectedSections.contains(sectionNum){
                selectedSections.remove(at: selectedSections.firstIndex(of: sectionNum)!)
            }
            delegate?.userDidSelectSection(section: sectionNum, sender:button)
            delegate?.userDidSelectClassroomSection(section: sectionNum)

        }
        
    }
    
    
    func loadLabel(view: UIView, text:String, origin:CGPoint){
        let myLabel = UILabel()
        myLabel.text = text
        view.addSubview(myLabel)
        myLabel.frame = CGRect(origin: origin, size: CGSize(width: 100, height: 20))
        myLabels.append(myLabel)

    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 100
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let sectionPicker = pickerView as! SectionPickerView
        
        let sectionNum = Int(sectionPicker.section.replacingOccurrences(of: "Section ", with: ""))!
        sectionStudents[sectionNum-1] = row
        if startPressed==true{
            delegate?.userDidSelectSectionStudents(section: sectionPicker.section, numStudents: row)
            mySteppers[sectionNum-1].value = Double(row)
        }
        print(sectionStudents)
    }
    
    func assignButtonPickers(){
        var counter = 0;
        while counter<6{
            myButtons[counter].picker = myPickerViews[counter]
            counter += 1
        }
    }
    
    func assignButtonSteppers(){
        var counter = 0;
        while counter<6{
            myButtons[counter].stepper = mySteppers[counter]
            counter += 1
        }
    }
    
    func reset(){
        myButtons.map(resetButton(_:))
        self.myButtons.removeAll()
        myLabels.map(resetLabel(_:))
        self.myLabels.removeAll()
        mySections.map(resetSection(_:))
        self.mySections.removeAll()
        myPickerViews.map(resetPicker(_:))
        self.myPickerViews.removeAll()
        mySteppers.map(resetStepper(_:))
        self.mySteppers.removeAll()
        self.selectedSections.removeAll()
        self.viewDidLoad()
        self.sectionStudents = [0,0,0,0,0,0]
    }
    
    func startButtonPressed() {
        startPressed = true
        loadSteppers()
        
        for stepper in mySteppers {
            stepper.backgroundColor = .white
            stepper.alpha = 2.0
        }
        assignButtonSteppers()
        deselectAllSections()
    }
    
    func selectAllSections(){
        for sender in self.myButtons{
            if sender.currentBackgroundImage == UIImage(systemName: "square"){
        sender.setBackgroundImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
            sender.tintColor = .link
            let button = sender as! SectionButton
            button.picker?.isUserInteractionEnabled = true
            button.stepper?.isUserInteractionEnabled = true

            let sectionNum = myButtons.firstIndex(of: button)! + 1;
            selectedSections.append(sectionNum)
            delegate?.userDidSelectSection(section: sectionNum, sender:button)
            //delegate?.userDidSelectClassroomSection(section: sectionNum)
        }
        }
    }
    
    func deselectAllSections(){
        for sender in self.myButtons{
            if sender.currentBackgroundImage == UIImage(systemName: "checkmark.square.fill"){
            sender.setBackgroundImage(UIImage(systemName: "square"), for: .normal)
                sender.tintColor = .systemGray2
                let button = sender as! SectionButton
                button.picker?.isUserInteractionEnabled = false
                button.stepper?.isUserInteractionEnabled = false

                let sectionNum = myButtons.firstIndex(of: button)! + 1;
                
                if selectedSections.contains(sectionNum){
                    selectedSections.remove(at: selectedSections.firstIndex(of: sectionNum)!)
                }
                delegate?.userDidSelectSection(section: sectionNum, sender:button)
                delegate?.userDidSelectClassroomSection(section: sectionNum)
        }
        }
    }
    
    func resetButtonPressed() {
        self.reset()
    }
    
    func sectionSelected(sender: SectionButton) {
        if let sectionNum = sender.section {
            self.buttonPressed(sender: myButtons[sectionNum-1])
            delegate?.userDidSelectClassroomSection(section: sectionNum)
        }
    }
    
    func resetButton(_ button:UIButton){
        button.removeFromSuperview()
    }
    func resetLabel(_ label:UILabel){
        label.removeFromSuperview()
    }
    func resetPicker(_ picker:UIPickerView){
        picker.removeFromSuperview()
    }
    func resetStepper(_ stepper:UIStepper){
        stepper.removeFromSuperview()
    }
    func resetSection(_ section:UIView){
        section.removeFromSuperview()
    }
}
