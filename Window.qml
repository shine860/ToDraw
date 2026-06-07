
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window

ApplicationWindow {
    id: mainView
    width: 1280
    height: 1024
    visible: true
    title: "ToDraw-GeoGebra"

    menuBar: MenuBar {
        Menu {
            title: "&File"
            MenuItem { action: actions.newAction }
            MenuItem { action: actions.openAction }
            MenuItem { action: actions.saveAction }
            MenuSeparator {}
            MenuItem { action: actions.exportAction }
            MenuSeparator {}
            MenuItem { action: actions.exitAction }
        }
        Menu {
            title: "&Edit"
            MenuItem { action: actions.undoAction }
            MenuSeparator {}
            MenuItem { action: actions.redoAction }

        }
        Menu {
            title: "&Help"
            MenuItem { text: "About"; onTriggered: aboutDialog.open() }
        }
    }
    Actions{
        id:actions
        // open.onTriggered: Controller.open();
        // aboutDialog.onTriggered: content.dialogs.about.open()
    }
    header: ToolBar {
        RowLayout{
            ToolButton{ action: actions.newAction }
            ToolButton{ action: actions.openAction }
            ToolButton{ action: actions.saveAction }
            ToolButton{ action: actions.exportAction }
            ToolButton{ action: actions.exitAction }
            ToolButton{ action: actions.undoAction }
            ToolButton{ action: actions.redoAction }
        }
    }
    Content{
        id:content
        anchors.fill: parent
    }
}