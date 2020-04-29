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
    anchors.fill: parent

    Rectangle {
        id: lineRectangle
        color: theme.buttonFocusColor

        width: plasmoid.formFactor === PlasmaCore.Types.Horizontal ? length : thickness
        height: plasmoid.formFactor === PlasmaCore.Types.Horizontal ? thickness : length

        readonly property int length: plasmoid.formFactor === PlasmaCore.Types.Horizontal ? parent.width : parent.height
        readonly property int thickness: Math.max(2, indicator.currentIconSize * 0.06)

        states: [
            State {
                name: "left"
                when: (plasmoid.location === PlasmaCore.Types.LeftEdge)

                AnchorChanges {
                    target: lineRectangle
                    anchors{ top:undefined; bottom:undefined; left:undefined; right:parent.right;
                        horizontalCenter: undefined; verticalCenter: parent.verticalCenter}
                }
            },
            State {
                name: "right"
                when: (plasmoid.location === PlasmaCore.Types.RightEdge)

                AnchorChanges {
                    target: lineRectangle
                    anchors{ top:undefined; bottom:undefined; left:parent.left; right:undefined;
                        horizontalCenter: undefined; verticalCenter: parent.verticalCenter}
                }
            },
            State {
                name: "bottom"
                when: (plasmoid.location === PlasmaCore.Types.BottomEdge)

                AnchorChanges {
                    target: lineRectangle
                    anchors{ top:parent.top; bottom:undefined; left:undefined; right:undefined;
                        horizontalCenter: parent.horizontalCenter; verticalCenter: undefined}
                }
            },
            State {
                name: "top"
                when: (plasmoid.location === PlasmaCore.Types.TopEdge)

                AnchorChanges {
                    target: lineRectangle
                    anchors{ top:undefined; bottom:parent.bottom; left:undefined; right:undefined;
                        horizontalCenter: parent.horizontalCenter; verticalCenter: undefined}
                }
            }
        ]
    }
}
