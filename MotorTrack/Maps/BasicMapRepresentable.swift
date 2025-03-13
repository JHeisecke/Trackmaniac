//
//  ZoomableImageView.swift
//  TrackMotor
//
//  Created by Javier Heisecke on 2025-03-11.
//

import SwiftUI

struct BasicMapRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIViewController

    func makeUIViewController(context: Context) -> UIViewController {
        let basicMap = BasicMapViewController()
        return basicMap
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    }
}
