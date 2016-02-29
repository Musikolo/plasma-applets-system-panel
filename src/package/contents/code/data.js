
var data = [{
//TODO: Find a way to remove the hard-code path for this icon:
//    icon: "system-standby",
    icon: "/usr/share/icons/breeze/apps/%s/system-standby",
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
