//
//  PhotoDetailViewController.swift
//  PhotoGallery
//
//  Created by Bakar Kharabadze on 5/8/24.
//
import UIKit

final class PhotoDetailViewController: UIViewController, UIScrollViewDelegate {
    
    //MARK: Properties
    var scrollView: UIScrollView!
    var imageView: UIImageView!
    var photos: [Photo] = []
    var currentIndex: Int = 0
    var pageLabel: UILabel!
    let viewModel = PhotoDetailViewModel()
    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.photos = photos
        viewModel.currentIndex = currentIndex
        viewModel.onPhotoLoaded = { [weak self] in
            self?.showPhoto()
        }
        view.backgroundColor = .systemBackground
        setupScrollView()
        setupGestures()
        setupPageLabel()
        showPhoto()
    }
    
    //MARK: SetupUI
    private func setupPageLabel() {
        pageLabel = UILabel()
        pageLabel.translatesAutoresizingMaskIntoConstraints = false
        pageLabel.textAlignment = .center
        pageLabel.textColor = .black
        pageLabel.backgroundColor = UIColor(white: 0, alpha: 0.7)
        pageLabel.layer.cornerRadius = 10
        pageLabel.clipsToBounds = true
        view.addSubview(pageLabel)
        
        NSLayoutConstraint.activate([
            pageLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            pageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageLabel.widthAnchor.constraint(equalToConstant: 80),
            pageLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func setupScrollView() {
        scrollView = UIScrollView(frame: view.bounds)
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 5.0
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.isPagingEnabled = true
        view.addSubview(scrollView)
        
        imageView = UIImageView(frame: scrollView.bounds)
        imageView.contentMode = .scaleAspectFit
        scrollView.addSubview(imageView)
    }
    
    private func setupGestures() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
        
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        imageView.addGestureRecognizer(doubleTapGesture)
        imageView.isUserInteractionEnabled = true
    }
    
    @objc func handleDoubleTap(_ gesture: UITapGestureRecognizer) {
        if scrollView.zoomScale == 1 {
            let tapLocation = gesture.location(in: imageView)
            let newZoomScale = scrollView.maximumZoomScale
            let size = CGSize(width: scrollView.frame.width / newZoomScale,
                              height: scrollView.frame.height / newZoomScale)
            let origin = CGPoint(x: tapLocation.x - size.width / 2,
                                 y: tapLocation.y - size.height / 2)
            scrollView.zoom(to: CGRect(origin: origin, size: size), animated: true)
        } else {
            scrollView.setZoomScale(1, animated: true)
        }
    }
    
    @objc func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .right {
            showPreviousPhoto()
        } else if gesture.direction == .left {
            showNextPhoto()
        }
    }
    
    func showPhoto() {
        if let photoData = viewModel.photoData {
            DispatchQueue.main.async {
                self.imageView.image = UIImage(data: photoData)
                self.scrollView.contentSize = self.imageView.bounds.size
                self.updatePageLabel()
            }
        }
    }
    
    private func updatePageLabel() {
        pageLabel.text = "\(viewModel.currentIndex + 1) / \(viewModel.photos.count)"
    }
    
    private func showPreviousPhoto() {
        viewModel.showPreviousPhoto()
    }
    
    private func showNextPhoto() {
        viewModel.showNextPhoto()
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
