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

import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.components 3.0 as PlasmaComponents3
import org.kde.plasma.plasmoid 2.0

import org.kde.latte.components 1.0 as LatteComponents

ColumnLayout {
    Layout.fillWidth: true

    readonly property bool deprecatedPropertiesAreHidden: dialog && dialog.hasOwnProperty("deprecatedOptionsAreHidden") && dialog.deprecatedOptionsAreHidden

    LatteComponents.SubHeader {
        text: i18n("Appearance")
    }

    ColumnLayout {
        spacing: 0

        RowLayout {
            Layout.fillWidth: true
            spacing: units.smallSpacing

            PlasmaComponents.Label {
                Layout.minimumWidth: implicitWidth
                horizontalAlignment: Text.AlignLeft
                Layout.rightMargin: units.smallSpacing
                text: i18n("Max Opacity")
            }

            LatteComponents.Slider {
                id: maxOpacitySlider
                Layout.fillWidth: true

                leftPadding: 0
                value: indicator.configuration.maxBackgroundOpacity * 100
                from: 10
                to: 100
                stepSize: 1
                wheelEnabled: false

                function updateMaxOpacity() {
                    if (!pressed) {
                        indicator.configuration.maxBackgroundOpacity = value/100;
                    }
                }

                onPressedChanged: {
                    updateMaxOpacity();
                }

                Component.onCompleted: {
                    valueChanged.connect(updateMaxOpacity);
                }

                Component.onDestruction: {
                    valueChanged.disconnect(updateMaxOpacity);
                }
            }

            PlasmaComponents.Label {
                text: i18nc("number in percentage, e.g. 85 %","%0 %").arg(maxOpacitySlider.value)
                horizontalAlignment: Text.AlignRight
                Layout.minimumWidth: theme.mSize(theme.defaultFont).width * 4
                Layout.maximumWidth: theme.mSize(theme.defaultFont).width * 4
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 2


            PlasmaComponents.Label {
                Layout.minimumWidth: implicitWidth
                horizontalAlignment: Text.AlignLeft
                Layout.rightMargin: units.smallSpacing
                text: i18n("Line Thickness")
            }

            LatteComponents.Slider {
                id: lineSlider
                Layout.fillWidth: true

                leftPadding: 0
                value: indicator.configuration.lineThickness * 100
                from: 2
                to: 20
                stepSize: 1
                wheelEnabled: false

                function updateLineThickness() {
                    if (!pressed) {
                        indicator.configuration.lineThickness = value/100;
                    }
                }

                onPressedChanged: {
                    updateLineThickness();
                }

                Component.onCompleted: {
                    valueChanged.connect(updateLineThickness);
                }

                Component.onDestruction: {
                    valueChanged.disconnect(updateLineThickness);
                }
            }

            PlasmaComponents.Label {
                text: i18nc("number in percentage, e.g. 85 %","%0 %").arg(lineSlider.value)
                horizontalAlignment: Text.AlignRight
                Layout.minimumWidth: theme.mSize(theme.defaultFont).width * 4
                Layout.maximumWidth: theme.mSize(theme.defaultFont).width * 4
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: units.smallSpacing
            visible: deprecatedPropertiesAreHidden

            PlasmaComponents.Label {
                text: i18n("Tasks Length")
                horizontalAlignment: Text.AlignLeft
            }

            LatteComponents.Slider {
                id: lengthIntMarginSlider
                Layout.fillWidth: true

                value: Math.round(indicator.configuration.lengthPadding * 100)
                from: 25
                to: maxMargin
                stepSize: 1
                wheelEnabled: false

                readonly property int maxMargin: 80

                onPressedChanged: {
                    if (!pressed) {
                        indicator.configuration.lengthPadding = value / 100;
                    }
                }
            }

            PlasmaComponents.Label {
                text: i18nc("number in percentage, e.g. 85 %","%0 %").arg(currentValue)
                horizontalAlignment: Text.AlignRight
                Layout.minimumWidth: theme.mSize(theme.defaultFont).width * 4
                Layout.maximumWidth: theme.mSize(theme.defaultFont).width * 4

                readonly property int currentValue: lengthIntMarginSlider.value
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 2

            PlasmaComponents.Label {
                Layout.minimumWidth: implicitWidth
                horizontalAlignment: Text.AlignLeft
                Layout.rightMargin: units.smallSpacing
                text: i18n("Applets Length")
            }

            LatteComponents.Slider {
                id: appletPaddingSlider
                Layout.fillWidth: true

                leftPadding: 0
                value: indicator.configuration.appletPadding * 100
                from: 0
                to: 80
                stepSize: 5
                wheelEnabled: false

                function updateMargin() {
                    if (!pressed) {
                        indicator.configuration.appletPadding = value/100;
                    }
                }

                onPressedChanged: {
                    updateMargin();
                }

                Component.onCompleted: {
                    valueChanged.connect(updateMargin);
                }

                Component.onDestruction: {
                    valueChanged.disconnect(updateMargin);
                }
            }

            PlasmaComponents.Label {
                text: i18nc("number in percentage, e.g. 85 %","%0 %").arg(appletPaddingSlider.value)
                horizontalAlignment: Text.AlignRight
                Layout.minimumWidth: theme.mSize(theme.defaultFont).width * 4
                Layout.maximumWidth: theme.mSize(theme.defaultFont).width * 4
            }
        }
    }


    LatteComponents.SubHeader {
        text: i18n("Options")
    }

    LatteComponents.CheckBoxesColumn {
        Layout.fillWidth: true

        LatteComponents.CheckBox {
            Layout.maximumWidth: dialog.optionsWidth
            text: i18n("Progress animation in background")
            checked: indicator.configuration.progressAnimationEnabled

            onClicked: {
                indicator.configuration.progressAnimationEnabled = !indicator.configuration.progressAnimationEnabled
            }
        }
    }

    LatteComponents.CheckBox {
        Layout.maximumWidth: dialog.optionsWidth
        text: i18n("Show indicators for applets")
        checked: indicator.configuration.enabledForApplets
        tooltip: i18n("Indicators are shown for applets")
        visible: deprecatedPropertiesAreHidden

        onClicked: {
            indicator.configuration.enabledForApplets = !indicator.configuration.enabledForApplets;
        }
    }
}
