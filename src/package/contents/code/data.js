let store = (function () {
  let operationIdx = null;
  const defaultData = [
    {
      icon: "system-standby",
      operation: "turnOffScreen",
      configKey: "turnOffScreen",
      tooltip_mainText: i18n("Standby"),
      tooltip_subText: i18n("Turn off the monitor to save energy"),
    },
    {
      icon: "system-lock-screen",
      operation: "lock",
      configKey: "lockScreen",
      tooltip_mainText: i18n("Lock"),
      tooltip_subText: i18n("Lock the screen"),
      requires: "canLock",
    },
    {
      icon: "system-switch-user",
      operation: "switchUser",
      configKey: "switchUser",
      tooltip_mainText: i18n("Switch user"),
      tooltip_subText: i18n("Start a parallel session as a different user"),
      requires: "canSwitchUser",
    },
    {
      icon: "system-shutdown",
      operation: "requestShutdown",
      configKey: "requestShutDown",
      tooltip_mainText: i18n("Shut Down"),
      tooltip_subText: i18n("Turn off the computer"),
      requires: "canShutdown",
    },
    {
      icon: "system-reboot",
      operation: "requestReboot",
      configKey: "requestRestart",
      tooltip_mainText: i18n("Restart"),
      tooltip_subText: i18n("Reboot the computer"),
      requires: "canReboot",
    },
    {
      icon: "system-log-out",
      operation: "requestLogout",
      configKey: "requestLogOut",
      tooltip_mainText: i18n("Log Out"),
      tooltip_subText: i18n("Log out the computer"),
      requires: "canLogout",
    },
    {
      icon: "system-suspend",
      operation: "suspend",
      configKey: "suspendToRam",
      tooltip_mainText: i18n("Sleep"),
      tooltip_subText: i18n("Suspend to RAM"),
      requires: "canSuspend",
    },
    {
      icon: "system-suspend-hibernate",
      operation: "hibernate",
      configKey: "suspendToDisk",
      tooltip_mainText: i18n("Hibernate"),
      tooltip_subText: i18n("Suspend to disk"),
      requires: "canHibernate",
    },
  ];

  let myData = deepCopy(defaultData);

  function deepCopy(array) {
    const newArray = array.slice();
    for (let i = 0; i < array.length; i++) {
      const item = array[i];
      const newItem = {};
      for (let key in item) {
        newItem[key] = item[key];
      }
      newArray[i] = newItem;
    }

    return newArray;
  }

  function resetOperationIdx() {
    operationIdx = null;
  }

  function getOperationIdx() {
    if (!operationIdx) {
      operationIdx = {};
      for (let i = 0; i < myData.length; i++) {
        operationIdx[myData[i].operation] = i;
      }
    }

    return operationIdx;
  }

  function swapOperation(currentPosition, newPosition) {
    console.log("Swapping position from", currentPosition, "to", newPosition);
    let success = false;
    const item = myData[currentPosition];
    myData.splice(currentPosition, 1);
    myData.splice(newPosition, 0, item);
    success = true;

    return success;
  }

  function syncData() {
    console.log("Synchronizing data...");
    let cfgData = plasmoid.configuration.layoutData;
    if (cfgData) {
      console.log("Parsing data", cfgData);
      cfgData = JSON.parse(cfgData);
      if (cfgData && cfgData.length > 0) {
        const newData = [];
        const operationIdx = getOperationIdx();
        for (let i = 0; i < cfgData.length; i++) {
          const item = cfgData[i];
          const itemIdx = operationIdx[item.operation];
          const defaultItem = myData[itemIdx];
          defaultItem.icon = item.icon;
          newData[newData.length] = defaultItem;
        }

        myData = newData;
        resetOperationIdx();
      }
    }
    console.log("Data synchronized successfully!");
  }

  return {
    getOperationPosition: function (operation) {
      const operationIdx = getOperationIdx();
      const idx = operationIdx[operation];

      return idx;
    },
    updateOperationIcon: function (operation, icon) {
      console.log("updateOperationIcon - operation=", operation, "icon=", icon);
      let success = false;
      const operationIdx = getOperationIdx();
      const idx = operationIdx[operation];
      if (idx || idx == 0) {
        myData[idx].icon = icon;
        success = true;
      } else {
        console.error("Could not find index for operation=", operation);
      }

      return success;
    },
    updateOperationPosition: function (operation, newPosition) {
      console.log(
        "Updating position of operation= ",
        operation,
        "to",
        newPosition
      );
      let success = false;
      const operationIdx = getOperationIdx();
      const currentPosition = operationIdx[operation];
      if (currentPosition || currentPosition == 0) {
        success = swapOperation(currentPosition, newPosition);
        if (success) {
          resetOperationIdx();
        }
        console.log("Position updated with success=", success);
      } else {
        console.error("Could not find index for operation=", operation);
      }

      return success;
    },
    getData: function () {
      console.log("getData", JSON.stringify(myData));

      return myData;
    },
    getConfigData: function () {
      console.log("getConfigData", JSON.stringify(myData));
      syncData();

      return myData;
    },
    getBasicJsonData: function () {
      let json = null;
      if (myData) {
        const basicData = [];
        for (let i = 0; i < myData.length; i++) {
          basicData[i] = {
            icon: myData[i].icon,
            operation: myData[i].operation,
          };
        }

        json = JSON.stringify(basicData);
        console.log("JSON", json);
      }

      return json;
    },
    restore: function () {
      myData = deepCopy(defaultData);
      resetOperationIdx();

      return myData;
    },
  };
})();
