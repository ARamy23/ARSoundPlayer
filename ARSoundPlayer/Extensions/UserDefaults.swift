//
//  UserDefaults.swift
//  PodcastApp
//
//  Created by ScaRiLiX on 9/25/18.
//  Copyright © 2018 ScaRiLiX. All rights reserved.
//

import Foundation

extension UserDefaults
{
    static let savedPodcastsKey = "SavedPodcasts"
    static let downloadedEpisodesKey = "DownloadedEpisodesKey"
    
    func savedPodcasts() -> [Podcast]
    {
        guard let savedPodcastsData =  data(forKey: UserDefaults.savedPodcastsKey) else { return [] }
        do
        {
            let savedPodcasts = try JSONDecoder().decode([Podcast].self, from: savedPodcastsData)
            return savedPodcasts
        }
        catch (let err)
        {
            print(err)
            return []
        }
    }
    
    func downloadedEpisodes() -> [Episode]
    {
        guard let downloadedEpisodesData =  data(forKey: UserDefaults.downloadedEpisodesKey) else { return [] }
        do
        {
            let downloadedEpisodes = try JSONDecoder().decode([Episode].self, from: downloadedEpisodesData)
            return downloadedEpisodes
        }
        catch (let err)
        {
            print(err)
            return []
        }
    }
    
    func save(_ podcasts: [Podcast])
    {
        do
        {
            let data = try JSONEncoder().encode(podcasts)
            UserDefaults.standard.set(data, forKey: UserDefaults.savedPodcastsKey)
        }
        catch (let err)
        {
            print("failed to encode Episode with error:", err)
        }
    }
    
    func download(_ episode: Episode)
    {
        do
        {
            var episodes = downloadedEpisodes()
            episodes.append(episode)
            let data = try JSONEncoder().encode(episodes)
            UserDefaults.standard.set(data, forKey: UserDefaults.downloadedEpisodesKey)
        }
        catch (let err)
        {
            print("failed to encode Episode with error:", err)
        }
    }
    
    func remove(_ episode: Episode)
    {
        do
        {
            var episodes = downloadedEpisodes()
            if let index = episodes.index(where: { $0.title == episode.title && $0.author == episode.author } )
            {
                episodes.remove(at: index)
                let data = try JSONEncoder().encode(episodes)
                UserDefaults.standard.set(data, forKey:     UserDefaults.downloadedEpisodesKey)
            }
        }
        catch (let err)
        {
            print("failed to encode Episode with error:", err)
        }
    }
}
