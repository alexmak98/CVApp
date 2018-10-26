//
//  ViewController.swift
//  CVApp
//
//  Created by  User on 24.10.2018.
//  Copyright © 2018 Alex Makovetskiy. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate {
    
    var audioPlayer : AVAudioPlayer!
    @IBOutlet weak var tagLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func anyButtonTouched(_ sender: UIButton) {
        playSound("buttonClick")
        self.tagLabel.text = "tag:\(sender.tag)"
    }
    
    func playSound(_ soundPlayed : String) {

        let soundURL = Bundle.main.url(forResource: soundPlayed, withExtension:"mp3")!

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            guard let audioPlayer = audioPlayer else {return}

            audioPlayer.prepareToPlay()
            audioPlayer.play()

        } catch let error as NSError {
            print(error.description)
        }
    }
    
}

extension UIButton {
    
    func getColourFromPoint(point:CGPoint) -> UIColor {
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitMapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        
        var pixelData:[UInt8] = [0,0,0,0]
        
        let context = CGContext(data: &pixelData, width: 1,height: 1,bitsPerComponent: 8,bytesPerRow: 4,space: colorSpace,bitmapInfo: bitMapInfo.rawValue)
        context!.translateBy(x:-point.x, y:-point.y)
        
        self.layer.render(in: context!)
        
        let red = CGFloat(pixelData[0])/CGFloat(255.0)
        let green = CGFloat(pixelData[1])/CGFloat(255.0)
        let blue = CGFloat(pixelData[2])/CGFloat(255.0)
        let alpha = CGFloat(pixelData[3])/CGFloat(255.0)
        
        let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        return color
        
    }
    
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        let color = self.getColourFromPoint(point: point)
        let cgColor = color.cgColor
        let alpha = cgColor.alpha
        if alpha <= 0 {
            return nil
        }
        return self
    }
}


