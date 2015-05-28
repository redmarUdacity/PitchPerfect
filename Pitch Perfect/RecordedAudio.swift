//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Redmar Kerkhoff on 25/05/15.
//  Copyright (c) 2015 Creative Code. All rights reserved.
//

import Foundation

class RecordedAudio {
    
    init(filePathUrl: NSURL, title: String) {
        self.filePathUrl = filePathUrl
        self.title = title
    }
    
    let filePathUrl: NSURL
    let title: String
}
