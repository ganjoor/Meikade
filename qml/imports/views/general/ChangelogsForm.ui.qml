import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.MaterialIcons 2.0
import AsemanQml.Controls 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.0
import QtQuick.Controls.IOSStyle 2.0
import globals 1.0
import micros 1.0
import models 1.0

Page {
    id: dis
    width: Constants.width
    height: Constants.height

    property alias textLabel: textLabel
    property alias closeBtn: closeBtn

    AsemanFlickable {
        id: flick
        anchors.top: headerItem.bottom
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.left: parent.left
        flickableDirection: Flickable.VerticalFlick
        contentWidth: scene.width
        contentHeight: scene.height
        bottomMargin: Devices.navigationBarHeight

        Item {
            id: scene
            width: flick.width
            height: Math.max(sceneColumn.height + 20 * Devices.density,
                             flick.height)

            ColumnLayout {
                id: sceneColumn
                anchors.right: parent.right
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.topMargin: 10 * Devices.density
                anchors.margins: 10 * Devices.density
                spacing: 0

                Label {
                    id: textLabel
                    Layout.fillWidth: true
                    font.pixelSize: 9 * Devices.fontDensity
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    horizontalAlignment: Text.AlignLeft
                    Layout.bottomMargin: 10 * Devices.density
                }
            }
        }
    }

    HScrollBar {
        scrollArea: flick
        anchors.top: flick.top
        anchors.bottom: flick.bottom
        anchors.right: flick.right
        color: Colors.primary
    }

    Header {
        id: headerItem
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.left: parent.left
        text: qsTr("ChangeLogs") + Translations.refresher
        color: Colors.primary
        shadow: Devices.isAndroid

        RowLayout {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: 14 * Devices.density
            anchors.rightMargin: 2 * Devices.density
            anchors.bottom: parent.bottom
            height: Devices.standardTitleBarHeight

            RoundButton {
                id: closeBtn
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                text: qsTr("Close") + Translations.refresher
                highlighted: true
                radius: 6 * Devices.density
                font.pixelSize: 8 * Devices.fontDensity
                IOSStyle.accent: Qt.darker(Colors.primary, 1.3)
                Material.accent: Qt.darker(Colors.primary, 1.3)
                Material.theme: Material.Dark
                Material.elevation: 0
            }
        }
    }

    HScrollBar {
        anchors.right: parent.right
        anchors.bottom: flick.bottom
        anchors.top: flick.top
        color: "#fff"
        scrollArea: flick
    }
}
