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

function getRectForSelectedText() {
    var selection = window.getSelection();
    var range = selection.getRangeAt(0);
    var rect = range.getBoundingClientRect();
    return "{{" + rect.left + "," + rect.top + "}, {" + rect.width + "," + rect.height + "}}";
}

jQuery(function(){
       jQuery(document.body).bind('mouseup', function(e){
                                  var selection;
                                  if (window.getSelection) {
                                    selection = window.getSelection();
                                  } else if (document.selection) {
                                    selection = document.selection.createRange();
                                  }
                                  
                                  select_element = selection;
                                  var start_element  = select_element.baseNode.parentNode;
                                  if(start_element.nodeName === 'HTML' || start_element.nodeName === 'BODY'
                                     || (jQuery(start_element).attr('class') == 'usfm-m-tag' && start_element.nodeName === 'DIV')
                                     ){
                                    return true;
                                  }
                                  
                                  var end_element = select_element.extentNode.parentNode;
                                  var range = document.createRange();
                                  range.selectNodeContents(start_element);
                                  select_element.addRange(range);
                                  range.selectNodeContents(end_element);
                                  select_element.addRange(range);
                                  });
});
