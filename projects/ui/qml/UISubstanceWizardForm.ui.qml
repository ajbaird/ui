import QtQuick.Controls 2.12
import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.12
import QtQml.Models 2.2

Page {
  id : compoundWizard
  anchors.fill : parent
  property alias doubleValidator : doubleValidator
  property alias fractionValidator : fractionValidator
  property alias neg1To1Validator : neg1To1Validator
  property alias substanceListModel : substanceListModel
  property alias substanceDelegateModel : substanceDelegateModel
  property alias substanceTabBar : substanceTabBar
  property alias substanceStackLayout : substanceStackLayout
  property alias pkStackLayout : pkStackLayout


  DoubleValidator {
    id : doubleValidator
    bottom : 0
    decimals : 2
  }

  DoubleValidator {
    id : fractionValidator
    bottom : 0
    top : 1.0
    decimals : 4
  }

  DoubleValidator {
    id : neg1To1Validator
    bottom : -1.0
    top : 1.0
    decimals : 3
  }

  TabBar {
    id : substanceTabBar
    width : parent.width
    height : 40
    TabButton {
      id : baseDataButton
      text : "Physical Data"
      onClicked : {
        substanceStackLayout.currentIndex = TabBar.index
      }
    }
    TabButton {
      id : clearanceButton
      text : "Clearance"
      onClicked : {
        substanceStackLayout.currentIndex = TabBar.index
      }
    }
    TabButton {
      id : pkButton
      text : "Pharmacokinetics"
      onClicked : {
        substanceStackLayout.currentIndex = TabBar.index
      }
    }
    TabButton {
      id : pdButton
      text : "Pharmacodynamics"
      onClicked : {
        substanceStackLayout.currentIndex = TabBar.index
      }
    }
    TabButton {
      id : aerosolButton
      text : "Aerosolization"
      onClicked : {
        substanceStackLayout.currentIndex = TabBar.index
      }
    }
  }

  StackLayout {
    id : substanceStackLayout
    width : parent.width
    height : parent.height - substanceTabBar.height
    anchors.top : substanceTabBar.bottom
    currentIndex : 0
    property var subIndex : children[currentIndex].subIndex ? children[currentIndex].subIndex : 0
    Pane {
      id : physicalDataTab
      Layout.fillWidth : true
      Layout.fillHeight : true
      GridView {
        id: physicalDataGridView
        clip : true
        model : substanceDelegateModel.parts.physical
        anchors.top : parent.top
        anchors.topMargin : 10
        anchors.left : parent.left
        anchors.right : parent.right
        width : parent.width
        height : parent.height
        cellHeight : 60
        cellWidth : parent.width / 2
      }
    }
    Pane {
      id : clearanceTab
      Layout.fillWidth : true
      Layout.fillHeight : true
      Label {
        id : clearanceLabel
        width : parent.width
        height : implicitHeight
        anchors.top : parent.top
        anchors.topMargin : 15
        anchors.left : parent.left
        anchors.right : parent.right
        text : "Clearance"
        font.pointSize : 10
        horizontalAlignment : Text.AlignHCenter
      }
      GridView {
        id: clearanceGridView
        clip : true
        width : parent.width
        height : parent.height
        cellHeight : 60
        cellWidth : parent.width / 2
        model : substanceDelegateModel.parts.clearance
        anchors.top : clearanceLabel.bottom
        anchors.topMargin : 10
        anchors.left : parent.left
        anchors.right : parent.right
        currentIndex: -1
      }
    }
    Pane {
      id : pkTab
      Layout.fillWidth : true
      Layout.fillHeight : true
      property var subIndex : pkStackLayout.currentIndex
      Label {
        id : pkLabel
        width : parent.width
        height : implicitHeight
        anchors.top : parent.top
        anchors.topMargin : 15
        anchors.left : parent.left
        anchors.right : parent.right
        text : "Pharmacokinetics"
        font.pointSize : 10
        horizontalAlignment : Text.AlignHCenter
      }
      RowLayout {
        id : switchItem
        width : parent.width
        height : implicitHeight
        anchors.top : pkLabel.bottom
        anchors.topMargin : 10
        anchors.left : parent.left
        anchors.right : parent.right
        Label {
          text : "Physicochemical Input"
          font.pointSize : 9
          Layout.alignment : Qt.AlignRight
        }
        Switch {
          text : "Partition Coefficients"
          font.pointSize : 9
          onClicked : {
            pkStackLayout.currentIndex = position 
          }
        }
      }
      StackLayout {
        id : pkStackLayout
        anchors.top : switchItem.bottom
        anchors.topMargin : 10
        width : parent.width
        height : parent.height - switchItem.height
        currentIndex : 0
        Item {
          GridView {
            id: pkGridView1
            clip : true
            width : parent.width
            height : parent.height
            cellHeight : 60
            cellWidth : parent.width / 2
            model : substanceDelegateModel.parts.pkPhysicochemical
            currentIndex: -1
          }
        }
        Item {
          GridView {
            id: pkGridView2
            clip : true
            width : parent.width
            height : parent.height
            cellHeight : 60
            cellWidth : parent.width / 2
            model : substanceDelegateModel.parts.pkTissueKinetics
            currentIndex: -1
          }
        }
      }   
    }
    Pane {
      id : pdTab
      Layout.fillWidth : true
      Layout.fillHeight : true
      Label {
        id : pdLabel
        width : parent.width
        height : implicitHeight
        anchors.top : parent.top
        anchors.topMargin : 15
        anchors.left : parent.left
        anchors.right : parent.right
        text : "Pharmacodynamics"
        font.pointSize : 10
        horizontalAlignment : Text.AlignHCenter
      }
      GridView {
        id: pdGridView
        clip : true
        width : parent.width
        height : parent.height
        cellHeight : 60
        cellWidth : parent.width / 2
        model : substanceDelegateModel.parts.pharmacodynamics
        anchors.top : pdLabel.bottom
        anchors.topMargin : 10
        anchors.left : parent.left
        anchors.right : parent.right
        currentIndex: -1
      }
    }
  }
  

  DelegateModel {
    id : substanceDelegateModel
    model : substanceListModel      
    delegate : substanceDelegate
    groups :  [
                DelegateModelGroup {name : "physical"; includeByDefault : false},
                DelegateModelGroup {name : "clearance"; includeByDefault : false},
                DelegateModelGroup {name : "pkPhysicochemical"; includeByDefault : false},
                DelegateModelGroup {name : "pkTissueKinetics"; includeByDefault : false},
                DelegateModelGroup {name : "pharmacodynamics"; includeByDefault : false}
              ]
    filterOnGroup : root.setDelegateFilter(substanceStackLayout.currentIndex, substanceStackLayout.subIndex)  
  }

  Component {
    id : substanceDelegate  
    Package {
      Item {
        width : GridView.view.cellWidth
        height : GridView.view.cellHeight
        UIUnitScalarEntry {
          anchors.centerIn : parent
          prefWidth : parent.width * 0.9
          prefHeight : parent.height * 0.95
          label : root.displayFormat(model.name)
          unit : model.unit
          type : model.type
          hintText : model.hint
          entryValidator : root.assignValidator(model.type)
          onInputAccepted : {
            physicalData[model.name] = input
            if (model.name === "Name" && root.editMode && !nameWarningFlagged){
              root.nameEdited()
              nameWarningFlagged = true
            }
          }
        }
        Package.name : "physical"
      }
     Item {
        width : GridView.view.cellWidth
        height : GridView.view.cellHeight
        UIUnitScalarEntry {
          anchors.centerIn : parent
          prefWidth : parent.width * 0.9
          prefHeight : parent.height * 0.95
          label : root.displayFormat(model.name)
          unit : model.unit
          type : model.type
          hintText : model.hint
          entryValidator : root.assignValidator(model.type)
          onInputAccepted : {
            clearanceData[model.name] = input
          }
        }
        Package.name : "clearance"
      }
      Item {
        width : GridView.view.cellWidth
        height : GridView.view.cellHeight
        UIUnitScalarEntry {
          anchors.centerIn : parent
          prefWidth : parent.width * 0.9
          prefHeight : parent.height * 0.95
          label : root.displayFormat(model.name)
          unit : model.unit
          type : model.type
          hintText : model.hint
          entryValidator : root.assignValidator(model.type)
          onInputAccepted : {
            pkData.physicochemical[model.name] = input
          }
        }
        Package.name : "pkPhysicochemical"
      }
      Item {
        width : GridView.view.cellWidth
        height : GridView.view.cellHeight
        UIUnitScalarEntry {
          anchors.centerIn : parent
          prefWidth : parent.width * 0.9
          prefHeight : parent.height * 0.95
          label : root.displayFormat(model.name)
          unit : model.unit
          type : model.type
          hintText : model.hint
          entryValidator : root.assignValidator(model.type)
          onInputAccepted : {
            pkData.tissueKinetics[model.name] = input
          }
        }
        Package.name : "pkTissueKinetics"
      }
      Item {
        width : GridView.view.cellWidth
        height : GridView.view.cellHeight
        UIUnitScalarEntry {
          anchors.centerIn : parent
          prefWidth : parent.width * 0.9
          prefHeight : parent.height * 0.95
          label : root.displayFormat(model.name)
          unit : model.unit
          type : model.type
          hintText : model.hint
          entryValidator : root.assignValidator(model.type)
          onInputAccepted : {
            pdData[model.name] = input
          }
        }
        Package.name : "pharmacodynamics"
      }
    }
  }

  ListModel {
    id : substanceListModel
    ListElement {name : "Name"; unit: ""; type : "string"; hint : "*Required"; valid : true}
      ListElement {name : "Classification"; unit : "substanceClass"; type : "enum"; hint : ""; valid : true}
      ListElement {name : "MolarMass";  unit : "molar"; type : "double"; hint : "Enter a value"; valid : true}
      ListElement {name : "Density";  unit : "concentration"; type : "double"; hint : "Enter a value"; valid : true}
      ListElement {name : "MaximumDiffusionFlux"; unit : "massFlux"; type : "double"; hint : "Enter a value"; valid : true}
      ListElement {name : "MichaelisCoefficient";  unit : ""; type : "double"; hint : "Enter a value"; valid : true}
      ListElement {name : "MembraneResistance";  unit : "electricalResistance"; type : "double"; hint : "Enter a value"; valid : true}
      ListElement {name : "RelativeDiffusionCoefficient"; unit : ""; type : "double"; hint : "Enter a value"; valid : true}
      ListElement {name : "SolubilityCoefficient";  unit : "inversePressure"; type : "double"; hint : "Enter a value"; valid : true}
    ListElement {name : "IntrinsicClearance"; unit : "volumetricFlowNorm"; type : "double"; hint : "Enter a value "; valid : true}
      ListElement {name : "RenalClearance"; unit : "volumetricFlowNorm"; type : "double"; hint : "Enter a value "; valid : true}
      ListElement {name : "SystemicClearance"; unit : "volumetricFlowNorm"; type : "double"; hint : "Enter a value "; valid : true}
      ListElement {name : "FractionUnboundInPlasma"; unit : ""; type : "0To1"; hint : "Enter a value [0-1]"; valid : true}
      ListElement {name : "ChargeInBlood"; unit : "charge"; type : "enum"; hint : ""; valid : true}
      ListElement {name : "ReabsorptionRatio"; unit : ""; type : "double"; hint : "Enter a value"; valid : true}     
    ListElement {name : "AcidDissociationConstant"; unit : ""; type : "double"; hint : "Enter a value"; valid : true}     
      ListElement {name : "BindingProtein"; unit : "protein"; type : "enum"; hint : ""; valid : true}     
      ListElement {name : "BloodPlasmaRatio"; unit : ""; type : "double"; hint : "Enter a value"; valid : true}     
      ListElement {name : "FractionUnboundInPlasma"; unit : ""; type : "0To1"; hint : "Enter a value [0-1]"; valid : true} 
      ListElement {name : "IonicState"; unit : "ionicState"; type : "enum"; hint : ""; valid : true} 
      ListElement {name : "LogP"; unit : ""; type : "double"; hint : "Enter a value"; valid : true}
      ListElement {name : "HydrogenBoundCount"; unit : ""; type : "double"; hint : "Enter a value"; valid : true}
      ListElement {name : "PolarSurfaceArea"; unit : ""; type : "double"; hint : "Enter a value"; valid : true}
    ListElement {name : "BonePartitionCoefficient"; unit : ""; type : "double"; hint : "Enter a value"; valid : true}
      ListElement {name : "BrainPartitionCoefficient"; unit : ""; type : "double"; hint : "Enter a value"; valid : true}
      ListElement {name : "FatPartitionCoefficient"; unit : ""; type : "double"; hint : "Enter a value"; valid : true}
      ListElement {name : "GutPartitionCoefficient"; unit : ""; type : "double"; hint : "Enter a value"; valid : true}
      ListElement {name : "LeftKidneyPartitionCoefficient"; unit : ""; type : "double"; hint : "Enter a value"; valid : true}
      ListElement {name : "LeftLungPartitionCoefficient"; unit : ""; type : "double"; hint : "Enter a value"; valid : true}
      ListElement {name : "LiverPartitionCoefficient"; unit : ""; type : "double"; hint : "Enter a value"; valid : true}
      ListElement {name : "MusclePartitionCoefficient"; unit : ""; type : "double"; hint : "Enter a value"; valid : true}
      ListElement {name : "MyocardiumPartitionCoefficient"; unit : ""; type : "double"; hint : "Enter a value"; valid : true}
      ListElement {name : "RightKidneyPartitionCoefficient"; unit : ""; type : "double"; hint : "Enter a value"; valid : true}
      ListElement {name : "RightLungPartitionCoefficient"; unit : ""; type : "double"; hint : "Enter a value"; valid : true}
      ListElement {name : "SkinPartitionCoefficient"; unit : ""; type : "double"; hint : "Enter a value"; valid : true}
      ListElement {name : "SpleenPartitionCoefficient"; unit : ""; type : "double"; hint : "Enter a value"; valid : true}
    ListElement {name : "EC50"; unit : "concentration"; type : "double"; hint : "Enter a value"; valid : true}
      ListElement {name : "ShapeParameter"; unit : ""; type : "double"; hint : "Enter a value"; valid : true}
      ListElement {name : "EffectSiteRateConstant"; unit : "frequency"; type : "double"; hint : "Enter a value"; valid : true}
      ListElement {name : "BronchodilationModifier"; unit : ""; type : "-1To1"; hint : "Enter a value [-1-1]"; valid : true}
      ListElement {name : "DiastolicPressureModifier"; unit : ""; type : "-1to1"; hint : "Enter a value [-1-1]"; valid : true}
      ListElement {name : "SystolicPressureModifier"; unit : ""; type : "-1To1"; hint : "Enter a value [-1-1]"; valid : true}
      ListElement {name : "FeverModifier"; unit : ""; type : "-1To1"; hint : "Enter a value [-1-1]"; valid : true}
      ListElement {name : "HeartRateModifier"; unit : ""; type : "-1to1"; hint : "Enter a value [-1-1]"; valid : true}
      ListElement {name : "HemorrhageModifier"; unit : ""; type : "-1To1"; hint : "Enter a value [-1-1]"; valid : true}
      ListElement {name : "NeuromuscularBlockModifier"; unit : ""; type : "-1To1"; hint : "Enter a value [-1-1]"; valid : true}
      ListElement {name : "PainModifier"; unit : ""; type : "-1to1"; hint : "Enter a value [-1-1]"; valid : true}
      ListElement {name : "RespirationRateModifier"; unit : ""; type : "-1To1"; hint : "Enter a value [-1-1]"; valid : true}
      ListElement {name : "TidalVolumeModifier"; unit : ""; type : "-1To1"; hint : "Enter a value [-1-1]"; valid : true}
      ListElement {name : "SedationModifier"; unit : ""; type : "-1To1"; hint : "Enter a value [-1-1]"; valid : true}
      ListElement {name : "TubularPermeabilityModifier"; unit : ""; type : "-1To1"; hint : "Enter a value [-1-1]"; valid : true}
      ListElement {name : "CentralNervousModifier"; unit : ""; type : "-1To1"; hint : "Enter a value [-1-1]"; valid : true}
      ListElement {name : "AntibacterialEffect"; unit : ""; type : "-1To1"; hint : "Enter a value [-1-1]"; valid : true}
      ListElement {name : "PupillaryResponse"; unit : ""; type : "-1To1"; hint : "Enter a value [-1-1]"; valid : true}
  }


}
/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
 ##^##*/
 