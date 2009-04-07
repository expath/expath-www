<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:http="http://www.exslt.org/v2/http-client"
                xmlns:http-java="java:org.fgeorges.exslt2.saxon.HttpClient"
                exclude-result-prefixes="#all"
                version="2.0">

   <xsl:template name="main-YO">
      <xsl:variable name="req" as="element()">
         <http:request href="http://localhost:8181/exist/rest/db/expath/modules.xml"
                       method="put" auth-method="basic" send-authorization="true"
                       username="admin" password="adminadmin">
            <http:body content-type="application/xml"/>
         </http:request>
      </xsl:variable>
      <xsl:sequence select="http-java:send-request($req, (), doc('modules.xml'))"/>
   </xsl:template>

   <xsl:template name="main">
      <xsl:variable name="req" as="element()">
         <http:request href="http://localhost:8181/exist/rest/db/expath/"
                       method="get" auth-method="basic" send-authorization="true"
                       username="admin" password="adminadmin"/>
      </xsl:variable>
      <xsl:sequence select="http-java:send-request($req)"/>
   </xsl:template>

</xsl:stylesheet>
