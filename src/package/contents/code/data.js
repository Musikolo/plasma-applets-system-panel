var store = function(){
    
    var operationIdx = null
    var defaultData = [{
            icon: "system-standby",
            operation: "turnOffScreen",
            tooltip_mainText: i18n("Standby"),
            tooltip_subText: i18n("Turn off the monitor to save energy")
        }, {
            icon: "system-lock-screen",
            operation: "lockScreen",
            tooltip_mainText: i18n("Lock"),
            tooltip_subText: i18n("Lock the screen"),
            requires: "LockScreen"
        }, {
            icon: "system-switch-user",
            operation: "switchUser",
            tooltip_mainText: i18n("Switch user"),
            tooltip_subText: i18n("Start a parallel session as a different user")
        }, {
            icon: "system-shutdown",
            operation: "requestShutDown",
            tooltip_mainText: i18n("Leave..."),
            tooltip_subText: i18n("Log out, turn off or restart the computer")
        }, {
            icon: "system-suspend",
            operation: "suspendToRam",
            tooltip_mainText: i18n("Suspend"),
            tooltip_subText: i18n("Sleep (suspend to RAM)"),
            requires: "Suspend"
        }, {
            icon: "system-suspend-hibernate",
            operation: "suspendToDisk",
            tooltip_mainText: i18n("Hibernate"),
            tooltip_subText: i18n("Hibernate (suspend to disk)"),
            requires: "Hibernate"
        }]
    
    var myData = deepCopy(defaultData)
    
    function deepCopy(array){
        
        var newArray = array.slice();
        for(var i = 0; i < array.length; i++){
            var item = array[i]
            var newItem = {}
            for(var x in item ){
                newItem[x] = item[x]
            }
            newArray[i] = newItem
        }
        
        return newArray
    }
    
    function resetOperationIdx(){
        
        operationIdx = null
    }
    
    function getOperationIdx(force) {
        
        if(!operationIdx){
            operationIdx = {}
            for(var i = 0; i < myData.length; i++){
                operationIdx[myData[i].operation] = i
            }
        }
        
        return operationIdx
    }
    
    function swapOperation(currentPosition, newPosition){
        
        console.log("Swapping position from", currentPosition, "to", newPosition )
        var success = false
        var item = myData[currentPosition];
        myData.splice(currentPosition, 1);
        myData.splice(newPosition, 0, item)
        success = true
     
        return success
    }
        
    function syncData(){
        
        console.log("Synchronizing data...")
        var cfgData = plasmoid.configuration.layoutData
        if(cfgData){
            console.log("Parsing data", cfgData)
            cfgData = JSON.parse(cfgData)
            if(cfgData && cfgData.length > 0){
                var newData = []
                var operationIdx = getOperationIdx()
                for(var i = 0; i < cfgData.length; i++){
                    var item = cfgData[i]
                    var itemIdx = operationIdx[item.operation]
                    var defaultItem = myData[itemIdx]
                    defaultItem.icon = item.icon
                    newData[newData.length]=defaultItem
                }
                
                myData = newData
                resetOperationIdx()
            }
        }
        console.log("Data synchronized successfully!")
    }

    return {
        getOperationPosition: function(operation){
            
            var operationIdx = getOperationIdx()
            var idx = operationIdx[operation]
            
            return idx
        }
        ,updateOperationIcon: function(operation, icon){
            
            console.log("updateOperationIcon - operation=", operation, "icon=",icon)
            var success = false
            var operationIdx = getOperationIdx()
            var idx = operationIdx[operation]
            if(idx || idx == 0){
                myData[idx].icon = icon
                success = true
            }
            else {
                console.error("Could not find index for operation=", operation)
            }
            
            return success
        }
        ,updateOperationPosition: function (operation, newPosition) {
            
            console.log("Updating position of operation= ", operation, "to", newPosition )
            var success = false
            var operationIdx = getOperationIdx()
            var currentPosition = operationIdx[operation]
            if(currentPosition || currentPosition == 0){
                success = swapOperation(currentPosition, newPosition)
                if(success){
                    resetOperationIdx()
                }
                console.log("Position updated with success=", success)
            }
            else {
                console.error("Could not find index for operation=", operation)
            }
            
            return success
        }
        ,getData: function(){
            
            console.log("getData", myData)
            
            return myData
        }
        ,getConfigData: function(){
            
            console.log("getConfigData", myData)
            syncData();
             
            return myData;
        }
        ,getBasicJsonData: function(){
            
            var json = null
            if(myData){
                 var basicData = []
                 for( var i = 0; i < myData.length; i++){
                     basicData[i] = {'icon':myData[i].icon, 'operation':myData[i].operation}
                 }
                 
                 json = JSON.stringify(basicData)
                 console.log("JSON", json)
            }
            
            return json
        }
        ,restore: function(){
            
            myData = deepCopy(defaultData)
            resetOperationIdx()
            
            return myData
        }
    }
}()
