//
//  ColorSet.swift
//  CCombineApp
//
//  Created by Andrey Novikov on 7/20/21.
//

import SwiftUI

enum ColorSet {
    case success
    case failure
}

extension ColorSet {
    func color() -> Color {
        switch self {
        case .success:
            return .green
        case .failure:
            return .red
        }
    }
}
