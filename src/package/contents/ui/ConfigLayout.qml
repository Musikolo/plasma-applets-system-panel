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
import QtQuick.Dialogs 1.0
import org.kde.plasma.components 2.0

import QtQuick.Layouts 1.1 as QtLayouts
import QtQuick.Controls 1.1 as QtControls
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.extras 2.0 as PlasmaExtras
import "../code/data.js" as Data
    
Item {

    readonly property int defaultIconSize: 64
    property var selectedToolButton
    property var selectedIcon
    property var selectedIconData

    FileDialog {
        id: fileDialog
        title: "Please choose a file"
        folder: shortcuts.home
        nameFilters: [i18n("Icons only (*.svg *.png *.jpg *.jpeg)"), i18n("All files (*)")]
        onAccepted: {
            if(selectedToolButton){
                console.log("Chosen file icon is", fileDialog.fileUrl)
                selectedToolButton.iconSource = fileDialog.fileUrl
                selectedToolButton = null
            }
            Qt.quit()
        }
        onRejected: {
            selectedToolButton = null
            Qt.quit()
        }
//        Component.onCompleted: visible = true
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
            id: changeIconsAction
            anchors.left: parent.left
            anchors.leftMargin: 10
            text: "Change icons"
            checked: true
            exclusiveGroup: actionRadioGroup
            onClicked: uncheckToolButtons()
        }
        QtControls.RadioButton {
            id: rearrangeIconsAction
            anchors.left: parent.left
            anchors.leftMargin: 10
            text: "Rearrange icons"
            exclusiveGroup: actionRadioGroup
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
                model: Data.data
                delegate: ToolButton {
                    iconSource: modelData.icon
                    checkable: rearrangeIconsAction.checked
                    width: defaultIconSize
                    height: defaultIconSize
                    tooltip: { 
                         return changeIconsAction.checked ? i18n("Click to change icon") : i18n("Click to select and move icon")
                    }
                    onClicked: {
                        if(changeIconsAction.checked){
                            chooseIconFile(this)
                        }
                        else {
                            selectIcon(this, modelData)
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
    }
    
    function uncheckToolButtons(){
        
        if(selectedIcon){
            selectedIcon.checked = false
            selectIcon(selectedIcon)
        }
    }
    
    function chooseIconFile(toolButton){

        console.log("Clicked on", toolButton.iconSource)
        selectedToolButton = toolButton
        fileDialog.open();
    }
    
    function selectIcon(toolButton, modelData){

        console.log("Clicked on", toolButton.iconSource, "Selected:", toolButton.checked)
        if(selectedIcon && selectedIcon != toolButton){
            selectedIcon.checked = false
        }
        
        if(toolButton.checked){
            selectedIcon = toolButton
            selectedIconData = modelData
            arrowLeft.enabled = true
            arrowRight.enabled = true
            
        }
        else {
            selectedIcon = null
            selectedIconData = null
            arrowLeft.enabled = false
            arrowRight.enabled = false
        }
    }
    
    function moveIcon(direction){
        
        if(selectedIconData){
            var idx;
            for(idx=0; idx < iconList.count;idx++){
                if(iconList.model[idx].operation==selectedIconData.operation){
                    console.log("Found idx=" ,idx)
                    break;
                }
            }
            
            if(idx < iconList.count){
                var idxTarget = -1
                if(direction == "LEFT" && idx > 0){
                    idxTarget = idx - 1;
                }
                else if(direction == "RIGHT" && idx < iconList.count - 1) {
                    idxTarget = idx + 1;
                }
                
                if(idxTarget > -1){
                    console.log("Moving idx=", idx, "to", idxTarget)
                    var array = Data.data
                    
                    var tmp = array[idx]
                    array[idx]=array[idxTarget]
                    array[idxTarget]=tmp

                    Data.data = array
                    iconList.model = array
                    selectedIcon = iconList.itemAt(idxTarget)
                    selectedIcon.checked = true
                    
                    console.log("moveIcon done")
                }
                else {
                    console.log("Cannot be moved")
                }
            }
            else {
                console.error("Item not found!")
            }
        }
    }
}
