/*
 * SimpleModal Basic Modal Dialog
 * http://www.ericmmartin.com/projects/simplemodal/
 * http://code.google.com/p/simplemodal/
 *
 * Copyright (c) 2010 Eric Martin - http://ericmmartin.com
 *
 * Licensed under the MIT license:
 *   http://www.opensource.org/licenses/mit-license.php
 *
 * Revision: $Id: basic.js 254 2010-07-23 05:14:44Z emartin24 $
 */

jQuery(function ($) {
	// Load dialog on page load
	//$('#basic-modal-content').modal();

	// Load dialog on click
	$('#basic-modal .basic').click(function (e) {
		$('#basic-modal-content').modal();

		return false;
	});
});

$(".preview_tab_link").click(function () {


    preview_html = '<h3>Preview question</h3>';

    preview_html += '<p class="col600 qsholder">';
    /* question */
    if ($('#question').length && $('#question').val().length) {
        preview_html += bbCode(replaceLineBreak($('#question').val()));
    }
    /* P question */
    if ($('#questionp').length && $('#questionp').val().length) {
        preview_html += '<p class="gray">Correct this punctuation</p><p>' + $('#questionp').val() + '</p>';
    }
    /* MC Answers */
    preview_html += '</p><div class="dotted"></div>';
    preview_html += '<table class="answholder" cellpadding="0" cellspacing="0"><tr class="qs"><td><img src="' + webpath_img + 'i.gif" width="20" height="1" alt="" /></td><td><img src="' + webpath_img + 'i.gif" width="20" height="1" alt="" /></td><td><img src="' + webpath_img + 'i.gif" width="30" height="1" alt=""  /></td></tr>';

    /* MC - Loop through existing ans fields on the page */
    $('[id^="ans"]').each(function (index) {
        num = this.id.substring(3);
        if ($(this).val().length) {

            /* See if checkbox is checked */
            if ($("input[type=checkbox][name=correct" + num + "]").is(':checked')) {
                gif = '<img src="' + webpath_img + 'correct.gif" alt="Correct">';
            } else {
                gif = '';
            }
            preview_html += '<tr class="qs"><td>' + gif + '</td><td class="number">' + letters[num - 1] + ')</td><td class="answer">' + bbCode(replaceLineBreak($(this).val())) + '</td></tr>';
        }
    });
    /* TF - Loop through existing ans fields on the page */
    num = 1;
    $("input[type=radio][name=correct]").each(function (index) {

        /* See if radio button is checked */
        if ($(this).is(':checked')) {
            gif = '<img src="' + webpath_img + 'correct.gif" alt="Correct">';
        } else {
            gif = '';
        }
        preview_html += '<tr class="qs"><td>' + gif + '</td><td class="number">' + letters[num - 1] + ')</td><td class="answer">' + $('#tfans' + num).val() + '</td></tr>';

        num++;
    });

    /* FT - Loop through existing ans fields on the page */
    if ($('#ftans1').length) {
        preview_html += '<tr class="qs"><td></td><td class="number"></td><td class="answer"><p class="gray">Accepted answers</p></td></tr>';
    }
    $('[id^="ftans"]').each(function (index) {
        num = this.id.substring(5);
        if ($(this).val().length) {
            preview_html += '<tr class="qs"><td><img src="' + webpath_img + 'correct.gif" alt="Correct"></td><td class="number"></td><td class="answer">' + $(this).val() + '</td></tr>';
        }
    });
    /* P */
    if ($('#pans').length && $('#pans').val().length) {
        preview_html += '<tr class="qs"><td></td><td class="answer" colspan="2"><p class="gray">Correct version for checking users answer against</p></td></tr>';
        preview_html += '<tr class="qs"><td><img src="' + webpath_img + 'correct.gif" alt="Correct"></td><td class="answer" colspan="2">' + $('#pans').val() + '</td></tr>';
    }

    preview_html += '</table><div class="clearheight"></div>';



    //preview_html += '<p class="gray">Correct version for checking users answer against</p><p>' + $('#questionp').val() + '</p>;

    if ($("#correct_feedback").length && $("#correct_feedback").val().length) {
        preview_html += '<div class="previewfeedback"><p><span class="green"><strong>Feedback</strong></span><br />' + bbCode(replaceLineBreak($("#correct_feedback").val())) + '</p></div>';
    }
    if ($("#wrong_feedback").length && $("#wrong_feedback").val().length) {
        preview_html += '<div class="previewfeedback"><p><span class="red"><strong>Feedback</strong></span><br />' + bbCode(replaceLineBreak($("#wrong_feedback").val())) + '</p></div>';
    }


    $("#div_preview").html('');
    $("#div_preview").html(preview_html);
    $("#div_preview").show();
    $("#div_question_edit").hide();

    $("#question_preview_tab1").attr('class', "question_edit_tab");
    $("#question_edit_tab1").attr('class', "question_preview_tab");
    return false;

});