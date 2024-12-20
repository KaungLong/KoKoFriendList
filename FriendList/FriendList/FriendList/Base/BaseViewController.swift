import UIKit
import RxSwift

class BaseViewController<ViewModelType>: UIViewController, BaseViewModelProtocol {
    var viewModel: ViewModelType!
    let disposeBag = DisposeBag()
 
    func observeErrors(from viewModel: BaseViewModel) {
        viewModel.errorRelay
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] errorMessage in
                self?.showError(errorMessage)
            })
            .disposed(by: disposeBag)
    }
    
    func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
