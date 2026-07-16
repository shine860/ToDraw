// File: todraw.js
// Created: suqian2024051604029 3236863614@qq.com      2026-07-16
// Version: 1.0      License: AGPLv3
//这个js主要是想要处理数据管理部分，和简易音乐处理器相似
function initial(){
    console.log("Controller initialized")
}

function exportToImage(){
    var content=mainView.content
    if(!content){
        console.log("Content not find")
        return
    }
    if(!content.dialogs || !content.dialogs.fileExport){
        console.log("Export dialog not found")
        return
    }
    content.dialogs.fileExport.open()
}
function showAbout(){
    content.dialogs.about.open()
}