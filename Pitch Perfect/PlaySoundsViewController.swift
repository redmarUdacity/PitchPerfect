//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Redmar Kerkhoff on 25/05/15.
//  Copyright (c) 2015 Creative Code. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    var audioPlayer:AVAudioPlayer!
    var audioPlayer2:AVAudioPlayer! // Used for echo
    var receivedAudio:RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        audioPlayer2 = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playSlowAudio(sender: AnyObject) {
        playAudioWithVariableRate(0.5)
    }

    @IBAction func playFastAudio(sender: AnyObject) {
        playAudioWithVariableRate(2.0)
    }
    
    func playAudioWithVariableRate(rate: Float) {
        stopAudioPlayersAndEngine()
        audioPlayer.rate = rate
        audioPlayer.play()
    }
    
    func stopAudioPlayersAndEngine() {
        audioPlayer2.stop()
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        audioPlayer.rate = 1.0
        audioPlayer.currentTime = 0
    }
    
    @IBAction func playChipmunkAudio(sender: AnyObject) {
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func playDarthvaderAudio(sender: AnyObject) {
        playAudioWithVariablePitch(-1000)
    }
    
    @IBAction func playEchoAudio(sender: AnyObject) {
        stopAudioPlayersAndEngine()
        
        audioPlayer2.volume = 0.8;
        audioPlayer2.currentTime = audioPlayer.currentTime
        audioPlayer2.playAtTime(0.5)
        audioPlayer.play()
    }
    
    @IBAction func playReverbAudio(sender: AnyObject) {
        stopAudioPlayersAndEngine()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var reverbEffect = AVAudioUnitReverb()
        reverbEffect.loadFactoryPreset(AVAudioUnitReverbPreset.LargeHall2)
        reverbEffect.wetDryMix = 50
        audioEngine.attachNode(reverbEffect)
        
        audioEngine.connect(audioPlayerNode, to: reverbEffect, format: nil)
        audioEngine.connect(reverbEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    
    @IBAction func stopPlayingAudio(sender: AnyObject) {
        stopAudioPlayersAndEngine()
    }
    
    /// This method will first stop all audio and play the audio
    /// with the given pitch.
    ///
    /// :param: pitch The amount by which the input signal is pitch shifted
    func playAudioWithVariablePitch(pitch: Float) {
        stopAudioPlayersAndEngine()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)

        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
}
