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
import QtQuick.Controls 1.1 as QtControls
import QtQuick.Dialogs 1.0
import QtQuick.Layouts 1.1 as QtLayouts

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0
import org.kde.plasma.extras 2.0 as PlasmaExtras
import "../code/data.js" as Data
    
Item {
    readonly property int defaultIconSize: 64
    property var selectedIcon
    property var selectedIconData

    property alias cfg_layoutData : cfgStore.text

    QtControls.Label {
        id : cfgStore
        text : cfg_layoutData
        visible:  false
    }

    FileDialog {
        id: fileDialog
        title: i18n("Please choose a file")
        nameFilters: [i18n("Icons only (*.svg *.png *.jpg *.jpeg)"), i18n("All files (*)")]
        onAccepted: {
            if(selectedIcon){
                console.log("Chosen file icon is", fileDialog.fileUrl.toString())
                var icon = getIconName(fileDialog.fileUrl)
                selectedIcon.iconSource = icon
                selectedIcon = null
                
                Data.store.updateOperationIcon(selectedIconData.operation, icon)
                selectedIconData = null
                
                var json = Data.store.getBasicJsonData()
                cfgStore.text = json
            }
            Qt.quit()
        }
        onRejected: {
            selectedIcon = null
            selectedIconData = null
            Qt.quit()
        }
    }

    QtLayouts.ColumnLayout {

        PlasmaExtras.Heading {
            text: i18n("Customize & rearrange icons")
            color: syspal.text
            level: 2
        }
        
        QtControls.Label {
            text: i18nc("Actions for the available radio buttons","Action:")
        }
        QtControls.ExclusiveGroup {
            id: actionRadioGroup
        }        
        QtControls.RadioButton {
            id: rearrangeIconsAction
            anchors.left: parent.left
            anchors.leftMargin: 10
            text: i18n("Rearrange icons")
            checked: true
            exclusiveGroup: actionRadioGroup
        }
        QtControls.RadioButton {
            id: changeSystemIconsAction
            anchors.left: parent.left
            anchors.leftMargin: 10
            text: i18n("Change icons with system icons (recommended)")
            exclusiveGroup: actionRadioGroup
            onClicked: uncheckToolButtons()
        }
        QtControls.RadioButton {
            id: changeUserIconsAction
            anchors.left: parent.left
            anchors.leftMargin: 10
            text: i18n("Change icons with user-defined icons")
            exclusiveGroup: actionRadioGroup
            onClicked: uncheckToolButtons()
        }

        Row {
            ToolButton {
                id:arrowLeft
                iconSource: "arrow-left"
                width: defaultIconSize
                height: defaultIconSize
                tooltip: i18n("Move icon to the left")
                enabled: false
                onClicked: moveIcon("LEFT")
            }
            
            Repeater {
                id:iconList
                model: Data.store.getConfigData()
                delegate: ToolButton {
                    iconSource: modelData.icon
                    checkable: rearrangeIconsAction.checked
                    width: defaultIconSize
                    height: defaultIconSize
                    tooltip: { 
                         return rearrangeIconsAction.checked ? i18n("Click to select and move icon") : i18n("Click to change icon")
                    }
                    onClicked: {
                        if(rearrangeIconsAction.checked){
                            selectIcon(this, modelData, index)
                        }
                        else {
                            chooseIconFile(this, modelData)
                        }
                    }
                }
            }
            
            ToolButton {
                id:arrowRight
                iconSource: "arrow-right"
                width: defaultIconSize
                height: defaultIconSize
                tooltip: i18n("Move icon to the right")
                enabled: false
                onClicked: moveIcon("RIGHT")
            }
        }
        
        ToolButton {
            id: restore
            iconSource: "edit-undo"
            width: 90
            height: 48
            text: i18n("Reset")
            tooltip: i18n("Reset all current changes to previous values")
            onClicked: restoreDefaults()
        }
    }
    
    function getIconName(icon){
        
        if( icon && icon.toString){
            icon = icon.toString()
        }
        
        if(changeUserIconsAction.checked){
            icon = icon.replace("file://", "")
        }
        else {
            var lastSlashIdx = icon.lastIndexOf('/')
            if(lastSlashIdx > -1 && lastSlashIdx < icon.length && icon.substr(-4)==".svg"){
                icon = icon.slice(lastSlashIdx + 1, -4)
            }
        }
        
        return icon
    }
    
    function uncheckToolButtons(){
        
        if(selectedIcon){
            selectedIcon.checked = false
            selectIcon(selectedIcon)
        }
    }
    
    function chooseIconFile(toolButton, modelData){

        console.log("Clicked on", toolButton.iconSource)
        selectedIcon = toolButton
        selectedIconData = modelData
        fileDialog.folder = (changeUserIconsAction.checked ? fileDialog.shortcuts.home : "/usr/share/icons")
        fileDialog.open();
    }
    
    function selectIcon(toolButton, modelData, index){

        console.log("Clicked on", toolButton.iconSource, "Selected:", toolButton.checked)
        if(selectedIcon && selectedIcon != toolButton){
            selectedIcon.checked = false
        }
        
        if(toolButton.checked){
            selectedIcon = toolButton
            selectedIconData = modelData
            updateArrows()
            
        }
        else {
            resetArrows()
        }
    }
    
    function moveIcon(direction){
        
        if(selectedIconData){
            var currentPosition = Data.store.getOperationPosition(selectedIconData.operation);
            if(currentPosition < iconList.count){

                var newPosition = -1
                if(direction == "LEFT" && currentPosition > 0){
                    newPosition = currentPosition - 1;
                }
                else if(direction == "RIGHT" && currentPosition < iconList.count - 1) {
                    newPosition = currentPosition + 1;
                }
                
                if(newPosition > -1){
                    var success = Data.store.updateOperationPosition(selectedIconData.operation, newPosition)
                    if(success){
                        iconList.model = Data.store.getData()
                        selectedIcon = iconList.itemAt(newPosition)
                        selectedIcon.checked = true
                        updateArrows()

                        var json = Data.store.getBasicJsonData()
                        cfgStore.text = json
                        console.log("moveIcon done")
                    }
                    else {
                        console.error("updateOperationIcon success = false")
                    }
                }
                else {
                    console.log("Cannot be moved")
                }
            }
            else {
                console.error("Operation=",selectedIconData.operation, "not found!")
            }
        }
    }
    
    function updateArrows(){
        
        var currentPosition = Data.store.getOperationPosition(selectedIconData.operation);
        arrowLeft.enabled = (currentPosition > 0)
        arrowRight.enabled = (currentPosition < iconList.count - 1)
    }
    
    function resetArrows(){
        
        selectedIcon = null
        selectedIconData = null
        arrowLeft.enabled = false
        arrowRight.enabled = false
    }
    
    function restoreDefaults(){

        iconList.model = null // Needed to force refresh
        iconList.model = Data.store.restore()
        cfgStore.text = Data.store.getBasicJsonData()
        resetArrows()
    }
}
