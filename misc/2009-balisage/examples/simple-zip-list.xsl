<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:zip="http://www.expath.org/mod/zip"
                exclude-result-prefixes="#all"
                version="2.0">

   <xsl:import href="http://www.expath.org/mod/zip.xsl"/>

   <xsl:output omit-xml-declaration="yes" indent="yes"/>

   <xsl:template name="main" match="/">

      <!-- the file name -->
      <xsl:variable name="file" select="
          resolve-uri('../presentation/balisage-expath.odp')"/>

      <!-- the entries in the presentation file -->
      <xsl:sequence select="zip:entries($file)"/>

   </xsl:template>

</xsl:stylesheet>
