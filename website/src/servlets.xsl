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
      <xsl:variable name="file" select="concat('pages/', $page, '.xml')"/>
      <xsl:choose>
         <xsl:when test="doc-available($file)">
            <web:response status="200" message="Ok">
               <web:body content-type="text/html" method="xhtml"/>
            </web:response>
            <xsl:variable name="doc" as="element(webpage)" select="doc($file)/*"/>
            <xsl:apply-templates select="$doc">
               <xsl:with-param name="page-name" select="tokenize($page, '/')[last()]"/>
            </xsl:apply-templates>
         </xsl:when>
         <xsl:otherwise>
            <web:response status="404" message="Not found">
               <web:body content-type="text/plain" method="text">
                  <xsl:text>Resource not found: </xsl:text>
                  <xsl:value-of select="$page"/>
               </web:body>
            </web:response>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:function>

   <!--
       The addresses have changed, propose to redirect *.html to *.
   -->
   <xsl:function name="app:old-page-servlet">
      <xsl:param name="request" as="element(web:request)"/>
      <xsl:param name="bodies"  as="item()*"/>
      <xsl:variable name="page" select="$request/web:path/web:match[@name eq 'page']"/>
      <web:response status="404" message="Not found">
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

   <xsl:function name="app:search-servlet">
      <xsl:param name="request" as="element(web:request)"/>
      <xsl:param name="bodies"  as="item()*"/>
      <xsl:variable name="page" as="element(webpage)">
         <webpage menu="main" xmlns="">
            <title>EXPath - Search</title>
            <section>
               <title>Search</title>
               <image src="images/machine.jpg" alt="Machine"/>
               <para>The search is not available yet...</para>
            </section>
         </webpage>
      </xsl:variable>
      <web:response status="200" message="Ok">
         <web:body content-type="text/html" method="xhtml"/>
      </web:response>
      <xsl:apply-templates select="$page">
         <xsl:with-param name="page-name" select="'[null]'"/>
      </xsl:apply-templates>
   </xsl:function>

   <!--
       List all the specs.
       
       TODO: Add the latest version (the "current version").  As well
       as the "editor" revision if any.  And use user-friendly names.
       And add different formats (html, xml, diff, etc.)  And sort the
       files...
   -->
   <xsl:function name="app:specs-page-servlet">
      <xsl:param name="request" as="element(web:request)"/>
      <xsl:param name="bodies"  as="item()*"/>
      <xsl:variable name="specs" as="element(spec)+" select="
          document('spec/spec-list.xml')/specs/spec"/>
      <xsl:variable name="page" as="element(webpage)">
         <webpage menu="main" xmlns="">
            <title>EXPath - Specifications</title>
            <section>
               <title>Specifications</title>
               <!--image src="images/machine.jpg" alt="Machine"/>
               <para>Page under construction...</para-->
               <divider/>
               <xsl:for-each select="$specs">
                  <xsl:variable name="spec-name" select="@name"/>
                  <primary>
                     <title>
                        <xsl:value-of select="$spec-name"/>
                     </title>
                     <list>
                        <item>
                           <xsl:text>Latest: </xsl:text>
                           <link href="spec/{ $spec-name }">
                              <xsl:value-of select="$spec-name"/>
                           </link>
                        </item>
                        <xsl:variable name="file-re" select="concat('^', $spec-name, '-[0-9]{8}.xml$')"/>
                        <xsl:for-each select="file[matches(@name, $file-re)]">
                           <item>
                              <xsl:variable name="start" select="string-length($spec-name) + 2"/>
                              <link href="spec/{ $spec-name }/{ substring(@name, $start, 8) }">
                                 <xsl:value-of select="substring(@name, 1, $start + 7)"/>
                              </link>
                           </item>
                        </xsl:for-each>
                     </list>
                  </primary>
               </xsl:for-each>
            </section>
         </webpage>
      </xsl:variable>
      <web:response status="200" message="Ok">
         <web:body content-type="text/html" method="xhtml"/>
      </web:response>
      <xsl:apply-templates select="$page">
         <xsl:with-param name="page-name" select="'specs'"/>
      </xsl:apply-templates>
   </xsl:function>

   <!--
       ...
       
       TODO: Try to see if the address does resolve to a spec, and if
       not try to suggest a correct one (e.g. the latest one for the
       spec, because we allow only addresses starting with a valid
       spec name...)
   -->
   <xsl:function name="app:spec-servlet">
      <xsl:param name="request" as="element(web:request)"/>
      <xsl:param name="bodies"  as="item()*"/>
      <xsl:variable name="spec"   select="$request/web:path/web:match[@name eq 'spec']"/>
      <xsl:variable name="editor" select="$request/web:path/web:match[@name eq 'editor']"/>
      <xsl:variable name="date"   select="$request/web:path/web:match[@name eq 'date']/substring(., 2)"/>
      <xsl:variable name="diff"   select="$request/web:path/web:match[@name eq 'diff']"/>
      <xsl:variable name="xml"    select="$request/web:path/web:match[@name eq 'xml']"/>
      <xsl:variable name="resolved" as="xs:anyURI?" select="
          app:resolve-spec($spec, $spec, exists($editor), $date, exists($diff), exists($xml))"/>
      <xsl:choose>
         <xsl:when test="exists($resolved)">
            <web:response status="200" message="Ok">
               <web:body content-type="text/html" src="{ $resolved }"/>
            </web:response>
         </xsl:when>
         <xsl:otherwise>
            <web:response status="404" message="Not found">
               <web:body content-type="text/plain" method="text">
                  <xsl:text>Specification not found: </xsl:text>
                  <xsl:value-of select="string-join($request/web:path/*[position() gt 1], '')"/>
               </web:body>
            </web:response>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:function>

   <xsl:function name="app:resolve-spec" as="xs:anyURI?">
      <xsl:param name="module" as="xs:string"/>
      <xsl:param name="spec"   as="xs:string"/>
      <xsl:param name="editor" as="xs:boolean"/>
      <xsl:param name="date"   as="xs:string?"/>
      <xsl:param name="diff"   as="xs:boolean"/>
      <xsl:param name="xml"    as="xs:boolean"/>
      <xsl:choose>
         <xsl:when test="$editor">
            <xsl:sequence select="
                resolve-uri(
                  concat(
                    'spec/',
                    $module, '/',
                    $spec,
                    '-diff'[$diff],
                    ('.xml'[$xml], '.html')[1]))"/>
         </xsl:when>
         <xsl:when test="exists($date)">
            <xsl:sequence select="
                resolve-uri(
                  concat(
                    'spec/',
                    $module, '/',
                    $spec, '-',
                    $date,
                    '-diff'[$diff],
                    ('.xml'[$xml], '.html')[1]))"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:variable name="latest" select="app:latest-spec($module, $spec)"/>
            <xsl:if test="exists($latest)">
               <xsl:sequence select="
                   app:resolve-spec($module, $spec, $editor, $latest, $diff, $xml)"/>
            </xsl:if>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:function>

   <xsl:function name="app:latest-spec" as="xs:string?">
      <xsl:param name="module" as="xs:string"/>
      <xsl:param name="spec"   as="xs:string"/>
      <xsl:variable name="file-re" select="concat('^', $spec, '-([0-9]{8}).html$')"/>
      <xsl:variable name="files" as="element(file)*" select="
          document(resolve-uri('spec/spec-list.xml'))/specs/spec[@name eq $spec]/file"/>
      <xsl:variable name="dates" as="xs:string*">
         <xsl:perform-sort select="$files/@version[. ne 'editor']">
            <xsl:sort select="."/>
         </xsl:perform-sort>
      </xsl:variable>
      <xsl:sequence select="$dates[last()]"/>
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
      <web:response status="404" message="Not found">
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
