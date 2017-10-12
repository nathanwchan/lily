//
//  MainViewModel.swift
//  lily
//
//  Created by Nathan Chan on 9/14/17.
//  Copyright © 2017 Nathan Chan. All rights reserved.
//

import Foundation

protocol MainViewModelDelegate: class {
    func mainViewDidClickLogout(_ mainViewModel: MainViewModel)
    func mainViewDidClickCreateNewContest(_ mainViewModel: MainViewModel)
    func mainView(_ mainViewModel: MainViewModel, didSelectContest contest: Contest)
    func mainView(_ mainViewModel: MainViewModel, didSelectMedia media: Media)
}

class MainViewModel {
    var pageType: PageType
    private(set) var contests: [Contest] = []
    private(set) var media: [Media] = []
    let dataProvider: DataProvider!
    
    // used by AppCoordinator
    weak var delegate: MainViewModelDelegate?
    
    init(dataProvider: DataProvider = TestInstagramDataProvider(), pageType: PageType) {
        self.dataProvider = dataProvider
        self.pageType = pageType
    }
    
    //MARK: - Events

    var didGetContests: (() -> Void)?
    var didGetMediaForUser: (() -> Void)?
    
    //MARK: - Private
    
    private func didGetContests(contests: [Contest]) {
        self.contests += contests
        self.didGetContests?()
    }
    
    private func didGetMediaForUser(media: [Media]) {
        self.media += media
        self.didGetMediaForUser?()
    }
    
    private func getContestsMinId() -> String? {
        // SUPER CUSTOM FOR TEST IG DATA
        let ids = contests.flatMap({ Int($0.media.id.components(separatedBy: "_")[0]) })
        guard let minId = ids.min() else { return nil }
        return "\(minId)_\(contests[0].media.id.components(separatedBy: "_")[1])"
    }
    
    //MARK: - Actions
    
    func didClickLogout() {
        self.delegate?.mainViewDidClickLogout(self)
    }
    
    func didClickCreateNewContest() {
        self.delegate?.mainViewDidClickCreateNewContest(self)
    }
    
    func didSelectContest(_ contest: Contest) {
        self.delegate?.mainView(self, didSelectContest: contest)
    }
    
    func getMedia() {
        dataProvider.getMediaForUser(completion: self.didGetMediaForUser)
    }
    
    func getContestsForUser() {
        dataProvider.getContestsForUser(maxId: nil, completion: self.didGetContests)
    }
    
    func getMoreContestsForUser() {
        let minId = getContestsMinId()
        dataProvider.getContestsForUser(maxId: minId, completion: self.didGetContests)
    }
    
    func getPublicContests() {
        dataProvider.getPublicContests(maxId: nil, completion: self.didGetContests)
    }
    
    func getMorePublicContests() {
        let minId = getContestsMinId()
        dataProvider.getPublicContests(maxId: minId, completion: self.didGetContests)
    }
}
