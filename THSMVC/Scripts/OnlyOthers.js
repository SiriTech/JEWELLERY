(function ($) {
    $.OnlyOthers = function f(element, openElement) {
        $(element).append('<option value="$">Other</option>');
    }
})(jQuery);