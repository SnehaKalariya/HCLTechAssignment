//
//  ViewModifier.swift
//  GarmentManager
//
//  Created by Sneha Kalariya on 2024-03-21.
//

import Foundation
import SwiftUI

struct BlackBoldText : ViewModifier {
    func body(content: Content) -> some View {
        content
            .fontWeight(.bold)
            .foregroundColor(.black)
            .font(.system(size: 18))
    }
}

struct BlackTitleText : ViewModifier{
    func body(content: Content) -> some View {
        content
            .fontWeight(.light)
            .foregroundColor(.black)
            .font(.system(size: 14))
    }
}
