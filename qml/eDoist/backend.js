/* Documentation for the todoist api is at: https://todoist.com/API
 *
 * This file implements all the necessary API calls.
 */

Qt.include("ajax.js");

var api_url = "https://todoist.com/API";
var api_token = "";

var colors = [
        "#bde876",
        "#ff8581",
        "#ffc472",
        "#faed75",
        "#a8c9e5",
        "#999999",
        "#e3a8e5",
        "#dddddd",
        "#fc603c",
        "#ffcc00",
        "#74e8d4",
        "#3cd6fc"
    ];

function login(data, success, error) {

    var url = api_url + "/login";

    var data_string = "email=" + data.email +
        "&password=" + data.password;

    ajax(url, {
         type: "POST",
         data: data_string,
         success: success,
         error: error
    });

}

function getTimezones(success, error) {

    var url = api_url + "/getTimezones";

    ajax(url, {
         type: "GET",
         success: success,
         error: error
    });

}

function register(data, success, error) {

    var url = api_url + "/register";

    ajax(url, {
         type: "POST",
         data: "email=" + encodeURIComponent(data.email) +
         "&full_name=" + encodeURIComponent(data.full_name) +
         "&password=" + encodeURIComponent(data.password) +
         "&timezone=" + encodeURIComponent(data.timezone),
         success: success,
         error: error
    });

}

function updateUser() {}

function getProjects(data, success, error) {

    var url = api_url + "/getProjects";

    var data_string = "token=" + data.token;

    ajax(url, {
         type: "POST",
         data: data_string,
         success: success,
         error: error
    });

}

function getProject() {}

function addProject(data, success, error) {

    var url = api_url + "/addProject"

    var data_string = "token=" + data.token +
        "&name=" + data.name;

    ajax(url, {
         type: "POST",
         data: data_string,
         success: success,
         error: error
    });

}

function updateProject(data, success, error) {

    var url = api_url + "/updateProject"
    var data_string = "token=" + data.token +
        "&project_id=" + data.project_id +
        "&name=" + data.name +
        "&color=" + data.color +
        "&indent=" + data.indent;

    ajax(url, {
         type: "POST",
         data: data_string,
         success: success,
         error: error,
    });

}

function updateProjectOrders(data, success, error) {

    var url = api_url + "/updateProjectOrders"

    ajax(url, {
         type: "POST",
         data: "token=" + data.token + "&item_id_list=" + data.id_list,
         success: success,
         error: error
    });
}

function deleteProject(data, success, error) {

    var url = api_url + "/deleteProject"

    ajax(url, {
         type: "POST",
         data: "token=" + data.token + "&project_id=" + data.project_id,
         success: success,
         error: error
    });

}

function getLabels() {}
function updateLabel() {}
function deleteLabel() {}

function getUncompletedItems(data, success, error) {
    //success('[{"due_date": null, "collapsed": 0, "labels": [], "is_dst": 1, "has_notifications": 0, "checked": 0, "indent": 1, "children": "8501227,8528310", "content": "Sanitering af klubdata.", "user_id": 109607, "mm_offset": 120, "in_history": 0, "id": 8481714, "priority": 1, "item_order": 1, "project_id": 836413, "chains": null, "date_string": "no due date"}, {"due_date": null, "collapsed": 0, "labels": [], "is_dst": 1, "has_notifications": 0, "checked": 0, "indent": 3, "children": "", "content": "Glemt adgangskode skal laves.", "user_id": 109607, "mm_offset": 120, "in_history": 0, "id": 8501227, "priority": 1, "item_order": 2, "project_id": 836413, "chains": null, "date_string": "no due date"}, {"due_date": null, "collapsed": 0, "labels": [], "is_dst": 1, "has_notifications": 0, "checked": 0, "indent": 2, "children": "", "content": "Restyling af admin sektionen.", "user_id": 109607, "mm_offset": 120, "in_history": 0, "id": 8528310, "priority": 1, "item_order": 3, "project_id": 836413, "chains": null, "date_string": "no due date"}, {"due_date": null, "collapsed": 0, "labels": [], "is_dst": 1, "has_notifications": 0, "checked": 0, "indent": 1, "children": "", "content": "Tilføj ejer til klub.", "user_id": 109607, "mm_offset": 120, "in_history": 0, "id": 8550339, "priority": 1, "item_order": 4, "project_id": 836413, "chains": null, "date_string": "no due date"}, {"due_date": null, "collapsed": 0, "labels": [], "is_dst": 1, "has_notifications": 0, "checked": 0, "indent": 1, "children": "", "content": "Visning af de 5/10 nærmeste klubber i et subpanel/boks, samt deres afstand fra adresse.", "user_id": 109607, "mm_offset": 120, "in_history": 0, "id": 8527536, "priority": 2, "item_order": 6, "project_id": 836413, "chains": null, "date_string": "no due date"}, {"due_date": null, "collapsed": 0, "labels": [], "is_dst": 1, "has_notifications": 0, "checked": 0, "indent": 1, "children": "", "content": "Marker flag som ved hover, når et klub navn har mouseover.", "user_id": 109607, "mm_offset": 120, "in_history": 0, "id": 8733586, "priority": 2, "item_order": 7, "project_id": 836413, "chains": null, "date_string": "no due date"}, {"due_date": null, "collapsed": 0, "labels": [], "is_dst": 1, "has_notifications": 0, "checked": 0, "indent": 1, "children": "", "content": "Op/Ned pil på menu bar virker ikke på tværs af postbacks.", "user_id": 109607, "mm_offset": 120, "in_history": 0, "id": 8735188, "priority": 1, "item_order": 8, "project_id": 836413, "chains": null, "date_string": "no due date"}, {"due_date": null, "collapsed": 0, "labels": [], "is_dst": 1, "has_notifications": 0, "checked": 0, "indent": 1, "children": "", "content": "Opdel visning af klubber, så baner og klub-info er i hver sin tab.", "user_id": 109607, "mm_offset": 120, "in_history": 0, "id": 8733526, "priority": 1, "item_order": 9, "project_id": 836413, "chains": null, "date_string": "no due date"}]');
    //return;
    var url = api_url + "/getUncompletedItems";

    ajax(url, {
         type: "POST",
         data: "token=" + data.token + "&project_id=" + data.project_id,
         success: success,
         error: error
    });
}

