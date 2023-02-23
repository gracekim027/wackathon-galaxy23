//
//  EmojiTextField.swift
//  Emotilt
//
//  Created by 최유림 on 2023/02/24.
//

import UIKit
import SwiftUI

struct EmojiTextField: UIViewRepresentable {
    let placeholder: String
    @Binding var text: String
    
    func makeUIView(context: Context) -> UIEmojiTextField {
        let textField = UIEmojiTextField()
        textField.placeholder = placeholder
        textField.font = .systemFont(ofSize: 168)
        textField.textAlignment = .center
        return textField
    }
    
    func updateUIView(_ uiView: UIEmojiTextField, context: Context) {

    }
}

extension EmojiTextField {
    class UIEmojiTextField: UITextField {
        override var textInputMode: UITextInputMode? {
            for mode in UITextInputMode.activeInputModes {
                if mode.primaryLanguage == "emoji" {
                    return mode
                }
            }
            return nil
        }
    }
}
