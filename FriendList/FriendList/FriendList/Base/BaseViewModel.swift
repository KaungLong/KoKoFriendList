import RxSwift
import RxRelay
import UIKit

class BaseViewModel {
    let disposeBag = DisposeBag()

    let errorRelay = PublishRelay<String>()
    
    func handleError(_ error: Error, context: String) {
        let errorMessage = "Error in \(context): \(error.localizedDescription)"
        print(errorMessage)
        errorRelay.accept(errorMessage)
    }
}

protocol BaseViewModelProtocol {
    associatedtype ViewModelType
    var viewModel: ViewModelType! { get set }
}
