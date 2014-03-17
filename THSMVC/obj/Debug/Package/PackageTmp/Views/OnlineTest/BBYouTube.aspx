<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>BBYouTube</title>
</head>
<body>
    <div class="popupHead">
        <span>Embed YouTube video</span>
    </div>
    <div id="videoForm">
        <div class="dotted">
        </div>
        <p>
            <strong>Example:</strong> When viewing your video on www.youtube.com the link will
            look like this:
            <br />
            http://www.youtube.com/watch?v=<strong>ojSngu0Qp8E</strong>
            <br />
            <br />
            You can add the whole link or just the YouTube video ID: <strong>ojSngu0Qp8E</strong><br />
            (Do not add YouTube embed code)</p>
        <div class="dotted">
        </div>
        <table>
            <tr>
                <td class="titlename">
                    Enter YouTube Link or Video ID
                </td>
            </tr>
            <tr>
                <td>
                    <div class="clearheight5">
                    </div>
                </td>
            </tr>
            <tr>
                <td>
                    <input type="text" name="video_id" size="30" id="test_video_id" />
                </td>
            </tr>
            <tr>
                <td>
                    <div class="clearheight5">
                    </div>
                </td>
            </tr>
            <tr>
                <td>
                    <input type="button" value="Test Video" class="rg_button_red" id="checkfullurl" />
                     <input type="button" value="Cancel" class="rg_button" id="btnCancel" />
                </td>
            </tr>
        </table>
    </div>
    <div id="show_preview" style="display: none;">
    <input type="button" value="Embed this video" class="rg_button_red" id="set_video" />
    <input type="button" value="Try again" class="rg_button_red" id="cancel_video" />
    </div>
    <div id="prev_yt">
    </div>
    <script type="text/javascript">
        $(document).ready(function () {

            $('#checkfullurl').click(function () {
                $('#test_video_id').val($('#test_video_id').val().replace(/\s/g, ''));
                if ($('#test_video_id').val().length > 11 && ($('#test_video_id').val().indexOf("youtube") == -1 && $('#test_video_id').val().indexOf("youtu.be") == -1)) {
                    alert('Only YouTube links or Video IDs can be used. Please copy and paste the link from the top of your web browser when looking at the video on www.youtube.com. (Do not use the embed code)');
                } else {
                    youtubeIdExtract($('#test_video_id').val());
                }
                return false;
            });

            $('#set_video').click(function () {
                $('#prev_yt').html('');
                //doYouTube( $('#obj_ref').text(), $('#test_video_id').val() );

                if (document.selection) {

                    sel.text = '[yt]' + $('#test_video_id').val() + '[/yt]';

                } else {

                    rep = '[yt]' + $('#test_video_id').val() + '[/yt]';
                    textarea.value = textarea.value.substring(0, start) + rep + textarea.value.substring(end, len);

                }
                $.modal.close();

            });
            var textarea = document.getElementById($('#obj_ref').text());
            if (document.selection) {
                textarea.focus();
                var sel = document.selection.createRange();
            } else {
                var len = textarea.value.length;
                var start = textarea.selectionStart;
                var end = textarea.selectionEnd;
                var sel = textarea.value.substring(start, end);

            }

            $('#cancel_video').click(function () {
                $('#test_video_id').val('');
                $('#show_preview').hide();
                $('#prev_yt').html('');
                $('#videoForm').show();
                $(".popupHead").show();
            });
            $('.jqmClose').click(function () {
                $('#prev_yt').html('');
            });
            $("#btnCancel").click(function () {
                $.modal.close();
            });

        });



        function youtubeIdExtract(youtube_id) {

            if (youtube_id.indexOf("youtube.com/embed/") != -1) {

                youtube_id = youtube_id.replace(/http:\/\/www\.youtube\.com\/embed\//, "").substring(0, 11);

            } else if (youtube_id.indexOf("youtube") != -1) {

                youtube_id = youtube_id.replace(/^[^v]+v.(.{11}).*/, "$1");

            } else if (youtube_id.indexOf("youtu.be") != -1) {

                youtube_id = youtube_id.replace(/http:\/\/youtu\.be\//, "").substring(0, 11);

            }

            if (youtube_id.length == 11) {
                $('#test_video_id').val(youtube_id);
                $('#prev_yt').html('<iframe width="525" height="349" src="http://www.youtube.com/embed/' + youtube_id + '" frameborder="0" allowfullscreen></iframe>');
                $('#videoForm').hide();
                $(".popupHead").hide();
                $('#show_preview').show();

            } else {
                alert('Video ID must be 11 characters long');
            }
        }

    </script>
</body>
</html>
