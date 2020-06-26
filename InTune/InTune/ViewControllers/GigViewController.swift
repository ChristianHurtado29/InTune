//
//  GigViewController.swift
//  InTune
//
//  Created by Tiffany Obi on 5/27/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class GigViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
    var listener: ListenerRegistration?
    
    var gigs = [GigsPost]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSearchBar()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "GigCell", bundle: nil), forCellReuseIdentifier: "gigCell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        listener = Firestore.firestore().collection(DatabaseService.gigPosts).addSnapshotListener({ (snapshot, error) in
                  if let error = error {
                      DispatchQueue.main.async {
                          self.showAlert(title: "Firestore Error", message: "\(error.localizedDescription)")
                      }
                  } else if let snapshot = snapshot {
                      let gig = snapshot.documents.map { GigsPost($0.data()) }
                      self.gigs = gig
                  }
              })
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        listener?.remove()
    }
    
    private func setUpSearchBar() {
        searchBar.layer.cornerRadius = 20
        searchBar.layer.masksToBounds = true
        searchBar.delegate = self
        searchBar.searchTextField.backgroundColor = .white
//        searchBar.searchBarShadow(for: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
    }
    
    
}

extension GigViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gigs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "gigCell", for: indexPath) as? GigCell else {
            fatalError("could not get cell")
        }
        let gig = gigs[indexPath.row]
        cell.configureGig(for: gig)
        return cell
    }
}

extension GigViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.addShadow()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "GigsView", bundle:  nil)
        guard let detailVC = storyBoard.instantiateViewController(identifier: "GigsDetailViewController") as? GigsDetailViewController else {
            fatalError("could not load gigsDetail")
        }
        let gig = gigs[indexPath.row]
        detailVC.gigPost = gig
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension GigViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
}
