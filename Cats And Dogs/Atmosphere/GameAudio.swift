//
//  GameAudio.swift
//  Cats And Dogs
//
//  Created by Levi on 3/29/18.
//  Copyright © 2018 App Volks. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit
import AVFoundation

class GameAudio {
    static var backgroundMusicIsPlaying = false
    static var backgroundMusicPlayer: AVAudioPlayer?
    static var rainAudioPlayer: AVAudioPlayer?
    static var thunderAudioPlayer: AVAudioPlayer?
    
    func setupAudioPlayers() {
        let backgroundMusic = Bundle.main.url(forResource: "backgroundMusic", withExtension: "mp3")
        do {
            GameAudio.backgroundMusicPlayer = try AVAudioPlayer(contentsOf: backgroundMusic!)
            GameAudio.backgroundMusicPlayer?.numberOfLoops = -1
        } catch let error {
            print(error.localizedDescription)
        }
        let rainAudio = Bundle.main.url(forResource: "rain", withExtension: "mp3")
        do {
            GameAudio.rainAudioPlayer = try AVAudioPlayer(contentsOf: rainAudio!)
            GameAudio.rainAudioPlayer?.numberOfLoops = -1
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func resetBackgroundMusic() {
        if let backgroundMusic = GameAudio.backgroundMusicPlayer {
            backgroundMusic.stop()
            backgroundMusic.volume = 1.0
            backgroundMusic.currentTime = 0.0
            backgroundMusic.play()
        }
    }
    
    //    func createDropSound() {
    //        // turn severity into randomly generated volume and thunder clap
    //        let randomThunderInt = Int(arc4random_uniform(6))
    //        print("randomThunderInt: \(randomThunderInt)")
    //        let backgroundMusic = Bundle.main.url(forResource: "thunder\(randomThunderInt)", withExtension: "mp3")
    //        // create URL for thunder file to be played
    //        var thunderVolume = Float()
    //        switch severityLevel {
    //        case 1:
    //            thunderVolume = 0.3
    //        case 2:
    //            thunderVolume = 0.5
    //        case 3:
    //            thunderVolume = 0.7
    //        case 4:
    //            thunderVolume = 0.8
    //        case 5:
    //            thunderVolume = 0.9
    //        case 6:
    //            thunderVolume = 1.0
    //        default:
    //            thunderVolume = 0.5
    //        }
    //        do {
    //            let thunderPlayer = try AVAudioPlayer(contentsOf: backgroundMusic!)
    //            thunderPlayer.numberOfLoops = 0
    //            thunderPlayer.volume = thunderVolume
    //            thunderPlayer.play()
    //            GameAudio.thunderAudioPlayers.append(thunderPlayer)
    //        } catch let error {
    //            print(error.localizedDescription)
    //        }
    //
    //        for player in GameAudio.thunderAudioPlayers {
    //            if player.isPlaying { continue } else {
    //                if let index = GameAudio.thunderAudioPlayers.index(of: player) {
    //                    GameAudio.thunderAudioPlayers.remove(at: index)
    //                }
    //            }
    //        }
    //    }
    
    func createThunderStrike(severityLevel: Int) {
        if var thunderPlayer = GameAudio.thunderAudioPlayer {
            if !thunderPlayer.isPlaying {
                let randomThunderInt = Int(arc4random_uniform(6))
                let backgroundMusic = Bundle.main.url(forResource: "thunder\(randomThunderInt)", withExtension: "mp3")
                var thunderVolume = Float()
                switch severityLevel {
                case 1:
                    thunderVolume = 0.3
                case 2:
                    thunderVolume = 0.5
                case 3:
                    thunderVolume = 0.7
                case 4:
                    thunderVolume = 0.9
                case 5:
                    thunderVolume = 1.0
                case 6:
                    thunderVolume = 1.0
                default:
                    thunderVolume = 0.5
                }
                do {
                    let newThunderPlayer = try AVAudioPlayer(contentsOf: backgroundMusic!)
                    thunderPlayer = newThunderPlayer
                    thunderPlayer.numberOfLoops = 0
                    thunderPlayer.volume = thunderVolume
                    thunderPlayer.play()
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func soundThunderStrike(scene: SKScene) {
        let thunder = SKAction.playSoundFileNamed("thunder3.mp3", waitForCompletion: true)
        scene.run(thunder)
    }
}
