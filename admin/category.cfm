<cfinclude template="includes/session.cfm">
<cfinclude template="includes/header.cfm">
<cfset categories = []>

<cfquery name="getCategories" datasource="fashion">
    SELECT * FROM category
</cfquery>

<cfloop query="getCategories">
    <cfset category = {
        "id": getCategories.id,
        "name": getCategories.name
    }>
    <cfset arrayAppend(categories, category)>
</cfloop>

<body class="hold-transition skin-blue sidebar-mini">
<div class="wrapper">
  <cfinclude template="includes/navbar.cfm">
  <cfinclude template="includes/menubar.cfm">
  
  <div class="content-wrapper">
    <section class="content-header">
      <h1>
        Category
      </h1>
      <ol class="breadcrumb">
        <li><a href="#"><i class="fa fa-dashboard"></i> Home</a></li>
        <li>Products</li>
        <li class="active">Category</li>
      </ol>
    </section>

    <section class="content">
      <!-- Display error and success messages -->
      <cfif structKeyExists(session, "error")>
        <div class="alert alert-danger alert-dismissible">
          <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
          <h4><i class="icon fa fa-warning"></i> Error!</h4>
          <cfoutput>#session.error#</cfoutput>
        </div>
        <cfset structDelete(session, "error")>
      </cfif>
      <cfif structKeyExists(session, "success")>
        <div class="alert alert-success alert-dismissible">
          <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
          <h4><i class="icon fa fa-check"></i> Success!</h4>
          <cfoutput>#session.success#</cfoutput>
        </div>
        <cfset structDelete(session, "success")>
      </cfif>

      <div class="row">
        <div class="col-xs-12">
          <div class="box">
            <div class="box-header with-border">
              <a href="#addnew" data-toggle="modal" class="btn btn-primary btn-sm btn-flat"><i class="fa fa-plus"></i> New</a>
            </div>
            <div class="box-body">
              <table id="example1" class="table table-bordered">
                <thead>
                  <th>Category Name</th>
                  <th>Tools</th>
                </thead>
                <tbody>
                  <cfloop array="#categories#" index="category">
                    <tr>
                      <cfoutput>
                        <td>#category.name#</td>
                        <td>
                          <button class="btn btn-success btn-sm edit btn-flat" data-id="#category.id#"><i class="fa fa-edit"></i> Edit</button>
                          <button class="btn btn-danger btn-sm delete btn-flat" data-id="#category.id#"><i class="fa fa-trash"></i> Delete</button>
                        </td>
                      </cfoutput>
                    </tr>
                  </cfloop>
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </div>
    </section>
  </div>
  <cfinclude template="includes/footer.cfm">
  <cfinclude template="includes/category_modal.cfm">
</div>

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

});

function getRow(id){
  $.ajax({
    type: 'POST',
    url: 'category_row.cfm',
    data: {id:id},
    dataType: 'json',
    success: function(response){
      $('.catid').val(response[0].id);
      $('#edit_name').val(response[0].name);
      $('.catname').html(response[0].name);
    }
  });
}
</script>
</body>
</html>
