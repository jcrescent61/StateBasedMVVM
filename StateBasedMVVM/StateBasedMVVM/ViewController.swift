//
//  ViewController.swift
//  StateBasedMVVM
//
//  Created by Ellen J on 2022/11/27.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
    
    private let viewModel = ViewModel()
    private let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        
        viewModel.mutate(action: .onViewDidLoad)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.mutate(action: .onViewWillAppear)
    }
    
    private func bind() {
        
        viewModel.state
            .map { state -> String? in
                guard case .log(let message) = state else {
                    return nil
                }
                return message
            }.subscribe(onNext: { message in
                guard let message = message else {
                    return
                }
                print("\(message)")
            }).disposed(by: bag)
        
        viewModel.state
            .filter { $0 == .request }
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
//                self.indicator.start()
            }).disposed(by: bag)
        
        viewModel.state
            .filter { $0 == .complete }
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
//                self.collectionView.realodData()
//                self.indicator.stop()
            }).disposed(by: bag)
        
        viewModel.state
            .map { state -> Error in
                guard case .error(let error) = state else {
                    return CommonError.optionalChaingFailed
                }
                return error
            }
            .subscribe(onNext: { [weak self] error in
                guard let self = self else { return }
                self.errorHandler(error)
            }).disposed(by: bag)
    }
    
    private func errorHandler(_ error: Error) {
//        let alert = UIAlertController
    }

}

