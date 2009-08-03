<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:zip="http://www.expath.org/mod/zip"
                xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                version="2.0">

   <xsl:import href="http://www.expath.org/mod/zip.xsl"/>

   <xsl:template name="main" match="/">

      <!-- the file name -->
      <xsl:variable name="file" select="
          '../presentation/balisage-expath.odp'"/>

      <!-- the XML entry -->
      <xsl:variable name="doc" select="zip:xml-entry($file, 'meta.xml')"/>

      <!-- the title of the presentation -->
      <title>
         <xsl:value-of select="$doc/*/office:meta/dc:title"/>
      </title>

   </xsl:template>

</xsl:stylesheet>
