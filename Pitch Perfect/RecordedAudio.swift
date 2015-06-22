//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Amit Kumar on 2015-06-04.
//  Copyright (c) 2015 Agranee Solutions Ltd. All rights reserved.
//

import Foundation
import AVFoundation

class RecordedAudio{
    var filePathUrl : NSURL!
    var title : String!
    
    init(avRecorder: AVAudioRecorder){
        self.filePathUrl = avRecorder.url
        self.title = avRecorder.url.lastPathComponent
    }
}