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
import QtQuick.Layouts 1.0
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0
import "data.js" as Data

Item {
    id: root

    readonly property int minButtonSize: units.iconSizes.small
    readonly property int medButtonSize: units.iconSizes.medium
    readonly property int maxButtonSize: units.iconSizes.large

    Layout.minimumWidth: minButtonSize * itemGrid.columns
    Layout.minimumHeight: minButtonSize * itemGrid.rows

    Layout.maximumWidth: maxButtonSize * itemGrid.columns
    Layout.maximumHeight: maxButtonSize * itemGrid.rows
    
    readonly property int iconSize: {
        var value = 0
        if(plasmoid.formFactor != PlasmaCore.Types.Vertical){
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

    Plasmoid.preferredRepresentation: Plasmoid.fullRepresentation
    
    PlasmaCore.DataSource {
        id: dataEngine
        engine: "powermanagement"
        connectedSources: ["Sleep States","PowerDevil"]
    }
    
    Grid {
        id: itemGrid
        
        readonly property int numVisibleButtons: (visibleChildren.length - 1)
        
        rows: {
            var value = plasmoid.configuration.rows
            if(plasmoid.configuration.inlineBestFit){
                if(plasmoid.formFactor != PlasmaCore.Types.Vertical){
                    value = 1;
                }
                else {
                    value = numVisibleButtons
                }
            }
            
            return value
        }
        columns: {
            var value = plasmoid.configuration.columns
            if(plasmoid.configuration.inlineBestFit){
                if(plasmoid.formFactor === PlasmaCore.Types.Vertical){
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
            
            PlasmaCore.IconItem {
                id: iconButton
                visible: { 
                    var value = plasmoid.configuration["show_" + modelData.operation] && (!modelData.hasOwnProperty("requires") || dataEngine.data["Sleep States"][modelData.requires])
                    console.log(modelData.operation,"visible=", value)
                    
                    return value
                }
                
                width: items.iconSize
                height: items.iconSize
//TODO: Clean up
//                source: provideIcon(modelData.icon, modelData.operation, true)
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
//TODO: Clean up
//                        icon: provideIcon(modelData.icon, modelData.operation, false)
                        icon: modelData.icon
                    }
                }
            } 
        }
    }
    
    Component {
        id: hibernateDialogComponent
        QueryDialog {
            titleIcon: "system-suspend-hibernate"
            titleText: i18n("Hibernate")
            message: i18n("Do you want to suspend to disk (hibernate)?")
            location: plasmoid.location

            acceptButtonText: i18n("Yes")
            rejectButtonText: i18n("No")

            onAccepted: performOperation("suspendToDisk")
        }
    }
    property QueryDialog hibernateDialog

    Component {
        id: sleepDialogComponent
        QueryDialog {
            titleIcon: "system-suspend"
            titleText: i18n("Suspend")
            message: i18n("Do you want to suspend to RAM (sleep)?")
            location: plasmoid.location

            acceptButtonText: i18n("Yes")
            rejectButtonText: i18n("No")

            onAccepted: performOperation("suspendToRam")
        }
    }
    property QueryDialog sleepDialog

    SystemPanel {
        id: systemPanel
    }
    
    //TODO: Find a way to remove this workaround
//     function provideIcon(iconName, operation, scaleNeeded) {
//         
//         var value = iconName
//         
//         if(operation == "turnOffScreen"){
//             if(items.iconSize >=32 || !scaleNeeded){
//                 value = value.replace("%s", "32")
//             }
//             else if(items.iconSize >=22){
//                 value = value.replace("%s", "22")
//             }
//             else {
//                 value = value.replace("%s", "16")
//             }
//         }
//         
//         return value
//     }
    
    function clickHandler(what, button) {
        if (what == "suspendToDisk" && plasmoid.configuration.hibernateConfirmation) {
            if (!hibernateDialog) {
                hibernateDialog = hibernateDialogComponent.createObject(itemGrid);
            }
            hibernateDialog.visualParent = button
            hibernateDialog.open()

        } else if (what == "suspendToRam" && plasmoid.configuration.sleepConfirmation){
            if (!sleepDialog) {
                sleepDialog = sleepDialogComponent.createObject(itemGrid);
            }
            sleepDialog.visualParent = button
            sleepDialog.open()

        } else if (what == "turnOffScreen") {
            systemPanel.turnOffScreen();
            
        } else {
            performOperation(what)
        }
    }
    
    function performOperation(what) {
                    
        var service = dataEngine.serviceForSource("PowerDevil");
        var operation = service.operationDescription(what);
        var serviceJob = service.startOperationCall(operation);
        serviceJob.finished.connect(result);
    }

    function result(job) {

        console.log("ServiceJob result=",  job.result, "operationName=", job.operationName);

        if(job.operationName == "lockScreen" && plasmoid.configuration.lockTurnOffScreen){
            systemPanel.turnOffScreen()
        }
    }
}
