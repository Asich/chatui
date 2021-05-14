//
//  ChatViewController.swift
//  DMVNO
//
//  Created by User on 18.03.2021.
//  Copyright © 2021 VEON. All rights reserved.
//

import Foundation
import UIKit
import MessageKit
import InputBarAccessoryView

public class ChatViewController: MessagesViewController, ChatViewProtocol {

    public var presenter: ChatPresenterMessageDataSourceProtocol?
    public var configuration: ChatViewConfigurationProtocol?
    lazy var navigationTitleView = LoadingNavigationTitleView(title: configuration?.navigationTitleLoadingText)
    lazy var imagePicker = UIImagePickerController()
    lazy var messagesLoadingIndicator = UIActivityIndicatorView(style: .gray)
    
    lazy var emptyView: UILabel = {
       let label = UILabel()
        label.text = configuration?.emptyViewText
        label.textAlignment = .center
        label.textColor = .gray
        return label
    }()
    
    lazy var closeButtonIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = UIColor.systemBlue
        return activityIndicator
    }()

    public init(configuration: ChatViewConfigurationProtocol) {
        super.init(nibName: nil, bundle: nil)
        self.configuration = configuration
        NotificationCenter.default.addObserver(self,
            selector: #selector(didEnterForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil)
    }

    @objc func didEnterForeground() {
        if #available(iOS 13, *) {
            print("not invalidating")
        } else {
            DispatchQueue.main.async { [weak self] in
                self?.messagesCollectionView.reloadData()
                self?.messagesCollectionView.messagesCollectionViewFlowLayout.invalidateLayout()
            }
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewWillAppear()
        messageInputBar.delegate = self
        tabBarController?.tabBar.isHidden = true
    }

    public override func willMove(toParent parent: UIViewController?) {
        tabBarController?.tabBar.isHidden = false
    }

    public override func viewDidLoad() {
        let layout = ChatBotActionMessagesFlowLayout()
        messagesCollectionView = MessagesCollectionView(frame: .zero, collectionViewLayout: layout)
        messagesCollectionView.messagesCollectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        super.viewDidLoad()
        messagesCollectionView.backgroundView = emptyView
        messagesCollectionView.backgroundColor = configuration?.backgroundColor
        messagesCollectionView.contentInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8) // this property causes harmless but annoying logs in console, comment this line on development process
        messagesCollectionView.isPrefetchingEnabled = false
        navigationItem.titleView = navigationTitleView
        presenter?.viewDidLoad()
        configureMessageInputBar()
        configureMessagesCollectionView()
        hideOutgoingMessageAvatarView()
        registerCells()
        setupLoadingView()
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        becomeFirstResponder()
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
        presenter?.viewWillDisappear()
    }

    func registerCells() {
        messagesCollectionView.register(ChatBotActionCollectionViewCell.self)
        messagesCollectionView.register(MessageDateReusableView.nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "MessageDateReusableViewModel")
        messagesCollectionView.register(MessageButtonFooterView.nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: MessageButtonFooterView.classIdentifierName)
    }

    private func setupLoadingView() {
        messagesCollectionView.alpha = 0
        messageInputBar.alpha = 0
        view.addSubview(messagesLoadingIndicator)
        messagesLoadingIndicator.startAnimating()
        messagesLoadingIndicator.snp.makeConstraints { $0.center.equalToSuperview() }
    }

    func hideLoadingView() {
        messagesLoadingIndicator.stopAnimating()
        messagesLoadingIndicator.isHidden = true
        UIView.animate(withDuration: 0.5) {
            self.messagesCollectionView.alpha = 1
            self.messageInputBar.alpha = 1
        }
    }

    func hideEmptyView() {
        messagesCollectionView.backgroundView = nil
    }

    /// This function is called when chat messages are loaded for the first time and all cells are reloaded
    public func chatDidLoad() {
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 1) {
            DispatchQueue.main.async {
                self.messagesCollectionView.reloadData()
                self.messagesCollectionView.scrollToBottom(animated: true)
                self.hideLoadingView()
            }
        }
    }

    /// This function is called when user sends message and only visible cells are reloaded
    public func reloadUI() {
        DispatchQueue.main.async {
            self.messagesCollectionView.reloadData()
            self.scrollToBottom(animated: true)
        }
    }

    public func scrollToBottom(animated: Bool = false) {
        let lastSection = messagesCollectionView.numberOfSections - 1
        let lastItem = numberOfItems(inSection: lastSection, in: messagesCollectionView) - 1
        messagesCollectionView.scrollToItem(at: IndexPath(item: lastItem, section: lastSection), at: .centeredVertically, animated: animated)
    }

    public func showActivityIndicator() {
        if navigationItem.titleView == nil {
            navigationItem.titleView = navigationTitleView
        }
    }
    
    public func hideActivityIndicator() {
        navigationItem.titleView = nil
        navigationItem.title = configuration?.navigationTitleText
    }

    deinit {
        presenter?.viewWillDeinit()
        print("CHAT DEINIT")
    }

    override open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let messagesDataSource = messagesCollectionView.messagesDataSource else { fatalError("Ouch. nil data source for messages") }

        let message = messagesDataSource.messageForItem(at: indexPath, in: messagesCollectionView)

        guard case .custom = message.kind else { return super.collectionView(collectionView, cellForItemAt: indexPath) }
        let cell = messagesCollectionView.dequeueReusableCell(ChatBotActionCollectionViewCell.self, for: indexPath)
        cell.configure(with: message, at: indexPath, and: messagesCollectionView, cellConfiguration: configuration?.cellConfiguration)
        return cell
    }

    public func showEndChatButton() {
        if self.navigationItem.rightBarButtonItem == nil {
            let endChatButtonItem = UIBarButtonItem(title: configuration?.navigationButtonText, style: .done, target: self, action: #selector(endChatButtonPressed))
            self.navigationItem.rightBarButtonItem = endChatButtonItem
        }
    }

    public func showEndingChatLoader() {
        hideEndChatButton()
        closeButtonIndicator.startAnimating()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: closeButtonIndicator)
    }

    public func hideEndChatButton() {
        closeButtonIndicator.stopAnimating()
        self.navigationItem.rightBarButtonItem = nil
    }

    @objc private func endChatButtonPressed() {
        showEndingChatLoader()
        presenter?.closeOperatorConnectionPressed()
    }

    func setAttachButton() {
        let attachItem = InputBarButtonItem(type: .system)
        attachItem.image = UIImage(nameInModule: "attach_icon")
        attachItem.setSize(CGSize(width: 36, height: 36), animated: false)
        attachItem.addTarget(self, action: #selector(attachItemPressed), for: .touchUpInside)
        messageInputBar.setStackViewItems([attachItem], forStack: .left, animated: true)
    }

    public func showAttachButton() {
        messageInputBar.setLeftStackViewWidthConstant(to: 38, animated: true)
    }

    public func hideAttachButton() {
        messageInputBar.setLeftStackViewWidthConstant(to: 0, animated: true)
    }

    @objc func attachItemPressed() {
        imagePicker.modalPresentationStyle = .popover
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
}

extension ChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    public func imagePickerController(_: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        dismiss(animated: true, completion: nil)
        presenter?.imageDidPick(image: image)
    }

    public func imagePickerControllerDidCancel(_: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

}

extension ChatViewController: ChatBotActionDelegate {
    func actionDidPress(sender: UIButton) {
        guard let button = sender as? ChatBotActionButton else { return }
        guard let url = button.viewModel.url else {
            presenter?.actionButtonWasPressed(viewModel: button.viewModel)
            return
        }
        presenter?.handleDeeplink(url: url)
    }
}

extension ChatViewController {
    public func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}
