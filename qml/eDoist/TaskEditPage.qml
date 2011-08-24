import QtQuick 1.0
import com.nokia.symbian 1.0
import com.nokia.extras 1.0
import "backend.js" as Todoist

Page {

    id: taskEditPage

    property string content
    property variant due_date
    property int priority // TODO: Is this used?
    property int task_id
    property int project_id
    property int index
    property int indent
    property ListModel tasksListModel

    function updateSuccess(data) {
        //console.log(data);
        var task = JSON.parse(data);
        tasksListModel.set(index, task);
        infoBanner.close();
        pageStack.pop();
    }

    function updateError(data) {
        infoBanner.close();
        errorBanner.text = "Error updating task";
        errorBanner.open();
    }

    function deleteTaskSuccess(data) {
        tasksListModel.remove(index);
        infoBanner.close();
        pageStack.pop();
    }

    function deleteTaskError(data) {
        infoBanner.close();
        errorBanner.text = "Error deleting task";
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
            enabled: contentTextArea.text != content ||
                     dueDateTextField.text != Qt.formatDate(due_date, "MM/dd/yyyy") ||
                     priorityButtonRow.index != priority ||
                     indentSlider.value != indent

            onClicked: {

                infoBanner.text = "Updating task";
                infoBanner.open();

                var update_data = {
                    token: main.api_token,
                    id: task_id,
                    content: contentTextArea.text,
                    date_string: dueDateTextField.text,
                    priority: priorityButtonRow.index,
                    indent: indentSlider.value,
                    // item_order: 1,
                    // collapsed: 0,
                    js_date: 0
            };
                Todoist.updateItem(update_data, updateSuccess, updateError);
            }

        }
        ToolButton {
            iconSource: "toolbar-delete"
            onClicked: {
                deleteDialog.open();
            }
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
                text: "<b>Edit task</b>"
                font.family: platformStyle.fontFamilyRegular
                font.pixelSize: platformStyle.fontSizeLarge
                color: platformStyle.colorNormalLight
            }

            Rectangle {
                width: parent.width
                height: 1
            }

            Text {
                text: "Content:"
                font.family: platformStyle.fontFamilyRegular
                font.pixelSize: platformStyle.fontSizeMedium
                color: platformStyle.colorNormalLight
            }

            TextArea {
                id: contentTextArea
                width: parent.width
                text: content
            }

            Text {
                text: "Due date:"
                font.family: platformStyle.fontFamilyRegular
                font.pixelSize: platformStyle.fontSizeMedium
                color: platformStyle.colorNormalLight
            }

            TextField {

                id: dueDateTextField

                width: parent.width
                placeholderText: "no due date"
                enabled: false
                text: due_date ?  Qt.formatDate(due_date, "MM/dd/yyyy") : ""

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
                text: "Priority:"
                font.family: platformStyle.fontFamilyRegular
                font.pixelSize: platformStyle.fontSizeMedium
                color: platformStyle.colorNormalLight
            }

            IndexedButtonRow {

                id: priorityButtonRow

                width: parent.width
                index: taskEditPage.priority

            }

            Text {
                text: "Indent:"
                font.family: platformStyle.fontFamilyRegular
                font.pixelSize: platformStyle.fontSizeMedium
                color: platformStyle.colorNormalLight
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

    QueryDialog {

        id: deleteDialog

        titleText: "Delete task"
        message: "Are you sure you wish to delete this task?"
        acceptButtonText: "Yes"
        rejectButtonText: "No"

        onAccepted: {
            var delete_data = {
                token: main.api_token,
                project_id: project_id,
                ids: JSON.stringify([task_id])
        };
            infoBanner.text = "Deleting task"
            infoBanner.open();
            Todoist.deleteItems(delete_data, deleteTaskSuccess, deleteTaskError);
        }

    }

}
