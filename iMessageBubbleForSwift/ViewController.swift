//
//  ViewController.swift
//  iMessageBubbleForSwift
//
//  Created by Mirac Okan on 2.07.2018.
//  Copyright © 2018 Mirac Okan. All rights reserved.
//

import UIKit
class ViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var chatTable: UITableView!
    @IBOutlet var contentView: ContentView!
    @IBOutlet var chatTextView: UITextView!
    @IBOutlet var chatTextViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var contentViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var contentViewBottomConstraint: NSLayoutConstraint!
    var chatCell: ChatTableViewCell?
    var handler: ContentView?
    private var currentMessages = NSMutableArray()
    private var chatCellSettings: ChatCellSettings?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chatCellSettings = ChatCellSettings.getInstance()
        chatCellSettings?.setSenderBubbleColorHex("007AFF")
        chatCellSettings?.setReceiverBubbleColorHex("DFDEE5")
        chatCellSettings?.setSenderBubbleNameTextColorHex("FFFFFF")
        chatCellSettings?.setReceiverBubbleNameTextColorHex("000000")
        chatCellSettings?.setSenderBubbleMessageTextColorHex("FFFFFF")
        chatCellSettings?.setReceiverBubbleMessageTextColorHex("000000")
        chatCellSettings?.setSenderBubbleTimeTextColorHex("FFFFFF")
        chatCellSettings?.setReceiverBubbleTimeTextColorHex("000000")
        chatCellSettings?.setSenderBubbleFontWithSizeForName(UIFont.boldSystemFont(ofSize: 11))
        chatCellSettings?.setReceiverBubbleFontWithSizeForName(UIFont.boldSystemFont(ofSize: 11))
        chatCellSettings?.setSenderBubbleFontWithSizeForMessage(UIFont.systemFont(ofSize: 14))
        chatCellSettings?.setReceiverBubbleFontWithSizeForMessage(UIFont.systemFont(ofSize: 14))
        chatCellSettings?.setSenderBubbleFontWithSizeForTime(UIFont.systemFont(ofSize: 11))
        chatCellSettings?.setReceiverBubbleFontWithSizeForTime(UIFont.systemFont(ofSize: 11))

        
        chatCellSettings?.senderBubbleTailRequired(true)
        chatCellSettings?.receiverBubbleTailRequired(true)
        navigationItem.title = "Mesaj Demo Swift"
        chatTable.separatorStyle = .none
        /*Uncomment second para and comment first to use XIB instead of code*/
        //Registering custom Chat table view cell for both sending and receiving
        chatTable.register(ChatTableViewCell.self, forCellReuseIdentifier: "chatSend")
        chatTable.register(ChatTableViewCell.self, forCellReuseIdentifier: "chatReceive")
        //Instantiating custom view that adjusts itself to keyboard show/hide
        handler = ContentView(textView: chatTextView, chatTextViewHeightConstraint: chatTextViewHeightConstraint, contentView: contentView, contentViewHeightConstraint: contentViewHeightConstraint, andContentViewBottomConstraint: contentViewBottomConstraint)
        //Setting the minimum and maximum number of lines for the textview vertical expansion
        handler?.updateMinimumNumber(ofLines: 1, andMaximumNumberOfLine: 3)
        
        //Tap gesture on table view so that when someone taps on it, the keyboard is hidden
