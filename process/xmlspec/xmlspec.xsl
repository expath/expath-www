<?xml version="1.0" encoding="UTF-8"?>

<!--
   Home for the XML Spec format: http://www.w3.org/2002/xmlspec/
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.w3.org/1999/xhtml"
                xmlns:h="http://www.w3.org/1999/xhtml"
                xmlns:spec="http://expath.org/ns/xmlspec"
                exclude-result-prefixes="#all"
                version="2.0">

   <xsl:import href="xmlspec-orig.xsl"/>
   <xsl:import href="shared.xsl"/>

   <xsl:param name="additional.css">
      code.function { font-weight: bold; }
      code.type { font-style: italic; }
      /* h1, h2, h3 { color: #84001C; background: white } */
      /* a, :link, :visited, a:active { color: #84005C; background: white } */
      body {
        <xsl:text>background-image: url(</xsl:text>
        <xsl:value-of select="( $logo-offline[$offline], $logo )[1]"/>
        <xsl:text>);</xsl:text>
      }
   </xsl:param>

</xsl:stylesheet>
