<cfinclude template="includes/session.cfm">
<cfset where = ''>

<cfif structKeyExists(url, "category")>
    <cfset catid = url.category>
    <cfset where = 'WHERE category_id =' & catid>
</cfif>

<cfinclude template="includes/header.cfm">
<cfoutput>
    <body class="hold-transition skin-blue sidebar-mini">
    <div class="wrapper">
        <cfinclude template="includes/navbar.cfm">
        <cfinclude template="includes/menubar.cfm">
    </div>
    </body>
</cfoutput>


  <!-- Content Wrapper. Contains page content -->
  <div class="content-wrapper">
    <!-- Content Header (Page header) -->
    <section class="content-header">
      <h1>
        Product List
      </h1>
      <ol class="breadcrumb">
        <li><a href="#"><i class="fa fa-dashboard"></i> Home</a></li>
        <li>Products</li>
        <li class="active">Product List</li>
      </ol>
    </section>

    <cfoutput>
    <section class="content">
        <cfif structKeyExists(session, "error")>
            <div class="alert alert-danger alert-dismissible">
                <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                <h4><i class="icon fa fa-warning"></i> Error!</h4>
                #session.error#
            </div>
            <cfset structDelete(session, "error")>
        </cfif>
        <cfif structKeyExists(session, "success")>
            <div class="alert alert-success alert-dismissible">
                <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                <h4><i class="icon fa fa-check"></i> Success!</h4>
                #session.success#
            </div>
            <cfset structDelete(session, "success")>
        </cfif>
        <div class="row">
            <div class="col-xs-12">
                <div class="box">
                    <div class="box-header with-border">
                        <a href="#addnew" data-toggle="modal" class="btn btn-primary btn-sm btn-flat" id="addproduct"><i class="fa fa-plus"></i> New</a>
                        <div class="pull-right">
                            <form class="form-inline">
                                <div class="form-group">
                                    <label>Category: </label>
                                    <select class="form-control input-sm" id="select_category">
                                        <option value="0">ALL</option>
                                        <cfset stmt = conn.prepare("SELECT * FROM category")>
                                        <cfset stmt.execute()>
                                        <cfloop query="stmt">
                                            <cfset selected = (currentRow.id eq url.category) ? 'selected' : ''>
                                            <option value="#currentRow.id#" #selected#>#currentRow.name#</option>
                                        </cfloop>
                                        <cfset pdo.close()>
                                    </select>
                                </div>
                            </form>
                        </div>
                    </div>
                    <div class="box-body">
                        <table id="example1" class="table table-bordered">
                            <thead>
                                <th>Name</th>
                                <th>Photo</th>
                                <th>Description</th>
                                <th>Price</th>
                                <th>Views Today</th>
                                <th>Tools</th>
                            </thead>
                            <tbody>
                                
                                <cftry>
                                    <cfset now = createDateTime(year(now()), month(now()), day(now()))>
                                    <cfset stmt = conn.prepare("SELECT * FROM products #where#")>
                                    <cfset stmt.execute()>
                                    <cfloop query="stmt">
                                        <cfset image = (!len(currentRow.photo)) ? '../images/' & currentRow.photo : '../images/noimage.jpg'>
                                        <cfset counter = (currentRow.date_view eq dateFormat(now, 'Y-m-d')) ? currentRow.counter : 0>
                                        <tr>
                                            <td>#currentRow.name#</td>
                                            <td>
                                                <img src="#image#" height="30px" width="30px">
                                                <span class="pull-right"><a href="#edit_photo" class="photo" data-toggle="modal" data-id="#currentRow.id#"><i class="fa fa-edit"></i></a></span>
                                            </td>
                                            <td><a href="#description" data-toggle="modal" class="btn btn-info btn-sm btn-flat desc" data-id="#currentRow.id#"><i class="fa fa-search"></i> View</a></td>
                                            <td>&#36; #numberFormat(currentRow.price, '9.99')#</td>
                                            <td>#counter#</td>
                                            <td>
                                                <button class="btn btn-success btn-sm edit btn-flat" data-id="#currentRow.id#"><i class="fa fa-edit"></i> Edit</button>
                                                <button class="btn btn-danger btn-sm delete btn-flat" data-id="#currentRow.id#"><i class="fa fa-trash"></i> Delete</button>
                                            </td>
                                        </tr>
                                    </cfloop>
                                    <cfcatch>
                                        #e.getMessage()#
                                    </cfcatch>
                                </cftry>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </section>
</cfoutput>

     
 </div>
  	<cfinclude template="includes/footer.cfm">
    <cfinclude template="includes/products_modal.cfm">
    <cfinclude template="includes/products_modal2.cfm">

</div>
<!-- ./wrapper -->

<cfinclude template="includes/scripts.cfm">

<script>
$(function(){
  $(document).on('click', '.edit', function(e){
    e.preventDefault();
    $('#edit').modal('show');
    var id = $(this).data('id');
    getRow(id);
  });

  $(document).on('click', '.delete', function(e){
    e.preventDefault();
    $('#delete').modal('show');
    var id = $(this).data('id');
    getRow(id);
  });

  $(document).on('click', '.photo', function(e){
    e.preventDefault();
    var id = $(this).data('id');
    getRow(id);
  });

  $(document).on('click', '.desc', function(e){
    e.preventDefault();
    var id = $(this).data('id');
    getRow(id);
  });

  $('#select_category').change(function(){
    var val = $(this).val();
    if(val == 0){
      window.location = 'products.php';
    }
    else{
      window.location = 'products.php?category='+val;
    }
  });

  $('#addproduct').click(function(e){
    e.preventDefault();
    getCategory();
  });

  $("#addnew").on("hidden.bs.modal", function () {
      $('.append_items').remove();
  });

  $("#edit").on("hidden.bs.modal", function () {
      $('.append_items').remove();
  });

});

function getRow(id){
  $.ajax({
    type: 'POST',
    url: 'products_row.php',
    data: {id:id},
    dataType: 'json',
    success: function(response){
      $('#desc').html(response.description);
      $('.name').html(response.prodname);
      $('.prodid').val(response.prodid);
      $('#edit_name').val(response.prodname);
      $('#catselected').val(response.category_id).html(response.catname);
      $('#edit_price').val(response.price);
      CKEDITOR.instances["editor2"].setData(response.description);
      getCategory();
    }
  });
}
function getCategory(){
  $.ajax({
    type: 'POST',
    url: 'category_fetch.php',
    dataType: 'json',
    success:function(response){
      $('#category').append(response);
      $('#edit_category').append(response);
    }
  });
}
</script>
</body>
</html>
