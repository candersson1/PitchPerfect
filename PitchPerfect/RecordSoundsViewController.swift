//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Chris Andersson on 2018-10-31.
//  Copyright © 2018 klarsolutions. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    var audioRecorder: AVAudioRecorder!

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordingButton.isEnabled = false
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppearCalled")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    @IBAction func recordAudio(_ sender: Any) {
        recordingLabel.text = "Recording in Progress"
        stopRecordingButton.isEnabled = true
        recordButton.isEnabled = false
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
        
    
    @IBAction func stopRecording(_ sender: Any) {
        recordingButtonStatus(.recording)
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
    }
   
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
         recordingButtonStatus(.notRecording)
        if flag {
        performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            print("recording was not succesful")
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
    
    enum RecordingState { case recording, notRecording}
    
    func recordingButtonStatus(_ recordingState: RecordingState ) {
        switch(recordingState) {
        case .recording:
            recordButton.isEnabled = false
            stopRecordingButton.isEnabled = true
            recordingLabel.text = "Recording in Progress"
        case .notRecording:
            recordButton.isEnabled = true
            stopRecordingButton.isEnabled = false
            recordingLabel.text = "Tap to Record"
        }
    }
}



