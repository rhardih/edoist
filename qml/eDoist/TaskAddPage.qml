import QtQuick 1.0
import com.nokia.symbian 1.0
import com.nokia.extras 1.0
import "backend.js" as Todoist

Page {

    property int project_id
    property ListModel tasksListModel
    property ListView tasksListView

    function addItemSuccess(data) {
        //console.log(data);
        infoBanner.close()
        if(data == '"ERROR_PROJECT_NOT_FOUND"') {
            // TODO: Proper handling. (Project could be deleted in the web interface in the meantime?
            addItemError(data);
        } else if (data == '"ERROR_WRONG_DATE_SYNTAX"') {
            // TODO: Proper handling.
            addItemError(data);
        } else {
            var task = JSON.parse(data);
            tasksListModel.append(task);
            tasksListView.positionViewAtIndex(tasksListModel.count - 1, ListView.End);
            listView.currentIndex = tasksListModel.count - 1;
            listView.currentItem.highlightRunning = true;
            pageStack.pop();
        }
    }

    function addItemError(data) {
        infoBanner.close();
        errorBanner.text = "Error adding task";
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
            enabled: contentTextField.text
            onClicked: {
                infoBanner.text = "Adding task"
                infoBanner.open();
                var add_item_data = {
                    token: main.api_token,
                    project_id: project_id,
                    content: contentTextField.text,
                    date_string: dueDateTextField.text,
                    priority: priorityButtonRow.index,
                    js_date: 0
                }
                Todoist.addItem(add_item_data, addItemSuccess, addItemError);

            }

        }

    }

    Column {

        anchors.fill:parent
        anchors.margins: platformStyle.paddingMedium
        spacing: platformStyle.paddingMedium

        Text {
            text: "<b>Add new task</b>"
            font.family: platformStyle.fontFamilyRegular
            font.pixelSize: platformStyle.fontSizeLarge
            color: platformStyle.colorNormalLight
        }

        Rectangle {
            width: parent.width
            height: 1
        }

        TextField {
            id: contentTextField
            anchors.left: parent.left
            anchors.right: parent.right
            placeholderText: "Task description"
        }

        Text {
            text: "Due date:"
            font.family: platformStyle.fontFamilyRegular
            font.pixelSize: platformStyle.fontSizeMedium
            color: platformStyle.colorNormalLight
        }

        TextField {
            id: dueDateTextField
            placeholderText: "No due date"
            anchors.left: parent.left
            anchors.right: parent.right
            enabled: false

            MouseArea {
                id: add
                anchors.fill: parent
                onClicked: {
                    var openAtDate = (dueDateTextField.text ? new Date(dueDateTextField.text) : new Date());
                    tDialog.year = openAtDate.getFullYear();
                    tDialog.month = openAtDate.getMonth() + 1;
                    tDialog.day = openAtDate.getDate();
                    tDialog.open();
                }
            }
        }

        Text {
            text: "Priority"
            font.family: platformStyle.fontFamilyRegular
            font.pixelSize: platformStyle.fontSizeMedium
            color: platformStyle.colorNormalLight
        }

        IndexedButtonRow {

            id: priorityButtonRow

            width: parent.width

        }

    }

    DatePickerDialog {
        id: tDialog
        titleText: "Choose date"
        acceptButtonText: "Ok"
        rejectButtonText: "Cancel"
        onAccepted: {
            var newDueDate = new Date(tDialog.year, tDialog.month - 1, tDialog.day);
            dueDateTextField.text = Qt.formatDate(newDueDate, "MM/dd/yyyy");
        }

    }

}
