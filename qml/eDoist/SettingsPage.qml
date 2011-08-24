import QtQuick 1.0
import com.nokia.symbian 1.0
import "storage.js" as Storage

Page {

    id: settingsPage

    tools: ToolBarLayout {
        ToolButton {
            iconSource: "toolbar-back";
            onClicked: {
                infoBanner.showBusy = true;
                infoBanner.timeout = 0;
                pageStack.pop();
            }
        }
    }

    Flickable {

        anchors.fill: parent
        anchors.margins: platformStyle.paddingMedium
        contentHeight: contentColumn.height


        Flow {

            id: contentColumn

            width: parent.width
            spacing: platformStyle.paddingMedium

            Text {

                id: titleText

                text: "<b>Settings</b>"
                width: parent.width
                font.family: platformStyle.fontFamilyRegular
                font.pixelSize: platformStyle.fontSizeLarge
                color: platformStyle.colorNormalLight
            }

            Rectangle {
                width: parent.width
                height: 1
            }

            Text {

                id: infoText

                width: parent.width
                text: "Your API token is what allows the application to interact with todoist.com. The application stores this key, so you don't need to log in every time you open the application. If you wish to reissue this key, you can invalidate it and you will then be asked to log in, next time you open up the application."
                font.family: platformStyle.fontFamilyRegular
                font.pixelSize: platformStyle.fontSizeLarge
                color: platformStyle.colorNormalLight
                wrapMode: Text.WordWrap
            }

            Text {
                text: "API token:"
                font.family: platformStyle.fontFamilyRegular
                font.pixelSize: platformStyle.fontSizeMedium
                color: platformStyle.colorNormalLight
            }

            TextArea {
                id: apiTokenTextField
                enabled: false
                width: parent.width
            }

            Button {
                width: parent.width
                text: "Invalidate token"

                onClicked: {
                    Storage.initialize();
                    Storage.setSetting("api_token", "Unknown");
                    infoBanner.text = "Api token invalidated."
                    infoBanner.showBusy = false;
                    infoBanner.timeout = 2000;
                    infoBanner.open();
                }

            }

        }

    }

    Component.onCompleted: {
        Storage.initialize();
        apiTokenTextField.text = Storage.getSetting("api_token");
    }

}
