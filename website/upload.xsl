<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:http="http://www.exslt.org/v2/http-client"
                xmlns:http-java="java:org.fgeorges.exslt2.saxon.HttpClient"
                xmlns:ser="http://www.fgeorges.org/xslt/serial"
                xmlns:my="my..."
                exclude-result-prefixes="#all"
                version="2.0">

   <xsl:param name="href-base" select="'http://localhost:8181/exist/rest/db/xxx/'"/>
   <xsl:param name="username"  select="'admin'"/>
   <xsl:param name="password"  select="'adminadmin'"/>

   <xsl:template match="sitemap">
      <xsl:apply-templates select="*">
         <xsl:with-param name="base" select="base-uri(.)"/>
         <xsl:with-param name="href" select="xs:anyURI($href-base)"/>
      </xsl:apply-templates>
   </xsl:template>

   <xsl:template match="dir">
      <xsl:param name="base" as="xs:anyURI"/>
      <xsl:param name="href" as="xs:anyURI"/>
      <xsl:apply-templates select="*">
         <xsl:with-param name="base" select="
             if ( @base ) then resolve-uri(@base, $base) else $base"/>
         <xsl:with-param name="href" select="
             if ( @href ) then resolve-uri(@href, $href) else $href"/>
      </xsl:apply-templates>
   </xsl:template>

   <xsl:variable name="my:content-types-alist" as="element()+">
      <ct ext="css"  type="text/css"/>
      <!-- TODO: I guess there's a more appropriated type for XSLT. -->
      <ct ext="xsl"  type="application/xml"/>
      <ct ext="xml"  type="application/xml"/>
      <ct ext="html" type="text/html"/>
   </xsl:variable>

   <xsl:template match="page">
      <xsl:param name="base" as="xs:anyURI"/>
      <xsl:param name="href" as="xs:anyURI"/>
      <xsl:variable name="s" select="resolve-uri(@src, $base)"  as="xs:anyURI"/>
      <xsl:variable name="h" select="resolve-uri(@href, $href)" as="xs:anyURI"/>
      <xsl:variable name="ext" select="replace(@src, '^.*\.', '')" as="xs:string"/>
      <xsl:variable name="type" select="$my:content-types-alist[@ext eq $ext]/@type"/>
      <xsl:choose>
         <xsl:when test="$ext eq 'xml'">
            <xsl:variable name="body" as="element()">
               <http:body content-type="{ $type }"/>
            </xsl:variable>
            <xsl:variable name="content">
               <xsl:apply-templates select="doc($s)" mode="format"/>
            </xsl:variable>
            <xsl:sequence select="my:put-in-exist($h, $body, $content)"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:variable name="body" as="element()">
               <http:body href="{ $s }" content-type="{ $type }"/>
            </xsl:variable>
            <xsl:sequence select="my:put-in-exist($h, $body, ())"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <xsl:function name="my:put-in-exist">
      <xsl:param name="href"    as="xs:anyURI"/>
      <xsl:param name="body"    as="element(http:body)"/>
      <xsl:param name="content" as="document-node()?"/>
      <xsl:variable name="req" as="element()">
         <http:request method="put" auth-method="basic" send-authorization="true"
                       username="{ $username }" password="{ $password }">
            <xsl:copy-of select="$body"/>
         </http:request>
      </xsl:variable>
<xsl:message>
   REQ: <xsl:copy-of select="$req"/>
</xsl:message>
      <xsl:variable name="res" select="http-java:send-request($req, $href, $content)"/>
<xsl:message>
   RES: <xsl:copy-of select="$res"/>
</xsl:message>
      <xsl:if test="$res/xs:integer(@status) ne 201">
         <xsl:sequence select="error((), 'TODO: Error in sending HTTP!', $res)"/>
      </xsl:if>
   </xsl:function>

   <xsl:template match="node()" mode="format">
      <xsl:copy>
         <xsl:copy-of select="@*"/>
         <xsl:apply-templates mode="format"/>
      </xsl:copy>
   </xsl:template>

   <xsl:template match="sample" mode="format">
      <xsl:copy-of select="document(@href)"/>
   </xsl:template>

</xsl:stylesheet>