//        let gestureRecognizer = UITapGestureRecognizer(target: self, action: Selector(dismisskeyboard))
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        chatTable.addGestureRecognizer(gestureRecognizer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func dismissKeyboard() {
        chatTextView.resignFirstResponder()
    }
    
    @IBAction func sendMessage(_ sender: Any) {
        if (chatTextView.text).count != 0 {
            var sendMessage: iMessage?
//            sendMessage = iMessage.initIMessage(withName: nil, message: chatTextView.text, time: "23:14", type: "self")
            sendMessage = iMessage.init(withName: "Ben", message: chatTextView.text, time: "23:14", type: "self")
            
            updateTableView(sendMessage)
        }
    }
    
    @IBAction func receiveMessage(_ sender: Any) {
        if (chatTextView.text).count != 0 {
            var receiveMessage: iMessage?
//            receiveMessage = iMessage.initIMessage(withName: nil, message: chatTextView.text, time: "23:14", type: "other")
            receiveMessage = iMessage.init(withName: "Sen", message: chatTextView.text, time: "23:14", type: "other")
            updateTableView(receiveMessage)
        }
    }
    
    func updateTableView(_ msg: iMessage?) {
        (chatTextView).text = ""
        handler?.textViewDidChange(chatTextView)
        chatTable.beginUpdates()
        let row1 = IndexPath(row: currentMessages.count, section: 0)
        if let aMsg = msg {
            currentMessages.insert(aMsg, at: currentMessages.count)
        }
        chatTable.insertRows(at: [row1], with: .bottom)
        chatTable.endUpdates()
        //Always scroll the chat table when the user sends the message
        if chatTable.numberOfRows(inSection: 0) != 0 {
            let ip = IndexPath(row: chatTable.numberOfRows(inSection: 0) - 1, section: 0)
//            chatTable.scrollToRow(at: ip, at: .bottom, animated: .left) eskisi bu
            chatTable.scrollToRow(at: ip, at: .bottom, animated: true)
        }
    }
    
    
//#pragma mark - UITableViewDatasource methods
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message: iMessage? = currentMessages[indexPath.row] as? iMessage
        if (message?.messageType == "self") {
            /*Uncomment second line and comment first to use XIB instead of code*/
            chatCell = tableView.dequeueReusableCell(withIdentifier: "chatSend") as? ChatTableViewCell
            //chatCell = (ChatTableViewCellXIB *)[tableView dequeueReusableCellWithIdentifier:@"chatSend"];
            chatCell?.chatMessageLabel.text = message?.userMessage
            chatCell?.chatNameLabel.text = message?.userName
            chatCell?.chatTimeLabel.text = message?.userTime
            chatCell?.chatUserImage.image = UIImage(named: "defaultUser")
            /*Comment this line is you are using XIB*/
//            chatCell?.authorType : ChatTableViewCell = iMessageBubbleTableViewCellAuthorTypeSender
            chatCell?.authorType = AuthorType.iMessageBubbleTableViewCellAuthorTypeSender
//            chatCell?.authorType = ChatTableViewCell.
            
        } else {
            /*Uncomment second line and comment first to use XIB instead of code*/
            chatCell = tableView.dequeueReusableCell(withIdentifier: "chatReceive") as? ChatTableViewCell
            //chatCell = (ChatTableViewCellXIB *)[tableView dequeueReusableCellWithIdentifier:@"chatReceive"];
            chatCell?.chatMessageLabel.text = message?.userMessage
            chatCell?.chatNameLabel.text = message?.userName
            chatCell?.chatTimeLabel.text = message?.userTime
            chatCell?.chatUserImage.image = UIImage(named: "defaultUser")
            /*Comment this line is you are using XIB*/
            chatCell?.authorType = AuthorType.iMessageBubbleTableViewCellAuthorTypeReceiver
        }
        return chatCell!
    }
    

    

    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let message: iMessage? = currentMessages[indexPath.row] as? iMessage
        var size            = CGSize()
        var Namesize        = CGSize()
        var Timesize        = CGSize()
        var Messagesize     = CGSize()
        var fontArray = [Any]()
        //Get the chal cell font settings. This is to correctly find out the height of each of the cell according to the text written in those cells which change according to their fonts and sizes.
        //If you want to keep the same font sizes for both sender and receiver cells then remove this code and manually enter the font name with size in Namesize, Messagesize and Timesize.
        if (message?.messageType == "self") {
            fontArray = (chatCellSettings?.senderBubbleFontWithSize)!
//            fontArray = chatCellSettings?.getSenderBubbleFontWithSize
            
        } else {
            fontArray = (chatCellSettings?.receiverBubbleFontWithSize)!
//            fontArray = chatCellSettings?.getReceiverBubbleFontWithSize
        }
        //Find the required cell height
        Namesize = "Name".boundingRect(with: CGSize(width: 220.0, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: [kCTFontAttributeName as NSAttributedStringKey: fontArray[0]], context: nil).size
        Messagesize = message?.userMessage.boundingRect(with: CGSize(width: 220.0, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: [kCTFontAttributeName as NSAttributedStringKey: fontArray[1]], context: nil).size ?? CGSize.zero
        Timesize = "Time".boundingRect(with: CGSize(width: 220.0, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: [kCTFontAttributeName as NSAttributedStringKey: fontArray[2]], context: nil).size
        size.height = (Messagesize.height + Namesize.height + Timesize.height + 48.0)
        
//        size.height = 48.0
        return size.height
    }
    
    
    

}


class iMessage: NSObject {
    var userName = ""
    var userMessage = ""
    var userTime = ""
    var messageType = ""
    
     init (withName name: String?, message: String?, time: String?, type: String?) {
        super.init()
        initIMessage(withName: name, message: message, time: time, type: type)
    }
    
    
    
    func initIMessage(withName name: String?, message: String?, time: String?, type: String?) -> iMessage {
//        super.init()

        userName = name!
        userMessage = message!
        userTime = time!
        messageType = type!

        return self
    }
}

