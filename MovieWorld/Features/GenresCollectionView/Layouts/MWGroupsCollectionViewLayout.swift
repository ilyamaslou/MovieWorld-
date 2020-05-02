//
//  MWGroupsCollectionViewLayout.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 4/19/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import UIKit

class MWGroupsCollectionViewLayout: UICollectionViewLayout {

    weak var delegate: MWGroupsLayoutDelegate?
    private var cache: [UICollectionViewLayoutAttributes] = []
    private let numberOfColumns = 2
    private let cellPadding: CGFloat = 6

    private var contentHeight: CGFloat {
        guard let collectionView = collectionView else { return 0 }
        let insets = collectionView.contentInset
        return collectionView.bounds.height - (insets.top + insets.bottom)
    }

    private var contentWidth: CGFloat = 0

    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }

    override func prepare() {
        guard cache.isEmpty == true,
            let collectionView = collectionView else { return }

        let rowHeight = contentHeight / CGFloat(numberOfColumns)
        var yOffset: [CGFloat] = []
        for column in 0..<numberOfColumns {
            yOffset.append(CGFloat(column) * rowHeight)
        }
        var column = 0
        var xOffset: [CGFloat] = .init(repeating: 0, count: numberOfColumns)

        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)

            let labelWidth = delegate?.collectionView(
                collectionView,
                widthForLabelAtIndexPath: indexPath) ?? 180
            let width = cellPadding * 2 + labelWidth
            let frame = CGRect(x: xOffset[column],
                               y: yOffset[column],
                               width: width,
                               height: rowHeight)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)

            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)

            contentWidth = max(contentWidth, frame.maxX)
            xOffset[column] = xOffset[column] + width

            column = column < (numberOfColumns - 1) ? (column + 1) : 0
        }
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []

        for attributes in cache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        return visibleLayoutAttributes
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
}

protocol MWGroupsLayoutDelegate: AnyObject {
    func collectionView(
        _ collectionView: UICollectionView,
        widthForLabelAtIndexPath indexPath: IndexPath) -> CGFloat
}
