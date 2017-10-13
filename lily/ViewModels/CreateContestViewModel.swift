//
//  CreateContestViewModel.swift
//  lily
//
//  Created by Nathan Chan on 10/12/17.
//  Copyright © 2017 Nathan Chan. All rights reserved.
//

import Foundation

protocol CreateContestViewModelDelegate: class {
    func createContestView(_ createContestViewModel: CreateContestViewModel, didSelectMedia media: Media)
    func createContestView(_ createContestViewModel: CreateContestViewModel, didCreateContest contest: Contest)
    func createContestViewDidClickCancel(_ createContestViewModel: CreateContestViewModel)
}

class CreateContestViewModel {
    private(set) var media: [Media] = []
    var selectedMedia: Media?
    let dataProvider: DataProvider!
    
    // used by CreateContestCoordinator
    weak var delegate: CreateContestViewModelDelegate?
    
    init(dataProvider: DataProvider = TestInstagramDataProvider()) {
        self.dataProvider = dataProvider
    }
    
    //MARK: - Events
    
    var didGetMediaForUser: (() -> Void)?
    
    //MARK: - Private
    
    private func didGetMediaForUser(media: [Media]) {
        self.media += media
        if self.media.count == 1 {
            self.delegate?.createContestView(self, didSelectMedia: media.first!)
        } else {
            self.didGetMediaForUser?()
        }
    }
    
    //MARK: - Actions
    
    func didSelectMedia(_ media: Media) {
        self.delegate?.createContestView(self, didSelectMedia: media)
    }
    
    func didClickCreateNewContest(with media: Media) {
        let newContest = Contest(name: "new contest", media: media)
        self.delegate?.createContestView(self, didCreateContest: newContest)
    }
    
    func didClickCancel() {
        self.delegate?.createContestViewDidClickCancel(self)
    }
    
    func getMediaForUser() {
        dataProvider.getMediaForUser(completion: self.didGetMediaForUser)
    }
}
