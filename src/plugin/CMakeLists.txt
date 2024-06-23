set(plasmoidplugin_SRCS
    plasmoidplugin.cpp
    systempanel.cpp
    )

add_library(plasmoidplugin SHARED ${plasmoidplugin_SRCS})
target_link_libraries(plasmoidplugin Qt6::Quick)

install(TARGETS plasmoidplugin DESTINATION ${KDE_INSTALL_QMLDIR}/org/kde/private/systempanel)

install(FILES qmldir DESTINATION ${KDE_INSTALL_QMLDIR}/org/kde/private/systempanel)
