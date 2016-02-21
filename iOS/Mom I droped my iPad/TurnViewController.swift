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
import SwiftyJSON
import Alamofire



class Load {
    class func string(key:String) -> String! {
        return NSUserDefaults.standardUserDefaults().objectForKey(key) as? String
    }
}


class TurnViewController: UIViewController, AVAudioPlayerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var counter: UILabel!
    var startTime = NSTimeInterval()
    var timer = NSTimer()
    var countdownNumber = 4
    var motionManager = CMMotionManager()
    var numberOfCiclesStoped = 0
    let socket = SocketIOClient(socketURL: NSURL(string: "http://ec2-52-25-180-175.us-west-2.compute.amazonaws.com/")!, options: [ .ForcePolling(true)])
    var audioPlayer = AVAudioPlayer()
    var songAudioPlayer = AVAudioPlayer()
    var gameIsPlaying = false
    var puntuacion = 0
    var topGames : JSON = JSON("")
    @IBOutlet weak var restartButton: UIButton!
    @IBOutlet weak var textArea: UITextView!
    @IBOutlet weak var tableView: TopGamesTableView!
    
    
    var formater = NSDateFormatter()

    
    
    
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
        tableView.delegate = self
        tableView.dataSource = self
        let psytrance = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("psytrance", ofType: "mp3")!)
        do{
            songAudioPlayer = try AVAudioPlayer(contentsOfURL:psytrance)
            songAudioPlayer.prepareToPlay()
            songAudioPlayer.numberOfLoops = -1
            songAudioPlayer.delegate = self
        }catch{}
        
        Alamofire.request(Router.Top())
            .responseJSON { response in
                print(response.result.value)
                if (response.result.value != nil)
                {
                    let swiftyJson = JSON(response.result.value!)

                    self.topGames = swiftyJson
                    self.tableView.reloadData()
//                    print(self.topGames)
                }
                else
                {
                    print("ERROR Json is nil")
                }
        }
        
        
        restartButton(restartButton)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func restartButton(sender: AnyObject) {
        socket.disconnect()
        countdownNumber = 4
        NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("countdown:"), userInfo: nil, repeats: true)
        showMessage("Keep the iPad spinning in the air with one finger as long as you can!")
    }
    
    func countdown(timer: NSTimer)
    {
        counter.text = String(countdownNumber)
        if (countdownNumber > 0)
        {
            playSound("bep")
        }
        if (countdownNumber <= 0)
        {
            playSound("beep")
            timer.invalidate()
            startGame()
        }
        countdownNumber -= 1
    }
    
    func startGame()
    {

        songAudioPlayer.play()
        socket.connect()
        socket.on("connect")
        {
            data, ack in
            self.socket.emit("startgame")
        }
        
        timer = NSTimer.scheduledTimerWithTimeInterval(0.001, target: self, selector: Selector("updateTime"), userInfo: nil, repeats: true)
        startTime = NSDate.timeIntervalSinceReferenceDate()
        
        gameIsPlaying = true
        numberOfCiclesStoped = 0
        var anterior = 300.0;
        if motionManager.accelerometerAvailable == true
        {
            motionManager.startDeviceMotionUpdatesToQueue(NSOperationQueue.currentQueue()!, withHandler:
            {
                data, error in
                if (self.gameIsPlaying)
                {
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
                        self.timer.invalidate()
                        self.numberOfCiclesStoped += 1
                        self.fadeVolumeAndPause()
                        self.playSound("glass")
                        self.gameIsPlaying = false
                        self.numberOfCiclesStoped = 0
                        self.socket.emit("endgame")
                        
                        let params: [String:String] = [
                            "name":Load.string("name"),
                            "score":String(self.puntuacion)
                        ]
                        Api.game(params)
                        
//                        self.socket.disconnect()
                        
                        if (self.puntuacion < 100)
                        {
                            var messages: [String] = [
                                "My grandmother can last longer than you!",
                                "Bro, have you even tried?",
                                "Maybe you should think about it"]
                            let i = random() % messages.count ;
                            self.showMessage( messages[i] )
                        }
                        else if (self.puntuacion < 200)
                        {
                            var messages: [String] = [
                                "Keep trying"]
                            let i = random() % messages.count ;
                            self.showMessage( messages[i] )
                        }
                        else if (self.puntuacion < 1000)
                        {
                            var messages: [String] = [
                                "Wow! That was impressive!",
                                "Amazing skills!"]
                            let i = random() % messages.count ;
                            self.showMessage( messages[i] )
                        }
                    }
                    anterior = actual!;
                }
            })
        }
    }
    
    func updateTime()
    {
        let currentTime = NSDate.timeIntervalSinceReferenceDate()
        let elapsedTime = (currentTime - startTime) * 1000
        self.puntuacion = Int( (elapsedTime / 2323) * (elapsedTime / 2323) )
        counter.text = String(puntuacion)
        
    }
    
    @IBAction func exit(sender: AnyObject)
    {

    }
    
    
    func showMessage(text: String)
    {
        textArea.text = text
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("topGameCell") as?  TopGameTableViewCell!
        
        if (indexPath.row == 0)
        {
            cell!.position.text = "#"
            cell!.name.text = "Name"
            cell!.score.text = "Score"
            cell!.when.text = "Date"
        }
        else
        {
            cell!.position.text = String(indexPath.row)
            cell!.name.text = self.topGames[indexPath.row]["nombre"].string
            cell!.score.text = String( self.topGames[indexPath.row]["puntuacion"].intValue )
                
//            
//            let mydate : NSDateFormatter = NSDateFormatter()
//            mydate.dateFormat = "dd-MM-YYYY"
//            
//            let formatedDate : NSDate? = mydate.dateFromString( self.topGames[indexPath.row]["date"].string! )
            
            var string1 = self.topGames[indexPath.row]["date"].string!
            var index1 = string1.endIndex.advancedBy(-14)
            var substring1 = string1.substringToIndex(index1)
            
            
            cell!.when.text = String( substring1 )
            cell!.view.backgroundColor = UIColor.clearColor()
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        print(self.topGames.count)
        return self.topGames.count
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        self.tableView.contentInset = UIEdgeInsetsMake(0,0,55,0)
    }

}