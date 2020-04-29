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
    property bool showProgress: false

    Rectangle {
        anchors.fill: parent
        radius: backRect.radius
        color: theme.viewBackgroundColor
        visible: isActive
        opacity: 0.75
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

    /*RadialGradient{
        id: glowGradient
        anchors.verticalCenter: parent.top
        anchors.horizontalCenter: parent.left
        width: 2.5 * parent.width
        height: 2 * parent.height
        visible: false
        clip: true

        gradient: Gradient {
            GradientStop { position: 0.0; color: "#ccfcfcfc"}
            GradientStop { position: 0.05; color: "#bbfcfcfc"}
            GradientStop { position: 0.2; color: "#55fcfcfc"}
            GradientStop { position: 0.48; color: "transparent" }
        }
        //! States
        states: [
            State {
                name: "top"
                when: !indicator.configuration.glowReversed

                AnchorChanges {
                    target: glowGradient
                    anchors{horizontalCenter:parent.horizontalCenter; verticalCenter:parent.top}
                }
            },
            State {
                name: "bottom"
                when: indicator.configuration.glowReversed

                AnchorChanges {
                    target: glowGradient
                    anchors{horizontalCenter:parent.horizontalCenter; verticalCenter:parent.bottom}
                }
            }
        ]
    }

    Item {
        id: gradientMask
        anchors.fill: glowGradient

        Rectangle {
            id: glowMaskRect
            anchors.top: parent.verticalCenter
            anchors.left: parent.horizontalCenter
            width: root.width
            height: root.height
            radius: backRect.radius
        }

        visible: false
    }

    Rectangle {
        anchors.fill: parent
        color: "transparent"
        clip: true

        OpacityMask {
            anchors.horizontalCenter: parent.left
            anchors.verticalCenter: parent.top
            width: glowGradient.width
            height: glowGradient.height

            source: glowGradient
            maskSource: gradientMask
            visible: backRect.visible || borderRectangle.visible
            opacity: indicator.isHovered ? 0.75 : 0.6
        }
    }*/

    /*
    Rectangle {
        id: borderRectangle
        anchors.fill: parent
        color: "transparent"
        border.width: 1
        border.color: "#cc101010"
        radius: backRect.radius
        clip: true

        Rectangle {
            anchors.fill: parent
            anchors.margins: parent.border.width
            radius: backRect.radius
            color: "transparent"
            border.width: 1
            border.color: "#50dedede"
        }
    }*/

}
