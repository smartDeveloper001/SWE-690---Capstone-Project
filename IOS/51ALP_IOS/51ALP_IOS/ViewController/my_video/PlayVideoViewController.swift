//
//  PlayVideoViewController.swift
//  51ALP_IOS
//
//  Created by xiu on 3/17/19.
//  Copyright © 2019 wma. All rights reserved.
//

import UIKit
import BMPlayer
import SnapKit

class PlayVideoViewController: UIViewController {
    var player:BMPlayer!
    var takeVidePath:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
  
        takeVidePath = ENV.BACKENDURL.rawValue+"/video/aaa@aaa.com/2019-03-17-13-51-39.mp4"
        
//        var url: URL = URL(fileURLWithPath: takeVidePath)
//
//        let playerVC = MobilePlayerViewController(contentURL: url)
//        playerVC.title = "Vanilla Player"
//        playerVC.activityItems = [url] // Check the documentation for more information.
//        presentMoviePlayerViewControllerAnimated(playerVC)
//
//
        
        if let url: URL = URL(fileURLWithPath: takeVidePath) {

            let asset = BMPlayerResource(name: "123333 343 ",
                                         definitions: [BMPlayerResourceDefinition(url: url, definition: "")],
                                         cover: nil,
                                         subtitles: nil)

            var controller: BMPlayerControlView? = nil
            controller = BMPlayerCustomControlView()
            BMPlayerConf.shouldAutoPlay = false
            player = BMPlayer(customControlView: controller)
            //        player!.pause()
            self.view.addSubview(player)

            player.setVideo(resource: asset)
            player.delegate = self


            player.snp.makeConstraints { (make) in
                make.top.equalTo(self.view).offset(0)
                make.left.right.equalTo(self.view)
                make.height.equalTo(player.snp_width).multipliedBy(9.0/16.0).priority(750)
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

extension PlayVideoViewController: BMPlayerDelegate {
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
