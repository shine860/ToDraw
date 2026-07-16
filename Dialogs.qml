// File: Dialogs.qml
// Created:  黄钰琳2024051604104 <389930006@qq.com>     2026-07-16
// Version: 1.0      License: AGPLv3
//     [v0.1.2]  黄钰琳2024051604104 <389930006@qq.com>  2026-07-16 02:09:28
//         * 完成了dialog部分，最开始是打算完成保存等功能，但最后筛选最后完成export（导出）以及about和exit.
import QtQuick
import QtCore
import QtQuick.Controls
import QtQuick.Dialogs

Item {
     property alias about: _about
     property alias error: _errorDialog
     property alias fileOpen: _fileOpen
     property alias fileSave: _fileSave
     property alias fileExport: _fileExport

     FileDialog{
          id: _fileSave
          title: "Save Project"
          modality: Qt.ApplicationModal
          currentFolder: StandardPaths.writableLocation(StandardPaths.DocumentsLocation)
          fileMode: FileDialog.SaveFile
          nameFilters: ["GeoGebra Project (*.ggb)", "All Files (*)"]
          defaultSuffix: "ggb"
     }

     FileDialog{
          id: _fileOpen
          title: "Open Project"
          currentFolder: StandardPaths.standardLocations(StandardPaths.DocumentsLocation)[0]
          fileMode: FileDialog.OpenFile
          nameFilters: ["GeoGebra Project (*.ggb)", "All Files (*)"]
     }

     FileDialog{
          id: _fileExport
          title: "Export Image"
          modality: Qt.ApplicationModal
          currentFolder: StandardPaths.writableLocation(StandardPaths.DocumentsLocation)
          fileMode: FileDialog.SaveFile
          nameFilters: ["PNG Image (*.png)", "JPEG Image (*.jpg *.jpeg)"]
          defaultSuffix: "png"
          onAccepted:{
               var path = selectedFile.toString().replace("file://", "")
               console.log("Export path:", path)
               var c = mainView.content
               if(c){
                    var container = c.graphsContainer
                    if(container){
                         container.grabToImage(function(result){
                              if(result){
                                   var saved = result.saveToFile(path)
                                   console.log("Image saved:", saved)
                              }else{
                                   console.log("Failed to grab image")
                              }
                         })
                    }else{
                         console.log("Graphs container not found")
                    }
               }else{
                    console.log("Content not found")
               }
          }
          onRejected:{
               console.log("Export image cancelled")
          }
     }

     MessageDialog{
          id: _errorDialog
          title: qsTr("Error")
          text: qsTr("Undefined behavior")
          buttons: MessageDialog.Ok
          onButtonClicked: function(button, role){
               if (role === MessageDialog.Ok)
                    Qt.quit()
          }
     }

     MessageDialog{
          id:_about
          modality: Qt.WindowModal
          buttons:MessageDialog.Ok
          text:"todraw – a simple function graphing program"
          informativeText: qsTr("todraw is a free software")
          detailedText: "Copyright©2026 suqian (3236863614@qq.com) lilin202405160409(2293779871@qq.com)  huangyulin2024051604104(389930006@qq.com)"
     }
}