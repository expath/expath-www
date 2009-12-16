<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
   xmlns:xs="http://www.w3.org/2001/XMLSchema" 
   xmlns:zip="http://www.expath.org/mod/zip"
   version="2.0">
   
   <xsl:import href="http://www.expath.org/mod/zip.xsl"/>
   
   <xsl:output indent="yes"/>
   
   <!--
      $file is the ZIP file to use.  If $entry is set, extract that
      entry from $file, as an XML document.  If not, list the content
      of $file.
   -->
   <xsl:param name="file"  as="xs:string"/>
   <xsl:param name="entry" as="xs:string?"/>
   
   <xsl:template name="main" match="/">
      <xsl:choose>
         <xsl:when test="$entry">
            <!-- an XML entry in the ZIP file -->
            <xsl:sequence select="zip:xml-entry($file, $entry)"/>
         </xsl:when>
         <xsl:otherwise>
            <!-- the structure of the ZIP file -->
            <xsl:sequence select="zip:entries($file)"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   
</xsl:stylesheet>
