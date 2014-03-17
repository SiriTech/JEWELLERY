(function ($) {
    $.Others = function f(element, openElement, options) {
        $(element).append('<option value="$">Other</option>');
        $(element).change(function (e) {
            if ($(element).find(":selected").text() == "Other") {
                $(options.HeaderElement).text(options.popupHeader);
                $(options.labelElement).text(options.labelText);
                $(options.saveButtonElement).attr("value", options.saveButtonText);
                $(options.cancelButtonElement).attr("value", options.cancelButtonText);
                $(options.popupHiddenElement).val(options.popupHidden);
                $(options.popupOptionalElement).val(options.popupOptional);
                $("#hdnSelectElement").val(element);
                $("#hdnBeforeOptional").val("");
                $("#hdnBeforeOptionalName").val("");
                ClearMsg();
                $("#" + openElement + " input[type=text]").val("");
                //popup(openElement);
                $("#" + openElement).modal({close: false});
                $("#" + openElement + " input[type=text]").focus();
            }
        });
    }
    $.Others.options = {
        // Header text to be shown on popup header
        popupHeader: "",

        //maintain the element in popup, for further operations on select element
        popupHiddenSelectElement: "#hdnSelectElement",

        // Hidden field to maintain the control name
        popupHidden: "MasterTableName",

        //Popup hidden element
        popupHiddenElement: "#hdnVal",

        // Option value
        popupOptional: "ChildMasterTableName",

        //popup hidden optional element
        popupOptionalElement: "#hdnOptional",

        // label text for popup element
        labelText: "Enter value for Other",

        //Save button element
        saveButtonElement: "#btnpopupOtherSave",

        //Cancel button element
        cancelButtonElement: "#btnpopupOtherCancel",

        // save button text
        saveButtonText: "Ok",

        //Cancel button text
        cancelButtonText: "Cancel",

        //Default header element in popup
        HeaderElement: "#spnpopupOtherHeader",

        //Default label element in popup
        labelElement: "#spnLeft"

    };
})(jQuery);