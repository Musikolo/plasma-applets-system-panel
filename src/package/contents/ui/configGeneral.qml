/*
    Copyright (c) 2024 Carlos López Sánchez <musikolo{AT}hotmail[DOT]com>

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

import QtQuick
import QtQuick.Controls as QtControls
import QtQuick.Layouts

import org.kde.kirigami as Kirigami
import org.kde.kcmutils as KCM
import org.kde.plasma.private.sessions

KCM.SimpleKCM {
    id: iconsPage
    width: childrenRect.width
    height: childrenRect.height
    implicitWidth: pageColumn.implicitWidth
    implicitHeight: pageColumn.implicitHeight

    readonly property int numVisibleButtons: turnOffScreen.checked + shutdown.checked + restart.checked + logout.checked + lock.checked + switchUser.checked + hibernate.checked + sleep.checked

    property alias cfg_show_turnOffScreen: turnOffScreen.checked
    property alias cfg_show_requestShutDown: shutdown.checked
    property alias cfg_show_requestRestart: restart.checked
    property alias cfg_show_requestLogOut: logout.checked
    property alias cfg_lockTurnOffScreen: lockTurnOffScreen.checked
    property alias cfg_show_lockScreen: lock.checked
    property alias cfg_show_switchUser: switchUser.checked
    property alias cfg_show_suspendToDisk: hibernate.checked
    //TODO: See how to implement a confirmation dialog
    // property alias cfg_hibernateConfirmation: hibernateConfirmation.checked
    property alias cfg_show_suspendToRam: sleep.checked
    //TODO: See how to implement a confirmation dialog
    // property alias cfg_sleepConfirmation: sleepConfirmation.checked

    property alias cfg_inlineBestFit: inlineBestFit.checked
    property alias cfg_rows: rows.value
    property alias cfg_columns: columns.value

    readonly property int defaultLeftPadding: 10

    SessionManagement {
        id: session
    }

    SystemPalette { id: syspal }

    ColumnLayout {
        id: pageColumn

        Kirigami.Heading {
            text: i18nc("Heading for list of actions (leave, lock, shutdown, ...)", "Actions")
            color: syspal.text
            level: 2
        }

        Grid {
            spacing: 5
            columns: 2

            Column {
                QtControls.Label {
                    id: turnOffLabel
                    text: i18n("Turn Off Screen")
                }
                QtControls.CheckBox {
                    id: turnOffScreen
                    Layout.alignment : Qt.AlignLeft
                    leftPadding: defaultLeftPadding
                    text: i18n("Enabled")
                    enabled: (numVisibleButtons > 1 || !checked)
                }
            }
            Column {
                QtControls.Label {
                    text: i18n("Shut Down")
                }
                QtControls.CheckBox {
                    id: shutdown
                    Layout.alignment : Qt.AlignLeft
                    leftPadding: defaultLeftPadding
                    text: i18n("Enabled")
                    enabled: session.canShutdown && (numVisibleButtons > 1 || !checked)
                }
            }
            Column {
                QtControls.Label {
                    text: i18n("Restart")
                }
                QtControls.CheckBox {
                    id: restart
                    Layout.alignment : Qt.AlignLeft
                    leftPadding: defaultLeftPadding
                    text: i18n("Enabled")
                    enabled: session.canReboot && (numVisibleButtons > 1 || !checked)
                }
            }
            Column {
                QtControls.Label {
                    text: i18n("Log Out")
                }
                QtControls.CheckBox {
                    id: logout
                    Layout.alignment : Qt.AlignLeft
                    leftPadding: defaultLeftPadding
                    text: i18n("Enabled")
                    enabled: session.canLogout && (numVisibleButtons > 1 || !checked)
                }
            }
            Column {
                QtControls.Label {
                    text: i18n("Lock")
                }
                QtControls.CheckBox {
                    id: lock
                    Layout.alignment : Qt.AlignLeft
                    leftPadding: defaultLeftPadding
                    text: i18n("Enabled")
                    enabled: session.canLock && (numVisibleButtons > 1 || !checked)
                }
                QtControls.CheckBox {
                    id: lockTurnOffScreen
                    Layout.alignment : Qt.AlignLeft
                    leftPadding: defaultLeftPadding
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
                    Layout.alignment : Qt.AlignLeft
                    leftPadding: defaultLeftPadding
                    text: i18n("Enabled")
                    enabled: session.canSwitchUser && (numVisibleButtons > 1 || !checked)
                }
            }
            Column {
                QtControls.Label {
                    text: i18n("Hibernate")
                }
                QtControls.CheckBox {
                    id: hibernate
                    Layout.alignment : Qt.AlignLeft
                    leftPadding: defaultLeftPadding
                    text: i18n("Enabled")
                    enabled: session.canHibernate && (numVisibleButtons > 1 || !checked)
                }
                //TODO: See how to implement a confirmation dialog
                // QtControls.CheckBox {
                //     id: hibernateConfirmation
                //     Layout.alignment : Qt.AlignLeft
                //     leftPadding: defaultLeftPadding
                //     text: i18n("Ask for confirmation")
                //     enabled: hibernate.checked
                // }
            }
            Column {
                QtControls.Label {
                    text: i18n("Sleep")
                }
                QtControls.CheckBox {
                    id: sleep
                    Layout.alignment : Qt.AlignLeft
                    leftPadding: defaultLeftPadding
                    text: i18n("Enabled")
                    enabled: session.canSuspend && (numVisibleButtons > 1 || !checked)
                }
                //TODO: See how to implement a confirmation dialog
                // QtControls.CheckBox {
                //     id: sleepConfirmation
                //     Layout.alignment : Qt.AlignLeft
                //     leftPadding: defaultLeftPadding
                //     text: i18n("Ask for confirmation")
                //     enabled: sleep.checked
                // }
            }
        }

        Kirigami.Heading {
            text: i18nc("Number of rows, columns...","Layout")
            color: syspal.text
            level: 2
        }

        QtControls.CheckBox {
            id: inlineBestFit
            text: i18n("Inline best fit")
            checked: numVisibleButtons <= 1
        }

        Row {
            QtControls.SpinBox{
                id: rows
                //TODO: See if there is any case scenario we need to do any maths
                from: 1
                // from: {
                //     var value = 2
                //     if(numVisibleButtons <= 2) {
                //         value = 1
                //     }
                //     return value
                // }
                to: Math.ceil(numVisibleButtons / columns.value)
                value: cfg_rows
                enabled: !inlineBestFit.checked && numVisibleButtons > 1
            }
            QtControls.Label {
                leftPadding: 5
                topPadding: 5
                text: i18n("rows")
            }
        }

        Row {
            QtControls.SpinBox{
                id: columns
                to: Math.ceil(numVisibleButtons / rows.value)
                value: cfg_columns
                enabled: !inlineBestFit.checked && numVisibleButtons > 1
            }
            QtControls.Label {
                leftPadding: 5
                topPadding: 5
                text: i18n("columns")
            }
        }

    }
}
