<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>PostNotice </title>
    <style type="text/css">
        .gray
        {
            color: #4D4D4D;
        }
        .dotted
        {
            color: white;
            clear: both;
            float: none;
            height: 1px;
            margin: 5px 0 10px 0;
            padding: 0;
            border-bottom: 1px dotted #D2D2D2;
        }
    </style>
</head>
<body>
    <div class="clear">
        <div class="clear">
            <div class="ContentdivHead" onclick="toggleContentDivHead(this,'#divTestName');">
                <span class="divHeading">Notice Details</span>
            </div>
            <div class="clear">
                <div class="ContentdivBorder" id="divTestName">
                    <div class="clear" style="text-align: center; margin-top: 10px;">
                        <span id="spnTestName" style="font-size: 25px; font-family: Arial,Sans-Serif;">test</span>
                    </div>
                </div>
            </div>
        </div>
        <div id="AssignTest">
            <div class="clear">
                <div class="ContentdivHead" onclick="toggleContentDivHead(this,'#divAssignUsers');">
                    <span class="divHeading">Users for this notice</span>
                </div>
                <div class="clear">
                    <div class="ContentdivBorder" id="divAssignUsers">
                        <div id='tree3'>
                            <ul>
                                <li id='1_1' class='expanded'><span>For all 1 Administrator(s)</span><ul>
                                </ul>
                                </li>
                                <li id='1_2' class='expanded'><span>For all 5 Student(s)</span><ul>
                                    <li id='2_2' class='expanded'><span>For all 4 Student(s) in 1st Class</span><ul>
                                        <li id='3_2'><span>For all 3 Student(s) in A Section</span></li><li id='3_4'><span>For
                                            all 1 Student(s) in B Section</span></li></ul>
                                    </li>
                                    <li id='2_3' class='expanded'><span>For all 1 Student(s) in red</span><ul>
                                        <li id='3_3'><span>For all 1 Student(s) in reda</span></li></ul>
                                    </li>
                                </ul>
                                </li>
                                <li id='1_3' class='expanded'><span>For all 1 Teacher(s)</span><ul>
                                    <li id='2_2' class='expanded'><span>For all 1 Teacher(s) in 1st Class</span><ul>
                                    </ul>
                                    </li>
                                </ul>
                                </li>
                            </ul>
                        </div>
                        <input type="hidden" id="echoSelectionRootKeys3" />
                        <h3>
                            Selected Users:</h3>
                        <div id="echoSelectionRoots3">
                            No Users Selected.
                        </div>
                    </div>
                </div>
            </div>
            <div style="text-align: center;">
                <input type="button" class="g-button g-button-red" id="fg" value="POST" style="margin-right: 5px;" />
            </div>
        </div>
    </div>
    <script type="text/javascript">
        $(document).ready(function () {

            $("#tree3").dynatree({
                checkbox: true,
                selectMode: 3,
                onSelect: function (select, node) {
                    ClearMsg();
                    // Get a list of all selected nodes, and convert to a key array:
                    var selKeys = $.map(node.tree.getSelectedNodes(), function (node) {
                        return node.data.key;
                    });
                    $("#echoSelection3").text(selKeys.join(", "));

                    // Get a list of all selected TOP nodes
                    var selRootNodes = node.tree.getSelectedNodes(true);
                    // ... and convert to a key array:
                    var selRootKeys = $.map(selRootNodes, function (node) {
                        return node.data.key;
                    });
                    $("#echoSelectionRootKeys3").val(selRootKeys.join(", "));
                    $("#echoSelectionRoots3").html(selRootNodes.join("<br/> "));
                },
                onDblClick: function (node, event) {
                    node.toggleSelect();
                },
                onKeydown: function (node, event) {
                    if (event.which == 32) {
                        node.toggleSelect();
                        return false;
                    }
                }
            });
            $('#tree3 .dynatree-icon').remove();
        });
    </script>
</body>
</html>
