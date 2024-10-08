//
//  ViewController.swift
//  GameON
//
//  Created by Atharian Rahmadani on 22/09/24.
//

import Kingfisher
import UIKit
import Combine
import GameON_Core
import Games

class ViewController: UIViewController {
    
    @IBOutlet private var gameTableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    private var gameList: [GameDomainModel] = []
    
    private var searchWorkItem: DispatchWorkItem?
    
    private var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        gameTableView.dataSource = self
        gameTableView.delegate = self
        gameTableView.register(
            UINib(nibName: "GameTableViewCell", bundle: nil),
            forCellReuseIdentifier: "gameTableViewCell"
        )
        getGameList()
    }
    
    private func getGameList() {
        let gamesUseCase: Interactor<
            Any,
            [GameDomainModel],
            GetGamesRepository<
                GetGamesLocaleDataSource,
                GetGamesRemoteDataSource,
                GameTransformer
            >
        > = Injection.init().provideGames()
        let presenter = GetListPresenter(useCase: gamesUseCase)
        
        // Observe gameList changes
        presenter.$list
            .sink { [weak self] games in
                self?.gameList = games
                self?.gameTableView.reloadData()
            }
            .store(in: &cancellables)
        
        // Observe loadingState changes
        presenter.$isLoading
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.gameTableView.isHidden = true
                    self?.loadingIndicator.isHidden = false
                    self?.loadingIndicator.startAnimating()
                } else {
                    self?.gameTableView.isHidden = false
                    self?.loadingIndicator.isHidden = true
                    self?.loadingIndicator.stopAnimating()
                }
            }
            .store(in: &cancellables)
        
        // Observe errorMessage changes
        presenter.$errorMessage
            .sink { [weak self] errorMessage in
                guard let self = self else { return }
                if !errorMessage.isEmpty {
                    AlertUtils.showErrorAlert(on: self, errorMessage: errorMessage) {
                        self.getGameList()
                    }
                }
            }
            .store(in: &cancellables)
        
        presenter.getList(request: nil)
    }
    
    private func getSearchGameList(query: String) {
        let gameSearchUseCase: Interactor<
            Any,
            [GameDomainModel],
            GetGamesRepository<
                GetGamesLocaleDataSource,
                GetGamesRemoteDataSource,
                GameTransformer
            >
        > = Injection.init().provideSearchGames(query: query)
        let presenter = GetListPresenter(useCase: gameSearchUseCase)
        
        // Observe gameList changes
        presenter.$list
            .sink { [weak self] games in
                self?.gameList = games
                self?.gameTableView.reloadData()
            }
            .store(in: &cancellables)
        
        // Observe loadingState changes
        presenter.$isLoading
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.gameTableView.isHidden = true
                    self?.loadingIndicator.isHidden = false
                    self?.loadingIndicator.startAnimating()
                } else {
                    self?.gameTableView.isHidden = false
                    self?.loadingIndicator.isHidden = true
                    self?.loadingIndicator.stopAnimating()
                }
            }
            .store(in: &cancellables)
        
        // Observe errorMessage changes
        presenter.$errorMessage
            .sink { [weak self] errorMessage in
                guard let self = self else { return }
                if !errorMessage.isEmpty {
                    AlertUtils.showErrorAlert(on: self, errorMessage: errorMessage) {
                        self.getGameList()
                    }
                }
            }
            .store(in: &cancellables)
        
        presenter.getList(request: query)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(
        _: UITableView,
        numberOfRowsInSection _: Int
    ) -> Int {
        gameList.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(
            withIdentifier: "gameTableViewCell",
            for: indexPath
        ) as? GameTableViewCell {
            let game = gameList[indexPath.row]
            return setupCellView(cell: cell, game: game)
        }
        return UITableViewCell()
    }
    
    private func setupCellView(cell: GameTableViewCell, game: GameDomainModel) -> GameTableViewCell {
        cell.imageLoadingIndicator.isHidden = false
        cell.imageLoadingIndicator.startAnimating()
        
        cell.titleLabel.text = game.title
        cell.ratingLabel.text = "\(game.rating)"
        cell.releaseDateLabel.text = game.releaseDate
        
        cell.cardView.layer.cornerRadius = 16
        cell.cardView.layer.shadowColor = UIColor.black.cgColor
        cell.cardView.layer.shadowOpacity = 0.25
        cell.cardView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cell.cardView.layer.shadowRadius = 4
        cell.cardView.layer.masksToBounds = false
        cell.cardView.layer.backgroundColor = UIColor.white.cgColor
        
        cell.gameImage.layer.borderWidth = 0.5
        cell.gameImage.layer.masksToBounds = false
        cell.gameImage.layer.borderColor = UIColor.colorSecondary.cgColor
        cell.gameImage.layer.cornerRadius = 8
        cell.gameImage.clipsToBounds = true
        cell.gameImage.kf.setImage(
            with: URL(string: game.imageUrl),
            completionHandler: { _ in
                cell.imageLoadingIndicator.stopAnimating()
                cell.imageLoadingIndicator.isHidden = true
            }
        )
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        performSegue(withIdentifier: "moveToDetail", sender: gameList[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "moveToDetail" {
            if let detaiViewController = segue.destination as? DetailViewController {
                detaiViewController.gameModel = sender as? GameDomainModel
            }
        }
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchWorkItem?.cancel()
        
        let workItem = DispatchWorkItem { [weak self] in
            self?.getSearchGameList(query: searchText)
        }
        
        searchWorkItem = workItem
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: workItem)
    }
}
