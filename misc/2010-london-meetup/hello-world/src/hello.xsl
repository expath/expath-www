<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:pkg="http://expath.org/ns/pkg"
                xmlns:h="http://example.org/ns/hello-world"
                version="2.0">

   <pkg:import-uri>http://example.org/ns/hello-world.xsl</pkg:import-uri>

   <xsl:function name="h:greetings" as="xs:string">
      <xsl:param name="who" as="xs:string"/>
      <xsl:sequence select="concat('Hello, ', $who, '!')"/>
   </xsl:function>

</xsl:stylesheet>
