//
//  RecordSoundViewController.swift
//  SpeakMe
//
//  Created by yosemite on 29/01/15.
//  Copyright (c) 2015 yosemite. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var stopAudio: UIButton!
    
    @IBOutlet weak var recordAudio: UIButton!
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func  viewWillAppear(animated: Bool) {
        stopAudio.hidden = true
    }
    @IBAction func recordAudio(sender: UIButton){
        recordingInProgress.hidden = false
        //TODO:Record de user voice
        let dirParth = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        var currentDateTime = NSDate()
        var formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        var recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        var pathArray = [dirParth, recordingName ]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        //setuo audion session
            var session = AVAudioSession.sharedInstance()
            session.setCategory( AVAudioSessionCategoryPlayAndRecord, error: nil)
            audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
            audioRecorder.delegate = self
            audioRecorder.meteringEnabled = true
            audioRecorder.prepareToRecord()
            audioRecorder.record()
        
        
        
            
        
        
        stopAudio.hidden = false
        println("in record audio")
    }
    
    func  audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if flag {
            //save recorder
            recordedAudio = RecordedAudio()
            recordedAudio.filePathUrl = recorder.url
            recordedAudio.title = recorder.url.lastPathComponent
            //move next escene
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }else{
            println("Recording did not finish")
            recordAudio.enabled = true
            stopAudio.hidden = true
        }
      
    }
    
    override func  prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording" ){
            let playSoundsVC:PlaySoundViewController = segue.destinationViewController as PlaySoundViewController
                let data = sender as RecordedAudio
                playSoundsVC.recivedAudio = data
            
        }
    }
    
    @IBAction func stopAudio(sender: UIButton) {
        
        recordingInProgress.hidden = true
        
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
    
}

