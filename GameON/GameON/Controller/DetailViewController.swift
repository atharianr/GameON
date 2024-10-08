//
//  DetailViewController.swift
//  GameON
//
//  Created by Atharian Rahmadani on 25/09/24.
//

import UIKit
import UIView_Shimmer
import Kingfisher
import Combine
import Games
import GameDetail
import GameON_Core
import Favorite

extension UILabel: @retroactive ShimmeringViewProtocol {}

class DetailViewController: UIViewController {

    @IBOutlet weak var gameImage: UIImageView!

    @IBOutlet weak var smallGameImage: UIImageView!

    @IBOutlet weak var imageOverlayView: UIView!

    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!

    @IBOutlet weak var gameTitleLabel: UILabel!

    @IBOutlet weak var gamePublisherLabel: UILabel!

    @IBOutlet weak var gamePlatformLabel: UILabel!

    @IBOutlet weak var gameRatingLabel: UILabel!

    @IBOutlet weak var gameReleaseDateLabel: UILabel!

    @IBOutlet weak var gameEsrbRatingLabel: UILabel!

    @IBOutlet weak var gameDescriptionLabel: UILabel!

    @IBOutlet weak var favoriteButton: UIBarButtonItem!

    var gameModel: GameDomainModel?

    private var cancellables: Set<AnyCancellable> = []

    private var isFavorite = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func viewWillAppear(_ animated: Bool) {
        checkIsAlreadyFavorite()
        getGameDetail(id: gameModel?.id ?? 0)
    }

    @IBAction func setFavorite(_ sender: UIBarButtonItem) {
        isFavorite.toggle()

        if isFavorite {
            addFavorite(id: gameModel?.id ?? 0)
        } else {
            deleteFavorite(id: gameModel?.id ?? 0)
        }

        favoriteButton.image = UIImage(systemName: isFavorite ? "heart.fill" : "heart")
    }

    private func addFavorite(id: Int) {
        let setFavoriteUseCase: Interactor<
            Any,
            Bool,
            SetFavoriteRepository<
                FavoriteLocaleDataSource,
                FavoriteRemoteDataSource,
                FavoriteTransformer
            >
        > = Injection.init().provideSetFavorite()
        let presenter = GetDataPresenter(useCase: setFavoriteUseCase)

        // Observe data changes
        presenter.$data
            .sink { [] isSuccess in
                if isSuccess ?? false {
                    debugPrint("SUCCESS ADD TO FAVORITE")
                }
            }
            .store(in: &cancellables)

        // Observe errorMessage changes
        presenter.$errorMessage
            .sink { [weak self] errorMessage in
                guard let self = self else { return }
                if !errorMessage.isEmpty {
                    AlertUtils.showErrorAlert(on: self, errorMessage: errorMessage) {}
                }
            }
            .store(in: &cancellables)

        if let game = gameModel {
            let favoriteModel = FavoriteDomainModel(
                id: game.id,
                title: game.title,
                rating: game.rating,
                releaseDate: game.releaseDate,
                imageUrl: game.imageUrl
            )
            presenter.getData(request: ["add": favoriteModel])
        }
    }

    private func deleteFavorite(id: Int) {
        let setFavoriteUseCase: Interactor<
            Any,
            Bool,
            SetFavoriteRepository<
                FavoriteLocaleDataSource,
                FavoriteRemoteDataSource,
                FavoriteTransformer
            >
        > = Injection.init().provideSetFavorite()
        let presenter = GetDataPresenter(useCase: setFavoriteUseCase)

        // Observe data changes
        presenter.$data
            .sink { [] isSuccess in
                if isSuccess ?? false {
                    debugPrint("SUCCESS DELETE FROM FAVORITE")
                }
            }
            .store(in: &cancellables)

        // Observe errorMessage changes
        presenter.$errorMessage
            .sink { [weak self] errorMessage in
                guard let self = self else { return }
                if !errorMessage.isEmpty {
                    AlertUtils.showErrorAlert(on: self, errorMessage: errorMessage) {}
                }
            }
            .store(in: &cancellables)

        if let game = gameModel {
            let favoriteModel = FavoriteDomainModel(
                id: game.id,
                title: game.title,
                rating: game.rating,
                releaseDate: game.releaseDate,
                imageUrl: game.imageUrl
            )
            presenter.getData(request: ["delete": favoriteModel])
        }
    }

