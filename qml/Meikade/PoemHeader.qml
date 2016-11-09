/*
    Copyright (C) 2015 Nile Group
    http://nilegroup.org

    Meikade is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Meikade is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

import QtQuick 2.0
import AsemanTools 1.0
import AsemanTools.Awesome 1.0

Item {
    id: poem_header
    width: 100
    height: 190*Devices.density

    property int poemId: -1
    property int poetId: -1
    property int catId: -1
    property bool favorited: false
    property bool toolsOpened: false
    property alias font: txt1.font
    property color color: "#ffffff"

    onPoemIdChanged: {
        privates.signalBlocker = true
        var cat = Database.poemCat(poemId)
        txt1.text = Database.catName(cat)
        txt2.text = Database.poemName(poemId)
        favorited = UserData.isFavorited(poemId,0)

        var poet
        var book
        while( cat ) {
            book = poet
            poet = cat
            cat = Database.parentOf(cat)
        }

        poet_txt.text = Database.catName(poet) + ","
        book_txt.text = Database.catName(book)

        poetId = poet
        catId = book

        privates.signalBlocker = false
    }

    onFavoritedChanged: {
        if( privates.signalBlocker )
            return
        if( favorited ) {
            UserData.favorite(poemId,0)
            main.showTooltip( qsTr("Favorited") )
        } else {
            UserData.unfavorite(poemId,0)
            main.showTooltip( qsTr("Unfavorited") )
        }
    }

    Connections {
        target: UserData
        onFavorited: if(pid == poem_header.poemId && vid == 0) favorited = true
        onUnfavorited: if(pid == poem_header.poemId && vid == 0) favorited = false
    }

    QtObject {
        id: privates
        property bool signalBlocker: false
    }

    Column {
        id: title_column
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.right: parent.right
        spacing: 10*Devices.density

        Text {
            id: txt1
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: 13*globalFontDensity*Devices.fontDensity
            font.family: AsemanApp.globalFont.family
            wrapMode: Text.WordWrap
            color: poem_header.color
            horizontalAlignment: Text.AlignHCenter
        }

        Text {
            id: txt2
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: 13*globalFontDensity*Devices.fontDensity
            font.family: AsemanApp.globalFont.family
            wrapMode: Text.WordWrap
            color: poem_header.color
            horizontalAlignment: Text.AlignHCenter
        }

        Item {
            anchors.left: parent.left
            anchors.right: parent.right
            height: title_column.spacing
        }
    }

    Rectangle {
        id: header
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: 32*Devices.density
        color: "#EC4334"
        state: poem_header.toolsOpened? "toolsOn" : "toolsOff"

        states: [
            State {
                name: "toolsOn"
                AnchorChanges { target: poet_txt; anchors.verticalCenter: header.bottom }
                AnchorChanges { target: book_txt; anchors.verticalCenter: header.bottom }
                AnchorChanges { target: tools_row; anchors.verticalCenter: header.verticalCenter }
            },
            State {
                name: "toolsOff"
                AnchorChanges { target: poet_txt; anchors.verticalCenter: header.verticalCenter }
                AnchorChanges { target: book_txt; anchors.verticalCenter: header.verticalCenter }
                AnchorChanges { target: tools_row; anchors.verticalCenter: header.bottom }
            }
        ]

        transitions: Transition {
            AnchorAnimation { duration: 200 }
        }

        Text {
            id: poet_txt
            anchors.right: View.layoutDirection==Qt.LeftToRight? undefined : parent.right
            anchors.left: View.layoutDirection==Qt.LeftToRight? parent.left : undefined
            anchors.margins: 8*Devices.density
            font.pixelSize: 10*globalFontDensity*Devices.fontDensity
            font.family: AsemanApp.globalFont.family
            wrapMode: TextInput.WordWrap
            color: poem_header.color
            horizontalAlignment: Text.AlignHCenter
            visible: !poem_header.toolsOpened

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    page.backToPoet(poetId)
                }
            }
        }

        Text {
            id: book_txt
            anchors.right: View.layoutDirection==Qt.LeftToRight? undefined : poet_txt.left
            anchors.left: View.layoutDirection==Qt.LeftToRight? poet_txt.right : undefined
            anchors.margins: 8*Devices.density
            font.pixelSize: 10*globalFontDensity*Devices.fontDensity
            font.family: AsemanApp.globalFont.family
            wrapMode: TextInput.WordWrap
            color: poem_header.color
            horizontalAlignment: Text.AlignHCenter
            visible: !poem_header.toolsOpened

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    page.backToCats(catId, poetId)
                }
            }
        }

        Row {
            id: tools_row
            height: 32*Devices.density
            anchors.right: View.layoutDirection==Qt.LeftToRight? undefined : parent.right
            anchors.left: View.layoutDirection==Qt.LeftToRight? parent.left : undefined
            spacing: 1*Devices.density
            visible: poem_header.toolsOpened
            layoutDirection: View.layoutDirection

            Button {
                id: favorite
                height: tools_row.height
                width: height
                normalColor: "#44000000"
                highlightColor: Qt.rgba(0, 0, 0, 0.4)
                iconHeight: 14*Devices.density
                onClicked: poem_header.favorited = !poem_header.favorited

                Text {
                    anchors.centerIn: parent
                    font.pixelSize: 11*globalFontDensity*Devices.fontDensity
                    font.family: Awesome.family
                    color: "white"
                    text: poem_header.favorited? Awesome.fa_heart : Awesome.fa_heart_o
                }
            }

            Button {
                id: share
                height: tools_row.height
                width: height
                normalColor: "#44000000"
                highlightColor: Qt.rgba(0, 0, 0, 0.4)
                iconHeight: 14*Devices.density
                onClicked: {
                    networkFeatures.pushAction( ("Share Poem: %1").arg(poem_header.poemId) )
                    var subject = Database.poemName(poem_header.poemId)
                    var catId = Database.poemCat(poem_header.poemId)
                    while( catId ) {
                        subject = Database.catName(catId) + ", " + subject
                        catId = Database.parentOf(catId)
                    }

                    var message = getPoemText()
                    Devices.share(subject,message)
                }

                Text {
                    anchors.centerIn: parent
                    font.pixelSize: 11*globalFontDensity*Devices.fontDensity
                    font.family: Awesome.family
                    color: "white"
                    text: Awesome.fa_share_alt
                }
            }

            Button {
                id: copy
                height: tools_row.height
                width: height
                normalColor: "#44000000"
                highlightColor: Qt.rgba(0, 0, 0, 0.4)
                iconHeight: 14*Devices.density
                onClicked: {
                    networkFeatures.pushAction( ("Copy Poem: %1").arg(poem_header.poemId) )
                    var message = getPoemText()
                    Devices.clipboard = message
                }

                Text {
                    anchors.centerIn: parent
                    font.pixelSize: 11*globalFontDensity*Devices.fontDensity
                    font.family: Awesome.family
                    color: "white"
                    text: Awesome.fa_copy
                }
            }
        }

        Row {
            id: menu_row
            height: 32*Devices.density
            anchors.right: View.layoutDirection==Qt.LeftToRight? parent.right : undefined
            anchors.left: View.layoutDirection==Qt.LeftToRight? undefined : parent.left
            anchors.verticalCenter: parent.verticalCenter
            spacing: 1*Devices.density

            Button {
                id: menu
                height: menu_row.height
                width: height
                normalColor: "#44000000"
                highlightColor: Qt.rgba(0, 0, 0, 0.4)
                iconHeight: 14*Devices.density
                onClicked: poem_header.toolsOpened = !poem_header.toolsOpened

                Text {
                    anchors.centerIn: parent
                    font.pixelSize: 11*globalFontDensity*Devices.fontDensity
                    font.family: Awesome.family
                    color: "white"
                    text: poem_header.toolsOpened? Awesome.fa_close : Awesome.fa_ellipsis_v
                }
            }
        }
    }

    function getPoemText() {
        var poet
        var catId = Database.poemCat(poem_header.poemId)
        while( catId ) {
            poet = Database.catName(catId)
            catId = Database.parentOf(catId)
        }

        var message = ""
        var vorders = Database.poemVerses(poem_header.poemId)
        for( var i=0; i<vorders.length; i++ ) {
            var vid = vorders[i]
            if( i!=0 && Database.versePosition(poem_header.poemId,vid)===0 && Database.versePosition(poem_header.poemId,vid+1)===1 )
                message = message + "\n"

            message = message + Database.verseText(poem_header.poemId,vorders[i]) + "\n"

        }

        message = message + "\n\n" + poet
        return message
    }
}
