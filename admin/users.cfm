<cfinclude template="includes/session.cfm"> 
<cfinclude template="includes/header.cfm">
<body class="hold-transition skin-blue sidebar-mini">
<div class="wrapper">


<cfinclude template="includes/navbar.cfm"> 
<cfinclude template="includes/menubar.cfm">


  <!-- Content Wrapper. Contains page content -->
  <div class="content-wrapper">
    <!-- Content Header (Page header) -->
    <section class="content-header">
      <h1>
        Users
      </h1>
      <ol class="breadcrumb">
        <li><a href="#"><i class="fa fa-dashboard"></i> Home</a></li>
        <li class="active">Users</li>
      </ol>
    </section>

    <!-- Main content -->
    <section class="content">
            <cfif IsDefined("session.error")>
                <div class="alert alert-danger alert-dismissible">
                    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                    <h4><i class="icon fa fa-warning"></i> Error!</h4>
                    <cfoutput>#session.error#</cfoutput>
                    
                </div>
                <cfset StructDelete(session, "error")>
            </cfif>

            <cfif IsDefined("session.success")>
                <div class="alert alert-success alert-dismissible">
                    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                    <h4><i class="icon fa fa-check"></i> Success!</h4>
                    <cfoutput>#session.success#</cfoutput>
                </div>
                <cfset StructDelete(session, "success")>
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
                  <th>Photo</th>
                  <th>Email</th>
                  <th>Name</th>
                  <th>Status</th>
                  <th>Date Added</th>
                  <th>Tools</th>
                </thead>
                <tbody>
                  <cftry>
                    <cfquery name="users" datasource="fashion" RETURNTYPE="array">
                        SELECT * FROM users WHERE type=0
                    </cfquery>

                      <cfloop array="#users#" index="user">
                        <cfoutput>
                        <cfset status = (user.status) ? '<span class="label label-success">active</span>' : '<span class="label label-danger">not verified</span>'>
                        <cfset active = (user.status) ? '' : '<span class="pull-right"><a href="##activate" class="status" data-toggle="modal" data-id="#user.id#"><i class="fa fa-check-square-o"></i></a></span>'>

                        <tr>
                            <td>
                              <cfset userImage = (isDefined("user.photo") and len(trim(user.photo)) GT 0) ? '../images/' & user.photo : '../images/profile.jpg'>
                              <img src="#userImage#" height="30px" width="30px">
                              <span class="pull-right"><a href="##edit_photo" class="photo" data-toggle="modal" data-id="#user.id#"><i class="fa fa-edit"></i></a></span>
                            </td>
                            <td>#user.email#</td>
                            <td>#user.firstname# #user.lastname#</td>
                            <td>
                                #status#
                                #active#
                            </td>
                            <td>#DateFormat(user.created_on, 'MMM dd, yyyy')#</td>
                            <td>
                                <a href="cart.cfm?user=#user.id#" class="btn btn-info btn-sm btn-flat"><i class="fa fa-search"></i> Cart</a>
                                <button class="btn btn-success btn-sm edit btn-flat" data-id="#user.id#"><i class="fa fa-edit"></i> Edit</button>
                                <button class="btn btn-danger btn-sm delete btn-flat" data-id="#user.id#"><i class="fa fa-trash"></i> Delete</button>
                            </td>
                        </tr>
                        </cfoutput>
                      </cfloop>
                      <cfcatch type="any">
                          <cfoutput>#cfcatch.message#</cfoutput>
                      </cfcatch>
                  </cftry>
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </div>
    </section>
     
  </div>

  <cfinclude template="includes/footer.cfm"> 
  <cfinclude template="includes/users_modal.cfm">

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

  $(document).on('click', '.status', function(e){
    e.preventDefault();
    var id = $(this).data('id');
    getRow(id);
  });

});

function getRow(id){
  $.ajax({
    type: 'POST',
    url: 'users_row.php',
    data: {id:id},
    dataType: 'json',
    success: function(response){
      $('.userid').val(response.id);
      $('#edit_email').val(response.email);
      $('#edit_password').val(response.password);
      $('#edit_firstname').val(response.firstname);
      $('#edit_lastname').val(response.lastname);
      $('#edit_address').val(response.address);
      $('#edit_contact').val(response.contact_info);
      $('.fullname').html(response.firstname+' '+response.lastname);
    }
  });
}
</script>
</body>
</html>
