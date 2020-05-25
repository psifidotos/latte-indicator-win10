/*
*  Copyright 2020  Michail Vourlakos <mvourlakos@gmail.com>
*
*  This file is part of Latte-Dock
*
*  Latte-Dock is free software; you can redistribute it and/or
*  modify it under the terms of the GNU General Public License as
*  published by the Free Software Foundation; either version 2 of
*  the License, or (at your option) any later version.
*
*  Latte-Dock is distributed in the hope that it will be useful,
*  but WITHOUT ANY WARRANTY; without even the implied warranty of
*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*  GNU General Public License for more details.
*
*  You should have received a copy of the GNU General Public License
*  along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

import QtQuick 2.0
import QtGraphicalEffects 1.0

import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore

Item{
    width: layerWidth
    height: parent.height
    clip: true

    property bool isSecondStackedBackLayer: false
    property bool isThirdStackedBackLayer: false

    readonly property bool isUnhoveredSecondStacked: isSecondStackedBackLayer && !indicator.isHovered && root.backgroundOpacity === 0

    readonly property int layerWidth: isUnhoveredSecondStacked ? 2 * (root.groupItemLength) : root.groupItemLength

    BackLayer{
        anchors.right: parent.right
        anchors.top: parent.top

        width: 4*parent.width
        height: parent.height

        isSecondStackedBackLayer: parent.isSecondStackedBackLayer
        isThirdStackedBackLayer: parent.isThirdStackedBackLayer
    }

    Rectangle {
        id: borderRect
        width:1
        height: parent.height - lineThickness
        anchors.top: parent.top
        anchors.left: parent.left
        color: "#020202"//theme.backgroundColor
        visible: (isSecondStackedBackLayer || isThirdStackedBackLayer) && root.backgroundOpacity>0
        opacity: {
            if (isSecondStackedBackLayer) {
                return 0.2;
            } else if (isThirdStackedBackLayer) {
                return 0.30;
            }

            return 0;
        }
    }

    Rectangle {
        id: lineBorderRect
        width: 1
        height: lineThickness
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        color: "#020202"//theme.backgroundColor
        visible: (isSecondStackedBackLayer || isThirdStackedBackLayer) && !isUnhoveredSecondStacked
        opacity: borderRect.opacity
    }
}
