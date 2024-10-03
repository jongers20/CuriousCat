//
//  ViewController.swift
//  CuriousCats
//
//  Created by Erika Ypil on 10/1/24.
//

import UIKit
import Combine

class HomeSreenViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var shimmerView: ShimmerView!
    @IBOutlet weak var pageIndicatorLabel: UILabel!
    private var viewModel: HomeScreenViewModel!
    private var cancellables = Set<AnyCancellable>() //For resouce management
    //jong
    var currentLoadingTask: Task<Void, Never>?
    var isLoadingImage: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel = HomeScreenViewModel()
        self.setupGesture()
        self.subscribe()
        
        self.callFetchData()
        
        viewModel.onFetchDataRequested = { [weak self] in
            self?.callFetchData()
        }
    }
    
    func callFetchData(){
        Task {
            self.shimmer()
            await viewModel.fetchData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func setupGesture() {
        let tapGest = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        view.addGestureRecognizer(tapGest)
    }
    
    func subscribe() {
        viewModel.$factsArr
            .receive(on: DispatchQueue.main)
            .sink { [weak self] description in
                guard let self = self,
                      let factsArr = description else { return }
                self.descriptionLabel.text = factsArr.first
            }
            .store(in: &cancellables)
        
        viewModel.$image
            .receive(on: DispatchQueue.main)
            .sink { [weak self] img in
                self?.shimmerView.isHidden = true
                self?.imageView.image = img
            }
            .store(in: &cancellables)
        
        viewModel.$currentIndex
            .receive(on: DispatchQueue.main)
            .sink { [weak self] index in
                self?.refreshUI()
            }
            .store(in: &cancellables)
    }
    
    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        let tapLocation = gesture.location(in: view)
        let screenWidth = view.bounds.width
        
        viewModel.handleTap(at: tapLocation, in: screenWidth)
    }
    
    func shimmer() {
        shimmerView.isHidden = false
        shimmerView.startShimmering()
    }
    
    func refreshUI() {
        self.shimmer()
        
        guard let factsArr = viewModel.factsArr else { return }
        
        if viewModel.currentIndex < factsArr.count {
            descriptionLabel.text = factsArr[viewModel.currentIndex]
            pageIndicatorLabel.text = String("\(viewModel.currentIndex + 1)")
        }

        currentLoadingTask?.cancel()
        
        if isLoadingImage {
            return
        }

        isLoadingImage = true
        currentLoadingTask = Task {
            do {
                let image = try await viewModel.loadIndexImage()

                if Task.isCancelled {
                    isLoadingImage = false
                    return
                }
                DispatchQueue.main.async {
                    if !self.viewModel.isNewPage() {
                        self.shimmerView.isHidden = true
                        self.shimmerView.stopShimmering()
                        self.imageView.image = image
                    }
                    self.isLoadingImage = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.shimmer()
                    self.isLoadingImage = false
                    self.refreshUI()
                }
                print("Error loading image: \(error)")
            }
        }
    }
    
//    func refreshUI() {
//        
//        shimmerView.isHidden = false
//        shimmerView.startShimmering()
//        
//        guard let factsArr = viewModel.factsArr else { return }
//        
//        if viewModel.currentIndex < factsArr.count {
//            descriptionLabel.text = factsArr[viewModel.currentIndex]
//        }
//        
//        titleLabel.text = viewModel.breed
//        
//        Task {
//            do {
//                let image = try await viewModel.loadIndexImage()
//                DispatchQueue.main.async {
//                    self.shimmerView.isHidden = true
//                    self.shimmerView.stopShimmering()
//                    self.imageView.image = image
//                }
//            } catch {
//                DispatchQueue.main.async {
//                    self.shimmerView.isHidden = true
//                }
//                print("Error loading image: \(error)")
//            }
//        }
//    }
}

