import QtQuick 1.0
import com.nokia.symbian 1.0

Page {

    id: helpPage

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

                text: "<b>Help</b>"
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
                text: "The following applies to:\n - List of projects.\n - List of tasks."
                font.family: platformStyle.fontFamilyRegular
                font.pixelSize: platformStyle.fontSizeSmall
                color: platformStyle.colorNormalLink
                wrapMode: Text.WordWrap

            }

            Text {

                width: parent.width
                text: "Drag to update:"
                font.family: platformStyle.fontFamilyRegular
                font.pixelSize: platformStyle.fontSizeLarge
                color: platformStyle.colorNormalLight

            }

            Text {

                width: parent.width
                text: "When the list is positioned at the first element, dragging the list further downwards a certain distance will initiates a \"refresh\" of the list content."
                font.family: platformStyle.fontFamilyRegular
                font.pixelSize: platformStyle.fontSizeMedium
                color: platformStyle.colorNormalLight
                wrapMode: Text.WordWrap

            }

            Text {

                width: parent.width
                text: "Editing:"
                font.family: platformStyle.fontFamilyRegular
                font.pixelSize: platformStyle.fontSizeLarge
                color: platformStyle.colorNormalLight

            }

            Text {

                width: parent.width
                text: "In order to get to the editing screen for a project or a task, simply do a \"long-press\", ~ 1s, on the corresponding list item."
                font.family: platformStyle.fontFamilyRegular
                font.pixelSize: platformStyle.fontSizeMedium
                color: platformStyle.colorNormalLight
                wrapMode: Text.WordWrap

            }

            Text {

                width: parent.width
                text: "Reordering:"
                font.family: platformStyle.fontFamilyRegular
                font.pixelSize: platformStyle.fontSizeLarge
                color: platformStyle.colorNormalLight

            }

            Text {

                width: parent.width
                text: "To reorder items on the list, the list must first be put into \"reorder\" mode. This is done by toggling the button in the toolbar shaped as an up and down arrow. When the list is in reorder mode, simply drag and release any item and it will reposition that item within the list."
                font.family: platformStyle.fontFamilyRegular
                font.pixelSize: platformStyle.fontSizeMedium
                color: platformStyle.colorNormalLight
                wrapMode: Text.WordWrap

            }

            Text {

                width: parent.width
                text: "The following applies to:\n - List of tasks."
                font.family: platformStyle.fontFamilyRegular
                font.pixelSize: platformStyle.fontSizeSmall
                color: platformStyle.colorNormalLink
                wrapMode: Text.WordWrap

            }

            Text {

                width: parent.width
                text: "Completed tasks:"
                font.family: platformStyle.fontFamilyRegular
                font.pixelSize: platformStyle.fontSizeLarge
                color: platformStyle.colorNormalLight

            }

            Text {

                width: parent.width
                text: "In order to load completed tasks, press the middle button in the toolbar, the one that looks like a bulleted list. This will append the completed tasks to the end of the list."
                font.family: platformStyle.fontFamilyRegular
                font.pixelSize: platformStyle.fontSizeMedium
                color: platformStyle.colorNormalLight
                wrapMode: Text.WordWrap

            }

        }

    }

}
