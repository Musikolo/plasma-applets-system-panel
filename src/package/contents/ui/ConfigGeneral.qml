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
    property alias cfg_show_lockScreen: lock.checked
    property alias cfg_show_switchUser: switchUser.checked
    property alias cfg_show_suspendToDisk: hibernate.checked
    property alias cfg_show_suspendToRam: sleep.checked
    
    property alias cfg_inlineBestFit: inlineBestFit.checked
    property alias cfg_rows: rows.value
    property alias cfg_columns: columns.value

    readonly property bool lockScreenEnabled: dataEngine.data["Sleep States"].LockScreen
    readonly property bool suspendEnabled: dataEngine.data["Sleep States"].Suspend
    readonly property bool hibernateEnabled: dataEngine.data["Sleep States"].Hibernate

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

        QtControls.CheckBox {
            id: turnOffScreen
            text: i18n("Turn Off Screen")
            enabled: (numVisibleButtons > 1 || !checked)
        }        
        QtControls.CheckBox {
            id: leave
            text: i18n("Leave")
            enabled: iconsPage.lockScreenEnabled && (numVisibleButtons > 1 || !checked)
        }
        QtControls.CheckBox {
            id: lock
            text: i18n("Lock")
            enabled: numVisibleButtons > 1 || !checked
        }
        QtControls.CheckBox {
            id: switchUser
            text: i18n("Switch User")
            enabled: numVisibleButtons > 1 || !checked
        }
        QtControls.CheckBox {
            id: hibernate
            text: i18n("Hibernate")
            enabled: iconsPage.hibernateEnabled && (numVisibleButtons > 1 || !checked)
        }
        QtControls.CheckBox {
            id: sleep
            text: i18n("Suspend")
            enabled: iconsPage.suspendEnabled && (numVisibleButtons > 1 || !checked)
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
            suffix: i18n(" rows")
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
            suffix: i18n(" columns")
            enabled: !inlineBestFit.checked && numVisibleButtons > 1
        }
    }
}
