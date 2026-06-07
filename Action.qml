import QtQuick
import QtQuick.Controls

Item {
    property alias newAction:_newAction
    property alias openAction:_openAction
    property alias saveAction:_saveAction
    property alias exportAction:_exportAction
    property alias exitAction:_exitAction
    property alias undoAction:_undoAction
    property alias redoAction:_redoAction
    property alias aboutAction: _aboutAction

    Action {
        id: _newAction
        text: qsTr("&New")
        shortcut: "Ctrl+N"
        icon.name: "document-new"
    }

    Action {
        id: _openAction
        text: qsTr("&Open")
        shortcut: "Ctrl+O"
        icon.name: "document-open"
    }

    Action {
        id: _saveAction
        text: qsTr("&Save")
        shortcut: "Ctrl+S"
        icon.name: "document-save"
    }

    Action {
        id: _exportAction
        text: qsTr("&Export")
        shortcut: "Ctrl+E"
        icon.name: "document-export"
    }
    Action {
        id: _exitAction
        text: qsTr("&Exit")
        shortcut: "Ctrl+Q"
        onTriggered: Qt.quit()
        icon.name: "application-exit"
    }

    Action {
        id: _undoAction
        text: qsTr("Undo")
        shortcut: "Ctrl+Z"
        icon.name: "edit-undo"
    }
    Action {
        id: _redoAction
        text:qsTr("Redo")
        shortcut: "Ctrl+Y"
        icon.name: "edit-redo"
    }
    Action {
        id: _aboutAction
        text: qsTr("&About")
        icon.name: "help-about"
    }
}