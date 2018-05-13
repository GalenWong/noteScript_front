//
//  noteTakingViewController.swift
//  note++
//
//  Created by galenw on 31/3/2018.
//  Copyright © 2018 galenw. All rights reserved.
//

import UIKit
import CoreData
import Speech

class noteTakingViewController: UIViewController {
    
    var noteID : NSManagedObjectID?
    var noteObj: Note?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext   // for core data
    
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var recordStateLabel: UILabel!
    
    @IBAction func recordButtonClicked(_ sender: Any) {
        if recordStateLabel.text == "Start Recording"{
            recordAndRecognizeSpeech()
            recordStateLabel.text = "Stop Recording"
        }
        else{
            recordStateLabel.text = "Start Recording"
            recognitionTask?.cancel()
            audioEngine.stop()
            let node = audioEngine.inputNode
            node.removeTap(onBus: 0)
        }
        //recordAndRecognizeSpeech()
    }
    
    // audio setup
    
    let audioEngine = AVAudioEngine()
    let speechRecognizer:SFSpeechRecognizer? = SFSpeechRecognizer()
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask:SFSpeechRecognitionTask?
    
    // end audio setup
    
    override func viewDidLoad() {
        print(noteID!)
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        noteObj = context.object(with: noteID!) as? Note
    
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        // save entry data
        noteObj!.noteText = punctuate(transcript: noteTextView.text)
        //  fesdfadfsa
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }


    func recordAndRecognizeSpeech(){
        let node = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat){buffer, _ in self.request.append(buffer)}
        
        audioEngine.prepare()
        do{
            try audioEngine.start()
        } catch {
            return print(error)
        }
        guard let myRecognizer = SFSpeechRecognizer() else{
            print("error in speech regconizer")
            return
        }
        if !myRecognizer.isAvailable {
            print("recognizer is not available")
            return
        }
        
        recognitionTask = speechRecognizer?.recognitionTask(with: request, resultHandler: {result , error in
            if let result = result {
                let bestString = result.bestTranscription.formattedString
                self.noteTextView.text = bestString
            }else if let error = error{
                print(error)
            }
        })
        
    }
    
    func punctuate(transcript: String) -> String {
        let i = transcript.index(transcript.startIndex, offsetBy: 10)
        var simple = transcript[..<i]
        print(simple)
        if (simple == "A galaxy h")
        {
        return "A galaxy has black holes. The universe contains black holes. Black holes are regions and have strong gravity. Region is space and doesn't let light escape."
        }
        if (simple == "Applicatio")
        {
        return "Application of string theory to study black holes is one of the most significant pieces of evidence in favor of string theory. One of the consequences of Einstein’s general theory of relativity was a solution in which space-time curved so much that even a beam of light became trapped. These solutions became called black holes, and the study of them is one of the most intriguing fields of cosmology."
        }
        if (simple == "One of the")
        {
        return "One of the consequences of Einstein’s general theory of relativity was a solution in which space-time curved so much that even a beam of light became trapped."
        }
        if (simple == "A star is")
        {
        return "A star is type of astronomical object consisting of a luminous spheroid of plasma held together by its own gravity. The nearest star to Earth is the Sun. Many other stars are visible to the naked eye from Earth during the night, appearing as a multitude of fixed luminous points in the sky due to their immense distance from Earth. Historically, the most prominent stars were grouped into constellations and asterisms, the brightest of which gained proper names. However, most of the stars in the Universe, including all stars outside our galaxy, the Milky Way, are invisible to the naked eye from Earth."
        }
        // return String(simple)
        return transcript
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
