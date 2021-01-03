//
//  NoteTaker.swift
//  ROCA-UVA
//
//  Created by Anusha Choudhary on 12/20/20.
//
import Foundation


protocol NoteTakerDelegate: AnyObject {
    func updateFeedBackBar(displayNote: String)
}

struct NoteTaker {
    //This struct is responsible for storing the timestamp of all the buttons pressed within
   // the app, and is also responsible for writing its data to a file, and saving/sharing the file
  // on the device.
    
    var notes: String;
    var currentNote: String?;
    weak var delegate: NoteTakerDelegate? = nil;
    
    init(){
        self.notes = "";
    }
    
    mutating func takeNotes(note: String, type: String?){
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .none
        let timeStamp = formatter.string(from: currentDate)
        if type != nil {
            self.currentNote = "[" + timeStamp + "] " + type! + ": " + note;
        }
        else {
            self.currentNote = "[" + timeStamp + "] " + note;
        }
        notes.append("\n"+currentNote!);
        delegate?.updateFeedBackBar(displayNote: currentNote!)
    }
    
    func saveNotes() -> URL? {
        //returns a URL with the notes in a .txt file saved in the documents directory
        
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateFormat = "MM_dd_yyyy"
        let date = formatter.string(from: currentDate)

        let fileName = "roca_observation_"+date;
        
        let documentDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let fileURL = documentDirURL.appendingPathComponent(fileName).appendingPathExtension("txt")
        
        guard let data = self.notes.data(using: .utf8) else {
            print("Unable to convert notes to data")
            return nil
        }
        do {
         try data.write(to: fileURL)
         print("Data saved.")
        } catch {
         // Catch any errors
         print(error.localizedDescription)
        }
        return fileURL
    }
    
    func getCurrentNote() -> String? {
        return self.currentNote
    }
    
    func printNotes(){
        print(self.notes)
    }
    
    mutating func reset(){
      notes = ""
      currentNote = nil
    }
}
 
