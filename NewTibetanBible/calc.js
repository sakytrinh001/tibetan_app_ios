var getYPos = function(chapNumber) {
    var elementId = 'c-' + chapNumber;
    var elOffSet = document.getElementById(elementId).getBoundingClientRect();
    return elOffSet.top;
};

var getHighLightYPosition = function(verseId) {
    var elOffSet = document.getElementById(verseId).getBoundingClientRect();
    return elOffSet.top;
}

var getYPositionVerse = function(verseId) {
    var elOffSet = document.getElementById(verseId).getBoundingClientRect();
    return elOffSet.top;
}


var scrollYPos = function(yPos) {
    window.scroll(0,yPos);
}

var scrollYPos = function(yPos) {
    window.scroll(0,yPos);
}

var stylizeHighlightedString = function(highLightId) {
    var text        = window.getSelection();
    var selectedText    = text.anchorNode.textContent.substr(text.anchorOffset, text.focusOffset - text.anchorOffset);
    var element =  window.getSelection().anchorNode.parentNode;
    element.className = 'uiWebviewHighlight';
    return selectedText;
}

var stylizeRemoveHighlightedString = function(highLightId) {
    var text        = window.getSelection();
    var selectedText    = text.anchorNode.textContent.substr(text.anchorOffset, text.focusOffset - text.anchorOffset);
    var element =  window.getSelection().anchorNode.parentNode;
    element.className = '';
    return selectedText;
}

var getSelectedText = function() {
    var text        = window.getSelection();
    var selectedText    = text.anchorNode.textContent.substr(text.anchorOffset, text.focusOffset - text.anchorOffset);
    return selectedText;
}


var getSelectedTexted = function() {
    var text        = window.getSelection();
    var selectedText    = text.anchorNode.parentNode;
    return selectedText;
}

var GetVerseIdSelected = function() {
    // Note Begin
    var element =  window.getSelection().anchorNode.parentNode;
    return element.id;
}

var RemoveHighLight = function(verseId) {
    var element = document.getElementById(verseId);
    element.className = '';
}

var GetTextContenById = function(idOfElement) {
    return document.getElementById(idOfElement).innerHTML;
}
