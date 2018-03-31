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
import MediaPlayer

class GameAudio {
    static var backgroundMusicIsPlaying = false
    static var backgroundMusicPlayer: AVAudioPlayer?
    static var rainAudioPlayer: AVAudioPlayer?
    static var thunderAudioPlayer: AVAudioPlayer?
    static var pops = [AVAudioPlayer]()
    static var shakes = [AVAudioPlayer]()
    static var chimes = [AVAudioPlayer]()
    
    func setupAudioPlayers() {
        setupMusicPlayer()
        setupRainPlayer()
    }
    
    // DOESN'T WORK
    func setupMusicPlayer() {
        let audioSession = AVAudioSession.sharedInstance()
        if UserPrefs.musicAllowed {
            do {
                try audioSession.setCategory(AVAudioSessionCategorySoloAmbient)
            }
            catch let error as NSError {
                print(error)
            }
            if let backgroundMusic = Bundle.main.url(forResource: "backgroundMusic", withExtension: "mp3") {
                do {
                    GameAudio.backgroundMusicPlayer = try AVAudioPlayer(contentsOf: backgroundMusic)
                    GameAudio.backgroundMusicPlayer?.numberOfLoops = -1
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        } else {
            do {
                try audioSession.setCategory(AVAudioSessionCategoryAmbient)
            }
            catch let error as NSError {
                print(error)
            }
        }
    }
    
    func setupRainPlayer() {
        if UserPrefs.rainAllowed {
            if let rainAudio = Bundle.main.url(forResource: "rain", withExtension: "mp3") {
                do {
                    GameAudio.rainAudioPlayer = try AVAudioPlayer(contentsOf: rainAudio)
                    GameAudio.rainAudioPlayer?.numberOfLoops = -1
                    GameAudio.rainAudioPlayer?.volume = 0.5
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }
        if let thunderAudio = Bundle.main.url(forResource: "thunder", withExtension: "wav") {
            do {
                GameAudio.thunderAudioPlayer = try AVAudioPlayer(contentsOf: thunderAudio)
                GameAudio.thunderAudioPlayer?.numberOfLoops = -1
                GameAudio.thunderAudioPlayer?.volume = 0.4
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    func playBackgroundMusic() {
        if let backgroundMusicPlayer = GameAudio.backgroundMusicPlayer {
            backgroundMusicPlayer.play()
        }
    }
    
    func resetBackgroundMusic() {
        if UserPrefs.musicAllowed {
            if let backgroundMusic = GameAudio.backgroundMusicPlayer {
                backgroundMusic.stop()
                backgroundMusic.volume = 1.0
                backgroundMusic.currentTime = 0.0
                backgroundMusic.play()
            }
        }
    }
    
    func setThunderVolume() {
        var thunderVolume = Float()
        switch GameVariables.currentLevel {
        case 1:
            thunderVolume = 0.4
        case 2:
            thunderVolume = 0.6
        case 3:
            thunderVolume = 0.7
        case 4:
            thunderVolume = 0.8
        case 5:
            thunderVolume = 0.9
        case 6:
            thunderVolume = 1.0
        default:
            thunderVolume = 1.0
        }
        GameAudio.thunderAudioPlayer?.setVolume(thunderVolume, fadeDuration: 1.0)
    }
    
    func soundPop() {
        if UserPrefs.soundFxAllowed {
            let popSound = Bundle.main.url(forResource: "pop", withExtension: "mp3")
            do {
                let popPlayer = try AVAudioPlayer(contentsOf: popSound!)
                popPlayer.numberOfLoops = 0
                popPlayer.volume = 0.5
                popPlayer.play()
                GameAudio.pops.append(popPlayer)
            } catch let error {
                print(error.localizedDescription)
            }
            
            for player in GameAudio.pops {
                if player.isPlaying { continue } else {
                    if let index = GameAudio.pops.index(of: player) {
                        GameAudio.pops.remove(at: index)
                    }
                }
            }
        }
    }
    
    func soundShake() {
//        if UserPrefs.soundFxAllowed {
//            let shakeSound = Bundle.main.url(forResource: "shake", withExtension: "mp3")
//            do {
//                let shakePlayer = try AVAudioPlayer(contentsOf: shakeSound!)
//                shakePlayer.numberOfLoops = 0
//                shakePlayer.volume = 0.2
//                shakePlayer.play()
//                GameAudio.pops.append(shakePlayer)
//            } catch let error {
//                print(error.localizedDescription)
//            }
//
//            for player in GameAudio.shakes {
//                if player.isPlaying { continue } else {
//                    if let index = GameAudio.shakes.index(of: player) {
//                        GameAudio.shakes.remove(at: index)
//                    }
//                }
//            }
//        }
    }
    
    func soundChime() {
        if UserPrefs.soundFxAllowed {
//            let chimeSound = Bundle.main.url(forResource: "chime", withExtension: "mp3")
//            do {
//                let chimePlayer = try AVAudioPlayer(contentsOf: chimeSound!)
//                chimePlayer.numberOfLoops = 0
//                chimePlayer.volume = 0.2
//                chimePlayer.play()
//                GameAudio.chimes.append(chimePlayer)
//            } catch let error {
//                print(error.localizedDescription)
//            }
//
//            for player in GameAudio.chimes {
//                if player.isPlaying { continue } else {
//                    if let index = GameAudio.chimes.index(of: player) {
//                        GameAudio.chimes.remove(at: index)
//                    }
//                }
//            }
        }
    }
    
    func soundThunderStrike(scene: SKScene) {
        if UserPrefs.soundFxAllowed {
            let thunder = SKAction.playSoundFileNamed("thunder3.mp3", waitForCompletion: true)
            scene.run(thunder)
        }
    }
}
