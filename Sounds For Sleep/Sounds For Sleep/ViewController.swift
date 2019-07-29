//
//  ViewController.swift
//  Sounds For Sleep
//
//  Created by Howard Ellenberger on 7/10/19.
//  Copyright © 2019 Howard Ellenberger. All rights reserved.
//

import UIKit
import AVFoundation

var sounds:[String] = []
var sleepSoundPlayer = AVAudioPlayer()


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var soundsTable: UITableView!
    
    @IBAction func volumeSlider(_ sender: UISlider) {
        sleepSoundPlayer.volume = sender.value
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     return sounds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = sounds[indexPath.row]
        cell.textLabel?.textColor = UIColor.white
        guard let helvetica = UIFont(name: "Helvetica", size: 14) else {
            fatalError("""
        Failed to load the "Helvetica" font.
        Since this font is included with all versions of iOS that support Dynamic Type, verify that the spelling and casing is correct.
        """
            )
        }
        cell.textLabel?.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: helvetica)
    cell.textLabel?.adjustsFontForContentSizeCategory = true
        cell.backgroundColor = UIColor.black
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        do
        {
            let audioPath = Bundle.main.path(forResource: sounds[indexPath.row], ofType: ".m4a")
            try sleepSoundPlayer = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: audioPath!) as URL)
            sleepSoundPlayer.play()
            sleepSoundPlayer.numberOfLoops = -1
        }
        catch
        {
            print ("ERROR")
        }
    }
    
    @IBAction func stopButton(_ sender: Any) {

        if sleepSoundPlayer.isPlaying == true {
            sleepSoundPlayer.stop()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getSoundNames()
    }
    
    func getSoundNames() {
        let folderURL = URL(fileURLWithPath: Bundle.main.resourcePath!)
        
        do{
            let soundPath = try FileManager.default.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            
            for sound in soundPath {
                var mySound = sound.absoluteString
                
                if mySound.contains(".m4a")
                {
                    let findString = mySound.components(separatedBy: "/")
                    mySound = findString[findString.count-1]
                    mySound = mySound.replacingOccurrences(of: "%20", with: " ")
                    mySound = mySound.replacingOccurrences(of: ".m4a", with: "")
                    sounds.append(mySound)
                }
            }
            soundsTable.reloadData()
        }
        catch{
        }
    }
}

