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
    static var drumsAudioPlayer: AVAudioPlayer?
    
    static var testPopCount = 0 {
        didSet {
            GameAudio.testTotalCount += 1
            print("testPopCount: \(GameAudio.testPopCount)")
            print("testTotalCount: \(GameAudio.testTotalCount) \n")
        }
    }
    static var testPopAndShakeCount = 0 {
        didSet {
            GameAudio.testTotalCount += 1
            print("testPopAndShakeCount: \(GameAudio.testPopAndShakeCount)")
            print("testTotalCount: \(GameAudio.testTotalCount) \n")
        }
    }
    static var testPopAndChimeCount = 0 {
        didSet {
            GameAudio.testTotalCount += 1
            print("testPopAndChime: \(GameAudio.testPopAndChimeCount)")
            print("testTotalCount: \(GameAudio.testTotalCount) \n")
        }
    }
    static var testTotalCount = 0
    
    
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
            if let drumsAudio = Bundle.main.url(forResource: "shortDrumsLoop", withExtension: "mp3") {
                do {
                    GameAudio.drumsAudioPlayer = try AVAudioPlayer(contentsOf: drumsAudio)
                    GameAudio.drumsAudioPlayer?.numberOfLoops = -1
                    GameAudio.drumsAudioPlayer?.volume = 0.5
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
                    GameAudio.rainAudioPlayer?.volume = 0.3
                } catch let error {
                    print(error.localizedDescription)
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
    }
    
    func stopAndResetDrums() {
        if let drumsPlayer = GameAudio.drumsAudioPlayer {
            drumsPlayer.stop()
            drumsPlayer.currentTime = 0.0
            drumsPlayer.volume = 0.7
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
    
    func soundPop(scene: SKScene) {
//        print("pop sound")
//        GameAudio.testPopCount += 1
//        if UserPrefs.soundFxAllowed {
//            let popSound = SKAction.playSoundFileNamed("pop.mp3", waitForCompletion: true)
//            scene.run(popSound)
//        }
    }
    
    func soundPopAndShake(scene: SKScene) {
//        print("pop and shake sound")
//        GameAudio.testPopAndShakeCount += 1
//            if UserPrefs.soundFxAllowed {
//                let popSound = SKAction.playSoundFileNamed("popAndShake.mp3", waitForCompletion: true)
//                scene.run(popSound)
//        }
    }
    
    func soundPopAndChime(scene: SKScene) {
//        print("pop and chime sound")
//        GameAudio.testPopAndChimeCount += 1
//        if UserPrefs.soundFxAllowed {
//            let popAndChime = SKAction.playSoundFileNamed("popAndChime.mp3", waitForCompletion: true)
//            scene.run(popAndChime)
//        }
    }
    
    func soundThunderStrike(scene: SKScene) {
        if UserPrefs.soundFxAllowed {
            let thunder = SKAction.playSoundFileNamed("thunder3.mp3", waitForCompletion: true)
            scene.run(thunder)
        }
    }
    
    func drumStrike() -> SKAction {
        var strike = SKAction()
        if UserPrefs.musicAllowed {
            strike = SKAction.playSoundFileNamed("singleDrumStrike.mp3", waitForCompletion: true)
        }
        return strike
    }
}
