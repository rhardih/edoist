import QtQuick 1.0
import com.nokia.symbian 1.0

Page {

    id: aboutPage

    tools: ToolBarLayout {

        ToolButton {

            iconSource: "toolbar-back";

            onClicked: {
                pageStack.pop();
            }

        }

    }


    Flickable {

        anchors.fill:parent
        anchors.margins: platformStyle.paddingMedium
        contentHeight: contentColumn.height

        Column {

            id: contentColumn

            width: parent.width
            spacing: platformStyle.paddingMedium

            Text {

                text: "<b>About</b>"
                font.family: platformStyle.fontFamilyRegular
                font.pixelSize: platformStyle.fontSizeLarge
                color: platformStyle.colorNormalLight

            }

            Rectangle {

                width: parent.width
                height: 1

            }

            Text {

                width: parent.width
                text: "éDoist"
                font.family: platformStyle.fontFamilyRegular
                font.pixelSize: platformStyle.fontSizeLarge
                color: platformStyle.colorNormalLight

            }

            Text {

                width: parent.width
                text: "1.0.0"
                font.family: platformStyle.fontFamilyRegular
                font.pixelSize: platformStyle.fontSizeSmall
                color: platformStyle.colorNormalLight

            }

            Text {

                width: parent.width
                text: "http://éncoder.dk/édoist"
                font.family: platformStyle.fontFamilyRegular
                font.pixelSize: platformStyle.fontSizeSmall
                color: platformStyle.colorNormalLight

            }

            Text {

                width: parent.width
                text: "This program is provided as is with no warranty of any kind, including the warranty of design, merchantability and fitness for a particular purpose."
                font.family: platformStyle.fontFamilyRegular
                font.pixelSize: platformStyle.fontSizeSmall
                color: platformStyle.colorNormalLight
                wrapMode: Text.WordWrap

            }

        }

    }

}
