<?xml version="1.1" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:zip="http://www.expath.org/mod/zip"
                xmlns="urn:oasis:names:tc:opendocument:xmlns:container"
                exclude-result-prefixes="#all"
                version="2.0">

   <xsl:import href="http://www.expath.org/mod/zip.xsl"/>

   <xsl:output omit-xml-declaration="yes" indent="yes"/>

   <xsl:template name="main" match="/">

      <!-- the output file name -->
      <xsl:variable name="file" select="
          resolve-uri('simple-zip-create.zip')"/>

      <!-- description of the content of the new ZIP file -->
      <xsl:variable name="struct" as="element(zip:file)">
         <!-- the ZIP file itself -->
         <zip:file href="{ $file }">
            <!-- the 'mimetype' file within the ZIP -->
            <zip:entry name="mimetype" output="text">
               <xsl:text>application/epub+zip</xsl:text>
            </zip:entry>
            <!-- some XHTML file within the ZIP -->
            <zip:entry name="hello.html" output="xhtml">
               <html xmlns="http://www.w3.org/1999/xhtml" xmlns:zip="">
                  <head>
                     <title>Hello, world</title>
                  </head>
                  <body>
                     <p>Hello, world!</p>
                  </body>
               </html>
            </zip:entry>
            <!-- the 'META-INF' dir within the ZIP -->
            <zip:dir name="META-INF">
               <!-- the 'container.xml' file within the dir -->
               <zip:entry name="container.xml" output="xml">
                  <container version="1.0">
                     <rootfiles>
                        <rootfile full-path="..." media-type="..."/>
                     </rootfiles>
                  </container>
               </zip:entry>
            </zip:dir>
         </zip:file>
      </xsl:variable>

      <!-- the entries in the presentation file -->
      <xsl:sequence select="zip:zip-file($struct)"/>

   </xsl:template>

</xsl:stylesheet>
