//
//  selectClassroomVC.swift
//  ROCA-UVA
//
//  Created by Anusha Choudhary on 12/20/20.
//
import UIKit

protocol ClassroomSelectedDelegate: AnyObject {
    func userDidSelectClassroom(number: String)
}

class selectClassroomVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var classroomsTableView: UITableView!
    weak var delegate:ClassroomSelectedDelegate? = nil
    var selectedClassroomNum: String?=nil;
    var classrooms = [
        ClassRoom("McLeod Hall", ["MCL-1020"]),
        ClassRoom("Mechanical Engineering", ["MEC-341"]),
        ClassRoom("Minor Hall",["MIN-130"]),
        ClassRoom("Rice Hall", ["RICE-130"]),
        ClassRoom("Thornton Hall", ["THN-E303","THN-E316"]),
        ClassRoom("Wilson Hall", ["WIL-402"])
    ];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        classroomsTableView.delegate = self;
        classroomsTableView.dataSource = self;
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedClassroomNum = classrooms[indexPath.section].num[indexPath.row]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return classrooms.count;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return classrooms[section].num.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basicStyleCell") ?? UITableViewCell(style: UITableViewCell.CellStyle(rawValue: 1)!, reuseIdentifier: "basicStyleCell")
        cell.textLabel!.text = classrooms[indexPath.section].num[indexPath.row]
        return cell;
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return classrooms[section].title
    }
    
    
    @IBAction func donePressed(_ sender: UIBarButtonItem) {
        delegate?.userDidSelectClassroom(number: selectedClassroomNum ?? "")
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
