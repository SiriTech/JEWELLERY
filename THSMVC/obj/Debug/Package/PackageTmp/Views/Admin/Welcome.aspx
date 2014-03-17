


    <div id="divid">
    Hi,  Admin....
        
    </div>
    <div id="basic-modal-content">
			<span>Basic Modal Dialog</span>
			<p>For this demo, SimpleModal is using this "hidden" data for its content. You can also populate the modal dialog with an AJAX response, 
            standard HTML or DOM element(s).</p>
			<p>Examples:</p>
			

		</div>
    <input type="button"  value="click" class="rg_button" onclick="test();" />
    <%--<input type="text" id="testDate" class="CalendarBox" title="Select date from calendar." />--%>
   <script type="text/javascript">
       function test() {
           $("#divid").html("<img height='150px' width='350px' src='../../images/contactus.jpg' />");
           noty({ text: 'noty - a jquery notification library!', type: "success", layout: "bottom" });
           $('#basic-modal-content').modal();
       }
       $(document).ready(function () {
//           $('#testDate').datepicker({
//               changeMonth: true,
//               changeYear: true,
//               showButtonPanel: true
//           });
          
           $("#testDate").tooltip({

               // place tooltip on the right edge
               position: "center right",

               // a little tweaking of the position
               offset: [-2, 10],

               // use the built-in fadeIn/fadeOut effect
               effect: "fade",

               // custom opacity setting
               opacity: 0.7

           });
       });
      
   </script>
    
