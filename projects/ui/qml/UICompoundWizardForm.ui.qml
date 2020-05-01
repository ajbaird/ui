import QtQuick.Controls 2.12
import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.12
import com.biogearsengine.ui.scenario 1.0

Page {
  id : compoundWizard
  anchors.fill : parent
  property alias doubleValidator : doubleValidator
  property alias compoundDataModel : compoundDataModel 
  property alias compoundGridView : compoundGridView

  UIUnitScalarEntry {
    id : compoundName
    prefWidth : parent.width / 2 * 0.9
    prefHeight : 60 * 0.95
    anchors.top : parent.top
    anchors.horizontalCenter : parent.horizontalCenter
    label : "Compound Name"
    unit : ""
    type : "string"
    hintText : "Required*"
  }

  GridView {
    id: compoundGridView
    clip : true
    width : parent.width
    height : targetGridHeight < maxGridHeight ? targetGridHeight : maxGridHeight
    model : compoundDataModel
    anchors.top : compoundName.bottom
    anchors.topMargin : 10
    anchors.left : parent.left
    anchors.right : parent.right
    currentIndex: -1
    property var targetGridHeight : (Math.floor(count / 2) + count % 2) * cellHeight
    property var maxGridHeight : parent.height - addComponent.height
    cellHeight : 70
    cellWidth : width / 2
    ScrollIndicator.vertical: ScrollIndicator { }
    delegate : Item {
      //Wrapping scalar entry in an item helps us center the rectangle inside the gridview cell.  If we tried to
      // anchor in center without this, every delegate instance would center itself in the middle of the view (not
      // the middle of the individual cell)
      id: delegateWrapper
      width : compoundGridView.cellWidth
      height : compoundGridView.cellHeight
      UISubstanceEntry {
        id : substanceEntryDelegate
        anchors.centerIn : parent
        prefWidth : compoundGridView.cellWidth * 0.875 //Tuned to get the remove icon to fit
        prefHeight : compoundGridView.cellHeight * 0.85
        //label : root.displayFormat(model.name)
        unit : model.unit
        type : model.type
        hintText : model.hint
        //entryValidator : root.assignValidator(model.type)
        onInputAccepted : {
          root.compoundData[model.name] = input
          if (model.name === "Name" && root.editMode && !nameWarningFlagged){
            root.nameChanged()
            nameWarningFlagged = true
          }
        }
      }
      Image {
        id: removeIcon
        source : "icons/remove.png"
        sourceSize.width : 15
        sourceSize.height: 15
        MouseArea {
          anchors.fill : parent
          cursorShape : Qt.PointingHandCursor
          acceptedButtons : Qt.LeftButton
          onClicked: {  
            compoundDataModel.remove(index)
          }
        }
      }
    }
  }
  
  Rectangle {
    id : addComponent
    width: parent.width
    height : 40
    anchors.top : compoundGridView.bottom
    color : "transparent"
    Rectangle {
      id : lineRectangle
      width : parent.width - 60
      height : 2
      anchors.left : parent.left
      anchors.verticalCenter : parent.verticalCenter
      border.color : "black"
      color : "black"
    }
    Image {
      id: addIcon
      source : "icons/add.png"
      sourceSize.width : 30
      sourceSize.height: 30
      anchors.verticalCenter : parent.verticalCenter
      anchors.right : parent.right
      anchors.rightMargin : sourceSize.width / 2
      MouseArea {
        anchors.fill : parent
        cursorShape : Qt.PointingHandCursor
        acceptedButtons : Qt.LeftButton
        onClicked: {  
          let newComponent = {name: "Component", unit: "concentration", type: "double", hint: "", valid: true}
          compoundDataModel.append(newComponent)
        }
      }
    }
  }

  DoubleValidator {
    id : doubleValidator
    bottom : 0
  }

  ListModel {
    id : compoundDataModel
  }
}
/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
 ##^##*/
 