    private func checkIsAlreadyFavorite() {
        let favoriteUseCase: Interactor<
            Any,
            Bool,
            SetFavoriteRepository<
                FavoriteLocaleDataSource,
                FavoriteRemoteDataSource,
                FavoriteTransformer
            >
        > = Injection.init().provideSetFavorite()
        let presenter = GetDataPresenter(useCase: favoriteUseCase)

        // Observe data changes
        presenter.$data
            .sink { [weak self] isFavoriteResult in
                if let isFavorite = isFavoriteResult {
                    self?.isFavorite = isFavorite
                    self?.favoriteButton.image = UIImage(systemName: (isFavorite ? "heart.fill" : "heart"))
                }
            }
            .store(in: &cancellables)

        // Observe errorMessage changes
        presenter.$errorMessage
            .sink { [weak self] errorMessage in
                guard let self = self else { return }
                if !errorMessage.isEmpty {
                    AlertUtils.showErrorAlert(on: self, errorMessage: errorMessage) {}
                }
            }
            .store(in: &cancellables)

        if let game = gameModel {
            let favoriteModel = FavoriteDomainModel(
                id: game.id,
                title: game.title,
                rating: game.rating,
                releaseDate: game.releaseDate,
                imageUrl: game.imageUrl
            )
            presenter.getData(request: ["isExist": favoriteModel])
        }
    }

    private func getGameDetail(id: Int) {
        let gamesUseCase: Interactor<
            Any,
            GameDetailDomainModel,
            GetGameDetailRepository<
                GetGameDetailLocaleDataSource,
                GetGameDetailRemoteDataSource,
                GameDetailTransformer
            >
        > = Injection.init().provideGameDetail(id: id)
        let presenter = GetDataPresenter(useCase: gamesUseCase)

        // Observe gameDetail changes
        presenter.$data
            .sink { [weak self] game in
                self?.bindData(gameDetailModel: game)
            }
            .store(in: &cancellables)

        // Observe loadingState changes
        presenter.$isLoading
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.loadingIndicator.isHidden = false
                    self?.loadingIndicator.startAnimating()
                    self?.view.setTemplateWithSubviews(true, viewBackgroundColor: .gray)
                } else {
                    self?.view.setTemplateWithSubviews(false)
                }
            }
            .store(in: &cancellables)

        // Observe errorMessage changes
        presenter.$errorMessage
            .sink { [weak self] errorMessage in
                guard let self = self else { return }
                if !errorMessage.isEmpty {
                    AlertUtils.showErrorAlert(on: self, errorMessage: errorMessage) {
                        self.getGameDetail(id: id)
                    }
                }
            }
            .store(in: &cancellables)

        presenter.getData(request: id)
    }

    private func setupView() {
        smallGameImage.layer.masksToBounds = false
        smallGameImage.layer.cornerRadius = 8
        smallGameImage.clipsToBounds = true

        gameImage.layer.masksToBounds = false
        gameImage.layer.cornerRadius = 16
        gameImage.clipsToBounds = true

        imageOverlayView.layer.masksToBounds = false
        imageOverlayView.layer.cornerRadius = 16
        imageOverlayView.clipsToBounds = true
    }

    private func bindData(gameDetailModel: GameDetailDomainModel?) {
        if let game = gameDetailModel {
            gameTitleLabel.text = game.title
            gamePublisherLabel.text = game.publisher
            gamePlatformLabel.text = game.platform
            gameRatingLabel.text = "\(game.rating)/5"
            gameReleaseDateLabel.text = game.releaseDate
            gameEsrbRatingLabel.text = game.esrbRating
            gameDescriptionLabel.text = game.description

            smallGameImage.kf.setImage(with: URL(string: game.imageUrl))

            gameImage.kf.setImage(
                with: URL(string: game.imageAdditionalUrl),
                completionHandler: { _ in
                    self.loadingIndicator.stopAnimating()
                    self.loadingIndicator.isHidden = true
                }
            )
        }
    }
}
