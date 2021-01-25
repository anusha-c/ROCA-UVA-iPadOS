//
//  selectActivityVC.swift
//  ROCA-UVA
//
//  Created by Anusha Choudhary on 12/20/20.
//
import UIKit
 
protocol ActivitySelectedDelegate: AnyObject {
    func userDidSelectActivity(activity: ActivityItem?)
}
 
class selectActivityVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var activitiesTableView: UITableView!
    weak var delegate:ActivitySelectedDelegate? = nil;
    var selectedActivity:ActivityItem? = nil;
    let databaseManager = DatabaseManager()
    var database: Database? = nil;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        activitiesTableView.delegate = self;
        activitiesTableView.dataSource = self;
        database = databaseManager.getDatabaseContents()
    }
    
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedActivity = database?.activities[indexPath.section].data[indexPath.row]
        delegate?.userDidSelectActivity(activity: selectedActivity)
        self.dismiss(animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return database?.activities.count ?? 0;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return database?.activities[section].data.count ?? 0;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basicStyleCell") ?? UITableViewCell(style: UITableViewCell.CellStyle(rawValue: 1)!, reuseIdentifier: "basicStyleCell")
        cell.textLabel!.text = database?.activities[indexPath.section].data[indexPath.row].title ?? ""
        return cell;
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return database?.activities[section].title;
    }
    

}

