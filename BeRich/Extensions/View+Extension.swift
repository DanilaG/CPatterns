//
//  View+Extension.swift
//  BeRich
//
//  Created by Ilya Solovyov on 13.04.2023.
//

import SwiftUI

public extension View {
    func addBorder<S>(_ content: S, width: CGFloat = 1, cornerRadius: CGFloat) -> some View where S: ShapeStyle {
        let roundedRect = RoundedRectangle(cornerRadius: cornerRadius)
        return clipShape(roundedRect)
            .overlay(roundedRect.strokeBorder(content, lineWidth: width))
    }
}
