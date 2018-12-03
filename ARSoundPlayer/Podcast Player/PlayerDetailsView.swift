//
//  PlayerDetailsView.swift
//  PodcastsCourseLBTA
//
//  Created by Brian Voong on 2/28/18.
//  Copyright © 2018 Brian Voong. All rights reserved.
//

import UIKit
import AVKit
import MediaPlayer
import SVProgressHUD
import SwifterSwift

public class PlayerDetailsView: UIView {
    
    //MARK:- Maximized Player IBOutlets
    
    @IBOutlet weak var maximizedPlayerStackView: UIStackView!
    @IBOutlet weak var episodeImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var progressSlider: UISlider!
    @IBOutlet weak var episodeDurationLabel: UILabel!
    @IBOutlet weak var episodeCurrentTimeLabel: UILabel!
    @IBOutlet weak var volumeSlider: UISlider!
    
    //MARK:- Minimized Player IBOutlets
    
    @IBOutlet weak var minimizedPlayerView: UIView!
    @IBOutlet weak var minimizedEpisodeImageView: UIImageView!
    @IBOutlet weak var minimziedTitleLabel: UILabel!
    @IBOutlet weak var minimizedPlayPauseButton: UIButton!
    
    //MARK:- Helping Vars
    
    var episode: Episode! {
        didSet
        {
            titleLabel.text = episode.title
            authorLabel.text = episode.author
            minimziedTitleLabel.text = episode.title
            setupNowPlayingInfo()
            setupAudioSession()
            playEpisode()
        }
    }
    
    var podcastEpisodes: [Episode]!
    
    var player: AVPlayer =
    {
        let avPlayer = AVPlayer()
        avPlayer.automaticallyWaitsToMinimizeStalling = false
        avPlayer.volume = 0.5
        return avPlayer
    }()
    
    var panGesture: UIPanGestureRecognizer!
    
    var parentVC: UIViewController?
    var parentView: UIView?
    
    var maximizedTopAnchorConstraint: NSLayoutConstraint!
    var minimizedTopAnchorConstraint: NSLayoutConstraint!
    var bottomAnchorConstraint: NSLayoutConstraint!
    
