//
//  ChartView.swift
//  CoinCapApp
//
//  Created by d.leonova on 24.03.2022.
//

import UIKit

class ChartView: UIView {
    private enum Constants {
        static let margins = UIEdgeInsets(top: 36.8, left: 0.0, bottom: 64.4, right: 0.0)
        static let lineWidth: CGFloat = 2
        static let colorWidth = UIColor.black
    }
    
    private var data: [Double] = []
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .clear
    }
    
    func update(with newData: [Double]) {
        guard newData.count > 1 else { return }
        self.data = newData
        setNeedsDisplay()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        guard data.count > 1 else { return }
        
        let chartHeight = bounds.height - Constants.margins.top - Constants.margins.bottom
        let chartWidth = bounds.width
        
        let chartStartX = Constants.margins.left
        let minValue = data.min() ?? 0
        let maxValue = data.max() ?? 1
        let diff = maxValue - minValue
        let unitChartHeight = diff > 0 ? chartHeight / CGFloat(diff) : chartHeight / 10
        let horizontalPointsOffset = chartWidth / CGFloat(data.count - 1)
        
        let xCoordinateForPoint = { (pointIndex: Int) -> CGFloat in
            return chartStartX + CGFloat(pointIndex) * horizontalPointsOffset
        }
        let yCoordinateForPoint = { (pointIndex: Int, pointValue: Double) -> CGFloat in
            return rect.height - Constants.margins.bottom - (pointValue - minValue) * unitChartHeight
        }
        
        let path = UIBezierPath()
        path.lineWidth = Constants.lineWidth
        path.move(to: CGPoint(x: xCoordinateForPoint(0), y: yCoordinateForPoint(0, data[0])))

        for (index, value) in data.enumerated() {
            let xCoordinate = xCoordinateForPoint(index)
            let yCoordinate = yCoordinateForPoint(index, value)
            path.addLine(to: CGPoint(x: xCoordinate, y: yCoordinate))
            
            Constants.colorWidth.setStroke()
            path.stroke()
        }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let attributes = [
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13.0),
            NSAttributedString.Key.foregroundColor: UIColor.gray
        ]
        
        let maxValueText = String(format: "%.2f", data.max() ?? 0)
        let maxValueAttributedString = NSAttributedString(string: maxValueText, attributes: attributes)
        let maxValueTextSize = maxValueAttributedString.size()
        
        if let maxValueIndex = data.firstIndex(of: data.max() ?? 0) {
            let stringRect = CGRect(
                x: xCoordinateForPoint(maxValueIndex) - maxValueTextSize.width / 2,
                y: yCoordinateForPoint(maxValueIndex, data[maxValueIndex]) - 3 - maxValueTextSize.height,
                width: maxValueTextSize.width,
                height: maxValueTextSize.height
            )
            maxValueAttributedString.draw(in: stringRect)
        }
        
        let minValueText = String(format: "%.2f", data.min() ?? 0)
        let minValueAttributedString = NSAttributedString(string: minValueText, attributes: attributes)
        let minValueTextSize = minValueAttributedString.size()
        
        if let minValueIndex = data.firstIndex(of: data.min() ?? 0) {
            let stringRect = CGRect(
                x: xCoordinateForPoint(minValueIndex) - minValueTextSize.width / 2,
                y: yCoordinateForPoint(minValueIndex, data[minValueIndex]) + 3,
                width: minValueTextSize.width,
                height: minValueTextSize.height
            )
            minValueAttributedString.draw(in: stringRect)
        }
    }
}
