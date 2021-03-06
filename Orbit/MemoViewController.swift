//
//  MemoViewController.swift
//  Orbit
//
//  Created by ilhan won on 03/01/2019.
//  Copyright © 2019 orbit. All rights reserved.
//

import UIKit
import RealmSwift

protocol DismissDelegate : class {
    func dismissBackGroundView(isSaving : Bool)
}

class MemoViewController: UIViewController {
    //MARK: Ream Property
    var realm = try! Realm()
    let realmManager = RealmManager.shared.realm
    
    fileprivate var keyboardShown = false
    weak var dismissDelegate : DismissDelegate!
    
    //UI
    fileprivate var backGroundView : UIView!
    fileprivate var memoView : UIStackView!
    fileprivate var dateStackView : UIStackView!
    var selectedDate : UILabel!
    var memoTextView : UITextView!
    var saveBtnBackView : UIView!
    var saveBtn : UIImageView!
    var cancelBtn : UIImageView!
    fileprivate var baseView : UIView!
    var selectDate : Date!
    var contentsAliment : String = "left"
    
    var memoViewRect : CGRect!
    var updateHeight : NSLayoutConstraint!
    fileprivate var transY : CGFloat!
    var createAt : Date!
    fileprivate var type : String = "memo"
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        self.view.insetsLayoutMarginsFromSafeArea = false
        self.view.directionalLayoutMargins = NSDirectionalEdgeInsets.init(top: 0, leading: 0, bottom: 0, trailing: 0)
        //        self.view.layoutMargins = UIEdgeInsets(top: self.view.layoutMargins.top, left: 0, bottom: self.view.layoutMargins.bottom, right: 0)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        registerForKeyboardNotification()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        unregisterForKeyboardNotification()
    }
    
    override func viewWillLayoutSubviews() {
        if baseView == nil {
            setUI()
            selectedDate.text = "  \(dateToString(in: selectDate, dateFormat: "yyyy.MM.dd eee"))"
        }
    }
}

extension MemoViewController {
    @objc func dismissMemoView() {
        
        if memoTextView.text == "" || memoTextView.text == nil {
            dismiss(animated: true) {
                self.dismissDelegate.dismissBackGroundView(isSaving: false)
            }
        } else {
            showAlert(title: "잠 깐!", message: "메모한 내용이 저장되지 않습니다. \n 메모장을 닫을까요?", actionStyle: .cancel, cancelBtn: true, buttonTitle: "확인", onView: self) { (_) in
                self.dismiss(animated: true, completion: {
                    self.dismissDelegate.dismissBackGroundView(isSaving: false)
                })
            }
        }
    }
    
    @objc func saveMemo() {
        if memoTextView.text == "" || memoTextView.text == nil {
            showAlert(title: "잠 깐!", message: "메모내용이 없습니다. \n 이대로 메모장을 닫을까요?", actionStyle: .cancel, cancelBtn: true, buttonTitle: "확인", onView: self) { (_) in
                self.dismiss(animated: true, completion: {
                    self.dismissDelegate.dismissBackGroundView(isSaving: true)
                })
            }
        } else {
            let stringDate = dateToString(in: selectDate, dateFormat: "dd MMM yyyy hh mm")
            print(stringDate)
            createAt = stringToDate(in: stringDate, dateFormat: "dd MMM yyyy hh mm")
            let createAtMonth = dateToString(in: createAt, dateFormat: "MMM yyyy")
            let contents = memoTextView.text
            let data = Content(type : type, createdAt: createAt, createdAtMonth: createAtMonth,
                               title: "", weather: "", body: contents!, contentsAlignment: self.contentsAliment,image: nil)
            RealmManager.shared.creat(object: data)
            self.dismiss(animated: true, completion: nil)
            self.dismissDelegate.dismissBackGroundView(isSaving: true)
        }
    }
}

