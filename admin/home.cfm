<cfinclude template="includes/session.cfm">

<cfset today = LSDateFormat(now(), 'yyyy-mm-dd')>
<cfset year = DateFormat(now(), 'yyyy')>

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
        <li><a href="##"><i class="fa fa-dashboard"></i> Home</a></li>
        <li class="active">Dashboard</li>
      </ol>
    </section>

    <!-- Main content -->
<section class="content">
  <cfif structKeyExists(session, "error")>
    <div class="alert alert-danger alert-dismissible">
      <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
      <h4><i class="icon fa fa-warning"></i> Error!</h4>
      <cfoutput>#session.error#</cfoutput>
      <cfset structDelete(session, "error")>
    </div>
  </cfif>
  <cfif structKeyExists(session, "success")>
    <div class="alert alert-success alert-dismissible">
      <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
      <h4><i class="icon fa fa-check"></i> Success!</h4>
      <cfoutput>#session.success#</cfoutput>
      <cfset structDelete(session, "success")>
    </div>
  </cfif>
  
  <!-- Small boxes (Stat box) -->
  <div class="row">
    <div class="col-lg-3 col-xs-6">
      <!-- small box -->
      <div class="small-box bg-aqua">
        <div class="inner">
          <cfquery name="productDetails" datasource="fashion">
            SELECT * FROM details LEFT JOIN products ON products.id=details.product_id
          </cfquery>
          <cfset total = 0>
          <cfloop query="productDetails">
            <cfset subtotal = productDetails.price * productDetails.quantity>
            <cfset total += subtotal>
          </cfloop>
          <cfoutput><h3>&##36; #numberFormat(total, "9.99")#</h3></cfoutput>
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
          <cfquery name="products" datasource="fashion">
            SELECT COUNT(*) AS numrows
            FROM products
          </cfquery>
          <cfoutput><h3>#products.numrows#</h3></cfoutput>
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
          <cfquery name="users" datasource="fashion">
            SELECT COUNT(*) AS numrows
            FROM users
          </cfquery>
          <cfoutput><h3>#users.numrows#</h3></cfoutput>
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
          <cfquery name="details" datasource="fashion">
            SELECT * FROM details 
            LEFT JOIN sales 
            ON sales.id=details.sales_id 
            LEFT JOIN products 
            ON products.id=details.product_id 
            WHERE sales_date = <cfqueryparam value="#today#" cfsqltype="cf_sql_date">
          </cfquery>
          <cfset total = 0>
          <cfloop query="details">
            <cfset subtotal = product.price * product.quantity>
            <cfset total += subtotal>
          </cfloop>
          <cfoutput><h3>&##36; #numberFormat(total, "9.99")#</h3></cfoutput>
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
                    <cfoutput><option value="#i#" #selected#>#i#</option></cfoutput>
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
<cfscript>
    months = [];
    sales = [];

    for (m = 1; m <= 12; m++) {
        try {
            // Calculate the month and year
            currentYear = Year(now());
            monthDate = createDate(currentYear, m, 1);
            startDate = dateAdd('m', -1, monthDate);
            endDate = dateAdd('d', -1, dateAdd('m', 1, monthDate));

            // Query the database
            queryService = queryExecute(
                "SELECT SUM(price * quantity) AS total
                 FROM details
                 LEFT JOIN sales ON sales.id = details.sales_id
                 LEFT JOIN products ON products.id = details.product_id
                 WHERE sales_date >= :startDate AND sales_date <= :endDate",
                {
                    startDate: startDate,
                    endDate: endDate
                },
                {datasource: 'fashion'}
            );

            // Get the total sales for the month
            total = queryResult.total ?: 0;
            total = numberFormat(total, '9.99'); // Round to two decimal places
            arrayAppend(sales, total);

        } catch (any e) {
            // Handle any exceptions here
            writeOutput(e.getMessage());
        }

        // Format month names
        monthName = monthAsString(m);
        arrayAppend(months, monthName);
    }

    // Convert arrays to JSON
    monthsJSON = serializeJSON(months);
    salesJSON = serializeJSON(sales);
</cfscript>



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