import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12
import QtQuick.Controls.Material 2.3

RowLayout {
  id: scalarEntry
  //Properties -- used to customize look and functionality of component
  property real labelFieldRatio : 0.5
  property real prefWidth : parent.width
  property real prefHeight : scalarEntry.implicitHeight
  property string entry : "Default"
  property string unit : ""
  property bool textEntry : true
  //Property aliases
  property alias entryLabel : entryLabel
  property alias entryField : entryField
  property alias entryUnit : entryUnit
  //Layout options
  Layout.preferredWidth : prefWidth
  Layout.preferredHeight : prefHeight
  
  Rectangle {
    id : labelRectangle
    Layout.maximumWidth : scalarEntry.prefWidth * 0.75
    Layout.preferredWidth : scalarEntry.prefWidth * 0.75
    Layout.maximumHeight : scalarEntry.prefHeight
    Layout.fillHeight : true
    color : "transparent"
    border.color : entryField.activeFocus ? "teal" : "black"
    border.width : 2

    Column {
      anchors.fill : parent
      spacing : 20
      Label {
        id: entryLabel
        width : parent.width
        height : (parent.height - parent.spacing) * 0.3
        text : scalarEntry.entry
        color : "black"
        font.pointSize : 7
        horizontalAlignment : Text.AlignLeft
        padding : 5
      }
      TextField {
        id : entryField
        width : parent.width
        height : (parent.height - parent.spacing) * 0.7
        Layout.alignment: Qt.AlignBottom
        leftPadding : 10
        topPadding : 0
        bottomPadding : 0
        placeholderText: "Data"
        font.pointSize : 9
        horizontalAlignment : Text.AlignLeft
        background : Rectangle {
          anchors.fill : parent
          color : "transparent"
          border.width : 0
        }
      }
    }
  }


  /*Label {
    id: entryLabel
    Layout.maximumWidth : scalarEntry.prefWidth * labelFieldRatio * 0.75
    Layout.preferredWidth : scalarEntry.prefWidth * labelFieldRatio * 0.75
    Layout.maximumHeight : scalarEntry.prefHeight
    Layout.fillHeight : true
    Layout.alignment: Qt.AlignBottom
    text : scalarEntry.entry
    color : "white"
    font.pointSize : 9
    verticalAlignment : Text.AlignVCenter
    horizontalAlignment : Text.AlignHCenter
    padding : 5
    background : Rectangle {
      color : "teal"
      border.color : "teal"
      radius : 20
      anchors.fill : parent
    }
  }

  TextField {
    id : entryField
    Layout.maximumWidth : scalarEntry.prefWidth * (1.0 - labelFieldRatio) * 0.75
    Layout.preferredWidth : textEntry ? scalarEntry.prefWidth * (1.0 - labelFieldRatio) * 0.75 : 0
    Layout.fillWidth : true
    Layout.alignment: Qt.AlignBottom
    placeholderText: "Data"
    font.pointSize : 8
    horizontalAlignment : Text.AlignHCenter
  }*/

  ComboBox {
    id : entryUnit
    Layout.maximumWidth : scalarEntry.prefWidth * 0.25
    Layout.maximumHeight : scalarEntry.prefHeight
    Layout.fillWidth : true
    Layout.fillHeight : true
    Layout.alignment: Qt.AlignBottom
    model : scalarEntry.units[unit]
    font.pointSize : 6
  }

  property var units : ({'mass' : ['cm', 'kg'],
                         'length' : ['in', 'm'],
                         'volume' : ['L','mL','uL'],
                         'gender' : ['F', 'M'],
                         'bloodType' : ['A+','A-','B+','B-','AB+','AB-','O+','O-'],
                         'frequency' : ['1/s', '1/min'],
                         'density' : ['g/mL','kg/m^3'],
                         'time' : ['yr', 'hr','min','s'],
                         'pressure' : ['mmHg', 'cmH2O']})

}




/*##^## Designer {
    D{i:0;height:25;width:200}
}
 ##^##*/