    //MARK:- IB Methods
    
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        observePlayerCurrentTime()
        observeStartingOfEpisode()
        setupInterrubtionsObserver()
        setupUI()
    }
    
    //MARK:- Setup Methods
    
    fileprivate func setupLockScreenDuration()
    {
        guard let duration = player.currentItem?.duration else { return }
        let durationSeconds = CMTimeGetSeconds(duration)
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPMediaItemPropertyPlaybackDuration] = durationSeconds
    }
    
    fileprivate func setupElapsedTime(playBackRate: Float)
    {
        let elapsedTime = CMTimeGetSeconds(player.currentTime())
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = elapsedTime
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyPlaybackRate] = playBackRate
    }
    
    fileprivate func setupInterrubtionsObserver()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(handleInterrutption(notification:)), name:
            AVAudioSession.interruptionNotification, object: nil)
    }
    
    //MARK:- Background music Section
    
    fileprivate func setupNowPlayingInfo()
    {
        guard let duration = player.currentItem?.duration else { return }
        let artwork = MPMediaItemArtwork(boundsSize: episodeImageView.image?.size ?? .zero) { (_) -> UIImage in
            return self.episodeImageView.image ?? #imageLiteral(resourceName: "podcast icon")
        }
        
        var nowPlayingInfo = [String: Any]()
        
        nowPlayingInfo[MPMediaItemPropertyTitle] = episode.title
        nowPlayingInfo[MPMediaItemPropertyArtist] = episode.author
        nowPlayingInfo[MPMediaItemPropertyArtwork] = artwork
        nowPlayingInfo[MPMediaItemPropertyArtist] = episode.author
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = CMTimeGetSeconds(duration)
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = CMTimeGetSeconds(player.currentTime())
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    fileprivate func setupRemoteControl()
    {
        UIApplication.shared.beginReceivingRemoteControlEvents()
        let commandCenter = MPRemoteCommandCenter.shared()
        
        //MARK: Play
        commandCenter.playCommand.isEnabled = true
        commandCenter.playCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
            self.player.play()
            self.playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            self.minimizedPlayPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyPlaybackRate] = 1
            return .success
        }
        
        //MARK: Pause
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.pauseCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
            self.player.pause()
            self.playPauseButton.setImage(#imageLiteral(resourceName: "playButton"), for: .normal)
            self.minimizedPlayPauseButton.setImage(#imageLiteral(resourceName: "playButton"), for: .normal)
            MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyPlaybackRate] = 0
            
            return .success
        }
        
        //MARK: HeadPhones
        commandCenter.togglePlayPauseCommand.isEnabled = true
        commandCenter.togglePlayPauseCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
            
            self.handlePlayPause(self.playPauseButton)
            
            return .success
        }
        
        //MARK: Next Episode
        commandCenter.nextTrackCommand.isEnabled = true
        commandCenter.nextTrackCommand.addTarget(self, action: #selector(handleNextEpisodeCommand))
        //MARK: Previous Episode
        commandCenter.previousTrackCommand.isEnabled = true
        commandCenter.previousTrackCommand.addTarget(self, action: #selector(handlePreviousEpisodeCommand))
        
    }
    
    fileprivate func setupAudioSession()
    {
        do
        {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: .defaultToSpeaker)
            try AVAudioSession.sharedInstance().setActive(true)
        }
        catch(let err)
        {
            print(err)
            SVProgressHUD.showError(withStatus: err.localizedDescription)
        }
    }
    
    fileprivate func setupUI()
    {
        progressSlider.value = 0
        episodeImageView.transform =  CGAffineTransform(scaleX: 0.7, y: 0.7)
        setupGestures()
    }
    
    //MARK:- Utility Methods
    
    static func initFromNib() -> PlayerDetailsView
    {
        return Bundle.main.loadNibNamed("PlayerDetailsView", owner: self, options: nil)?.first as! PlayerDetailsView
    }
    
    //MARK:- Logic
    
    @objc fileprivate func handleInterrutption(notification: Notification)
    {
        guard let userInfo = notification.userInfo else { return }
        guard let type = userInfo[AVAudioSessionInterruptionTypeKey] as? AVAudioSession.InterruptionType else { return }
        
        switch type
        {
        case .began:
            minimizedPlayPauseButton.setImage(#imageLiteral(resourceName: "playButton"), for: .normal)
            playPauseButton.setImage(#imageLiteral(resourceName: "playButton"), for: .normal)
        case .ended:
            guard let options = userInfo[AVAudioSessionInterruptionOptionKey] as? AVAudioSession.InterruptionOptions else { return }
            
            switch options
            {
            case .shouldResume:
                minimizedPlayPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
                playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
                player.play()
            default:
                break
            }
        }
    }
    
    @objc fileprivate func handlePreviousEpisodeCommand()
    {
        if podcastEpisodes.count <= 1 { return }
        
        if let currentEpisodeIndex = podcastEpisodes.index(where: { $0.title == self.episode.title })
        {
            let previousEpisodeIndex = (currentEpisodeIndex == podcastEpisodes.count - 1) ? podcastEpisodes.count - 1 : currentEpisodeIndex - 1
            let previousEpisode = podcastEpisodes[previousEpisodeIndex]
            self.episode = previousEpisode
        }
    }
    
    @objc fileprivate func handleNextEpisodeCommand()
    {
        if podcastEpisodes.count <= 1 { return }
        
        if let currentEpisodeIndex = podcastEpisodes.index(where: { $0.title == self.episode.title })
        {
            let nextEpisodeIndex = (currentEpisodeIndex == podcastEpisodes.count - 1) ? 0 : currentEpisodeIndex + 1
            let nextEpisode = podcastEpisodes[nextEpisodeIndex]
            self.episode = nextEpisode
        }
    }
    
    fileprivate func setupGestures() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleMaximizing)))
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        minimizedPlayerView.addGestureRecognizer(panGesture)
        maximizedPlayerStackView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleDismissalPan)))
    }
    
    fileprivate func observeStartingOfEpisode() {
        let time = CMTimeMake(value: 1, timescale: 3)
        let times = [NSValue(time: time)]
        player.addBoundaryTimeObserver(forTimes: times, queue: .main) {
            [weak self] in
            
            self?.scaleImageUp()
            self?.setupLockScreenDuration()
        }
    }
    
    fileprivate func observePlayerCurrentTime()
    {
        let interval = CMTimeMake(value: 1, timescale: 2)
        
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] (time) in
            
            self?.episodeCurrentTimeLabel.text = time.toDisplayString()
            let durationTime = self?.player.currentItem?.duration
            self?.episodeDurationLabel.text = durationTime?.toDisplayString()
            
            self?.updateSliderProgress()
        }
    }
    
    fileprivate func updateSliderProgress()
    {
        let currentTimeSeconds = CMTimeGetSeconds(player.currentTime())
        let totalTimeSeconds = CMTimeGetSeconds(player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
        let percentage = currentTimeSeconds / totalTimeSeconds
        
        progressSlider.value = percentage.float
    }
    
    fileprivate func playEpisode()
    {
        if let fileURL = episode.fileURL
        {
            playEpisodeLocally(from: fileURL)
        }
        else if let streamURL = episode.streamURL
        {
            let playerItem = AVPlayerItem(url: streamURL)
            player.replaceCurrentItem(with: playerItem)
            player.play()
        }
        else
        {
            SVProgressHUD.showError(withStatus: "Oops, something went wrong!")
        }
    }
    
    fileprivate func playEpisodeLocally(from fileURL: URL )
    {
        guard var localFileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileName = fileURL.lastPathComponent
        localFileURL.appendPathComponent(fileName)
        let playerItem = AVPlayerItem(url: localFileURL)
        player.replaceCurrentItem(with: playerItem)
        player.play()
    }
    
    fileprivate func scaleImageUp()
    {
        episodeImageView.transform =  CGAffineTransform(scaleX: 0.7, y: 0.7)
        
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.episodeImageView.transform = .identity
        })
    }
    
    fileprivate func scaleImageDown()
    {
        episodeImageView.transform =  CGAffineTransform(scaleX: 1, y: 1)
        
        UIView.animate(withDuration: 0.5) {
            self.episodeImageView.transform =  CGAffineTransform(scaleX: 0.7, y: 0.7)
        }
    }
    
    fileprivate func seekToCurrentTime(delta: Int64)
    {
        let fifteenSeconds = CMTimeMake(value: delta, timescale: 1)
        let seekTime = CMTimeAdd(player.currentTime(), fifteenSeconds)
        player.seek(to: seekTime)
    }
    
    @objc fileprivate func handleMaximizing()
    {
        self.maximizePlayerDetails()
    }
    
    fileprivate func handlePanEndedCase(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: superview)
        let velocity = gesture.velocity(in: superview)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.transform = .identity
            if translation.y < (-self.height / 4) || velocity.y < -500
            {
                self.minimizePlayerDetails()
            }
            else
            {
                self.minimizedPlayerView.alpha = 1
                self.maximizedPlayerStackView.alpha = 0
            }
            
        })
    }
    
    fileprivate func handlePanChange(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: superview)
        self.transform = CGAffineTransform(translationX: 0, y: translation.y)
        
        minimizedPlayerView.alpha = 1 + translation.y / (self.height / 4)
        maximizedPlayerStackView.alpha = -translation.y / (self.height / 4)
    }
    
    @objc fileprivate func handlePan(gesture: UIPanGestureRecognizer)
    {
        switch gesture.state
        {
        case .changed:
            handlePanChange(gesture)
        case .ended:
            handlePanEndedCase(gesture)
        default:
            break
        }
    }
    
    @objc fileprivate func handleDismissalPan(gesture: UIPanGestureRecognizer)
    {
        switch gesture.state
        {
        case .changed:
            let translation = gesture.translation(in: superview)
            maximizedPlayerStackView.transform = CGAffineTransform(translationX: 0, y: translation.y)
        case .ended:
            let translation = gesture.translation(in: superview)
            let velocity = gesture.velocity(in: superview)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                if translation.y > 200 || velocity.y > 500
                {
                    self.minimizePlayerDetails()
                }
                
                self.maximizedPlayerStackView.transform = .identity
            })
        default:
            break
        }
    }
    
    //MARK:- IBActions

    @IBAction func handleProgressChange(_ sender: Any)
    {
        let percentage = progressSlider.value
        guard let duration = player.currentItem?.duration else { return }
        
        let durationInSeconds = duration.seconds
        let seekTimeInSeconds = Float64(percentage) * durationInSeconds
        let seekTime = CMTimeMakeWithSeconds(seekTimeInSeconds, preferredTimescale: 1)
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = seekTimeInSeconds
        
        player.seek(to: seekTime)
    }
    
    @IBAction func handleRewind(_ sender: Any)
    {
        seekToCurrentTime(delta: -15)
    }
    
    @IBAction func handlePlayPause(_ sender: Any)
    {
        if player.timeControlStatus == .playing
        {
            player.pause()
            playPauseButton.setImage(#imageLiteral(resourceName: "playButton"), for:  .normal)
            minimizedPlayPauseButton.setImage(#imageLiteral(resourceName: "playButton"), for:  .normal)
            scaleImageDown()
            setupElapsedTime(playBackRate: 1)
        }
        else
        {
            player.play()
            playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for:  .normal)
            minimizedPlayPauseButton.setImage(#imageLiteral(resourceName: "pause"), for:  .normal)
            scaleImageUp()
            setupElapsedTime(playBackRate: 0)
        }
    }
    
    @IBAction func handleFastForward(_ sender: Any)
    {
        seekToCurrentTime(delta: 15)
    }
    
    @IBAction func handleMuting(_ sender: Any)
    {
        player.volume = 0.0
    }
    
    @IBAction func handleVolumeChange(_ sender: Any)
    {
        player.volume = volumeSlider.value
    }
    
    @IBAction func handleMaximzingVolume(_ sender: Any)
    {
        player.volume = 1.0
    }
    
    @IBAction func handleDismiss(_ sender: Any)
    {
        self.minimizePlayerDetails()
    }
}

extension PlayerDetailsView {
    public func setupPlayerDetailsView(in viewController: UIViewController, below subview: UIView)
    {
        parentVC = viewController
        parentView = subview
        
        viewController.view.insertSubview(self, belowSubview: subview)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        maximizedTopAnchorConstraint = self.topAnchor.constraint(equalTo: viewController.view.topAnchor, constant: viewController.view.height)
        maximizedTopAnchorConstraint.isActive = true
        
        minimizedTopAnchorConstraint = self.topAnchor.constraint(equalTo: subview.topAnchor, constant: -64)
        
        self.leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor).isActive = true
        bottomAnchorConstraint = self.bottomAnchor.constraint(equalTo: viewController.view.bottomAnchor, constant: viewController.view.height)
        bottomAnchorConstraint.isActive = true
        self.trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor).isActive = true
        
    }
    
    public func minimizePlayerDetails()
    {
        maximizedTopAnchorConstraint.isActive = false
        bottomAnchorConstraint.constant = parentVC?.view.height ?? 0.0
        minimizedTopAnchorConstraint.isActive = true
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.parentVC?.view.layoutIfNeeded()
            self.parentView?.transform = .identity
            self.maximizedPlayerStackView.alpha = 0
            self.minimizedPlayerView.alpha = 1
        })
    }
    
    public func maximizePlayerDetails()
    {
        minimizedTopAnchorConstraint.isActive = false
        maximizedTopAnchorConstraint.isActive = true
        maximizedTopAnchorConstraint.constant = 0
        bottomAnchorConstraint.constant = 0
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.parentVC?.view.layoutIfNeeded()
            self.parentView?.transform = CGAffineTransform(translationX: 0, y: 100)
            self.maximizedPlayerStackView.alpha = 1
            self.minimizedPlayerView.alpha = 0
        })
    }
}
