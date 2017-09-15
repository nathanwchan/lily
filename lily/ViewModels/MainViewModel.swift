//
//  MainViewModel.swift
//  lily
//
//  Created by Nathan Chan on 9/14/17.
//  Copyright © 2017 Nathan Chan. All rights reserved.
//

import Foundation

protocol MainViewModelDelegate: class {
    func mainView(_ mainViewModel: MainViewModel, didSelectContest contest: Contest)
    func mainView(_ mainViewModel: MainViewModel, didSelectMedia media: Media)
}

class MainViewModel {
    private(set) var contests: [Contest]?
    private(set) var media: [Media]?
    let dataProvider: DataProvider!
    
    // used by AppCoordinator
    weak var delegate: MainViewModelDelegate?
    
    init(dataProvider: DataProvider = TestInstagramDataProvider()) {
        self.dataProvider = dataProvider
    }
    
    //MARK: - Events

    var didGetContestsForUser: (() -> Void)?
    var didGetMediaForUser: (() -> Void)?
    
    //MARK: - Private
    
    private func didGetContestsForUser(contests: [Contest]?) {
        self.contests = contests
        self.didGetContestsForUser?()
    }
    
    private func didGetMediaForUser(media: [Media]?) {
        self.media = media
        self.didGetMediaForUser?()
    }
    
    //MARK: - Actions
    
    func didClickLogin() {
        print("didClickLogin")
    }
    
    func didSelectContest(at indexPath: IndexPath) {
        if let contests = contests {
            self.delegate?.mainView(self, didSelectContest: contests[indexPath.row])
        }
    }
    
    func getMedia() {
        dataProvider.getMediaForUser(completion: self.didGetMediaForUser)
    }
    
    func getContests() {
        dataProvider.getContestsForUser(completion: self.didGetContestsForUser)
    }
}
