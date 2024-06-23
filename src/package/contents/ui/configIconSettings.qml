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
import QtQuick.Controls
import QtQuick.Dialogs
import Qt.labs.platform
import QtQuick.Layouts

import org.kde.kcmutils as KCM
import org.kde.kirigami as Kirigami
import "../code/data.js" as Data

KCM.SimpleKCM {
    readonly property int defaultIconSize: 48
    property var selectedIcon
    property var selectedIconData

    property alias cfg_layoutData : cfgStore.text

    Label {
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
                console.log("Chosen file icon is", fileDialog.file.toString())
                var icon = getIconName(fileDialog.file)
                selectedIcon.icon.name = icon
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

    SystemPalette { id: syspal }

    ColumnLayout {

        Kirigami.Heading {
            text: i18n("Customize & rearrange icons")
            color: syspal.text
            level: 2
        }

        Label {
            text: i18nc("Actions for the available radio buttons","Action:")
        }
        ButtonGroup {
            id: actionRadioGroup
        }
        RadioButton {
            id: rearrangeIconsAction
            Layout.alignment : Qt.AlignLeft
            Layout.leftMargin: 10
            text: i18n("Rearrange icons")
            checked: true
            ButtonGroup.group: actionRadioGroup
        }
        RadioButton {
            id: changeSystemIconsAction
            Layout.alignment : Qt.AlignLeft
            Layout.leftMargin: 10
            text: i18n("Change icons with system icons (recommended)")
            ButtonGroup.group: actionRadioGroup
            onClicked: uncheckToolButtons()
        }
        RadioButton {
            id: changeUserIconsAction
            Layout.alignment : Qt.AlignLeft
            Layout.leftMargin: 10
            text: i18n("Change icons with user-defined icons")
            ButtonGroup.group: actionRadioGroup
            onClicked: uncheckToolButtons()
        }

        Row {
            ToolButton {
                id: arrowLeft
                icon.name: "arrow-left"
                icon.width: defaultIconSize
                icon.height: defaultIconSize
                ToolTip.visible: hovered
                ToolTip.text: i18n("Move icon to the left")
                enabled: false
                onClicked: moveIcon("LEFT")
            }

            Repeater {
                id: iconList
                model: Data.store.getConfigData()
                delegate: ToolButton {
                    icon.name: modelData.icon
                    checkable: rearrangeIconsAction.checked
                    icon.width: defaultIconSize
                    icon.height: defaultIconSize
                    ToolTip.visible: hovered
                    ToolTip.text: {
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
                id: arrowRight
                icon.name: "arrow-right"
                icon.width: defaultIconSize
                icon.height: defaultIconSize
                ToolTip.visible: hovered
                ToolTip.text: i18n("Move icon to the right")
                enabled: false
                onClicked: moveIcon("RIGHT")
            }
        }

        ToolButton {
            id: restore
            icon.name: "edit-undo"
            icon.width: 64
            icon.height: 32
            ToolTip.visible: hovered
            ToolTip.text: i18n("Reset all current changes to previous values")
            text: i18n("Reset")
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

        console.log("Clicked on", toolButton.icon.source)
        selectedIcon = toolButton
        selectedIconData = modelData
        fileDialog.folder = (changeUserIconsAction.checked ? StandardPaths.standardLocations(StandardPaths.HomeLocation)[0] :
                                                             "file:///usr/share/icons")
        fileDialog.open();
    }

    function selectIcon(toolButton, modelData, index){

        console.log("Clicked on", toolButton.icon.source, "Selected:", toolButton.checked)
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
