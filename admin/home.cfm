<cfinclude template="includes/session.cfm">
<cfinclude template="includes/format.cfm">

<cfset today = dateFormat(now(), "yyyy-mm-dd")>
<cfset year = year(now())>
<cfif structKeyExists(url, "year")>
  <cfset year = url.year>
</cfif>


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
        Dashboard
      </h1>
      <ol class="breadcrumb">
        <li><a href="#"><i class="fa fa-dashboard"></i> Home</a></li>
        <li class="active">Dashboard</li>
      </ol>
    </section>

    <!-- Main content -->
<section class="content">
  <cfif structKeyExists(session, "error")>
    <div class="alert alert-danger alert-dismissible">
      <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
      <h4><i class="icon fa fa-warning"></i> Error!</h4>
      #session.error#
    </div>
  </cfif>
  <cfif structKeyExists(session, "success")>
    <div class="alert alert-success alert-dismissible">
      <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
      <h4><i class="icon fa fa-check"></i> Success!</h4>
      #session.success#
    </div>
  </cfif>
  
  <!-- Small boxes (Stat box) -->
  <div class="row">
    <div class="col-lg-3 col-xs-6">
      <!-- small box -->
      <div class="small-box bg-aqua">
        <div class="inner">
          <cfquery name="stmt" datasource="fashion">
            SELECT details.price, details.quantity
            FROM details
            LEFT JOIN products ON products.id=details.product_id
          </cfquery>
          <cfset total = 0>
          <cfloop query="stmt">
            <cfset subtotal = stmt.price * stmt.quantity>
            <cfset total += subtotal>
          </cfloop>
          <h3>&#36; #numberFormat(total, "9.99")#</h3>
        </div>
        <div class="icon">
          <i class="fa fa-shopping-cart"></i>
        </div>
        <a href="book.cfm" class="small-box-footer">More info <i class="fa fa-arrow-circle-right"></i></a>
      </div>
    </div>
    <!-- ./col -->
    <div class="col-lg-3 col-xs-6">
      <!-- small box -->
      <div class="small-box bg-green">
        <div class="inner">
          <cfquery name="stmt" datasource="fashion">
            SELECT COUNT(*) AS numrows
            FROM products
          </cfquery>
          <cfset prow = stmt.fetchRow()>
          <h3>#prow.numrows#</h3>
        </div>
        <div class="icon">
          <i class="fa fa-barcode"></i>
        </div>
        <a href="student.cfm" class="small-box-footer">More info <i class="fa fa-arrow-circle-right"></i></a>
      </div>
    </div>
    <!-- ./col -->
    <div class="col-lg-3 col-xs-6">
      <!-- small box -->
      <div class="small-box bg-yellow">
        <div class="inner">
          <cfquery name="stmt" datasource="fashion">
            SELECT COUNT(*) AS numrows
            FROM users
          </cfquery>
          <cfset urow = stmt.fetchRow()>
          <h3>#urow.numrows#</h3>
        </div>
        <div class="icon">
          <i class="fa fa-users"></i>
        </div>
        <a href="return.cfm" class="small-box-footer">More info <i class="fa fa-arrow-circle-right"></i></a>
      </div>
    </div>
    <!-- ./col -->
    <div class="col-lg-3 col-xs-6">
      <!-- small box -->
      <div class="small-box bg-red">
        <div class="inner">
          <cfquery name="stmt" datasource="fashion">
            SELECT details.price, details.quantity
            FROM details
            LEFT JOIN sales ON sales.id=details.sales_id
            LEFT JOIN products ON products.id=details.product_id
            WHERE sales_date = <cfqueryparam value="#today#" cfsqltype="cf_sql_date">
          </cfquery>
          <cfset total = 0>
          <cfloop query="stmt">
            <cfset subtotal = stmt.price * stmt.quantity>
            <cfset total += subtotal>
          </cfloop>
          <h3>&#36; #numberFormat(total, "9.99")#</h3>
        </div>
        <div class="icon">
          <i class="fa fa-money"></i>
        </div>
        <a href="borrow.cfm" class="small-box-footer">More info <i class="fa fa-arrow-circle-right"></i></a>
      </div>
    </div>
    <!-- ./col -->
  </div>
  <!-- /.row -->
  <div class="row">
    <div class="col-xs-12">
      <div class="box">
        <div class="box-header with-border">
          <h3 class="box-title">Monthly Sales Report</h3>
          <div class="box-tools pull-right">
            <form class="form-inline">
              <div class="form-group">
                <label>Select Year: </label>
                <select class="form-control input-sm" id="select_year">
                  <cfloop from="2015" to="2065" index="i">
                    <cfset selected = (i eq year) ? "selected" : "">
                    <option value="#i#" #selected#>#i#</option>
                  </cfloop>
                </select>
              </div>
            </form>
          </div>
        </div>
        <div class="box-body">
          <div class="chart">
            <br>
            <div id="legend" class="text-center"></div>
            <canvas id="barChart" style="height:350px"></canvas>
          </div>
        </div>
      </div>
    </div>
  </div>
