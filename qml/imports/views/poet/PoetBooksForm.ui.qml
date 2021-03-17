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

Item {
    id: booksList
    width: Constants.width
    height: Constants.height

    property alias listView: listView
    property alias headerItem: headerItem
    property alias headerBtn: headerBtn
    property alias navigationRepeater: navigationRepeater
    property alias menuBtn: menuBtn
    property alias avatar: avatar
    property alias avatarBtn: avatarBtn
    property alias progressBar: progressBar

    property bool readWriteMode: false
    property bool poemAddMode: true
    property bool bookAddMode: true

    property real progress: progressBar.progress

    signal navigationClicked(string link, int index)
    signal addBookRequest()
    signal addPoemRequest()

    Rectangle {
        anchors.fill: parent
        color: Colors.deepBackground
    }

    ReloadItem {
        id: busyIndicator
        anchors.centerIn: parent
        viewItem: listView
    }

    FlexiList {
        id: listView
        anchors.top: headerItem.bottom
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.left: parent.left

        topMargin: 12 * Devices.density

        footer: Item {
            width: listView.width
            height: (readWriteMode? addColumn.height + 40 * Devices.density : 0) + 4 * Devices.density + Devices.navigationBarHeight

            ColumnLayout {
                id: addColumn
                anchors.left: parent.left
                anchors.right: parent.right
                y: 20 * Devices.density
                visible: readWriteMode
                spacing: 4 * Devices.density

                Label {
                    Layout.fillWidth: true
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: 8 * Devices.fontDensity
                    text: qsTr("To add new poem please tap on the below button.") + Translations.refresher
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    opacity: 0.7
                    visible: poemAddMode
                }

                RoundButton {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredWidth: addRow.width + 60 * Devices.density
                    highlighted: true
                    IOSStyle.accent: Colors.primary
                    Material.accent: Colors.primary
                    visible: poemAddMode

                    Connections {
                        onClicked: addPoemRequest()
                    }

                    RowLayout {
                        id: addRow
                        x: 30 * Devices.density
                        anchors.verticalCenter: parent.verticalCenter

                        Label {
                            font.pixelSize: 12 * Devices.fontDensity
                            font.family: MaterialIcons.family
                            text: MaterialIcons.mdi_plus
                            color: "#fff"
                        }

                        Label {
                            text: qsTr("New Poem") + Translations.refresher
                            font.pixelSize: 9 * Devices.fontDensity
                            color: "#fff"
                        }
                    }
                }

                Label {
                    visible: bookAddMode
                    Layout.topMargin: poemAddMode? 20 * Devices.density : 0
                    Layout.fillWidth: true
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: 8 * Devices.fontDensity
                    text: qsTr("if you want to add a sub-book category, please tap on the below button.") + Translations.refresher
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    opacity: 0.7
                }

                RoundButton {
                    visible: bookAddMode
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredWidth: addSubBookRow.width + 60 * Devices.density
                    highlighted: true
                    IOSStyle.accent: Colors.primary
                    Material.accent: Colors.primary

                    Connections {
                        onClicked: addBookRequest()
                    }

                    RowLayout {
                        id: addSubBookRow
                        x: 30 * Devices.density
                        anchors.verticalCenter: parent.verticalCenter

                        Label {
                            font.pixelSize: 12 * Devices.fontDensity
                            font.family: MaterialIcons.family
                            text: MaterialIcons.mdi_plus
                            color: "#fff"
                        }

                        Label {
                            text: qsTr("New Book") + Translations.refresher
                            font.pixelSize: 9 * Devices.fontDensity
                            color: "#fff"
                        }
                    }
                }
            }
        }
    }

    Header {
        id: headerItem
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.left: parent.left
        color: Colors.header
        shadow: Devices.isAndroid

        RowLayout {
            anchors.fill: parent
            anchors.topMargin: Devices.statusBarHeight
            spacing: 4 * Devices.density

            HeaderMenuButton {
                id: headerBtn
                ratio: 1
            }

            Item {
                Layout.preferredWidth: 32 * Devices.density
                Layout.preferredHeight: 32 * Devices.density
                Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter

                RoundedItem {
                    radius: Constants.radius
                    width: parent.width * 2
                    height: parent.height * 2
                    anchors.centerIn: parent
                    scale: 0.5
                    visible: !AsemanGlobals.testPoetImagesDisable

                    Rectangle {
                        anchors.fill: parent
                        color: Colors.background
                        visible: avatar.status != Image.Ready
                    }

                    Label {
                        anchors.centerIn: parent
                        color: Colors.primary
                        font.pixelSize: 36 * Devices.fontDensity
                        font.family: MaterialIcons.family
                        text: MaterialIcons.mdi_account
                    }

                    CachedImage {
                        id: avatar
                        anchors.fill: parent
                        sourceSize.width: width * 1.2
                        sourceSize.height: height * 1.2
                        fillMode: Image.PreserveAspectCrop
                    }

                    ItemDelegate {
                        id: avatarBtn
                        anchors.fill: parent
                    }
                }
            }

            Flickable {
                id: navFlick
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.leftMargin: 8 * Devices.density
                flickableDirection: Flickable.HorizontalFlick
                contentWidth: navScene.width
                contentHeight: navScene.height
                clip: true

                Item {
                    id: navScene
                    height: navFlick.height
                    width: Math.max(navFlick.width, navRow.width)

                    RowLayout {
                        id: navRow
                        height: parent.height
                        anchors.left: parent.left
                        spacing: 4 * Devices.density

                        Repeater {
                            id: navigationRepeater
                            model: ListModel {
                                ListElement {
                                    title: "Hello"
                                }
                                ListElement {
                                    title: "World"
                                }
                            }

                            RowLayout {
                                spacing: 0
                                Layout.alignment: Qt.AlignVCenter

                                Label {
                                    font.family: MaterialIcons.family
                                    text: LayoutMirroring.enabled? MaterialIcons.mdi_chevron_left : MaterialIcons.mdi_chevron_right
                                    font.pixelSize: 14 * Devices.fontDensity
                                    color: Colors.headerText
                                }

                                Label {
                                    text: model.title
                                    font.pixelSize: 9 * Devices.fontDensity
                                    color: Colors.headerText
                                    maximumLineCount: 1
                                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                                    elide: Text.ElideRight

                                    ItemDelegate {
                                        id: navDel
                                        anchors.fill: parent
                                        anchors.margins: -14 * Devices.density
                                        z: -1

                                        Connections {
                                            target: navDel
                                            onClicked: booksList.navigationClicked(model.link, model.index)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }

            MinimalProgressBar {
                id: progressBar
            }

            ItemDelegate {
                id: menuBtn
                Layout.preferredHeight: Devices.standardTitleBarHeight
                Layout.preferredWidth: Devices.standardTitleBarHeight

                Label {
                    anchors.centerIn: parent
                    font.family: MaterialIcons.family
                    font.pixelSize: 14 * Devices.fontDensity
                    text: MaterialIcons.mdi_dots_vertical
                    color: Colors.headerText
                }
            }
        }
    }

    HScrollBar {
        anchors.right: parent.right
        anchors.bottom: listView.bottom
        anchors.top: listView.top
        color: Colors.primary
        scrollArea: listView
    }
}
