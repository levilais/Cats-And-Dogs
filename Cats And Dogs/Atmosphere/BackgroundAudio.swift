//
//  BackgroundAudio.swift
//  Cats And Dogs
//
//  Created by Levi on 3/27/18.
//  Copyright © 2018 App Volks. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit
import AVFoundation

class BackgroundAudio {
    static var backgroundMusicIsPlaying = false
    static var backgroundMusicPlayer: AVAudioPlayer?
    static var rainAudioPlayer: AVAudioPlayer?
    static var thunderAudioPlayers = [AVAudioPlayer]()
    
    func setupAudioPlayers() {
        let backgroundMusic = Bundle.main.url(forResource: "backgroundMusic", withExtension: "mp3")
        do {
            BackgroundAudio.backgroundMusicPlayer = try AVAudioPlayer(contentsOf: backgroundMusic!)
            BackgroundAudio.backgroundMusicPlayer?.numberOfLoops = -1
        } catch let error {
            print(error.localizedDescription)
        }
        let rainAudio = Bundle.main.url(forResource: "rain", withExtension: "mp3")
        do {
            BackgroundAudio.rainAudioPlayer = try AVAudioPlayer(contentsOf: rainAudio!)
            BackgroundAudio.rainAudioPlayer?.numberOfLoops = -1
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func resetBackgroundMusic() {
        if let backgroundMusic = BackgroundAudio.backgroundMusicPlayer {
            backgroundMusic.stop()
            backgroundMusic.volume = 1.0
            backgroundMusic.currentTime = 0.0
            backgroundMusic.play()
        }
    }
    
    func createThunderPlayer(severityLevel: Int) {
        // turn severity into randomly generated volume and thunder clap
        // create URL for thunder file to be played
        do {
            let thunderPlayer = try AVAudioPlayer(contentsOf: url)
            thunderPlayer.numberOfLoops = 0
            thunderPlayer.volume = 1
            thunderPlayer.play()
            BackgroundAudio.thunderAudioPlayers.append(thunderPlayer)
        } catch let error {
            print(error.localizedDescription)
        }

        for player in BackgroundAudio.thunderAudioPlayers {
            if player.isPlaying { continue } else {
                if let index = BackgroundAudio.thunderAudioPlayers.index(of: player) {
                    BackgroundAudio.thunderAudioPlayers.remove(at: index)
                }
            }
        }
    }
    
    func soundThunderStrike(scene: SKScene) {
        let thunder = SKAction.playSoundFileNamed("thunder3.mp3", waitForCompletion: true)
        scene.run(thunder)
    }
}


// USE FOR NOTES THEN DELETE


//    func createRainAudio(scene: SKScene) {
//        scene.run(SKAction.playSoundFileNamed("rain.mp3", waitForCompletion: false))
////        let loopMusic:SKAction = SKAction.repeatForever(music)
////        scene.run(loopMusic)
//
//        BackgroundAudio.backgroundMusicIsPlaying = true
//    }

//    func createBackgroundMusic(scene: SKScene) {
////        if let musicURL = Bundle.main.url(forResource: "lightRain", withExtension: ".wav") {
////            BackgroundAudio.backgroundMusic = SKAudioNode(url: musicURL)
////            scene.addChild(BackgroundAudio.backgroundMusic)
////        }
//    }

