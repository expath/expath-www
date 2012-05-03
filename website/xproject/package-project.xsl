<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:proj="http://expath.org/ns/project"
                xmlns:zip="http://expath.org/ns/zip"
                exclude-result-prefixes="#all"
                version="2.0">

   <xsl:import href="http://expath.org/ns/project/package.xsl"/>

   <!--
       Add the specs from ../../specs/ to ../src/spec/, and set the $version
       and $revision values in webpage.xsl.
   -->

   <!-- The overload point. -->
   <xsl:template match="zip:file" mode="proj:modify-package">
      <xsl:apply-templates select="." mode="add-specs-and-version"/>
   </xsl:template>

   <!-- Copy everything... -->
   <xsl:template match="node()" mode="add-specs-and-version">
      <xsl:copy>
         <xsl:copy-of select="@*"/>
         <xsl:apply-templates select="node()" mode="add-specs-and-version"/>
      </xsl:copy>
   </xsl:template>

   <!-- ..except garbage... -->
   <!-- TODO: Still needed? -->
   <xsl:template match="zip:dir[@name eq '.~']" mode="add-specs-and-version"/>

   <!-- ...except the existing (and empty) 'spec' directory... -->
   <xsl:template match="zip:dir[@name eq 'spec']" mode="add-specs-and-version">
      <xsl:copy>
         <xsl:copy-of select="@*"/>
         <!-- the 'specs' dir, absolute, resolved from the project's dir -->
         <xsl:variable name="specs" select="resolve-uri('../specs/', $proj:project)"/>
         <!-- recurse in 'specs' and create the appropriate zip:file elements -->
         <xsl:variable name="content" select="proj:zip-directory-content($specs)"/>
         <xsl:sequence select="$content"/>
         <!-- create the file spec/spec-list.xml -->
         <zip:entry name="spec-list.xml" method="xml" indent="yes">
            <specs>
               <xsl:for-each select="$content">
                  <xsl:variable name="name" select="@name"/>
                  <xsl:variable name="file-re" select="
                      concat('^', $name, '(-([0-9]{8}))?(-diff)?.(ht|x)ml$')"/>
                  <spec name="{ $name }">
                     <xsl:for-each select="zip:entry">
                        <xsl:variable name="version" select="replace(@name, $file-re, '$2')"/>
                        <file name="{ @name }"
                              version="{ if ( $version ) then $version else 'editor' }"
                              format="{ substring-after(@name, '.') }"
                              diff="{ contains(@name, '-diff') }"/>
                     </xsl:for-each>
                  </spec>
               </xsl:for-each>
            </specs>
         </zip:entry>
      </xsl:copy>
   </xsl:template>

   <!-- ...and except the webpage.xsl stylesheet... -->
   <xsl:template match="zip:file/zip:dir/zip:entry[@name eq 'webpage.xsl']"
                 mode="add-specs-and-version">
      <xsl:copy>
         <xsl:copy-of select="@* except @src"/>
         <xsl:attribute name="method" select="'xml'"/>
         <xsl:apply-templates select="doc(@src)" mode="add-specs-and-version"/>
      </xsl:copy>
   </xsl:template>

   <!-- ...by resolving the $version and $revision global variables. -->
   <xsl:template match="xsl:stylesheet/xsl:variable[@name = ('version', 'revision')]"
                 mode="add-specs-and-version">
      <xsl:copy>
         <xsl:copy-of select="@* except @select"/>
         <xsl:attribute name="select" select="
             replace(
               replace(@select, '@@REVISION@@', $proj:revision),
               '@@VERSION@@', $proj:version)"/>
      </xsl:copy>
   </xsl:template>

</xsl:stylesheet>
