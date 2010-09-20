<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:pp="http://expath.org/ns/packager"
                xmlns:files="http://expath.org/ns/files"
                xmlns:zip="http://expath.org/ns/zip"
                exclude-result-prefixes="#all"
                version="2.0">

   <xsl:import href="http://expath.org/ns/packager/package-project.xsl"/>

   <!--
       Add the specs from ../../specs/ to ../src/spec/.
   -->

   <!-- The overload point. -->
   <xsl:template match="zip:file" mode="pp:modify-package">
      <xsl:apply-templates select="." mode="add-specs"/>
   </xsl:template>

   <!-- Copy everything... -->
   <xsl:template match="node()" mode="add-specs">
      <xsl:copy>
         <xsl:copy-of select="@*"/>
         <xsl:apply-templates select="node()" mode="add-specs"/>
      </xsl:copy>
   </xsl:template>

   <!-- ...except the existing (and empty) 'spec' directory. -->
   <xsl:template match="zip:dir[@name eq 'spec']" mode="add-specs">
      <xsl:copy>
         <xsl:copy-of select="@*"/>
         <!-- the 'specs' dir, absolute, resolved from the project's dir -->
         <xsl:variable name="specs" select="resolve-uri('../specs/', $pp:project)"/>
         <!-- recurse in 'specs' and create the appropriate zip:file elements -->
         <xsl:sequence select="pp:zip-directory-content($specs)"/>
      </xsl:copy>
   </xsl:template>

</xsl:stylesheet>
