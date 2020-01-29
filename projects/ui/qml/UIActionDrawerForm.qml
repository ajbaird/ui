import QtQuick.Controls 2.12
import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls.Material 2.12

import com.biogearsengine.ui.scenario 1.0

Drawer {
    property alias applyButton : applyButton
    width : parent.width * 0.2
    height : parent.height
    edge : Qt.LeftEdge
    interactive : true
    position : 0

    ColumnLayout {
        id : drawerColumn
        anchors.fill : parent
            
        Item {
            Layout.fillWidth : true
            Layout.alignment: Qt.AlignTop
            implicitHeight : root.parent.height * 0.8

            ListView {
                id : actionListView
                anchors.fill: parent
                clip : true
                model : actionMenuModel
                delegate : actionMenuDelegate
                focus : true
                section {
                    property : "section"
                    delegate : Rectangle {
                        color : "#7CB342"
                        width : parent.width
                        height : childrenRect.height
                        Text {
                            anchors.horizontalCenter : parent.horizontalCenter
                            text : section
                            font.pointSize : 14
                        }
                    }
                }
            }

            Component {
                id : actionMenuDelegate
                Rectangle {
                    id : delegateWrapper
                    height : delegateText.height * 1.4
                    width : root.width
                    Layout.alignment : Qt.AlignVCenter
                    color : inUse == "true" ? "steelblue" : "white"
                    border.color: "black"
                    border.width : ListView.isCurrentItem ? 2 : 0
                    Text {
                        id: delegateText
                        anchors.verticalCenter : parent.verticalCenter
                        leftPadding: 5
                        text : name
                        font.pointSize : 12
                        Layout.alignment : Qt.AlignVCenter
                    }
                    MouseArea {
                        anchors.fill : parent
                        onClicked : {
                            console.log(index, name)
                            actionListView.currentIndex = index
                            if (model.inUse == "false"){
                                model.inUse ="true";
                            }
                            else {
                                model.inUse = "false"
                            }
                        }
                    }
                    Keys.onReturnPressed : {
                        if (root.opened ){
                            console.log(index, name)
                            if (model.inUse == "false"){
                                model.inUse ="true";
                            }
                            else {
                                model.inUse = "false"
                            }
                        }
                    }
                }
            }

            ListModel {
                id : actionMenuModel
                ListElement { name : "Exercise"; inUse: "false"; section : "Patient Actions"}
                ListElement { name : "ConsumeMeal"; inUse: "false"; section : "Patient Actions"}
                ListElement { name : "Hemorrhage"; inUse: "false"; section : "Insults"}
                ListElement { name : "PainStimulus"; inUse: "false"; section : "Insults"}
                ListElement { name : "TensionPneumothorax"; inUse: "false"; section : "Insults"}
                ListElement { name : "Sepsis"; inUse: "false"; section : "Insults"}
                ListElement { name : "AsthmaAttack"; inUse: "false"; section : "Insults"}
                ListElement { name : "AirwayObstruction"; inUse: "false"; section : "Insults"}
                ListElement { name : "TraumaticBrainInjury"; inUse: "false"; section : "Insults"}
                ListElement { name : "Bronchoconstriction"; inUse: "false"; section : "Insults" }
                ListElement { name : "AcuteStress"; inUse: "false"; section : "Insults"}
                ListElement { name : "DrugAdministration"; inUse: "false"; section : "Interventions"}
                ListElement { name : "NeedleDecompression"; inUse: "false"; section : "Interventions"}
                ListElement { name : "Inhaler"; inUse: "false"; section : "Interventions" }
                ListElement { name : "AnesthesiaMachine"; inUse: "false"; section : "Interventions"}
                ListElement { name : "Transfusion"; inUse: "false"; section : "Interventions"}
                ListElement { name : "Diabetes (Type 1)"; inUse: "false"; section : "Conditions"}
                ListElement { name : "Diabetes (Type 2)"; inUse: "false"; section : "Conditions"}
                ListElement { name : "Bronchitis"; inUse: "false"; section : "Conditions"}
            }
        }
        Button {
            id: applyButton
            Layout.preferredWidth : 0.5 * root
            Layout.alignment : Qt.AlignTop | Qt.AlignHCenter
            text : "Apply"
        }
    }
}

/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
 ##^##*/