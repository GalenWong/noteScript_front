//
//  ViewController.swift
//  note++
//
//  Created by galenw on 28/3/2018.
//  Copyright © 2018 galenw. All rights reserved.
//

import UIKit
import CoreData

class noteIdObj{
    var id : NSManagedObjectID?
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var notesTableView: UITableView! // for calling reload
    
    var arrOfNotes : [NSManagedObject]?
    
    var tempArray = ["111", "222", "333", "444", "555"]
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext   // for core data
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // data base setup ========

        /*  example to create object and save database
        for item in tempArray{
            let note = Note(context: context)   // creating an object, Note is a subclass of NSManagedObject
            note.dateCreated = Date()
            note.topics = item
            note.lectureName = item
            note.noteText = ""
            print(note.objectID)    // unique object ID created by core data
        }
 
        (UIApplication.shared.delegate as! AppDelegate).saveContext()   // save everything i guess
         */
        loadNotesIntoArray()
        // data base setup END ====
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func addNewLecture(_ sender: Any) {
        let note = Note(context:context)        // create new note entry
        note.dateCreated = Date()   // current date
        
        let alert = UIAlertController(title: "New Lecture Note", message: "Input the lecture name", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addTextField(configurationHandler: {textField in textField.placeholder = "Lecture Name... CS33?"})
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
            if let lectureNM = alert.textFields?.first?.text{
                note.lectureName = lectureNM
                // save entry data
                (UIApplication.shared.delegate as! AppDelegate).saveContext()
                
                self.loadNotesIntoArray()
                self.notesTableView.reloadData() //reload new data
                self.goToNoteTakingView(ID: note.objectID)   // go to new View
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func goToNoteTakingView(ID: NSManagedObjectID){
        let send = noteIdObj()
        send.id = ID
        print("Object ID passed: ", ID)
        self.performSegue(withIdentifier: "toNoteTakingSegue", sender: send)
    }
    
    func goToAnalyzeView(ID: NSManagedObjectID){
        let send = noteIdObj()
        send.id = ID
        self.performSegue(withIdentifier: "toAnalyzeViewSegue", sender: send)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toNoteTakingSegue"{
            let vc = segue.destination as! noteTakingViewController
            if (sender as? noteIdObj) != nil{
                let senderViaAddButton  = sender as! noteIdObj
                vc.noteID = senderViaAddButton.id
            }
        }
        else if segue.identifier == "toAnalyzeViewSegue"{
            let vc = segue.destination as! analyzeViewController
            if(sender as? noteIdObj) != nil{
                let senderViaCell = sender as! noteIdObj
                vc.noteID = senderViaCell.id
            }
        }
    }
    
    func loadNotesIntoArray(){
        let fetchR = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        fetchR.returnsObjectsAsFaults = false
        fetchR.sortDescriptors = [NSSortDescriptor(key: "dateCreated", ascending: false)]
        do{
            arrOfNotes = []     //empty array for optional avoidence
            let result = try context.fetch(fetchR)
            for data in result as! [NSManagedObject]{
                /*
                print(data.value(forKey: "topics") as! String!)
                print(data.objectID)
                print("====")
                */
                arrOfNotes!.append(data)
            }
        }catch{
            print("error in fetching object")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrOfNotes!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath) as! noteCellTableViewCell
        let noteInstant = arrOfNotes![indexPath.row] as! Note
        if let className = noteInstant.lectureName{
             cell.classLabel.text = "Class: " + className
        }
        else{
            cell.classLabel.text = "Class: "
        }
        cell.dateLabel.text = "Date Created: " + currentTime(noteInstant.dateCreated!)
        if let topicText = noteInstant.topics{
            cell.topicLabel.text = "Topics: " + topicText
        }
        else{
            cell.topicLabel.text = "Topics: "
        }
        cell.objID = noteInstant.objectID
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellSelected = tableView.cellForRow(at: indexPath) as! noteCellTableViewCell
        self.goToAnalyzeView(ID: cellSelected.objID!)
    }
    func currentTime(_ dateP : Date = NSDate.distantPast) -> String{
        var date = dateP
        if(date == NSDate.distantPast){ // if no date is provided, should not be the case
            print("no date passed in")
            date = Date()   //current day
        }
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        return "\(year)-\(month)-\(day)"
    }
    
}

