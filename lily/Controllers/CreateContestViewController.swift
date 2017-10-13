//
//  CreateContestViewController.swift
//  lily
//
//  Created by Nathan Chan on 9/13/17.
//  Copyright © 2017 Nathan Chan. All rights reserved.
//

import UIKit

class CreateContestViewController: BaseViewModelViewController<CreateContestViewModel> {
    
    let scrollView = UIScrollView(frame: .zero)
    var scrollViewBottomConstraint: NSLayoutConstraint?
    var scrollViewDidScrollToBottom = false
    let likePostSwitch = UISwitch(frame: .zero)
    let followHostSwitch = UISwitch(frame: .zero)
    let maxEntriesTextField = UITextField(frame: .zero)
    let endDateTextField = UITextField(frame: .zero)
    let endDatePicker = UIDatePicker(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.clipsToBounds = true
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.navigationItem.title = "Create a new contest"
        
        let cancelBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelButtonTapped))
        self.navigationItem.rightBarButtonItem = cancelBarButtonItem
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: .UIKeyboardWillHide, object: nil)
    
        guard let media = viewModel.selectedMedia else {
            return
        }
    
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.keyboardDismissMode = .none
        scrollView.alwaysBounceVertical = true
        
        view.addSubview(scrollView)
        
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        scrollViewBottomConstraint = scrollView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor)
        scrollViewBottomConstraint?.isActive = true
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.width))
        imageView.contentMode = .scaleAspectFit
        imageView.image(fromUrl: media.imageUrl, readjustFrameSize: true)
        
        imageView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        scrollView.addSubview(imageView)
        
        let spacing: CGFloat = 20
        
        let detailStackView = UIStackView(frame: .zero)
        detailStackView.translatesAutoresizingMaskIntoConstraints = false
        detailStackView.axis = .vertical
        detailStackView.distribution = .fill
        detailStackView.alignment = .fill
        detailStackView.isLayoutMarginsRelativeArrangement = true
        detailStackView.clipsToBounds = true
        detailStackView.spacing = spacing
        
        scrollView.addSubview(detailStackView)
        
        detailStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: spacing).isActive = true
        detailStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -spacing).isActive = true
        detailStackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: spacing).isActive = true
        detailStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -spacing).isActive = true
        
        let captionLabel = UILabel(frame: .zero)
        let attrs = [NSAttributedStringKey.font: UIFont(name: "HelveticaNeue-Bold", size: 14)!]
        let attributedString = NSMutableAttributedString(string: media.username, attributes: attrs)
        
        if let caption = media.caption {
            let attrs = [NSAttributedStringKey.font: UIFont(name: "HelveticaNeue", size: 14)!]
            attributedString.append(NSMutableAttributedString(string: " \(caption)", attributes: attrs))
        }
        
        captionLabel.attributedText = attributedString
        captionLabel.textColor = .black
        captionLabel.textAlignment = .left
        captionLabel.numberOfLines = 0
        
        detailStackView.addArrangedSubview(captionLabel)
        
        let likePostStackView = UIStackView(frame: .zero)
        likePostStackView.translatesAutoresizingMaskIntoConstraints = false
        likePostStackView.axis = .horizontal
        likePostStackView.distribution = .fill
        likePostStackView.alignment = .center
        
        let likePostLabel = UILabel(frame: .zero)
        likePostLabel.text = "Like Post"
        likePostLabel.textColor = .black
        likePostLabel.textAlignment = .left
        likePostLabel.font = UIFont(name: "HelveticaNeue", size: 16)
        
        likePostSwitch.isOn = true
        
        likePostStackView.addArrangedSubview(likePostLabel)
        likePostStackView.addArrangedSubview(likePostSwitch)
        
        detailStackView.addArrangedSubview(likePostStackView)
        
        let followHostStackView = UIStackView(frame: .zero)
        followHostStackView.translatesAutoresizingMaskIntoConstraints = false
        followHostStackView.axis = .horizontal
        followHostStackView.distribution = .fill
        followHostStackView.alignment = .center
        
        let followHostLabel = UILabel(frame: .zero)
        followHostLabel.text = "Follow Host"
        followHostLabel.textColor = .black
        followHostLabel.textAlignment = .left
        followHostLabel.font = UIFont(name: "HelveticaNeue", size: 16)
        
        followHostSwitch.isOn = true
        
        followHostStackView.addArrangedSubview(followHostLabel)
        followHostStackView.addArrangedSubview(followHostSwitch)
        
        detailStackView.addArrangedSubview(followHostStackView)
        
        let maxEntriesStackView = UIStackView(frame: .zero)
        maxEntriesStackView.translatesAutoresizingMaskIntoConstraints = false
        maxEntriesStackView.axis = .horizontal
        maxEntriesStackView.distribution = .fillEqually
        maxEntriesStackView.alignment = .center
        
        let maxEntriesLabel = UILabel(frame: .zero)
        maxEntriesLabel.text = "Max Entries"
        maxEntriesLabel.textColor = .black
        maxEntriesLabel.textAlignment = .left
        maxEntriesLabel.font = UIFont(name: "HelveticaNeue", size: 16)
        
        maxEntriesTextField.text = "100"
        maxEntriesTextField.textColor = .black
        maxEntriesTextField.textAlignment = .right
        maxEntriesTextField.font = UIFont(name: "HelveticaNeue", size: 20)
        maxEntriesTextField.keyboardType = .numberPad
        
        maxEntriesStackView.addArrangedSubview(maxEntriesLabel)
        maxEntriesStackView.addArrangedSubview(maxEntriesTextField)
        
        detailStackView.addArrangedSubview(maxEntriesStackView)
        
        let endDateStackView = UIStackView(frame: .zero)
        endDateStackView.translatesAutoresizingMaskIntoConstraints = false
        endDateStackView.axis = .horizontal
        endDateStackView.distribution = .fillEqually
        endDateStackView.alignment = .center
        
        let endDateLabel = UILabel(frame: .zero)
        endDateLabel.text = "End Date"
        endDateLabel.textColor = .black
        endDateLabel.textAlignment = .left
        endDateLabel.font = UIFont(name: "HelveticaNeue", size: 16)
        
        guard let defaultDate = Calendar.current.date(byAdding: DateComponents(day: 7), to: Date()) else { return }
        
        endDateTextField.textColor = .black
        endDateTextField.textAlignment = .right
        endDateTextField.font = UIFont(name: "HelveticaNeue", size: 20)
        endDateTextField.inputView = endDatePicker
        
        endDatePicker.date = defaultDate
        endDatePicker.datePickerMode = .date
        endDatePicker.addTarget(self, action: #selector(endDatePickerValueChanged), for: .valueChanged)
        endDatePickerValueChanged(sender: endDatePicker) // update the text field
        
        endDateStackView.addArrangedSubview(endDateLabel)
        endDateStackView.addArrangedSubview(endDateTextField)
        
        detailStackView.addArrangedSubview(endDateStackView)
        
        let createContestButton = UIButton(frame: .zero)
        createContestButton.center = view.center
        createContestButton.setTitle("Create Contest", for: .normal)
        createContestButton.setTitleColor(.white, for: .normal)
        createContestButton.backgroundColor = .instagramBlue
        createContestButton.addTarget(self, action: #selector(self.createContestButtonClicked(sender:)), for: .touchUpInside)
        
        detailStackView.addArrangedSubview(createContestButton)
    }

    @objc func keyboardWasShown(notification: NSNotification)
    {
        guard let keyboardHeight = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height else { return }
        
        DispatchQueue.main.async {
            self.scrollViewBottomConstraint?.isActive = false
            self.scrollViewBottomConstraint = self.scrollView.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.topAnchor, constant: -keyboardHeight)
            self.scrollViewBottomConstraint?.isActive = true
            if !self.scrollViewDidScrollToBottom {
                let bottomOffset = CGPoint(x: 0, y: self.scrollView.contentSize.height - self.scrollView.bounds.size.height + keyboardHeight)
                self.scrollView.setContentOffset(bottomOffset, animated: true)
                self.scrollViewDidScrollToBottom = true
            }
        }
    }

    @objc func keyboardWillBeHidden(notification: NSNotification)
    {
        DispatchQueue.main.async {
            self.scrollViewBottomConstraint?.isActive = false
            self.scrollViewBottomConstraint = self.scrollView.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.topAnchor)
            self.scrollViewBottomConstraint?.isActive = true
            self.scrollViewDidScrollToBottom = false
        }
    }
    
    @objc func endDatePickerValueChanged(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        DispatchQueue.main.async {
            self.endDateTextField.text = dateFormatter.string(from: sender.date)
        }
    }

    @objc func cancelButtonTapped(sender: UIBarButtonItem) {
        viewModel.didClickCancel()
    }

    @objc func createContestButtonClicked(sender: Any?) {
        guard let media = viewModel.selectedMedia else {
            return
        }
        viewModel.didClickCreateNewContest(with: media)
    }
}
