//
//  analyzeViewController.swift
//  note++
//
//  Created by galenw on 1/4/2018.
//  Copyright © 2018 galenw. All rights reserved.
//

import UIKit
import CoreData

class analyzeViewController: UIViewController, UITextViewDelegate{
    var editedNote:String?
    var noteID:NSManagedObjectID?
    var noteObj:Note?
    @IBOutlet weak var scriptTextView: UITextView!
    @IBOutlet weak var editedTextView: UITextView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext   // for core data
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        noteObj = context.object(with: noteID!) as? Note
        scriptTextView.text = noteObj!.noteText
        self.scriptTextView.delegate = self
        self.editedTextView.delegate = self
        
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        noteObj!.noteText = scriptTextView.text
        // magic
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }

    @IBAction func analyzeClicked(_ sender: Any) {
        /*
        let str = noteObj!.noteText
        let json  = ["strToTranscribe":str, "punctuated":"Y"] as! [String:String]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        print(json)
        
        
        let url = URL(string: "https://5537d2a4.ngrok.io/api/transcribe")!
        var request = URLRequest(url:url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = URLSession.shared.dataTask(with: request){
            data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print(responseJSON)
            }
        }
        task.resume()
 */
        let url = URL(string: "https://5537d2a4.ngrok.io/api/transcribe")!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let postString = "strToTranscribe=\(scriptTextView.text!)&punctuated=Y"
        request.httpBody = postString.data(using: .utf8)
        var result: String?
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            do{
            let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
                print("json=\(json)")
                result = json["transcribedStr"] as! String
                print("result: \(result!)")

                DispatchQueue.main.async { // Correct
                    self.editedTextView.text = result
                }
            }
            catch{
                print("json response error")
                return
            }
            let responseString = String(data: data, encoding: .utf8)!
            print("responseString = \(responseString)")
            //print(json)
            
        }
        task.resume()
    }
    
    func noteReady(){
        self.editedTextView.text = editedNote!
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
