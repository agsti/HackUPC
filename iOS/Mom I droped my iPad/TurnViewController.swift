//
//  turn.swift
//  Mom I droped my iPad
//
//  Created by Victor Gallego Betorz on 20/2/16.
//  Copyright © 2016 Victor Gallego Betorz. All rights reserved.
//

import Foundation
import UIKit
import CoreMotion
import SocketIOClientSwift
import AVFoundation

class TurnViewController: UIViewController, AVAudioPlayerDelegate {
    
    @IBOutlet weak var counter: UILabel!
    var startTime = NSTimeInterval()
    var timer = NSTimer()
    var countdown = 4
    var motionManager = CMMotionManager()
    var numberOfCiclesStoped = 0
    let socket = SocketIOClient(socketURL: NSURL(string: "http://ec2-52-25-180-175.us-west-2.compute.amazonaws.com/")!, options: [ .ForcePolling(true)])
    var audioPlayer = AVAudioPlayer()
    var songAudioPlayer = AVAudioPlayer()
    @IBOutlet weak var restartButton: UIButton!

    
    @IBAction func start(sender: AnyObject)
    {
        socket.connect()
        socket.on("connect")
        {
            data, ack in
            self.socket.emit("startgame")
        }
        socket.on("startgame")
        {
            data, ack in
        }
        timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: Selector("updateTime"), userInfo: nil, repeats: true)
        startTime = NSDate.timeIntervalSinceReferenceDate()
        var anterior = 300.0;
        if motionManager.accelerometerAvailable == true
        {
            motionManager.startDeviceMotionUpdatesToQueue(NSOperationQueue.currentQueue()!, withHandler:
            {
                data, error in
                let actual = data?.attitude.yaw
                if (self.numberOfCiclesStoped < 50)
                {
                    let increment = abs(actual!) - abs(anterior)
                    if (abs(increment) < 0.008)
                    {
                        self.numberOfCiclesStoped += 1
                    }
                    else
                    {
                        self.numberOfCiclesStoped = 0
                    }
                }
                if (self.numberOfCiclesStoped == 50)
                {
                    self.socket.emit("endgame")
                    self.timer.invalidate()
                    self.numberOfCiclesStoped += 1
                    self.fadeVolumeAndPause()
                    self.playSound("glass")
                    // self.stop(self.counter)

                }
                anterior = actual!;
            })
        }
    }
    
    @IBAction func stop(sender: AnyObject)
    {
        socket.emit("endgame")
        timer.invalidate()
        self.fadeVolumeAndPause()
    }
    
    func updateTime()
    {
        let currentTime = NSDate.timeIntervalSinceReferenceDate()
        var elapsedTime: NSTimeInterval = currentTime - startTime
        let minutes = UInt8(elapsedTime / 60.0)
        elapsedTime -= (NSTimeInterval(minutes) * 60)
        let seconds = UInt8(elapsedTime)
        elapsedTime -= NSTimeInterval(seconds)
        let fraction = UInt8(elapsedTime * 100)
        
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        let strFraction = String(format: "%02d", fraction)
        
        counter.text = strMinutes + ":" + strSeconds + ":" + strFraction
    }
    
    func count(timer: NSTimer)
    {
        countdown--
        if (countdown <= 0)
        {
            countdown = 0
            timer.invalidate()
            songAudioPlayer.play()
        }
        if (countdown == 1) {
            playSound("beep")
        }
        if (countdown > 1)
        {
            playSound("bep")
        }
        counter.text = String(countdown)
        if (countdown <= 0)
        {
            start(counter)
        }
    }
    
    @IBAction func restartButton(sender: AnyObject) {
        countdown = 4
        numberOfCiclesStoped = 0
        counter.text = String(countdown)
        let psytrance = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("psytrance", ofType: "mp3")!)
        do{
            songAudioPlayer = try AVAudioPlayer(contentsOfURL:psytrance)
            songAudioPlayer.prepareToPlay()
            songAudioPlayer.numberOfLoops = -1
            songAudioPlayer.delegate = self
        }catch{}
        playSound("bep")
        NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("count:"), userInfo: nil, repeats: true)
    }
    
    func playSound(soundName: String)
    {
        let coinSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(soundName, ofType: "mp3")!)
        do
        {
            audioPlayer = try AVAudioPlayer(contentsOfURL:coinSound)
            audioPlayer.prepareToPlay()
            audioPlayer.delegate = self
            audioPlayer.play()
        }
        catch
        {
            print("Error getting the audio file")
        }
    }
    
    func fadeVolumeAndPause()
    {
        if self.songAudioPlayer.volume > 0.1
        {
            self.songAudioPlayer.volume = self.songAudioPlayer.volume - 0.1
            
            let dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(0.1 * Double(NSEC_PER_SEC)))
            dispatch_after(dispatchTime, dispatch_get_main_queue(), {
                self.fadeVolumeAndPause()
            })
            
        }
        else
        {
            self.songAudioPlayer.pause()
            self.songAudioPlayer.volume = 1.0
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        restartButton(restartButton)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}