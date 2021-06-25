////
//  ViewController.swift
//  ROCA-UVA
//
//  Created by Anusha Choudhary on 12/17/20.
//

import UIKit
import AVKit
import AVFoundation

protocol PrimaryViewControllerDelegate:AnyObject {
    func startButtonPressed(_ start: Bool)
    func activitySelected(_ activity:ActivityItem!)
}

protocol SecondViewControllerDelegate:AnyObject {
    func startButtonPressed(_ start: Bool)
    func activitySelected(_ activity:ActivityItem!)
}

protocol ViewControllerSectionsDelegate:AnyObject {
    func resetButtonPressed()
    func startButtonPressed()
    func loadDefaultView()
    func sectionSelected(sender: SectionButton)
}

protocol ViewControllerClassroomSectionsDelegate:AnyObject {
    func sectionCheckBoxSelected(sectionNum: Int)
}


class ViewController: UIViewController, CommentEnteredDelegate,
                      ClassroomSelectedDelegate, ActivitySelectedDelegate,
                      NoteTakerDelegate, ZEventsVCDelegate, AEventsVCDelegate,
                      SectionsVCDelegate, ClassroomSectionDelegate,
                      UIActivityItemSource{
    
    @IBOutlet weak var classroomLabel: UILabel!
    @IBOutlet weak var activityTitle: UILabel!
    @IBOutlet weak var feedBackLabel: UILabel!
    @IBOutlet weak var startStopButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var selectActivityButton: UIButton!
    @IBOutlet weak var startStopLabel: UILabel!
    @IBOutlet weak var zEventsContainerView: UIView!
    @IBOutlet weak var aEventsContainerView: UIView!
    @IBOutlet weak var sectionsContainerView: UIView!
    @IBOutlet weak var classroomSectionsContainerView: UIView!
    @IBOutlet weak var classroomImageView: UIImageView!
    @IBOutlet weak var classroomVideoView: UIView!
    @IBOutlet weak var previewButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var rewindButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    
    
    weak var primaryDelegate:PrimaryViewControllerDelegate?=nil;
    weak var secondaryDelegate:SecondViewControllerDelegate?=nil;
    weak var sectionsDelegate:ViewControllerSectionsDelegate?=nil;
    weak var classroomSectionsDelegate:ViewControllerClassroomSectionsDelegate?=nil
    var sessionStarted = false;
    var noteTaker = NoteTaker();
    
    var classroomSectionsVC:ClassroomSectionsVC?=nil
    
    var selectedActivity:ActivityItem?=nil;
    var selectedSections:[Int]=[];
    
    let rssParser = RSSParser()
    let rssUrl = URL(string:"https://uva.hosted.panopto.com/Panopto/Podcast/Podcast.ashx?courseid=df6e8127-2519-4ca2-93f7-aacb00ca4463&type=mp4")
    let videoController = AVPlayerViewController()
    
    // the following variable indicates which state the video player was in most recently.
    //---- Play : 0
    //---- Preview state : 1
    var playerPreviousState = 0;
    
    //the following variable is to keep track of the player's timestamp
    var currentTimestamp:CMTime?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noteTaker.delegate = self;
        videoController.view.frame.size.height = classroomVideoView.frame.size.height
        videoController.view.frame.size.width = classroomVideoView.frame.size.width
        classroomVideoView.isHidden = true;
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
            primaryDelegate?.startButtonPressed(true)
            secondaryDelegate?.startButtonPressed(true)
            sectionsDelegate?.startButtonPressed()
            self.selectedSections=[]
            sessionStarted = true;
            noteTaker.takeNotes(note: "Observation started", type: nil, playbackTime: nil)
            videoController.player?.play()
            startStopButton.backgroundColor = UIColor.red;
            startStopLabel.text = "Stop";
        }
        else if sessionStarted {
            stopAlert()
        }
    }
    
    //---------------------VIDEO PLAYBACK CONTROLS---------------------------
    
    @IBAction func playPressed(_ sender: UIButton) {
        videoController.player?.play()
    }
    
    @IBAction func pausePressed(_ sender: UIButton) {
        videoController.player?.pause()
    }
    
    @IBAction func rewindPressed(_ sender: UIButton) {
        videoController.player?.playImmediately(atRate: -10.0)
    }
    
    @IBAction func forwardPressed(_ sender: Any) {
        videoController.player?.playImmediately(atRate: 10.0)
    }
    
    @IBAction func previewButtonPressed(_ sender: UIButton) {
        
        //Entering "Preview" State:
        if(playerPreviousState == 0){
            playerPreviousState = 1;
            
            sender.backgroundColor = .red;
            sender.setTitle("Stop Preview", for: .normal)
                
            currentTimestamp = videoController.player?.currentTime()
            noteTaker.takeNotes(note: "Preview Button Pressed", type: nil, playbackTime: videoController.player?.currentTime() ?? nil)
        
            playButton.isEnabled = true;
            pauseButton.isEnabled = true;
            rewindButton.isEnabled = true;
            forwardButton.isEnabled = true;
            
            playButton.alpha = 1;
            pauseButton.alpha = 1;
            rewindButton.alpha = 1;
            forwardButton.alpha = 1;
            
            zEventsContainerView.isUserInteractionEnabled = false;
            aEventsContainerView.isUserInteractionEnabled = false;
            zEventsContainerView.alpha = 0.8
            aEventsContainerView.alpha = 0.8
            commentButton.isEnabled = false;
            commentButton.alpha = 0.7
        }
        
        //Exiting "Preview" State:
        else if(playerPreviousState == 1){
            playerPreviousState = 0;
            
            sender.backgroundColor = .systemYellow;
            sender.setTitle("Preview", for: .normal)

            
            let smallValue = 0.0401588716
            let frameTime = CMTime(seconds: smallValue, preferredTimescale: 1000000)
            videoController.player?.seek(to: currentTimestamp ?? frameTime)
            videoController.player?.play()
            
            playButton.isEnabled = false;
            pauseButton.isEnabled = false;
            rewindButton.isEnabled = false;
            forwardButton.isEnabled = false;
            
            playButton.alpha = 0.5;
            pauseButton.alpha = 0.5;
            rewindButton.alpha = 0.5;
            forwardButton.alpha = 0.5;
            
            zEventsContainerView.isUserInteractionEnabled = true;
            aEventsContainerView.isUserInteractionEnabled = true;
            zEventsContainerView.alpha = 1
            aEventsContainerView.alpha = 1
            commentButton.isEnabled = true;
            commentButton.alpha = 1
        }
        
    }
    
    //-------------------------END VIDEO PLAYBACK CONTROLS----------------------------
    
    @IBAction func resetButtonPressed(_ sender: UIButton) {
        //TODO: Reset all displays and buttons
        handleReset()
    }
    
    @IBAction func commentButtonPressed(_ sender: UIButton) {
        videoController.player?.pause()
        self.performSegue(withIdentifier: "commentSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "classroomSectionsSegue"{
                self.classroomSectionsVC = segue.destination as? ClassroomSectionsVC
                classroomSectionsVC?.delegate = self
                self.classroomSectionsDelegate = classroomSectionsVC
            }
            
            if segue.identifier == "commentSegue" {
                let commentViewController = segue.destination as! commentVC
                commentViewController.delegate = self
            }
            else if segue.identifier == "selectClassroomSegue" {
                let classroomViewController = segue.destination as! selectClassroomVC
                classroomViewController.delegates.append(self)
                if(self.classroomSectionsVC != nil){
                classroomViewController.delegates.append(self.classroomSectionsVC!)
                }
            }
            else if segue.identifier == "selectActivitySegue" {
                let activityViewController = segue.destination as! selectActivityVC
                activityViewController.delegate = self
                
            }
            else if segue.identifier == "loadZEvents" {
                let zEventsVC = segue.destination as! ZEventsVC
                zEventsVC.delegate = self
                self.primaryDelegate = zEventsVC
            }
            else if segue.identifier == "loadAEvents" {
                let aEventsVC = segue.destination as! AEventsVC
                aEventsVC.delegate = self
                self.secondaryDelegate = aEventsVC
            }
            else if segue.identifier == "classroomDataLoaded" {
                let sectionsVC = segue.destination as! SectionsVC
                sectionsVC.delegate = self
                self.sectionsDelegate = sectionsVC
            }
                
            
            
        }
    
    func userDidEnterComment(comment: String){
        noteTaker.takeNotes(note:comment,type:"Comment",playbackTime: videoController.player?.currentTime())
        videoController.player?.play()
        
    }
    
    func userDidSelectClassroom(number: String,classroom:ClassRoom?,index: Int?) {
        if(index != nil){
            classroomVideoView.isHidden = false;
            classroomVideoView.addSubview(videoController.view)
            rssParser.startParsingWithContentsOfURL(rssURL: rssUrl!, with: {_ in })
            let ind = (index ?? 0) + 1
                if(ind < rssParser.parsedData.count){
                    guard let url = URL(string: rssParser.parsedData[ind]["guid"]!) else {
                            return
                        }
                    let player = AVPlayer(url: url)
                    videoController.player = player
                    videoController.showsPlaybackControls = true;
                    //player.play()
                }
        }
        
        if (number != ""){
            classroomLabel.text = number;
            classroomLabel.textColor = UIColor.black
            classroomLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 28.0)
            classroomImageView.image = UIImage(named:number)
            noteTaker.takeNotes(note:number,type:"Classroom",playbackTime: nil)
            selectActivityButton.isEnabled = true;
            startStopButton.isEnabled = true;
            previewButton.isHidden = false;
            previewButton.isEnabled = true;
            playButton.isHidden = false;
            playButton.isEnabled = false;
            pauseButton.isHidden = false;
            pauseButton.isEnabled = false;
            rewindButton.isHidden = false;
            rewindButton.isEnabled = false;
            forwardButton.isHidden = false;
            forwardButton.isEnabled = false;
            //sectionsContainerView.isHidden = false;
            //classroomSectionsContainerView.isHidden = false;
            //sectionsDelegate?.resetButtonPressed()
            //sectionsDelegate?.loadDefaultView()
            //selectedSections.removeAll()
        }
        }
    
    func userDidSelectActivity(activity: ActivityItem?) {
        //TODO: Update related activities in the UI once an activity is successfully selected.
        if (activity != nil){
            self.selectedActivity = activity
            activityTitle.text = activity!.title
            let noteToTake = activity!.title + " [" + activity!.code + "]"
            noteTaker.takeNotes(note: noteToTake, type: "Activity", playbackTime: videoController.player?.currentTime() ?? nil);
            
            //Loading Z-Event Buttons:
            zEventsContainerView.isHidden = false;
            aEventsContainerView.isHidden = false;
            primaryDelegate?.activitySelected(activity!)
            secondaryDelegate?.activitySelected(activity!)
            
            if sessionStarted {
            primaryDelegate?.startButtonPressed(true)
            secondaryDelegate?.startButtonPressed(true)
            }
        }
    }
    
    func userDidSelectSection(section: Int, sender:SectionButton?) {
        if selectedSections.contains(section) {
            self.selectedSections.remove(at: selectedSections.firstIndex(of: section)!)
        }
        else {
            self.selectedSections.append(section)
        }
        print(self.selectedSections)
    }
    
    func userDidSelectClassroomSection(section: Int) {
        self.classroomSectionsDelegate?.sectionCheckBoxSelected(sectionNum: section)
    }
    
    func sectionSelected(sender: SectionButton) {
        sectionsDelegate?.sectionSelected(sender: sender)
        }
    
    func userDidSelectSectionStudents(section: String, numStudents: Int) {
        let noteToTake = "\(numStudents) student(s) [\(section)]"
        noteTaker.takeNotes(note:noteToTake,type:"Event",playbackTime: nil)
    }
    
    
    
    func zEventButtonPressed(button: EventButton) {
        //TODO: Record the event and the section(s) it took place in
       
        var noteToTake = button.currentTitle! + " [" + button.event!.code + "]"
        
        if (selectedSections != []){
            let stringSections = selectedSections.map { String($0) }
            noteToTake.append(" [section(s) " + stringSections.joined(separator: ",")+"]")
        }
        
        if (button.event!.type == "instantaneous"){
            noteTaker.takeNotes(note: noteToTake, type: "Event", playbackTime: videoController.player?.currentTime() ?? nil)}
        else if (button.event!.type == "durational"){
            if button.durationalStatus == true {
                noteTaker.takeNotes(note: noteToTake, type: "End of event", playbackTime: videoController.player?.currentTime() ?? nil)}
            else {
                noteTaker.takeNotes(note: noteToTake, type: "Start of event", playbackTime: videoController.player?.currentTime() ?? nil)}
        }
    }
    
    func aEventButtonPressed(button: EventButton) {
        let noteToTake = button.currentTitle! + " [" + button.event!.code + "]"
        if (button.event!.type == "instantaneous"){
            noteTaker.takeNotes(note: noteToTake, type: "Event", playbackTime: videoController.player?.currentTime() ?? nil)}
        else if (button.event!.type == "durational"){
            if button.durationalStatus == true {
                noteTaker.takeNotes(note: noteToTake, type: "End of event", playbackTime: videoController.player?.currentTime() ?? nil)}
            else {
                noteTaker.takeNotes(note: noteToTake, type: "Start of event", playbackTime: videoController.player?.currentTime() ?? nil)}
        }
}
    
    func updateFeedBackBar(displayNote: String){
        feedBackLabel.text = displayNote
        print(displayNote)
    }
    
    func stopAlert(){
        videoController.player!.pause()
        let alert = UIAlertController(title: "Are you sure you want to perform this action?", message: "This cannot be undone", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Stop", style: .default, handler: handleStop(_:)))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func handleStop(_ sender: UIAlertAction){
        
        share(sender:UIView())
        sessionStarted = false;
        primaryDelegate?.startButtonPressed(false)
        secondaryDelegate?.startButtonPressed(false)
        noteTaker.takeNotes(note: "Observation stopped", type: nil, playbackTime: nil)
        startStopButton.backgroundColor = UIColor(red: 0, green: 0.82, blue: 0, alpha: 1);
        startStopLabel.text = "Start";
        handleReset()
    }
    
    func handleReset(){
        noteTaker.reset()
        activityTitle.text = "Select an Activity"
        feedBackLabel.text = "Start recording events!"
        sessionStarted = false;
        startStopButton.backgroundColor = UIColor(red: 0, green: 0.82, blue: 0, alpha: 1);
        playerPreviousState = 0;
        previewButton.backgroundColor = .systemYellow;
        previewButton.setTitle("Preview", for: .normal);
        previewButton.isHidden = true;
        playButton.isHidden = true;
        pauseButton.isHidden = true;
        rewindButton.isHidden = true;
        forwardButton.isHidden = true;
        startStopLabel.text = "Start";
        classroomLabel.text = "none selected";
        classroomLabel.textColor = UIColor.link
        classroomLabel.font = UIFont(name: "HelveticaNeue", size: 17.0)
        classroomImageView.image = nil;
        zEventsContainerView.isHidden = true;
        aEventsContainerView.isHidden = true;
        selectActivityButton.isEnabled = false;
        startStopButton.isEnabled = false;
        sectionsContainerView.isHidden = true;
        classroomSectionsContainerView.isHidden = true;
        classroomVideoView.isHidden = true;
        videoController.player?.pause()
        let smallValue = 0.0401588716
        let frameTime = CMTime(seconds: smallValue, preferredTimescale: 1000000)
        videoController.player?.seek(to: frameTime)

        
        sectionsDelegate?.resetButtonPressed()
        selectedSections = []
        selectedActivity = nil
    }
    
    func share(sender: AnyObject) {
            let items = [self]
            let avc = UIActivityViewController(activityItems:items, applicationActivities:nil)

        self.present(avc, animated:true, completion:nil)
            if let pop = avc.popoverPresentationController {
                let sourceView = sender as! UIView
                pop.sourceView = sourceView
                pop.sourceRect = sourceView.bounds
            }
     }
    
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return noteTaker.saveNotes() ?? ""
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        return noteTaker.saveNotes() ?? ""
    }
    
    
    }


    
