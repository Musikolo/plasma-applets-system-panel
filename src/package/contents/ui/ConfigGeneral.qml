/*
    Copyright (c) 2016 Carlos López Sánchez <musikolo{AT}hotmail[DOT]com>

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

import QtQuick 2.0
import QtQuick.Layouts 1.1 as QtLayouts
import QtQuick.Controls 1.0 as QtControls

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.extras 2.0 as PlasmaExtras

Item {
    id: iconsPage
    width: childrenRect.width
    height: childrenRect.height
    implicitWidth: pageColumn.implicitWidth
    implicitHeight: pageColumn.implicitHeight

    readonly property int numVisibleButtons: turnOffScreen.checked + leave.checked + lock.checked + switchUser.checked + hibernate.checked + sleep.checked

    property alias cfg_show_turnOffScreen: turnOffScreen.checked
    property alias cfg_show_requestShutDown: leave.checked
    property alias cfg_lockTurnOffScreen: lockTurnOffScreen.checked
    property alias cfg_show_lockScreen: lock.checked
    property alias cfg_show_switchUser: switchUser.checked
    property alias cfg_show_suspendToDisk: hibernate.checked
    property alias cfg_hibernateConfirmation: hibernateConfirmation.checked
    property alias cfg_show_suspendToRam: sleep.checked
    property alias cfg_sleepConfirmation: sleepConfirmation.checked
    
    property alias cfg_inlineBestFit: inlineBestFit.checked
    property alias cfg_rows: rows.value
    property alias cfg_columns: columns.value

    readonly property bool lockScreenEnabled: dataEngine.data["Sleep States"].LockScreen
    readonly property bool suspendEnabled: dataEngine.data["Sleep States"].Suspend
    readonly property bool hibernateEnabled: dataEngine.data["Sleep States"].Hibernate

    readonly property int defaultLeftMargin: 10

    SystemPalette {
        id: sypal
    }

    PlasmaCore.DataSource {
        id: dataEngine
        engine: "powermanagement"
        connectedSources: ["Sleep States"]
    }
    
    QtLayouts.ColumnLayout {
        id: pageColumn

        PlasmaExtras.Heading {
            text: i18nc("Heading for list of actions (leave, lock, shutdown, ...)", "Actions")
            color: syspal.text
            level: 2
        }

        Column {
            spacing: 5

            Column {
                QtControls.Label {
                    id: turnOffLabel
                    text: i18n("Turn off screen")
                }
                QtControls.CheckBox {
                    id: turnOffScreen
                    anchors.left: parent.left
                    anchors.leftMargin: defaultLeftMargin
                    text: i18n("Enabled")
                    enabled: (numVisibleButtons > 1 || !checked)
                }
            }
            Column {
                QtControls.Label {
                    text: i18n("Leave")
                }
                QtControls.CheckBox {
                    id: leave
                    anchors.left: parent.left
                    anchors.leftMargin: defaultLeftMargin
                    text: i18n("Enabled")
                    enabled: iconsPage.lockScreenEnabled && (numVisibleButtons > 1 || !checked)
                }
            }
            Column {
                QtControls.Label {
                    text: i18n("Lock")
                }
                QtControls.CheckBox {
                    id: lock
                    anchors.left: parent.left
                    anchors.leftMargin: defaultLeftMargin
                    text: i18n("Enabled")
                    enabled: numVisibleButtons > 1 || !checked
                }
                QtControls.CheckBox {
                    id: lockTurnOffScreen
                    anchors.left: parent.left
                    anchors.leftMargin: defaultLeftMargin
                    text: i18n("Turn off screen when locking")
                    enabled: lock.checked
                }
            }
            Column {
                QtControls.Label {
                    text: i18n("Switch user")
                }
                QtControls.CheckBox {
                    id: switchUser
                    anchors.left: parent.left
                    anchors.leftMargin: defaultLeftMargin
                    text: i18n("Enabled")
                    enabled: numVisibleButtons > 1 || !checked
                }
            }
            Column {
                QtControls.Label {
                    text: i18n("Hibernate")
                }
                QtControls.CheckBox {
                    id: hibernate
                    anchors.left: parent.left
                    anchors.leftMargin: defaultLeftMargin
                    text: i18n("Enabled")
                    enabled: iconsPage.hibernateEnabled && (numVisibleButtons > 1 || !checked)
                }
                QtControls.CheckBox {
                    id: hibernateConfirmation
                    anchors.left: parent.left
                    anchors.leftMargin: defaultLeftMargin
                    text: i18n("Ask for confirmation")
                    enabled: hibernate.checked
                }
            }
            Column {
                QtControls.Label {
                    text: i18n("Suspend")
                }
                QtControls.CheckBox {
                    id: sleep
                    anchors.left: parent.left
                    anchors.leftMargin: defaultLeftMargin
                    text: i18n("Enabled")
                    enabled: iconsPage.suspendEnabled && (numVisibleButtons > 1 || !checked)
                }
                QtControls.CheckBox {
                    id: sleepConfirmation
                    anchors.left: parent.left
                    anchors.leftMargin: defaultLeftMargin
                    text: i18n("Ask for confirmation")
                    enabled: sleep.checked
                }
            }
        }

        PlasmaExtras.Heading {
            text: i18nc("Number of rows, columns...","Layout")
            color: syspal.text
            level: 2
        }

        QtControls.CheckBox {
            id: inlineBestFit
            text: i18n("Inline best fit")
            checked: cfg_inlineBestFit || numVisibleButtons <= 1
        }

        QtControls.SpinBox{
            id: rows
            minimumValue: {
                var value = 2;
                if(numVisibleButtons <= 2 /*&& columns.value > 1*/) {
                    value = 1
                }
                return value
            }
            maximumValue: Math.ceil(numVisibleButtons / columns.value)
            value: cfg_rows
            suffix: " " + i18n("rows")
            enabled: !inlineBestFit.checked && numVisibleButtons > 1
        }

        QtControls.SpinBox{
            id: columns
            minimumValue:  {
                var value = 2;
                if(numVisibleButtons <= 2 /*&& rows.value > 1*/) {
                    value = 1
                }
                return value
            }
            maximumValue: Math.ceil(numVisibleButtons / rows.value)
            value: cfg_columns
            suffix: " " + i18n("columns")
            enabled: !inlineBestFit.checked && numVisibleButtons > 1
        }
    }
}
