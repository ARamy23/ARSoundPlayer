# ARSoundPlayer
A Simple Audio Player

# Demo
To be uploaded

# Usage

1. We first create our track
  we can use a track over the internet and stream it using the streamURL
```swift
let trackTitle = "Venom"
let artistName = "Eminem"
let streamURL = "https://your-song-url-here".url!
let imageURL = "https://your-image-url-here".url!

let track = Track(title: trackTitle, 
      imageURL: imageURL,
      artistName: artistName,
      streamURL: streamURL)
```
  or we can use a downloaded track and run it from the fileURL
```swift
let trackTitle = "Venom"
let artistName = "Eminem"
let streamURL = "https://your-song-url-here".url!
let fileURL = "file://your-song-url-here".url!
let imageURL = "https://your-image-url-here".url!

let track = Track(title: trackTitle, 
      imageURL: imageURL,
      artistName: artistName,
      streamURL: streamURL,
      fileURL: fileURL)
      
```

2. then we setup our PlayerView in our VC over whatever view, 
  *I'm using a TabBarController in this example so am setting it above the tabBar*
```swift
Import ARSoundPlayer

...

let playerDetailsView = PlayerDetailsView.initFromNib(with: track)
playerDetailsView.setupPlayerDetailsView(in: self, below: self.tabBarController?.tabBar)
```

then launching/minimzing the player is as easy as...

```swift
playerDetailsView.maximizePlayerDetails()
playerDetailsView.minimizePlayerDetails()
```

# Installation 
put these 2 lines at the top of your podfile
```
source 'https://github.com/CocoaPods/Specs.git'
source 'https://github.com/ARamy23/ARSoundPlayerPodSpecs'
```
and then
`pod 'ARSoundPlayer', '~> 0.1.4'
