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
import QtQuick.Dialogs
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.components
import org.kde.plasma.private.sessions
import "../code/data.js" as Data

PlasmoidItem {
    id: root

    readonly property int minButtonSize: Kirigami.Units.iconSizes.small
    readonly property int medButtonSize: Kirigami.Units.iconSizes.medium
    readonly property int maxButtonSize: Kirigami.Units.iconSizes.large

    Layout.minimumWidth: minButtonSize * itemGrid.columns
    Layout.minimumHeight: minButtonSize * itemGrid.rows

    Layout.maximumWidth: maxButtonSize * itemGrid.columns
    Layout.maximumHeight: maxButtonSize * itemGrid.rows
    
    readonly property int iconSize: {
        var value = 0
        if(Plasmoid.formFactor != PlasmaCore.Types.Vertical){
            value = height / itemGrid.rows
        }
        else {
            value = width / itemGrid.columns
        }
        
        if(value < minButtonSize){
            value = minButtonSize
        }
        
        return value
    }

    Layout.preferredWidth: (iconSize * itemGrid.columns)
    Layout.preferredHeight: (iconSize * itemGrid.rows)

    preferredRepresentation: fullRepresentation

    SessionManagement {
        id: session
    }

    
    Grid {
        id: itemGrid
        
        readonly property int numVisibleButtons: (visibleChildren.length - 1)
        
        rows: {
            var value = Plasmoid.configuration.rows
            if(Plasmoid.configuration.inlineBestFit){
                if(Plasmoid.formFactor != PlasmaCore.Types.Vertical){
                    value = 1;
                }
                else {
                    value = numVisibleButtons
                }
            }
            
            return value
        }
        columns: {
            var value = Plasmoid.configuration.columns
            if(Plasmoid.configuration.inlineBestFit){
                if(Plasmoid.formFactor === PlasmaCore.Types.Vertical){
                    value = 1;
                }
                else {
                    value = numVisibleButtons
                }
            }
            
            return value
        }
        spacing: 0
        width: parent.width
        height: parent.height
        
        Repeater {
            id: items
            property int itemWidth: Math.floor(parent.width/parent.columns)
            property int itemHeight: Math.floor(parent.height/parent.rows)
            property int iconSize: Math.min(itemWidth, itemHeight)
            model: Data.store.getConfigData()
            
            Kirigami.Icon {
                id: iconButton
                visible: {
                    var value = Plasmoid.configuration["show_" + modelData.configKey] && (!modelData.hasOwnProperty("requires") || session[modelData.requires])
                    console.log(modelData.operation,"visible=", value)
                    
                    return value
                }
                
                width: items.iconSize
                height: items.iconSize
                source: modelData.icon

                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onReleased: clickHandler(modelData.operation, this)

                    PlasmaCore.ToolTipArea {
                        anchors.fill: parent
                        mainText: modelData.tooltip_mainText
                        subText: modelData.tooltip_subText
                        icon: modelData.icon
                    }
                }
            } 
        }
    }
    
    //TODO: See how to implement a confirmation dialog
    // MessageDialog {
    //     id: hibernateDialogComponent
    //     text: qsTr("The document has been modified.")
    //     informativeText: qsTr("Do you want to save your changes?")
    //     buttons: MessageDialog.Yes | MessageDialog.No
    //     onButtonClicked: function (button, role) {
    //         switch (button) {
    //         case MessageDialog.Yes:
    //             console.log("Clicked on YES button!");
    //             performOperation("suspendToDisk");
    //             break;
    //         }
    //     }
    // }
    // property MessageDialog hibernateDialog;

    //TODO: See how to implement a confirmation dialog
    // MessageDialog {
    //     id: sleepDialogComponent
    //     text: i18n("Suspend")
    //     informativeText: i18n("Do you want to suspend to RAM (sleep)?")
    //     buttons: MessageDialog.Yes | MessageDialog.No
    //     onButtonClicked: function (button, role) {
    //         switch (button) {
    //         case MessageDialog.Yes:
    //             console.log("SUSPEND - Clicked on YES button!");
    //             performOperation("suspendToRam");
    //             break;
    //         }
    //     }
    // }
    // property MessageDialog sleepDialog;

    //TODO: Clean up
    // Component {
    //     id: hibernateDialogComponent
    //     QueryDialog {
    //         titleIcon: "system-suspend-hibernate"
    //         titleText: i18n("Hibernate")
    //         message: i18n("Do you want to suspend to disk (hibernate)?")
    //         location: Plasmoid.location

    //         acceptButtonText: i18n("Yes")
    //         rejectButtonText: i18n("No")

    //         onAccepted: performOperation("suspendToDisk")
    //     }
    // }
    // property QueryDialog hibernateDialog

    // Component {
    //     id: sleepDialogComponent
    //     QueryDialog {
    //         titleIcon: "system-suspend"
    //         titleText: i18n("Suspend")
    //         message: i18n("Do you want to suspend to RAM (sleep)?")
    //         location: Plasmoid.location

    //         acceptButtonText: i18n("Yes")
    //         rejectButtonText: i18n("No")

    //         onAccepted: performOperation("suspendToRam")
    //     }
    // }
    // property QueryDialog sleepDialog

    SystemPanel {
        id: systemPanel
    }
    
    function clickHandler(operation, button) {
        //TODO: See how to implement a confirmation dialog
        // if (operation === "suspendToDisk" && Plasmoid.configuration.hibernateConfirmation) {
        //     // TODO: Clean up
        //     // if (!hibernateDialog) {
        //     //     hibernateDialog = hibernateDialogComponent.createObject(itemGrid);
        //     // }
        //     // hibernateDialog.visualParent = button
        //     // hibernateDialog.open()
        //     hibernateDialogComponent.open();

        // } else if (operation === "suspendToRam" && Plasmoid.configuration.sleepConfirmation){
        //     //TODO: Clean up
        //     // if (!sleepDialog) {
        //     //     sleepDialog = sleepDialogComponent.createObject(itemGrid);
        //     // }
        //     // sleepDialog.visualParent = button
        //     // sleepDialog.open()
        //     sleepDialogComponent.open();

        // } else if (operation === "turnOffScreen") {
        if (operation === "turnOffScreen") {
            systemPanel.turnOffScreen();
            
        } else {
            performOperation(operation);
        }
    }
    
    function performOperation(operation) {
        console.log("performOperation - operation=", operation);
        session[operation]();
    }
}