//MARK: UI
extension  MemoViewController {
    private func setUI() {
        //        let width = self.view.frame.size.width
        //        let height = self.view.frame.size.height
        //        let keyboardHeight
        
        backGroundView = UIView()
        memoView = UIStackView()
        selectedDate = UILabel()
        cancelBtn = UIImageView()
        dateStackView = UIStackView()
        memoTextView = UITextView()
        saveBtn = UIImageView()
        baseView = UIView()
        saveBtnBackView = UIView()
        
        backGroundView.translatesAutoresizingMaskIntoConstraints = false
        baseView.translatesAutoresizingMaskIntoConstraints = false
        memoView.translatesAutoresizingMaskIntoConstraints = false
        dateStackView.translatesAutoresizingMaskIntoConstraints = false
        selectedDate.translatesAutoresizingMaskIntoConstraints = false
        cancelBtn.translatesAutoresizingMaskIntoConstraints = false
        memoTextView.translatesAutoresizingMaskIntoConstraints = false
        saveBtnBackView.translatesAutoresizingMaskIntoConstraints = false
        saveBtn.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(backGroundView)
        backGroundView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        backGroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        backGroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        backGroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        backGroundView.backgroundColor = .clear
        
        view.addSubview(baseView)
        baseView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        baseView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        baseView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        baseView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        baseView.backgroundColor = .clear
        //        baseView.alpha = 0.3
        
        view.addSubview(memoView)
        let screenHeight = UIScreen.main.bounds.height
        switch screenHeight {
        case ...568 :
            memoView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75, constant: 0).isActive = true
            memoView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.52, constant: 0).isActive = true
            memoView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
            memoView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
            self.transY = (view.frame.size.height * 0.18)
        case 569...736 :
            memoView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75, constant: 0).isActive = true
            memoView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.58, constant: 0).isActive = true
            memoView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
            memoView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
            self.transY = (view.frame.size.height * 0.17)
        case 737... :
            memoView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75, constant: 0).isActive = true
            memoView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5, constant: 0).isActive = true
            memoView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
            memoView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
            self.transY = (view.frame.size.height * 0.17)
        default:
            print(screenHeight)
        }
        memoView.tintColor = .gray
        memoView.backgroundColor = .white
        
        view.addSubview(dateStackView)
        dateStackView.widthAnchor.constraint(equalTo: memoView.widthAnchor).isActive = true
        dateStackView.heightAnchor.constraint(equalTo: memoView.heightAnchor, multiplier: 0.1).isActive = true
        
        view.addSubview(selectedDate)
        selectedDate.backgroundColor = UIColor(red: 1, green: 1, blue: 240/255, alpha: 1)
        selectedDate.font = setFont(type: .date, onView: self, font: "NanumBarunGothic", size: 20)
        
        view.addSubview(cancelBtn)
        cancelBtn.widthAnchor.constraint(equalToConstant: 48).isActive = true
        cancelBtn.backgroundColor = UIColor(red: 1, green: 1, blue: 240/255, alpha: 1)
        cancelBtn.image = UIImage(named: "multiply")
        cancelBtn.contentMode = .scaleAspectFit
        cancelBtn.isUserInteractionEnabled = true
        let cancelGesture = UITapGestureRecognizer(target: self, action: #selector(dismissMemoView))
        cancelBtn.addGestureRecognizer(cancelGesture)
        
        view.addSubview(dateStackView)
        dateStackView.addArrangedSubview(selectedDate)
        dateStackView.addArrangedSubview(cancelBtn)
        dateStackView.axis = .horizontal
        dateStackView.alignment = .fill
        
        view.addSubview(memoTextView)
        memoTextView.widthAnchor.constraint(equalTo: memoView.widthAnchor, multiplier: 1).isActive = true
        memoTextView.heightAnchor.constraint(equalTo: memoView.heightAnchor, multiplier: 0.8).isActive = true
        memoTextView.centerXAnchor.constraint(equalTo: memoView.centerXAnchor).isActive = true
        memoTextView.backgroundColor = UIColor(red: 1, green: 1, blue: 240/255, alpha: 1)
        memoTextView.font = UIFont(name: "NanumBarunGothic", size: 16)
        memoTextView.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        memoTextView.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        memoTextView.layer.shadowRadius = 2.0
        memoTextView.layer.shadowOpacity = 1.0
        memoTextView.layer.masksToBounds = false
        memoTextView.layer.shadowPath = UIBezierPath(roundedRect: memoTextView.bounds , cornerRadius: 1).cgPath
        
        view.addSubview(saveBtnBackView)
        saveBtnBackView.widthAnchor.constraint(equalTo: memoView.widthAnchor, multiplier: 1).isActive = true
        saveBtnBackView.heightAnchor.constraint(equalTo: memoView.heightAnchor, multiplier: 0.1).isActive = true
        saveBtnBackView.backgroundColor = UIColor(red: 1, green: 1, blue: 240/255, alpha: 1)
        
        saveBtnBackView.addSubview(saveBtn)
        saveBtn.heightAnchor.constraint(equalTo: saveBtnBackView.heightAnchor, multiplier: 0.8).isActive = true
        saveBtn.widthAnchor.constraint(equalTo: saveBtnBackView.heightAnchor, multiplier: 0.8).isActive = true
        saveBtn.centerXAnchor.constraint(equalTo: saveBtnBackView.centerXAnchor, constant: 1).isActive = true
        saveBtn.centerYAnchor.constraint(equalTo: saveBtnBackView.centerYAnchor, constant: 1).isActive = true
        saveBtn.backgroundColor = .clear
        saveBtn.image = UIImage(named: "post")
        saveBtn.contentMode = .scaleAspectFill
        saveBtn.isUserInteractionEnabled = true
        let saveTapGesture = UITapGestureRecognizer(target: self, action: #selector(saveMemo))
        saveBtn.addGestureRecognizer(saveTapGesture)
        
        
        memoView.addArrangedSubview(dateStackView)
        memoView.addArrangedSubview(memoTextView)
        memoView.addArrangedSubview(saveBtnBackView)
        memoView.axis = .vertical
        memoView.alignment = .fill
        memoView.autoresizesSubviews = true
    }
    
}