</section>

      <!-- right col -->
    </div>
  	<cfinclude template="includes/footer.cfm">

</div>
<!-- ./wrapper -->

<!-- Chart Data -->
<!-- Chart Data -->
<cfset months = []>
<cfset sales = []>
<cfloop from="1" to="12" index="m">
  <cftry>
    <cfquery name="stmt" datasource="fashion">
      SELECT details.price, details.quantity
      FROM details
      LEFT JOIN sales ON sales.id=details.sales_id
      LEFT JOIN products ON products.id=details.product_id
      WHERE MONTH(sales_date) = <cfqueryparam value="#m#" cfsqltype="cf_sql_integer">
      AND YEAR(sales_date) = <cfqueryparam value="#year#" cfsqltype="cf_sql_integer">
    </cfquery>
    <cfset total = 0>
    <cfloop query="stmt">
      <cfset subtotal = stmt.price * stmt.quantity>
      <cfset total += subtotal>
    </cfloop>
    <cfset sales.add(round(total, 2))>
    <cfcatch type="any">
      <!-- Handle the exception here, e.g., echo the error message -->
      <cfoutput>#cfcatch.message#</cfoutput>
    </cfcatch>
  </cftry>

  <cfset num = repeatString("0", 2 - len(m)) & m>
  <cfset month = dateFormat(createDateTime(0, 0, 0, m, 1), "MMM")>
  <cfset arrayAppend(months, month)>
</cfloop>

<cfset monthsJSON = serializeJSON(months)>
<cfset salesJSON = serializeJSON(sales)>



<!-- Include the necessary scripts -->
<cfinclude template="includes/scripts.cfm"> 

<script>
$(function(){
  var barChartCanvas = $('#barChart').get(0).getContext('2d')
  var barChart = new Chart(barChartCanvas)
  var barChartData = {
    labels  : <?php echo $months; ?>,
    datasets: [
      {
        label               : 'SALES',
        fillColor           : 'rgba(60,141,188,0.9)',
        strokeColor         : 'rgba(60,141,188,0.8)',
        pointColor          : '#3b8bba',
        pointStrokeColor    : 'rgba(60,141,188,1)',
        pointHighlightFill  : '#fff',
        pointHighlightStroke: 'rgba(60,141,188,1)',
        data                : <?php echo $sales; ?>
      }
    ]
  }
  //barChartData.datasets[1].fillColor   = '#00a65a'
  //barChartData.datasets[1].strokeColor = '#00a65a'
  //barChartData.datasets[1].pointColor  = '#00a65a'
  var barChartOptions                  = {
    //Boolean - Whether the scale should start at zero, or an order of magnitude down from the lowest value
    scaleBeginAtZero        : true,
    //Boolean - Whether grid lines are shown across the chart
    scaleShowGridLines      : true,
    //String - Colour of the grid lines
    scaleGridLineColor      : 'rgba(0,0,0,.05)',
    //Number - Width of the grid lines
    scaleGridLineWidth      : 1,
    //Boolean - Whether to show horizontal lines (except X axis)
    scaleShowHorizontalLines: true,
    //Boolean - Whether to show vertical lines (except Y axis)
    scaleShowVerticalLines  : true,
    //Boolean - If there is a stroke on each bar
    barShowStroke           : true,
    //Number - Pixel width of the bar stroke
    barStrokeWidth          : 2,
    //Number - Spacing between each of the X value sets
    barValueSpacing         : 5,
    //Number - Spacing between data sets within X values
    barDatasetSpacing       : 1,
    //String - A legend template
    legendTemplate          : '<ul class="<%=name.toLowerCase()%>-legend"><% for (var i=0; i<datasets.length; i++){%><li><span style="background-color:<%=datasets[i].fillColor%>"></span><%if(datasets[i].label){%><%=datasets[i].label%><%}%></li><%}%></ul>',
    //Boolean - whether to make the chart responsive
    responsive              : true,
    maintainAspectRatio     : true
  }

  barChartOptions.datasetFill = false
  var myChart = barChart.Bar(barChartData, barChartOptions)
  document.getElementById('legend').innerHTML = myChart.generateLegend();
});
</script>
<script>
$(function(){
  $('#select_year').change(function(){
    window.location.href = 'home.cfm?year='+$(this).val();
  });
});
</script>
</body>
</html>