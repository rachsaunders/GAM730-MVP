//
//  UserProfileTableViewController.swift
//  GAM730-MVP
//
//  Created by Rachel Saunders on 05/10/2020.
//  Copyright © 2020 Rachel Saunders. All rights reserved.
//


import UIKit
import SKPhotoBrowser

protocol UserProfileTableViewControllerDelegate {
    func didLikeUser()
    func didDislikeUser()
}


class UserProfileTableViewController: UITableViewController {

    //MARK: - IBOutlets
  
    @IBOutlet weak var sectionOneView: UIView!
    
    @IBOutlet weak var sectionTwoView: UIView!
    
    @IBOutlet weak var sectionThreeView: UIView!
    
    @IBOutlet weak var sectionFourView: UIView!
    

    @IBOutlet weak var collectionView: UICollectionView!
    // missing collectionView
    
    @IBOutlet weak var dislikeButtonOutlet: UIButton!
    
    @IBOutlet weak var likeButtonOutlet: UIButton!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // missing links
    @IBOutlet weak var aboutTextView: UITextView!
    
    
    @IBOutlet weak var professionLabel: UILabel!
    
    @IBOutlet weak var jobLabel: UILabel!
    
    @IBOutlet weak var genderLabel: UILabel!
    
    @IBOutlet weak var heightLabel: UILabel!
    
    @IBOutlet weak var lookingForLabel: UILabel!
    
    //MARK:- VARS
    
    var userObject: FirebaseUser?
    
    var delegate: UserProfileTableViewControllerDelegate?
    
    var allImages: [UIImage] = []
    
    var isMatchedUser = false
    
    private let sectionInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 5.0)
    
    
    //MARK: - View lifecycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        pageControl.hidesForSinglePage = true
        
        if userObject != nil {
            updateLikeButtonStatus()
            showUserDetails()
            loadImages()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupBackgrounds()
        hideActivityIndicator()
        
        if isMatchedUser {
            updateUIForMatchedUser()
        }
    }

    
    //MARK: - IBActions
    @IBAction func dislikeButtonPressed(_ sender: Any) {
        
        self.delegate?.didDislikeUser()
        
        if self.navigationController != nil {
            navigationController?.popViewController(animated: true)
        } else {
            dismissView()
        }
    }
    
    
    @IBAction func likeButtonPressed(_ sender: Any) {
        
        self.delegate?.didLikeUser()
        
        if self.navigationController != nil {
            saveLikeToUser(userId: userObject!.objectId)
            FirebaseListener.shared.saveMatch(userId: userObject!.objectId)
            showMatchView()
        } else {
            dismissView()
        }
    }
    
    
    @objc func startChatButtonPressed() {
        goToChat()
    }
    
    
    //MARK: - TableViewDelegate
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return section == 0 ? 0 : 10
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView()
        view.backgroundColor = .clear
        
        return view
    }
    
    
    //MARK: - Setup UI
    private func setupBackgrounds() {

        sectionOneView.clipsToBounds = true
        sectionOneView.layer.cornerRadius = 30
        sectionOneView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        sectionTwoView.layer.cornerRadius = 10
        sectionThreeView.layer.cornerRadius = 10
        sectionFourView.layer.cornerRadius = 10
    }
    
    private func updateUIForMatchedUser() {
        
        self.likeButtonOutlet.isHidden = isMatchedUser
        self.dislikeButtonOutlet.isHidden = isMatchedUser
        
        showStartChatButton()
    }
    
    private func showStartChatButton() {
        
        let messageButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(startChatButtonPressed))
        
        self.navigationItem.rightBarButtonItem = isMatchedUser ? messageButton : nil
    }

    
    //MARK: - Show user profile
    private func showUserDetails() {
        
        aboutTextView.text = userObject!.about
        professionLabel.text = userObject!.profession
        jobLabel.text = userObject!.profession
        genderLabel.text = userObject!.isMan ? "Male" : "Female"
        lookingForLabel.text = userObject!.lookingFor
        
    }

    //MARK: - Activity indicator
    
    private func showActivityIndicator() {
        self.activityIndicator.startAnimating()
        self.activityIndicator.isHidden = false
    }

    private func hideActivityIndicator() {
        self.activityIndicator.stopAnimating()
        self.activityIndicator.isHidden = true
    }

    //MARK: - Load Images
    private func loadImages() {
        
        let placeholder = userObject!.isMan ? "mPlaceholder" : "fPlaceholder"
        let avatar = userObject!.avatar ?? UIImage(named: placeholder)
        
        allImages = [avatar!]
        self.setPageControlPages()
        
        self.collectionView.reloadData()
        
        if userObject!.imageLinks != nil && userObject!.imageLinks!.count > 0 {
            
            showActivityIndicator()
            
            FileStorage.downloadImages(imageUrls: userObject!.imageLinks!) { (returnedImages) in
                
                self.allImages += returnedImages as! [UIImage]

                DispatchQueue.main.async {
                    self.setPageControlPages()
                    self.hideActivityIndicator()
                    self.collectionView.reloadData()
                }

            }
        } else {
            hideActivityIndicator()
        }
    }
    
    //MARK: - PageControl
    private func setPageControlPages() {
        
        self.pageControl.numberOfPages = self.allImages.count
    }
    
    private func setSelectedPageTo(page: Int) {
        self.pageControl.currentPage = page
    }

    
    //MARK: - SKPhotoBrowse
    private func showImages(_ images: [UIImage], startIndex: Int) {
        
        var SKImages: [SKPhoto] = []
        
        for image in images {
            SKImages.append(SKPhoto.photoWithImage(image))
        }
        
        let browser = SKPhotoBrowser(photos: SKImages)
        browser.initializePageIndex(startIndex)
        self.present(browser, animated: true, completion: nil)
    }
    
    //MARK: - UpdateUI
    private func updateLikeButtonStatus() {
        likeButtonOutlet.isEnabled = !FirebaseUser.currentUser()!.likedIdArray!.contains(userObject!.objectId)
    }

    //MARK: - Helpers
    private func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: - Navigation
    private func showMatchView() {
        let matchView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "matchView") as! MatchViewController
        
        matchView.user = userObject!
        matchView.delegate = self
        self.present(matchView, animated: true, completion: nil)
    }
    
    private func goToChat() {
        
        let chatRoomId = startChat(user1: FirebaseUser.currentUser()!, user2: userObject!)
        
        let chatView = ChatViewController(chatId: chatRoomId, recipientId: userObject!.objectId, recipientName: userObject!.fullName)
        
        chatView.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(chatView, animated: true)
    }


}


extension UserProfileTableViewController : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ImageCollectionViewCell
        
        
        let countryCity = userObject!.country
        
        let nameAge = userObject!.fullName + ", " + "\(abs(userObject!.dateOfBirth.interval(ofComponent: .year, fromDate: Date())))"
        
        cell.setupCell(image: allImages[indexPath.row], country: countryCity, nameAge: nameAge, indexPath: indexPath)
        
        return cell
    }
    
}


extension UserProfileTableViewController : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        showImages(allImages, startIndex: indexPath.row)
    }
    
}

extension UserProfileTableViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        return CGSize(width: collectionView.frame.width, height: 453.0)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        setSelectedPageTo(page: indexPath.row)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return sectionInsets
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return sectionInsets.left
    }
}

extension UserProfileTableViewController: MatchViewControllerDelegate {
    
    func didClickSendMessage(to user: FirebaseUser) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.goToChat()
        }
        
        updateLikeButtonStatus()
    }
    
    func didClickKeepSwiping() {
        print("swipe ")
        updateLikeButtonStatus()
    }
}

