//
//  DateFormatting.swift
//  BeRich
//
//  Created by Максим Косников on 18.04.2023.
//

import Foundation

public enum DateFormatting {
    public static let full: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()
}
