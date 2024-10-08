//
//  ViewController.swift
//  GameON
//
//  Created by Atharian Rahmadani on 22/09/24.
//

import Kingfisher
import UIKit
import Combine
import Games
import GameON_Core
import Favorite

class FavoriteViewController: UIViewController {

    @IBOutlet private var gameTableView: UITableView!

    @IBOutlet weak var emptyStateStackView: UIStackView!

    private var gameList: [GameDomainModel] = []

    private var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        gameTableView.dataSource = self
        gameTableView.delegate = self
        gameTableView.register(
            UINib(nibName: "GameTableViewCell", bundle: nil),
            forCellReuseIdentifier: "gameTableViewCell"
        )
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getAllFavoriteGames()
    }
    
    private func getAllFavoriteGames() {
        let favoriteUseCase: Interactor<
            Any,
            [FavoriteDomainModel],
            FavoriteRepository<
                FavoriteLocaleDataSource,
                FavoriteRemoteDataSource,
                FavoriteTransformer
            >
        > = Injection.init().provideFavorites()
        let presenter = GetListPresenter(useCase: favoriteUseCase)
        
        // Observe gameDetail changes
        presenter.$list
            .sink { [weak self] favoriteGames in
                let hasFavorites = !favoriteGames.isEmpty
                self?.gameTableView.isHidden = !hasFavorites
                self?.emptyStateStackView.isHidden = hasFavorites

                if hasFavorites {
                    let gameList = favoriteGames.map { game in
                        GameDomainModel(
                            id: game.id,
                            title: game.title,
                            rating: game.rating,
                            releaseDate: game.releaseDate,
                            imageUrl: game.imageUrl
                        )
                    }
                    self?.gameList = gameList
                    self?.gameTableView.reloadData()
                }
            }
            .store(in: &cancellables)
        
        // Observe loadingState changes
        presenter.$isLoading
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.gameTableView.isHidden = true
                } else {
                    self?.gameTableView.isHidden = false
                }
            }
            .store(in: &cancellables)
        
        // Observe errorMessage changes
        presenter.$errorMessage
            .sink { [weak self] errorMessage in
                guard let self = self else { return }
                if !errorMessage.isEmpty {
                    AlertUtils.showErrorAlert(on: self, errorMessage: errorMessage) {
                        self.getAllFavoriteGames()
                    }
                }
            }
            .store(in: &cancellables)
        
        presenter.getList(request: nil)
    }

}

extension FavoriteViewController: UITableViewDataSource {
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

extension FavoriteViewController: UITableViewDelegate {
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
