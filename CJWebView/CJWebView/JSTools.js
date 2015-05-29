function GetHTMLEleAtPoint(x,y) {
    var tags = "";
    var e = document.elementFromPoint(x,y);
    if (e.tagName == 'IMG') {
        tags += e.getAttribute('src');
    }
    return tags;
}