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

import org.kde.latte.components 1.0 as LatteComponents

LatteComponents.IndicatorItem {
    id: root
    needsIconColors: true
    providesFrontLayer: false
    providesHoveredAnimation: true
    providesClickedAnimation: true
    minThicknessPadding: 0.03
    minLengthPadding: 0.25

    readonly property bool progressVisible: indicator.hasOwnProperty("progressVisible") ? indicator.progressVisible : false
    readonly property bool isHorizontal: plasmoid.formFactor === PlasmaCore.Types.Horizontal
    readonly property bool isVertical: !isHorizontal

    readonly property int screenEdgeMargin: indicator.hasOwnProperty("screenEdgeMargin") ? indicator.screenEdgeMargin : 0
    readonly property int thickness: !isHorizontal ? width - screenEdgeMargin : height - screenEdgeMargin

    readonly property int shownWindows: indicator.windowsCount - indicator.windowsMinimizedCount
    readonly property int maxDrawnMinimizedWindows: shownWindows > 0 ? Math.min(indicator.windowsMinimizedCount,2) : 3

    readonly property int groupItemLength: indicator.currentIconSize * 0.13
    readonly property int groupsSideMargin: indicator.windowsCount <= 1 ? 0 : (Math.min(indicator.windowsCount-1,2) * root.groupItemLength)

    readonly property real backColorBrightness: colorBrightness(indicator.palette.backgroundColor)
    readonly property color activeColor: indicator.palette.buttonFocusColor
    readonly property color outlineColor: {
        if (!indicator.configuration.drawShapesBorder) {
            return "transparent"
        }

        return backColorBrightness < 127 ? indicator.palette.backgroundColor : indicator.palette.textColor;
    }
    readonly property color backgroundColor: indicator.palette.backgroundColor

    function colorBrightness(color) {
        return colorBrightnessFromRGB(color.r * 255, color.g * 255, color.b * 255);
    }

    // formula for brightness according to:
    // https://www.w3.org/TR/AERT/#color-contrast
    function colorBrightnessFromRGB(r, g, b) {
        return (r * 299 + g * 587 + b * 114) / 1000
    }

    readonly property int lineThickness: Math.max(indicator.currentIconSize * indicator.configuration.lineThickness, 2)
    readonly property int shrinkLengthEdge: 0.13 * parent.width

    readonly property real opacityStep: {
        if (indicator.configuration.maxBackgroundOpacity >= 0.3) {
            return 0.1;
        }

        return 0.05;
    }

    readonly property real backgroundOpacity: {
        if (indicator.isHovered && indicator.hasActive) {
            return indicator.configuration.maxBackgroundOpacity;
        } else if (indicator.hasActive) {
            return indicator.configuration.maxBackgroundOpacity - opacityStep;
        } else if (indicator.isHovered) {
            return indicator.configuration.maxBackgroundOpacity - 2*opacityStep;
        }

        return 0;
    }


    //! Bindings for properties that have introduced
    //! later on Latte versions > 0.9.2
    Binding{
        target: level.requested
        property: "iconOffsetX"
        when: level && level.requested && level.requested.hasOwnProperty("iconOffsetX")
        value: -root.groupsSideMargin / 2
    }

    Binding{
        target: root
        property: "appletLengthPadding"
        when: root.hasOwnProperty("appletLengthPadding")
        value: indicator.configuration.appletPadding
    }

    Binding{
        target: root
        property: "enabledForApplets"
        when: root.hasOwnProperty("enabledForApplets")
        value: indicator.configuration.enabledForApplets
    }

    Binding{
        target: root
        property: "lengthPadding"
        when: root.hasOwnProperty("lengthPadding")
        value: indicator.configuration.lengthPadding
    }

    //! Background Layer
    Item {
        id: floater
        anchors.fill: parent
        anchors.topMargin: plasmoid.location === PlasmaCore.Types.TopEdge ? root.screenEdgeMargin : 0
        anchors.bottomMargin: plasmoid.location === PlasmaCore.Types.BottomEdge ? root.screenEdgeMargin : 0
        anchors.leftMargin: plasmoid.location === PlasmaCore.Types.LeftEdge ? root.screenEdgeMargin : 0
        anchors.rightMargin: plasmoid.location === PlasmaCore.Types.RightEdge ? root.screenEdgeMargin : 0

        Loader {
            id: thirdStackedLoader
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter

            height: parent.height
            active: indicator.windowsCount>=3 && backgroundOpacity > 0 && !secondStackedLoader.isUnhoveredSecondStacked && !indicator.inRemoving
            opacity: 0.4

            sourceComponent: GroupRect{
                isThirdStackedBackLayer: true
            }
        }

        Loader {
            id: secondStackedLoader
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.rightMargin: {
                if (isUnhoveredSecondStacked) {
                    return (shrinkLengthEdge - width) - 1 + offsetUnhoveredSecondStacked - 2;
                }

                return indicator.windowsCount>2 && active ? groupItemLength  : 0
            }

            height: parent.height
            active: indicator.windowsCount>=2 && !indicator.inRemoving
            opacity: 0.7

            readonly property bool isUnhoveredSecondStacked: active && !indicator.isHovered && root.backgroundOpacity === 0
            //readonly property int offsetUnhoveredSecondStacked: isUnhoveredSecondStacked ? 2*(root.groupItemLength+1)+1 : 0
            readonly property int offsetUnhoveredSecondStacked: isUnhoveredSecondStacked ? root.groupItemLength+3+groupsSideMargin : 0

            sourceComponent: GroupRect{
                isSecondStackedBackLayer: true
            }
        }

        Loader{
            id: backLayer
            anchors.fill: parent
            anchors.rightMargin: {
                if (secondStackedLoader.isUnhoveredSecondStacked) {
                    return root.groupItemLength + secondStackedLoader.offsetUnhoveredSecondStacked;
                }

                return groupsSideMargin;
            }
            active: level.isBackground && !indicator.inRemoving

            sourceComponent: BackLayer{
                anchors.fill: parent

                showProgress: root.progressVisible
            }
        }

      /*  Loader{
            id: plasmaBackHighlight
            anchors.fill: parent
            active: level.isBackground && indicator.isActive && !indicator.isSquare

            sourceComponent: PlasmaHighlight{
            }
        }*/
    }
}
