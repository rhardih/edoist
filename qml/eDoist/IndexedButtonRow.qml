import QtQuick 1.0
import com.nokia.symbian 1.0

ButtonRow {

    function indexToButton() {
        switch(index) {
            case 1: return b1;
            case 2: return b2;
            case 3: return b3;
            case 4: return b4;
            default: return b1;
        }
    }

    property int index

    checkedButton: indexToButton()

    Button {

        id: b1

        text: "1"

        onClicked: { index = 1; }

    }

    Button {

        id: b2

        checked: true
        text: "2"

        onClicked: { index = 2; }

    }

    Button {

        id: b3

        text: "3"

        onClicked: { index = 3; }

    }

    Button {

        id: b4

        text: "4"

        onClicked: { index = 4; }

    }

}