function getCompletedItems(data, success, error) {
    //success('[{"due_date": null, "collapsed": 0, "labels": [], "is_dst": 1, "has_notifications": 0, "checked": 1, "indent": 1, "children": "", "content": "Klubvisning skal persisteres på tværst af postbacks.", "user_id": 109607, "mm_offset": 120, "in_history": 1, "id": 8733612, "priority": 1, "item_order": 32, "project_id": 836413, "chains": null, "date_string": "no due date"}, {"due_date": null, "collapsed": 0, "labels": [], "is_dst": 1, "has_notifications": 0, "checked": 1, "indent": 1, "children": "", "content": "Tilføj en til mange relation mellem klubber og baner.", "user_id": 109607, "mm_offset": 120, "in_history": 1, "id": 8550344, "priority": 1, "item_order": 31, "project_id": 836413, "chains": null, "date_string": "no due date"}, {"due_date": null, "collapsed": 0, "labels": [], "is_dst": 1, "has_notifications": 0, "checked": 1, "indent": 1, "children": null, "content": "Editering af indpakning og udpakning af serialiseret data.", "user_id": 109607, "mm_offset": 120, "in_history": 1, "id": 8648488, "priority": 1, "item_order": 30, "project_id": 836413, "chains": null, "date_string": "no due date"}, {"due_date": null, "collapsed": 0, "labels": [], "is_dst": 1, "has_notifications": 0, "checked": 1, "indent": 1, "children": "", "content": "Styling af flash.", "user_id": 109607, "mm_offset": 120, "in_history": 1, "id": 8573690, "priority": 1, "item_order": 29, "project_id": 836413, "chains": null, "date_string": "no due date"}, {"due_date": null, "collapsed": 0, "labels": [], "is_dst": 1, "has_notifications": 0, "checked": 1, "indent": 1, "children": "", "content": "Lav store last location, hvis man bliver redirected til login.", "user_id": 109607, "mm_offset": 120, "in_history": 1, "id": 8550374, "priority": 1, "item_order": 28, "project_id": 836413, "chains": null, "date_string": "no due date"}, {"due_date": null, "collapsed": 0, "labels": [], "is_dst": 1, "has_notifications": 0, "checked": 1, "indent": 1, "children": "", "content": "Ret datatyper for klubber, baner, huller.", "user_id": 109607, "mm_offset": 120, "in_history": 1, "id": 8595368, "priority": 1, "item_order": 27, "project_id": 836413, "chains": null, "date_string": "no due date"}, {"due_date": null, "collapsed": 0, "labels": [], "is_dst": 1, "has_notifications": 0, "checked": 1, "indent": 1, "children": "", "content": "Visning af klubber på kortet.", "user_id": 109607, "mm_offset": 120, "in_history": 1, "id": 8527527, "priority": 1, "item_order": 26, "project_id": 836413, "chains": null, "date_string": "no due date"}, {"due_date": null, "collapsed": 0, "labels": [], "is_dst": 1, "has_notifications": 0, "checked": 1, "indent": 1, "children": null, "content": "Visning af klubinfo ved klik.", "user_id": 109607, "mm_offset": 120, "in_history": 1, "id": 8527529, "priority": 1, "item_order": 25, "project_id": 836413, "chains": null, "date_string": "no due date"}, {"due_date": null, "collapsed": 0, "labels": [], "is_dst": 1, "has_notifications": 0, "checked": 1, "indent": 1, "children": "", "content": "Implementer save as is, for interface udseende.", "user_id": 109607, "mm_offset": 120, "in_history": 1, "id": 8488225, "priority": 1, "item_order": 24, "project_id": 836413, "chains": null, "date_string": "no due date"}, {"due_date": null, "collapsed": 0, "labels": [], "is_dst": 1, "has_notifications": 0, "checked": 1, "indent": 1, "children": null, "content": "Style registrer ny bruger.", "user_id": 109607, "mm_offset": 120, "in_history": 1, "id": 8500959, "priority": 1, "item_order": 23, "project_id": 836413, "chains": null, "date_string": "no due date"}, {"due_date": null, "collapsed": 0, "labels": [], "is_dst": 1, "has_notifications": 0, "checked": 1, "indent": 1, "children": null, "content": "Diriger en nyregistreret bruger til profilsiden.", "user_id": 109607, "mm_offset": 120, "in_history": 1, "id": 8501798, "priority": 1, "item_order": 22, "project_id": 836413, "chains": null, "date_string": "no due date"}, {"due_date": null, "collapsed": 0, "labels": [], "is_dst": 1, "has_notifications": 0, "checked": 1, "indent": 1, "children": "", "content": "Fjern toppanel og lav en skuffe istedet.", "user_id": 109607, "mm_offset": 120, "in_history": 1, "id": 8488223, "priority": 1, "item_order": 21, "project_id": 836413, "chains": null, "date_string": "no due date"}, {"due_date": null, "collapsed": 0, "labels": [], "is_dst": 1, "has_notifications": 0, "checked": 1, "indent": 1, "children": "", "content": "Admin del skal lukkes af for ikke admins.", "user_id": 109607, "mm_offset": 120, "in_history": 1, "id": 8487594, "priority": 4, "item_order": 20, "project_id": 836413, "chains": null, "date_string": "no due date"}, {"due_date": null, "collapsed": 0, "labels": [], "is_dst": 1, "has_notifications": 0, "checked": 1, "indent": 1, "children": "", "content": "Lav en bootstrapper, så der er en admin user.", "user_id": 109607, "mm_offset": 120, "in_history": 1, "id": 8487593, "priority": 2, "item_order": 19, "project_id": 836413, "chains": null, "date_string": "no due date"}]');
    //return;
    var url = api_url + "/getCompletedItems";

    ajax(url, {
         type: "POST",
         data: "token=" + data.token + "&project_id=" + data.project_id,
         success: success,
         error: error
    });
}

