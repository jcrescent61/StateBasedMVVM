//
//  ViewModel.swift
//  StateBasedMVVM
//
//  Created by Ellen J on 2022/11/27.
//

import Foundation
import RxSwift
import RxRelay

protocol ViewModelStateable {
    
    associatedtype State
    associatedtype Action
    
    func mutate(action: Action)
}

class ViewModel: NSObject, ViewModelStateable {

    typealias State = ViewModelState
    typealias Action = ViewModelAction
    
    public private(set) var state = PublishRelay<State>()
    
    enum ViewModelState: Equatable {
        
        case request
        case complete
        case error(Error)
        
        case log(meesage: String)
        
        private var equatableValue: String {
            switch self {
            case .request: return "request"
            case .complete: return "complete"
            case .error: return "error"
            case .log: return "log"
            }
        }
        
        static func == (lhs: ViewModel.ViewModelState, rhs: ViewModel.ViewModelState) -> Bool {
            return lhs.equatableValue == rhs.equatableValue
        }
    }
    
    enum ViewModelAction {
        case onViewDidLoad
        case onViewWillAppear
    }
    
    func mutate(action: ViewModelAction) {
        switch action {
        case .onViewDidLoad:
            self.state.accept(.request)
            
            request()
            
        case .onViewWillAppear:
            self.state.accept(.log(meesage: "Print log"))
        }
    }

    
    private func request() {}
}
