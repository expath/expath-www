<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:f="http://www.functx.com"
                exclude-result-prefixes="f"
                version="2.0">

   <xsl:import href="http://www.functx.com/functx.xsl"/>

   <xsl:output indent="yes"/>

   <xsl:template name="main">
      <result>
         <xsl:sequence select="f:date(1979, 9, 1)"/>
      </result>
   </xsl:template>

</xsl:stylesheet>
