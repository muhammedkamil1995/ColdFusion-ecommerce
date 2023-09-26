<cfoutput>
  <aside class="main-sidebar">
    <!-- sidebar: style can be found in sidebar.less -->
    <section class="sidebar">

    <cfset image = (len(trim(getAdminresult.photo)) GT 0) ? '../images/' & getAdminresult.photo : '../images/profile.jpg'>
      <!-- Sidebar user panel -->
      <div class="user-panel">
        <div class="pull-left image">
          <cfoutput><img src="#image#">
        </div>
        <div class="pull-left info">
          <p>#getAdminresult.firstname# #getAdminresult.lastname#</p></cfoutput>
          <a><i class="fa fa-circle text-success"></i> Online</a>
        </div>
      </div>
      <!-- sidebar menu: : style can be found in sidebar.less -->
      <ul class="sidebar-menu" data-widget="tree">
        <li class="header">REPORTS</li>
        <li><a href="home.cfm"><i class="fa fa-dashboard"></i> <span>Dashboard</span></a></li>
        <li><a href="sales.cfm"><i class="fa fa-money"></i> <span>Sales</span></a></li>
        <li class="header">MANAGE</li>
        <li><a href="users.cfm"><i class="fa fa-users"></i> <span>Users</span></a></li>
        <li class="treeview">
          <a href="##">
            <i class="fa fa-barcode"></i>
            <span>Products</span>
            <span class="pull-right-container">
              <i class="fa fa-angle-left pull-right"></i>
            </span>
          </a>
          <ul class="treeview-menu">
            <li><a href="products.cfm"><i class="fa fa-circle-o"></i> Product List</a></li>
            <li><a href="category.cfm"><i class="fa fa-circle-o"></i> Category</a></li>
          </ul>
        </li>
      </ul>
    </section>
    <!-- /.sidebar -->
  </aside>
</cfoutput>
