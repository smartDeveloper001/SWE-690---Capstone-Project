//
//  VideoPlayViewController.swift
//  51ALP_IOS
//
//  Created by xiu on 2/3/19.
//  Copyright © 2019 wma. All rights reserved.
//

import UIKit
import SnapKit
import BMPlayer


class VideoPlayViewController: UIViewController {
    

    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        if let url: URL = URL(fileURLWithPath: "http://video.51alp.com/c6ade8b4df144b998013bc947cf214b6/a563847af3b3401186dfca568b55b1f3-5287d2089db37e62345123a1be272f8b.mp4") {
            
            let asset = BMPlayerResource(name: "测试视频",
                                         definitions: [BMPlayerResourceDefinition(url: url, definition: "")],
                                         cover: nil,
                                         subtitles: nil)
            
            var controller: BMPlayerControlView? = nil
            controller = BMPlayerCustomControlView()
            let player = BMPlayer(customControlView: controller)
            player.pause()
            self.view.addSubview(player)
            
            player.setVideo(resource: asset)
            player.delegate = self
            
            
            player.snp.makeConstraints { (make) in
                make.top.equalTo(self.view).offset(20)
                make.left.right.equalTo(self.view)
                make.height.equalTo(player.snp.width).multipliedBy(9.0/16.0).priority(750)
            }
            
            player.backBlock = { [unowned self] (isFullScreen) in
                print("isFullScreen\(isFullScreen)")
                //let _ = self.navigationController?.popViewController(animated: true)
                self.dismiss(animated: false) {}
            }
            
            
        } else {
            print("error ")
        }
        
  
    }
    




}

extension VideoPlayViewController: BMPlayerDelegate {
    // Call when player orinet changed
    func bmPlayer(player: BMPlayer, playerOrientChanged isFullscreen: Bool) {
        player.snp.remakeConstraints { (make) in
            make.top.equalTo(view.snp.top)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            if isFullscreen {
                make.bottom.equalTo(view.snp.bottom)
            } else {
                make.height.equalTo(view.snp.width).multipliedBy(9.0/16.0).priority(500)
            }
        }
    }
    
    // Call back when playing state changed, use to detect is playing or not
    func bmPlayer(player: BMPlayer, playerIsPlaying playing: Bool) {
        // print("| BMPlayerDelegate | playerIsPlaying | playing - \(playing)")
    }
    
    // Call back when playing state changed, use to detect specefic state like buffering, bufferfinished
    func bmPlayer(player: BMPlayer, playerStateDidChange state: BMPlayerState) {
        // print("| BMPlayerDelegate | playerStateDidChange | state - \(state)")
    }
    
    // Call back when play time change
    func bmPlayer(player: BMPlayer, playTimeDidChange currentTime: TimeInterval, totalTime: TimeInterval) {
        print("| BMPlayerDelegate | playTimeDidChange | \(currentTime) of \(totalTime)")
    }
    
    // Call back when the video loaded duration changed
    func bmPlayer(player: BMPlayer, loadedTimeDidChange loadedDuration: TimeInterval, totalDuration: TimeInterval) {
        //     print("| BMPlayerDelegate | loadedTimeDidChange | \(loadedDuration) of \(totalDuration)")
    }
}





