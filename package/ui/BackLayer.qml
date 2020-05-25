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
    id: rectangleItem

    property bool isActive: indicator.isActive || (indicator.isWindow && indicator.hasActive)
    property bool isSecondStackedBackLayer: false
    property bool isThirdStackedBackLayer: false
    property bool showProgress: false

    Rectangle {        
        anchors.fill: parent

        radius: backRect.radius
        color: theme.viewBackgroundColor
        visible: opacity > 0
        opacity: root.backgroundOpacity

        Behavior on opacity {
            enabled: !isSecondStackedBackLayer && !isThirdStackedBackLayer
            NumberAnimation {
                duration: 120
                easing.type: Easing.OutQuad
            }
        }

        Rectangle {
            id: borderRect
            width: parent.width
            height: parent.height + 4
            anchors.centerIn: parent
            color: "transparent"
            border.width: 1
            border.color: isSecondStackedBackLayer || isThirdStackedBackLayer ? theme.backgroundColor : "transparent"
        }
    }

    Loader {
        anchors.fill: parent
        asynchronous: true
        active: indicator.configuration.progressAnimationEnabled && rectangleItem.showProgress && indicator.progress>0
        sourceComponent: Item{
            Item{
                id: progressFrame
                anchors.fill: parent
                Rectangle {
                    width: backRect.width * (Math.min(indicator.progress, 100) / 100)
                    height: backRect.height

                    color: theme.neutralTextColor
                }

                visible: false
            }

            Item {
                id: progressMask
                anchors.fill: parent

                Rectangle {
                    anchors.fill: parent
                    anchors.margins: 1
                    radius: backRect.radius
                    color: "red"
                }
                visible: false
            }

            Rectangle {
                anchors.fill: parent
                radius: backRect.radius
                color: "transparent"
                clip: true

                OpacityMask {
                    anchors.fill: parent
                    source: progressFrame
                    maskSource: progressMask
                    opacity: 0.5
                }
            }
        }
    }

    Rectangle {
        id: backRect
        anchors.fill: parent
        //radius: indicator.currentIconSize / 16
        color: "transparent"
        clip: true
    }

    Rectangle {
        id: activeLine
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter

        width: root.backgroundOpacity > 0 || (isSecondStackedBackLayer && !indicator.isHovered) ? parent.width : parent.width - (2 * shrinkLengthEdge)
        height: root.lineThickness

        color: theme.highlightColor
        visible: !indicator.isApplet && (rectangleItem.isActive || indicator.isWindow)

        Behavior on width {
            enabled: !isSecondStackedBackLayer && !isThirdStackedBackLayer
            NumberAnimation {
                duration: 120
                easing.type: Easing.OutQuad
            }
        }
    }
}
