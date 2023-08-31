<cfcomponent>
    <cfproperty name="server" default="jdbc:mysql://localhost/fashion" />
    <cfproperty name="username" default="root" />
    <cfproperty name="password" default="" />
    <cfproperty name="conn" type="any" />

    <!--- Constructor --->
    <cffunction name="init" returntype="conn.cfc">
        <cfreturn this>
    </cffunction>

    <!--- Open database connection --->
    <cffunction name="open" returntype="any">
        <cftry>
            <cfset var connectionString = "class.forName('com.mysql.jdbc.Driver');"
                & "connection = DriverManager.getConnection('#server#', '#username#', '#password#');">
            <cfset this.conn = createObject("java", "java.sql.Connection")>
            <cfset evaluate(connectionString)>
            <cfreturn this.conn>
        <cfcatch type="any">
            <cfthrow message="There is some problem in connection: #cfcatch.message#" />
        </cfcatch>
        </cftry>
    </cffunction>

    <!--- Close database connection --->
    <cffunction name="close" returntype="void">
        <cfif isDefined("this.conn")>
            <cfset this.conn.close()>
            <cfset this.conn = "">
        </cfif>
    </cffunction>
</cfcomponent>