extension MemoViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if keyboardShown == true {
            view.endEditing(true)
        }
    }
    
    @objc fileprivate func cleanTextView() {
        memoTextView.text = ""
        memoTextView.textColor = .black
    }
    
    @objc fileprivate func textViewState() {
        if memoTextView.text == "" {
            memoTextView.text = ""
            memoTextView.textColor = UIColor(red: 208/255, green: 207/255, blue: 208/255, alpha: 1)
        }
    }
    
    fileprivate func registerForTextViewNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(cleanTextView),
                                               name: UITextView.textDidBeginEditingNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(textViewState),
                                               name: UITextView.textDidEndEditingNotification, object: nil)
    }
    
    fileprivate func unregisterForTextViewNotification() {
        NotificationCenter.default.removeObserver(self, name: UITextView.textDidBeginEditingNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UITextView.textDidEndEditingNotification, object: nil)
    }
    
    fileprivate func registerForKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillshow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    fileprivate func unregisterForKeyboardNotification() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc fileprivate func keyboardWillshow(notification : Notification) {
        adjustHeight(notification: notification)
    }
    
    @objc fileprivate func keyboardWillHide(notification : Notification) {
        adjustHide(notification: notification)
    }
    
    fileprivate func adjustHeight(notification : Notification) {
        guard let userInfo = notification.userInfo else {return}
        let keyboardFrame : CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        if keyboardFrame.height == 0 || keyboardShown {
            return
        } else {
            keyboardShown = true
            //            let height = (view.frame.size.height - keyboardFrame.height - 10)
            UIStackView.animate(withDuration: 0.5, animations: {
                self.memoView.transform = CGAffineTransform(translationX: 0, y: -(self.transY))
            })
        }
    }
    
    fileprivate func adjustHide(notification : Notification) {
        keyboardShown = false
        UIStackView.animate(withDuration: 0.5) {
            self.memoView.transform = CGAffineTransform(translationX: 0, y: 0)
        }
    }
    
}

