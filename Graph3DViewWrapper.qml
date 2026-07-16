// File: Graph3DViewWrapper.qml
// Created: lilin2024051604098，2293779871@qq.com      2026-07-16
// Version: 1.0      License: AGPLv3
//     [v0.1.2] lilin2024051604098，2293779871@qq.com  2026-07-16 02:11:45
//         * 完成了主要的3维的中心窗口
import QtQuick
import QtQuick.Layouts
import org.kde.analitza

Item {
    id: root
    signal ready()
    property var currentFunctions: []
    property bool isReady: false

    // 实际的3D图形绘制组件
    Graph3DView {
        id: graphView
        anchors.fill: parent

        Component.onCompleted: {
            console.log("Graph3DView created")
            root.isReady = true
            root.ready()
        }
    }

    //添加函数
    function addFunctions(expressions) {
        console.log("Adding functions:", expressions)
        if (!expressions||expressions.length===0) {
            console.log("No functions to add")
            return
        }
        currentFunctions = []
        // 添加新函数
        for (var i=0;i<expressions.length;i++) {
            var expr=expressions[i]
            if (!expr||expr.trim()==="") continue

            var t=expr.trim()
            console.log("Adding function "+i+": "+t)
            try{
                var result = graphView.addFunction(t)
                if (result!==undefined && result!==null) {
                    currentFunctions.push(t)
                    console.log("Function added successfully")
                }
            }catch(e){
                console.log("error adding function:",t,e)
            }
        }
        // 重置视角
        resetView()
    }

    // 放大视图
    function zoomIn() {
        try {
            graphView.scale(0.9)
        } catch(e) {
            console.log("Zoomin error:", e)
        }
    }

    // 缩小视图
    function zoomOut() {
        try {
            graphView.scale(1.1)
        } catch(e) {
            console.log("Zoomout error:", e)
        }
    }

    // 重置视角到初始位置
    function resetView() {
        try {
            graphView.resetViewport()
        } catch(e) {
            console.log("Reset error:", e)
        }
    }


    // 拖拽旋转
    DragHandler {
        id: dragHandler
        acceptedDevices: PointerDevice.Mouse|PointerDevice.TouchPad
        grabPermissions: PointerHandler.CanTakeOverFromItems|PointerHandler.CanTakeOverFromHandlersOfDifferentType

        property point lastPos: Qt.point(0, 0)
        onActiveChanged: {
            if (active) {
                lastPos=Qt.point(centroid.position.x, centroid.position.y)
                graphView.forceActiveFocus()
            }
        }

        // 拖拽移动时计算位移
        onTranslationChanged: {
            var currentX=centroid.position.x
            var currentY=centroid.position.y
            var dx=currentX-lastPos.x
            var dy=currentY-lastPos.y

            if ((dx!==0||dy!==0) && active) {
                try {
                    graphView.rotate(dx, dy)
                } catch(e) {}
            }
            lastPos = Qt.point(currentX, currentY)
        }
    }

    // 滚轮缩放
    WheelHandler {
        id: wheelHandler3D
        acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
        onWheel: (event) => {
                     try {
                         if (event.angleDelta.y > 0) {
                             graphView.scale(1.1)
                         } else {
                             graphView.scale(0.9)
                         }
                     } catch(e) {}
                 }
    }
}