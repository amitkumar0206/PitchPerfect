//
//  PlaySoundViewController.swift
//  Pitch Perfect
//
//  Created by Amit Kumar on 2015-06-03.
//  Copyright (c) 2015 Agranee Solutions Ltd. All rights reserved.
//

import UIKit
import AVFoundation

// This is a View Controller class to play back Recorded
// Audio. It takes it parameter from
// RecordSoundViewCOntroller
class PlaySoundViewController: UIViewController {

    var receivedAudio:RecordedAudio!
    
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    var audioPlayerNode : AVAudioPlayerNode!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //initializing the Audio Engine
        audioEngine = AVAudioEngine()
        
        //create the Audio File
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
        
        //start the Audio Session
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, withOptions:AVAudioSessionCategoryOptions.DefaultToSpeaker, error: nil)
        session.setActive(true, error: nil)
    }
    
    @IBAction func playReverb(sender: UIButton) {
        var revarb = AVAudioUnitReverb()
        revarb.wetDryMix = 75
        attachAndPlay(revarb)
    }

    @IBAction func playEcho(sender: UIButton) {
        let delayTime:NSTimeInterval = 0.2
        var delay = AVAudioUnitDelay()
        delay.delayTime = delayTime
        
        attachAndPlay(delay)
    }
    
    @IBAction func playSlowSound(sender: UIButton) {
        playAudioWithVariableRate(0.5)
    }

    @IBAction func playFastSound(sender: UIButton) {
        playAudioWithVariableRate(2.0)
    }
    
    @IBAction func playChipmunk(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func playDarthVader(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    
    
    @IBAction func stopPlayback(sender: UIButton) {
        resetAllPLayers()
    }
    
    func attachAndPlay(audioUnit : AVAudioUnit){
        //Stop and Reset the Engine before Playing again
        resetAllPLayers()
        
        audioEngine.attachNode(audioUnit)
        audioEngine.connect(audioPlayerNode, to: audioUnit, format: nil)
        audioEngine.connect(audioUnit, to: audioEngine.outputNode, format: nil)
        
        audioEngine.startAndReturnError(nil)
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioPlayerNode.volume = 1.0
        
        audioPlayerNode.play()
    }
    
    
    func playAudioWithVariableRate(rate:Float){
        // create the Time Pitch Object
        var changeAudioUnitTime = AVAudioUnitTimePitch()
        //change the rate of the playback
        changeAudioUnitTime.rate = rate
        
        attachAndPlay(changeAudioUnitTime)
    }
    
    func playAudioWithVariablePitch(pitch:Float){
        // create the Time Pitch Object
        var changeAudioUnitTime = AVAudioUnitTimePitch()
        //change the rate of the playback
        changeAudioUnitTime.pitch = pitch
        
        attachAndPlay(changeAudioUnitTime)
    }
    
    func resetAllPLayers(){
        //stopping pitch players
        audioEngine.stop()
        audioEngine.reset()
        
        audioPlayerNode = AVAudioPlayerNode()
        //attach to Audio Engine
        audioEngine.attachNode(audioPlayerNode)
    }
}
