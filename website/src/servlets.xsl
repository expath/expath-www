<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:pkg="http://expath.org/ns/pkg"
                xmlns:web="http://expath.org/ns/webapp"
                xmlns:app="http://expath.org/ns/website"
                xmlns:html="http://www.w3.org/1999/xhtml"
                xmlns="http://www.w3.org/1999/xhtml"
                exclude-result-prefixes="#all"
                version="2.0">

   <xsl:import href="http://expath.org/ns/website/webpage.xsl"/>

   <pkg:import-uri>http://expath.org/ns/website/servlets.xsl</pkg:import-uri>

   <xsl:param name="menus" as="element(menu)+" select="doc('sitemap.xml')/sitemap/menu"/>

   <!--
       ...
   -->
   <xsl:function name="app:page-servlet">
      <xsl:param name="request" as="element(web:request)"/>
      <xsl:param name="bodies"  as="item()*"/>
      <xsl:variable name="page" as="xs:string">
         <xsl:variable name="param" select="$request/web:path/web:match[@name eq 'page']"/>
         <xsl:sequence select="
             if ( not($param) or ends-with($param, '/') ) then
               concat($param, 'index')
             else
               $param"/>
      </xsl:variable>
      <web:response status="200" message="Ok">
         <web:body content-type="text/html" method="xhtml"/>
      </web:response>
      <xsl:variable name="doc" as="element(webpage)" select="doc(concat($page, '.xml'))/*"/>
      <xsl:apply-templates select="$doc"/>
   </xsl:function>

   <!--
       The addresses have changed, propose to redirect *.html to *.
   -->
   <xsl:function name="app:old-page-servlet">
      <xsl:param name="request" as="element(web:request)"/>
      <xsl:param name="bodies"  as="item()*"/>
      <xsl:variable name="page" select="$request/web:path/web:match[@name eq 'page']"/>
      <web:response status="404" message="Ok">
         <web:body content-type="text/html" method="xhtml"/>
      </web:response>
      <html>
         <head>
            <title>EXPath - Oops</title>
         </head>
         <body>
            <p>
               <xsl:text>The page you requested does not exist.  Did you mean </xsl:text>
               <a href="{ tokenize($page, '/')[last()] }">
                  <xsl:value-of select="$page"/>
               </a>
               <xsl:text> instead?</xsl:text>
            </p>
         </body>
      </html>
   </xsl:function>

   <!--
       ...
   -->
   <xsl:function name="app:spec-servlet">
      <xsl:param name="request" as="element(web:request)"/>
      <xsl:param name="bodies"  as="item()*"/>
      <xsl:variable name="spec" select="$request/web:path/web:match[@name eq 'spec']"/>
      <xsl:variable name="date" select="$request/web:path/web:match[@name eq 'date']"/>
      <xsl:variable name="diff" select="$request/web:path/web:match[@name eq 'diff']"/>
      <xsl:variable name="xml"  select="$request/web:path/web:match[@name eq 'xml']"/>
      <xsl:variable name="file" select="concat('spec/', $spec, $date, $diff, ($xml, '.html')[1])"/>
      <web:response status="200" message="Ok">
         <web:body content-type="text/html" src="{ resolve-uri($file) }"/>
      </web:response>
   </xsl:function>

   <!--
       The wiki redirection must be configured in Apache.
       
       In case it is not properly configured (or in case we are in a
       dev environment, without Apache), display a user-friednly error
       message.
   -->
   <xsl:function name="app:wiki-servlet">
      <xsl:param name="request" as="element(web:request)"/>
      <xsl:param name="bodies"  as="item()*"/>
      <xsl:variable name="page" select="$request/web:path/web:match[@name eq 'page']"/>
      <web:response status="404" message="Ok">
         <web:body content-type="text/html" method="xhtml"/>
      </web:response>
      <html>
         <head>
            <title>EXPath - Oops</title>
         </head>
         <body>
            <p>
               <xsl:text>Oops, it seems the wiki is not available for
               now.  Please try again later, and think to report the
               problem to the list or directly to the
               webmaster.</xsl:text>
            </p>
         </body>
      </html>
   </xsl:function>

</xsl:stylesheet>
