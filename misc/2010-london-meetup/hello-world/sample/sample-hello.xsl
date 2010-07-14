<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:h="http://example.org/ns/hello-world"
                exclude-result-prefixes="#all"
                version="2.0">

   <xsl:import href="http://example.org/ns/hello-world.xsl"/>

   <xsl:output indent="yes"/>

   <xsl:template name="main" match="/">
      <greetings>
         <xsl:value-of select="h:greetings('world')"/>
      </greetings>
   </xsl:template>

</xsl:stylesheet>
