//
//  MWGroupsCollectionViewLayout.swift
//  MovieWorld
//
//  Created by Ilya Maslou on 4/19/20.
//  Copyright © 2020 Ilya Maslou. All rights reserved.
//

import UIKit

class MWGroupsCollectionViewLayout: UICollectionViewLayout {

    //MARK:- delegate var

    weak var delegate: MWGroupsLayoutDelegate?

    //MARK: - private variables

    private var cache: [UICollectionViewLayoutAttributes] = []

    //MARK:- private configure properties

    private let numberOfColumns = 2
    private let cellPadding: CGFloat = 6

    private var contentHeight: CGFloat {
        guard let collectionView = self.collectionView else { return 0 }
        let insets = collectionView.contentInset
        return collectionView.bounds.height - (insets.top + insets.bottom)
    }

    private var contentWidth: CGFloat = 0

    override var collectionViewContentSize: CGSize {
        return CGSize(width: self.contentWidth, height: self.contentHeight)
    }

    //MARK:- update collectionView cells function

    override func prepare() {
        guard self.cache.isEmpty == true,
            let collectionView = self.collectionView else { return }

        let rowHeight = self.contentHeight / CGFloat(self.numberOfColumns)
        var yOffset: [CGFloat] = []
        for column in 0..<self.numberOfColumns {
            yOffset.append(CGFloat(column) * rowHeight)
        }
        var column = 0
        var xOffset: [CGFloat] = .init(repeating: 0, count: self.numberOfColumns)

        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)

            let labelWidth = self.delegate?.collectionView(
                collectionView,
                widthForLabelAtIndexPath: indexPath) ?? 180
            let width = self.cellPadding * 2 + labelWidth
            let frame = CGRect(x: xOffset[column],
                               y: yOffset[column],
                               width: width,
                               height: rowHeight)
            let insetFrame = frame.insetBy(dx: self.cellPadding, dy: self.cellPadding)

            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            self.cache.append(attributes)

            self.contentWidth = max(self.contentWidth, frame.maxX)
            xOffset[column] = xOffset[column] + width
            column = column < (self.numberOfColumns - 1) ? (column + 1) : 0
        }
    }

    //MARK:- setting layoutAttributes for cells

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []

        for attributes in self.cache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        return visibleLayoutAttributes
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return self.cache[indexPath.item]
    }
}

protocol MWGroupsLayoutDelegate: AnyObject {
    func collectionView(
        _ collectionView: UICollectionView,
        widthForLabelAtIndexPath indexPath: IndexPath) -> CGFloat
}
