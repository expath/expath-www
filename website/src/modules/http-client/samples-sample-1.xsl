<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
   xmlns:xs="http://www.w3.org/2001/XMLSchema"
   xmlns:http="http://www.expath.org/mod/http-client"
   xmlns:http-java="java:org.expath.saxon.HttpClient"
   xmlns:impl="urn:X-EXPath:httpclient:samples:exist:impl"
   exclude-result-prefixes="#all"
   version="2.0">

   <xsl:output indent="yes"/>

   <!-- credentials -->
   <xsl:param name="username" select="'guest'"/>
   <xsl:param name="password" select="'guest'"/>

   <!-- document to retrieve, and document to upload -->
   <xsl:param name="in"  select="'/db/tmp/in.xml'"/>
   <xsl:param name="out" select="'/db/tmp/out.xml'"/>

   <!-- URI of the REST interface of eXist instance -->
   <xsl:param name="rest" select="
      'http://localhost:8080/exist/rest'"/>

   <!-- main template: retrieve a doc, transform it and
        upload the result -->
   <xsl:template name="main">
      <xsl:variable name="doc">
         <xsl:apply-templates select="impl:get-in()"/>
      </xsl:variable>
      <xsl:sequence select="impl:put-out($doc)"/>
   </xsl:template>

   <!-- the transform rules -->
   <xsl:template match="who">
      <hello>
         <xsl:value-of select="."/>
      </hello>
   </xsl:template>

   <!-- retrieve the input doc -->
   <xsl:function name="impl:get-in" as="document-node()">
      <xsl:variable name="req" as="element()">
         <http:request href="{ $rest }{ $in }"
                       method="get"
                       username="{ $username }"
                       password="{ $password }"
                       auth-method="basic"
                       send-authorization="true"/>
      </xsl:variable>
      <!-- error checking is left as an exercise -->
      <xsl:sequence select="http-java:send-request($req)[2]"/>
   </xsl:function>

   <!-- upload the output doc -->
   <xsl:function name="impl:put-out" as="element()">
      <xsl:param name="doc" as="document-node()"/>
      <xsl:variable name="req" as="element()">
         <http:request href="{ $rest }{ $out }"
                       method="put"
                       username="{ $username }"
                       password="{ $password }"
                       auth-method="basic"
                       send-authorization="true">
            <http:body content-type="application/xml"/>
         </http:request>
      </xsl:variable>
      <!-- error checking is left as an exercise -->
      <xsl:sequence select="
         http-java:send-request($req, (), $doc)"/>
   </xsl:function>

</xsl:stylesheet>
