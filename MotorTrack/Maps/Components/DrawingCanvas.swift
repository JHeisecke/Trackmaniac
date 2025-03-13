//
//  DrawingCanvas.swift
//  MotorTrack
//
//  Created by Javier Heisecke on 2025-03-12.
//

import UIKit
import GoogleMaps

class DrawingCanvasView: UIView {
    weak var delegate: Delegate?

    private var lastPoint = CGPoint.zero
    private var path = UIBezierPath()
    private var lines: [[CGPoint]] = [[]]
    private(set) var isDrawing: Bool = false

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let point = touch.location(in: self)
        lines.append([point])
        lastPoint = point
        setNeedsDisplay()
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        lastPoint = touch.location(in: self)
        lines[lines.count - 1].append(lastPoint)
        setNeedsDisplay()
    }

    override func draw(_ rect: CGRect) {
        UIColor.red.setStroke()
        path.removeAllPoints()
        for line in lines {
            guard let firstPoint = line.first else { continue }
            path.move(to: firstPoint)
            for point in line.dropFirst() {
                path.addLine(to: point)
            }
        }
        path.lineWidth = 3
        path.stroke()
    }

    func finishDrawing() {
        isDrawing.toggle()
        if isDrawing {
            backgroundColor = UIColor.gray
        } else {
            backgroundColor = UIColor.gray.withAlphaComponent(0)

            // Convert points to map coordinates
            let route = lines.flatMap { line in
                line.map { convertToMapCoordinate($0) }
            }.filter { $0 != nil }.map { $0! }

            delegate?.didFinishDrawingRoute(points: route)
            cleanPaths()
        }
    }

    private func cleanPaths() {
        path = UIBezierPath()
        lines = [[]]
    }

    private func convertToMapCoordinate(_ point: CGPoint) -> CLLocationCoordinate2D? {
        guard let superview = superview as? GMSMapView else { return nil }
        return superview.projection.coordinate(for: point)
    }

    protocol Delegate: AnyObject {
        func didFinishDrawingRoute(points: [CLLocationCoordinate2D])
    }
}
