<!-- The request element to get Google page. -->
<xsl:variable name="req" as="element()">
   <http:request href="http://www.google.com/" method="get"/>
</xsl:variable>

<!-- The response sequence (http:response + HTML doc.) -->
<xsl:variable name="resp" select="http:send-request($req)"/>

<!-- If status code is not 200, throw an error. -->
<xsl:if test="$resp[1]/xs:integer(@status) ne 200">
   <xsl:sequence select="error((), 'Status is not 200.')"/>
</xsl:if>

<!-- Use the title element in the HTML document. -->
<xsl:value-of select="$resp[2]/h:html/h:head/h:title"/>
