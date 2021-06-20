//
//  selectClassroomVC.swift
//  ROCA-UVA
//
//  Created by Anusha Choudhary on 12/20/20.
//
import UIKit

protocol ClassroomSelectedDelegate: AnyObject {
    func userDidSelectClassroom(number: String,classroom:ClassRoom?,index:Int?)
}

class selectClassroomVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var classroomsTableView: UITableView!
    var delegates:[ClassroomSelectedDelegate] = []
    var selectedClassroomNum: String?=nil;
    var selectedClassroom:ClassRoom?=nil;
    var selectedIndex:Int?=nil;
    
    let rssParser = RSSParser()
    let rssUrl = URL(string:"https://uva.hosted.panopto.com/Panopto/Podcast/Podcast.ashx?courseid=df6e8127-2519-4ca2-93f7-aacb00ca4463&type=mp4");
    
    
    //NOTE: Classroom names have been replaced with titles from the RSS Feed
    /*var classrooms = [
        ClassRoom("McLeod Hall", ["MCL-1020"]),
        ClassRoom("Mechanical Engineering", ["MEC-341"]),
        ClassRoom("Minor Hall",["MIN-130"]),
        ClassRoom("Rice Hall", ["RICE-130"]),
        ClassRoom("Thornton Hall", ["THN-E303","THN-E316"]),
        ClassRoom("Wilson Hall", ["WIL-402"])
    ];*/
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        classroomsTableView.delegate = self;
        classroomsTableView.dataSource = self;
        rssParser.startParsingWithContentsOfURL(rssURL: rssUrl!, with: {_ in })
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //self.selectedClassroomNum = classrooms[indexPath.section].num[indexPath.row]
        //self.selectedClassroom = classrooms[indexPath.section]
        self.selectedIndex = indexPath.section
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //return classrooms.count;
        return rssParser.parsedData.count - 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return classrooms[section].num.count;
        return 1;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basicStyleCell") ?? UITableViewCell(style: UITableViewCell.CellStyle(rawValue: 1)!, reuseIdentifier: "basicStyleCell")
        //cell.textLabel!.text = classrooms[indexPath.section].num[indexPath.row]
        cell.textLabel!.text = rssParser.parsedData[indexPath.section + 1]["title"]
        return cell;
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //return classrooms[section].title
        return rssParser.parsedData[section + 1]["title"]
    }
    
    
    @IBAction func donePressed(_ sender: UIBarButtonItem) {
        for delegate in delegates{
            delegate.userDidSelectClassroom(number: selectedClassroomNum ?? "", classroom: selectedClassroom, index: selectedIndex)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
