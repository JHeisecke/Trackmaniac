//
//  BasicMapViewController.swift
//  TrackMotor
//
//  Created by Javier Heisecke on 2025-03-11.
//

import GoogleMaps
import UIKit

import GoogleMaps
import UIKit

class BasicMapViewController: UIViewController {
    var statusLabel: UILabel!
    var canvas: DrawingCanvasView!
    var mapView: GMSMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isTranslucent = false

        let options = GMSMapViewOptions()
        options.camera = GMSCameraPosition.camera(withLatitude: -25.3, longitude: -57.63, zoom: 14)
        mapView = GMSMapView(options: options)
        mapView.isIndoorEnabled = false
        mapView.delegate = self

        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        // Canvas overlay
        canvas = DrawingCanvasView()
        canvas.delegate = self
        view.addSubview(canvas)
        canvas.translatesAutoresizingMaskIntoConstraints = false
        canvas.alpha = 0
        NSLayoutConstraint.activate([
            canvas.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            canvas.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            canvas.widthAnchor.constraint(equalTo: view.widthAnchor),
            canvas.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])

        // Button to toggle drawing
        let button = UIButton(
            configuration: .borderedProminent(),
            primaryAction: UIAction(handler: { [weak self] _ in
                self?.toggleCanvas()
            })
        )
        button.setTitle("Draw", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)

        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 50),
            button.widthAnchor.constraint(equalToConstant: 100),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            button.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
        ])

        statusLabel = UILabel(frame: .zero)
        statusLabel.alpha = 0.0
        statusLabel.backgroundColor = .blue
        statusLabel.textColor = .white
        statusLabel.textAlignment = .center
        view.addSubview(statusLabel)
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            statusLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            statusLabel.heightAnchor.constraint(equalToConstant: 30),
            statusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            statusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func toggleCanvas() {
        canvas.alpha = canvas.isDrawing ? 1 : 0
        canvas.finishDrawing()
    }
}

// MARK: - DrawingCanvasView.Delegate

extension BasicMapViewController: DrawingCanvasView.Delegate {
    func didFinishDrawingRoute(points: [CLLocationCoordinate2D]) {
        guard !points.isEmpty else { return }

        let path = GMSMutablePath()
        points.forEach { path.add($0) }

        let polyline = GMSPolyline(path: path)
        polyline.strokeColor = .blue
        polyline.strokeWidth = 5
        polyline.map = mapView
    }
}

// MARK: - GMSMapViewDelegate

extension BasicMapViewController: GMSMapViewDelegate {
    func mapViewDidStartTileRendering(_ mapView: GMSMapView) {
        statusLabel.alpha = 0.8
        statusLabel.text = "Rendering"
    }

    func mapViewDidFinishTileRendering(_ mapView: GMSMapView) {
        statusLabel.alpha = 0.0
    }
}
