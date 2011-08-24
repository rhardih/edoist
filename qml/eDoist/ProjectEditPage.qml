import QtQuick 1.0
import com.nokia.symbian 1.0
import "backend.js" as Todoist

Page {

    id: projectEditPage

    property string name
    property string color
    property int indent
    property int project_id
    property int index

    property ListModel projectsListModel

    function deleteProjectSuccess(data) {
        projectsListModel.remove(index);
        infoBanner.close();
        pageStack.pop();
    }

    function deleteProjectError(data) {
        errorBanner.text = "Error deleting project."
        errorBanner.open();
    }

    function updateProjectSuccess(data) {
        //console.log(data);
        if(data == '"ERROR_PROJECT_NOT_FOUND"') {
            updateProjectError(data);
        } else {
            var project = JSON.parse(data);
            projectsListModel.set(index, project);
            infoBanner.close();
            pageStack.pop();
        }
    }

    function updateProjectError(data) {
        infoBanner.close();
        errorBanner.text = "Error updating project."
        errorBanner.open();
    }

    tools: ToolBarLayout {

        ToolButton {
            iconSource: "toolbar-back"
            flat: true
            onClicked: pageStack.pop()
        }

        ToolButton {
            text: "Save"
            enabled: nameTextArea.text != name ||
                     colorGrid.selectedColor != color ||
                     indentSlider.value != indent

            onClicked: {

                infoBanner.text = "Updating project";
                infoBanner.open();

                var update_data = {
                    project_id: project_id,
                    token: main.api_token,
                    name: nameTextArea.text,
                    color: colorGrid.selectedColor,
                    indent: indentSlider.value
                };
                Todoist.updateProject(update_data, updateProjectSuccess, updateProjectError);

            }

        }

        ToolButton {
            iconSource: "toolbar-delete"
            flat: true
            onClicked: deleteDialog.open()
        }

    }

    Flickable {

        id: flickableContent

        anchors.fill: parent
        anchors.leftMargin: platformStyle.paddingMedium
        anchors.rightMargin: platformStyle.paddingMedium
        contentHeight: contentColumn.height

        Column {

            id: contentColumn

            width: parent.width
            spacing: platformStyle.paddingMedium

            Text {
                text: "<b>Edit project</b>"
                font.family: platformStyle.fontFamilyRegular
                font.pixelSize: platformStyle.fontSizeLarge
                color: platformStyle.colorNormalLight
            }

            Rectangle {
                width: parent.width
                height: 1
            }

            Text {
                text: "Name:"
                font.family: platformStyle.fontFamilyRegular
                font.pixelSize: platformStyle.fontSizeMedium
                color: platformStyle.colorNormalLight
            }

            TextArea {
                id: nameTextArea
                width: parent.width
                text: name
            }

            Text {
                text: "Color:"
                font.family: platformStyle.fontFamilyRegular
                font.pixelSize: platformStyle.fontSizeMedium
                color: platformStyle.colorNormalLight
            }

            Flow {

                id: colorGrid

                property string selectedColor: color

                width: parent.width
                spacing: platformStyle.paddingMedium

                Repeater {

                    model: Todoist.colors

                    Rectangle {

                        id: colorRect

                        height : width
                        color: modelData
                        border.width: colorGrid.selectedColor == modelData ? 4 : 0
                        border.color: colorGrid.selectedColor == modelData ? platformStyle.colorHighlighted : "transparent"

                        MouseArea {

                            anchors.fill: parent

                            onClicked: {
                                colorGrid.selectedColor = modelData
                            }

                        }

                        states: [
                            State {
                                name: "4x3"
                                when: main.state === "Portrait"
                                PropertyChanges {
                                    target: colorRect
                                    width: (parent.width - 3 * platformStyle.paddingMedium) / 4
                                }
                            },
                            State {
                                name: "6x2"
                                when: main.state === "Landscape"

                                PropertyChanges {
                                    target: colorRect
                                    width: (colorGrid.width - 5 * platformStyle.paddingMedium) / 6
                                }

                            }

                        ]

                    }

                }

            }

            Text {

                id: indentText

                text: "Indent:"
                font.family: platformStyle.fontFamilyRegular
                font.pixelSize: platformStyle.fontSizeMedium
                color: platformStyle.colorNormalLight

                ToolTip {
                    text: "Indent: Indentation in list of projects."
                    target: indentText
                    visible: indentTextMouseArea.pressed
                }

                MouseArea {
                    id: indentTextMouseArea
                    anchors.fill: parent
                }

            }

            ValueSlider {

                id: indentSlider

                width: parent.width
                maximumValue: 4
                minimumValue: 1
                value: indent
                stepSize: 1

            }

        }

    }

    QueryDialog {

        id: deleteDialog

        titleText: "Delete project"
        message: "Are you sure you wish to delete this project?"
        acceptButtonText: "Yes"
        rejectButtonText: "No"

        onAccepted: {
            var delete_data = {
                token: main.api_token,
                project_id: project_id
            };
            infoBanner.text = "Deleting project."
            infoBanner.open();
            Todoist.deleteProject(delete_data, deleteProjectSuccess, deleteProjectSuccess);
        }

    }

}
