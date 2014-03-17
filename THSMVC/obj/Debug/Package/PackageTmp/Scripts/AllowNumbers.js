jQuery.fn.ForceNumericOnly =
 function () {
     return this.each(function () {
         $(this).keydown(function (e) {
                 var key;
                 var keychar;

                 if (window.event) {
                     key = window.event.keyCode;
                 }
                 else if (e) {
                     key = e.which;
                 }
                 else {
                     return true;
                 }
                 keychar = String.fromCharCode(key);

                 if ((key == null) || (key == 0) || (key == 8) || (key == 9) || (key == 13) || (key == 27)) {
                     return true;
                 }
                 else if ((("0123456789").indexOf(keychar) > -1)) {
                     return true;
                 }
                 else
                     return false;
         });
     });
 };
 jQuery.fn.ForceAlphabetsOnly =
 function () {
     return this.each(function () {
         $(this).keydown(function (e) {
             var key = e.charCode || e.keyCode || 0;
             if (key == 46 || key == 8 || key == 9 || key == 27 || (key >= 35 && key <= 39))
                 return;
             if (key < 65 /* a */ || key > 90 /* z */ && key < 97 /* a */ || key > 122 /* z */) {
                 e.preventDefault();
             }

         });
     });
 };
 jQuery.fn.ForceSymbolsOnly =
 function () {
     return this.each(function () {
         $(this).keydown(function (e) {
             var key = e.charCode || e.keyCode || 0;
             if (key == 46 || key == 8 || key == 9 || key == 27 ||
             // Allow: Ctrl+A       
                              (key == 65 && key === true) ||
             // Allow: home, end, left, right    
                                               (key >= 35 && key <= 39)) {
                 // let it happen, don't do anything        
                 return;
             }
             else {
                 // Ensure that it is a number and stop the keypress   
                 if ((key >= 48 && key <= 57) || (key >= 96 && key <= 105) || key >= 65 /* a */ && key <= 90 /* z */ || key >= 97 /* a */ && key <= 122 /* z */) {
                     e.preventDefault();
                 }
             }

         });
     });
 };

 jQuery.fn.ForceAlphaNumericsOnly =
 function () {
     return this.each(function () {
         $(this).bind('keyup blur', function () {
             if (this.value.match(/[^a-zA-Z0-9 ]/g)) {
                 this.value = this.value.replace(/[^a-zA-Z0-9 ]/g, '');
             }
         });
     });
 };

 



