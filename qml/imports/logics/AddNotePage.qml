import QtQuick 2.0
import AsemanQml.Base 2.0
import AsemanQml.Viewport 2.0
import models 1.0
import views 1.0
import requests 1.0
import queries 1.0
import globals 1.0

AddNoteView {
    id: home

    property alias poetId: createAction.poetId
    property alias poemId: createAction.poemId
    property alias catId: createAction.catId
    property alias verseId: createAction.verseId

    signal saved(string text)

    closeBtn.onClicked: home.ViewportType.open = false;
    confirmBtn.onClicked: confirm()

    noteField.onCursorRectangleChanged: ensureVisible(noteField.cursorRectangle)

    function ensureVisible(r)
    {
        var zeroY = noteField.mapToItem(scene, 0, 0).y;
        var rY = zeroY + r.y;
        if (home.flick.contentY >= rY - zeroY)
            home.flick.contentY = rY - zeroY;
        else if (home.flick.contentY + home.flick.height <= rY + r.height + keyboardHeight)
            home.flick.contentY = rY + r.height + keyboardHeight - home.flick.height;
    }

    function confirm() {
        var extra = {
            "public": false
        };

        var text = noteField.text.trim();

        createAction.value = text;
        createAction.declined = (text.length? 0 : 1)
        createAction.extra = Tools.variantToJson(extra, true);
        createAction.pushAction();

        GlobalSignals.notesRefreshed()
        home.ViewportType.open = false;

        home.saved(text);
    }

    UserActions {
        id: createAction
        type: UserActions.TypeNote
        poemId: 0
        poetId: 0
        declined: 0
        Component.onCompleted: {
            fetch()
            home.noteField.text = value;
        }
    }
}
