$.fn.selectRange = function(start, end) {
    return this.each(function() {
        if (typeof end == "undefined") {
            end = start;
        }
        if (start == -1) {
            start = this.value.length;
        }
        if (end == -1) {
            end = this.value.length;
        }
        if (this.setSelectionRange) {
            this.focus();
            this.setSelectionRange(start, end);
        }
        else if (this.createTextRange) {
            var range = this.createTextRange();
            range.collapse(true);
            range.moveEnd('character', end);
            range.moveStart('character', start);
            range.select();
        }
    });
};