function getItemsById() {}

function addItem(data, success, error) {

    var url = api_url + "/addItem"

    var data_string = "token=" + data.token +
        "&project_id=" + data.project_id +
        "&content=" + encodeURIComponent(data.content);

    if(data.date_string) {
        data_string += "&date_string=" + encodeURIComponent(data.date_string);
    }

    if(data.priority) {
        data_string += "&priority=" + data.priority;
    }

    if(data.js_date) {
        data_string += "&js_date=" + data.js_date;
    }

    // TODO: Ask for support for this in the backend
    //if(data.indent) {
    //    data_string += "&indent=" + data.indent
    //}

    ajax(url, {
         type: "POST",
         data: data_string,
         success: success,
         error: error
    });

}

function updateItem(data, success, error) {

    var url = api_url + "/updateItem";

    var data_string = "token=" + data.token + "&id=" + data.id;

    if(data.content) {
        data_string += "&content=" + data.content;
    }

    if(data.date_string) {
        data_string += "&date_string=" + data.date_string;
    }

    if(data.priority) {
        data_string += "&priority=" + data.priority;
    }

    if(data.indent) {
        data_string += "&indent=" + data.indent;
    }

    if(data.item_order) {
        data_string += "&item_order=" + data.item_order;
    }

    if(data.collapsed) {
        data_string += "&collapsed=" + data.collapsed;
    }

    if(data.js_date) {
    }

    ajax(url, {
         type: "POST",
         data: data_string,
         success: success,
         error: error
    });

}

function updateOrders(data, success, error) {

    var url = api_url + "/updateOrders";

    var data_string = "token=" + data.token +
        "&project_id=" + data.project_id +
        "&item_id_list=" + data.item_id_list;

    ajax(url, {
         type: "POST",
         data: data_string,
         success: success,
         error: error
    });

}

function moveItems() {}
function updateRecurringDate() {}

function deleteItems(data, success, error) {

    var url = api_url + "/deleteItems";

    var data_string = "token=" + data.token +
        "&project_id=" + data.project_id +
        "&ids=" + data.ids;

    ajax(url, {
         type: "POST",
         data: data_string,
         success: success,
         error: error
    });

}

function completeItems(data, success, error) {

    var url = api_url + "/completeItems"

    var data_string = "token=" + data.token +
        "&ids=" + data.ids;

    ajax(url, {
         type: "POST",
         data: data_string,
         success: success,
         error: error
    });

}

function uncompleteItems(data, success, error) {

    var url = api_url + "/uncompleteItems"

    var data_string = "token=" + data.token +
        "&ids=" + data.ids;

    ajax(url, {
         type: "POST",
         data: data_string,
         success: success,
         error: error
    });

}

function addNote() {}
function deleteNote() {}
function getNotes() {}
function query() {}
