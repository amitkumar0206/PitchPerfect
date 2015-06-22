//
//  RecordAudioViewController.swift
//  Pitch Perfect
//
//  Created by Amit Kumar on 2015-05-29.
//  Copyright (c) 2015 Agranee Solutions Ltd. All rights reserved.
//

import UIKit
import AVFoundation

// class to record audio andf passon to next vie to play
class RecordAudioViewController: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var resumeButton: UIButton!
    
    var audioRecorder : AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    func resetAllVariables(){
        recordButton.hidden = true
        pauseButton.hidden = true
        resumeButton.hidden = true
        recordLabel.text = "Tap to Record"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        resetAllVariables()
        recordButton.hidden = false
        stopButton.enabled = false
    }
    
    @IBAction func resumeRecording(sender: UIButton) {
        resetAllVariables()
        pauseButton.hidden = false
        //changing the label to show appropriate message
        recordLabel.text = "recording"
        
        //resuming the recording
        audioRecorder.record()
    }
    
    @IBAction func pauseRecording(sender: UIButton) {
        resetAllVariables()
        //changing the label to show appropriate message
        recordLabel.text = "paused"
        resumeButton.hidden = false
        
        //pausing the recording
        audioRecorder.pause()
    }
    
    @IBAction func recordAudio(sender: UIButton) {
        resetAllVariables()
        // hide appropriate buttons and labels
        stopButton.hidden = false
        pauseButton.hidden = false
        recordLabel.text = "recording"
        stopButton.enabled = true
        
        //get the directory path
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        
        let recordingName = "recorded_audio_1.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
        //start the Audio Session
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        
        // designate self as delegate
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        
        //prepare to Record
        audioRecorder.prepareToRecord()
        // record the Audio
        audioRecorder.record()
        stopButton.enabled = true
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        
        //if the Audio finish recording
        if (flag)
        {
            //setup values for Recorded Audio
            recordedAudio = RecordedAudio(avRecorder: recorder)
            self.performSegueWithIdentifier("stopRecordingSeg", sender: recordedAudio)
        }
        else {
            resetAllVariables()
            recordLabel.text = "Redording Error!! Tap to Try Again.."
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        //prepare the Audio file to be passed on to next View
        if (segue.identifier == "stopRecordingSeg")
        {
            let playSoundVC = segue.destinationViewController as! PlaySoundViewController
            let data = sender as! RecordedAudio
            playSoundVC.receivedAudio = data
        }
    }
    

    @IBAction func stopRecording(sender: UIButton) {
        resetAllVariables()
        audioRecorder.stop()
        
        //gett he Audio Session
        var audioSession = AVAudioSession.sharedInstance()
        
        //deactivate the Audio Session
        audioSession.setActive(false, error: nil)
    }

}

