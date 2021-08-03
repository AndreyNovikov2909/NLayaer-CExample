//
//  StatusViewModel.swift
//  CCombineApp
//
//  Created by Andrey Novikov on 7/20/21.
//

import Foundation

class StatusViewModel: ObservableObject {
    let title: String
    let color: ColorSet
    
    init(title: String, color: ColorSet) {
        self.title = title
        self.color = color
    }
}
