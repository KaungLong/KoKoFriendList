import UIKit
import SnapKit

class MainTestControlView: UIViewController {
    
    private let pickerView = UIPickerView()
    private let label = UILabel()
    private let startTestButton = UIButton()
    private let testModes = TestClient.TestMode.allCases

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "測試模式選擇"
        view.backgroundColor = .white
        setupUI()
        setupPickerView()
    }

    private func setupUI() {
        label.text = "選擇測試模式："
        label.font = .boldSystemFont(ofSize: 16)
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(pickerView)
        pickerView.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(150)
        }
        
        startTestButton.setTitle("測試開始", for: .normal)
        startTestButton.setTitleColor(.white, for: .normal)
        startTestButton.backgroundColor = .systemBlue
        startTestButton.layer.cornerRadius = 8
        startTestButton.addTarget(self, action: #selector(startTestButtonTapped), for: .touchUpInside)
        view.addSubview(startTestButton)
        startTestButton.snp.makeConstraints { make in
            make.top.equalTo(pickerView.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(50)
        }
    }

    private func setupPickerView() {
        pickerView.delegate = self
        pickerView.dataSource = self

        if let selectedIndex = testModes.firstIndex(of: TestClient.shared.testMode) {
            pickerView.selectRow(selectedIndex, inComponent: 0, animated: false)
        }
    }

    @objc private func startTestButtonTapped() {
        let tabBarController = MainTabBarController()
        navigationController?.pushViewController(tabBarController, animated: true)
    }
}

extension MainTestControlView: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return testModes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return testModes[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        TestClient.shared.testMode = testModes[row]
        print("選擇的測試模式：\(testModes[row].rawValue)")
    }
}
