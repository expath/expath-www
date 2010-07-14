<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:pkg="http://expath.org/ns/pkg"
                xmlns:web="http://expath.org/ns/webapp"
                xmlns:app="http://example.org/ns/hello-web"
                xmlns="http://www.w3.org/1999/xhtml"
                version="2.0">

   <pkg:import-uri>http://example.org/ns/hello-web/servlets.xsl</pkg:import-uri>

   <xsl:function name="app:main">
      <xsl:param name="request" as="element(web:request)"/>
      <web:response status="200" message="Ok">
         <web:body content-type="text/html" method="xhtml"/>
      </web:response>
      <html>
         <head>
            <title>Hello webapp</title>
         </head>
         <body>
            <h1>Hello webapp</h1>
            <form action="greetings" method="get">
               Who are you?: <input type="text" name="who"/><br/>
               <input type="submit" value="Submit"/>
            </form>
         </body>
      </html>
   </xsl:function>

   <xsl:function name="app:greets">
      <xsl:param name="request" as="element(web:request)"/>
      <xsl:variable name="who" select="
          ( $request/web:param[@name eq 'who']/@value, 'Mr. Nobody' )[1]"/>
      <web:response status="200" message="Ok">
         <web:body content-type="text/html" method="xhtml"/>
      </web:response>
      <html>
         <head>
            <title>Hello</title>
         </head>
         <body>
            <h1>Hello you</h1>
            <p>
               <xsl:text>Hello, </xsl:text>
               <xsl:value-of select="$who"/>
               <xsl:text>!</xsl:text>
            </p>
         </body>
      </html>
   </xsl:function>

</xsl:stylesheet>
