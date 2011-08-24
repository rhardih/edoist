import QtQuick 1.0
import com.nokia.symbian 1.0
import com.nokia.extras 1.0
import "storage.js" as Storage

Window {

    id: main

    property string api_token
    property int listRefreshBound

    PageStack {
        id: pageStack
        toolBar: commonToolBar
        anchors {
            left: parent.left;
            right: parent.right;
            top: parent.top;
            bottom: commonToolBar.top
        }
    }

    InfoBanner {

        id: infoBanner

        property alias showBusy: busyIndicator.visible
        timeout: 0

        BusyIndicator {

            id: busyIndicator

            running: true
            anchors.right: parent.right
            anchors.rightMargin: platformStyle.paddingMedium
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    InfoBanner {

        id: errorBanner
        iconSource: "images/warning.svg"

        timeout: 0
    }

    ToolBar {
        id: commonToolBar
        anchors.bottom: parent.bottom
        visible: false
    }

    Component.onCompleted: {

        Storage.initialize();
        main.api_token = Storage.getSetting("api_token");

        if(main.api_token == "Unknown") {
            pageStack.push(Qt.resolvedUrl("LoginPage.qml"));
        } else {
            commonToolBar.visible = true;
            pageStack.push(Qt.resolvedUrl("ProjectsPage.qml"));
        }

    }

    states: [
        State {
            name: "Portrait"
            when: screen.currentOrientation === Screen.Portrait ||
                  screen.currentOrientation === Screen.PortraitInverted
            PropertyChanges {
                target: main
                listRefreshBound: 140
            }

        },
        State {
            name: "Landscape"
            when: screen.currentOrientation === Screen.Landscape ||
                  screen.currentOrientation === Screen.LandscapeInverted
            PropertyChanges {
                target: main
                listRefreshBound: 70
            }

        }

    ]

}
