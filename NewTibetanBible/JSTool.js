function MyAppGetHTMLElementsAtPoint() {
// Note Begin
    var element =  window.getSelection().anchorNode.parentNode;
    return element.id;
}

function SelectText(containerid) {
    if (document.selection) {
        var range = document.body.createTextRange();
        range.moveToElementText(document.getElementById(containerid));
        range.select();
    } else if (window.getSelection) {
        var range = document.createRange();
        range.selectNode(document.getElementById(containerid));
        window.getSelection().addRange(range);
    }
}

function gText(e) {
    var select_element = document.getSelection();
    var start_element   = select_element.baseNode.parentNode;
    if(start_element.nodeName === 'BODY'){
        return true;
    }
    var end_element = select_element.extentNode.parentNode;
    var range = document.createRange();
    range.selectNodeContents(start_element);
    select_element.addRange(range);
    range.selectNodeContents(end_element);
    select_element.addRange(range);
}


document.onmouseup = gText();
if (!document.all) document.captureEvents(Event.MOUSEUP);
