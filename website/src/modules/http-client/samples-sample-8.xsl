<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"
                xmlns:wsx="http://www.webservicex.net"
                xmlns:http="http://expath.org/ns/http-client"
                exclude-result-prefixes="#all"
                version="2.0">

   <xsl:import href="http://expath.org/ns/http-client.xsl"/>

   <!-- The result is text -->
   <xsl:output method="text"/>

   <!-- To serialize with saxon:serialize() -->
   <xsl:output name="default" indent="yes" omit-xml-declaration="yes"/>

   <!-- The Web service endpoint -->
   <xsl:param name="endpoint" as="xs:string" select="
       'http://www.webservicex.net/WeatherForecast.asmx'"/>

   <!-- The element representing the HTTP request (with the SOAP envelope) -->
   <xsl:variable name="request" as="element()">
      <http:request method="post">
         <http:header name="SOAPAction" value="http://www.webservicex.net/GetWeatherByPlaceName"/>
         <http:body media-type="text/xml">
            <soap:Envelope>
               <soap:Header/>
               <soap:Body>
                  <wsx:GetWeatherByPlaceName>
                     <wsx:PlaceName>NEW YORK</wsx:PlaceName>
                  </wsx:GetWeatherByPlaceName>
               </soap:Body>
            </soap:Envelope>
         </http:body>
      </http:request>
   </xsl:variable>

   <!-- The main template -->
   <xsl:template match="/" name="main">
      <!-- Send the HTTP request and get the result back -->
      <xsl:variable name="response" select="http:send-request($request, $endpoint)"/>
      <!-- Check for error in the HTTP layer -->
      <xsl:if test="$response[1]/xs:integer(@status) ne 200">
         <xsl:sequence select="
             error((), $response[1]/concat('HTTP error: ', @status, ' ', @message))"/>
      </xsl:if>
      <!-- Apply templates to the SOAP's payload -->
      <xsl:apply-templates select="$response[2]/soap:Envelope/soap:Body/*/*"/>
   </xsl:template>

   <!-- Handle the payload -->
   <xsl:template match="wsx:GetWeatherByPlaceNameResult">
      <xsl:text>Place: </xsl:text>
      <xsl:value-of select="wsx:PlaceName"/>
      <xsl:text>&#10;</xsl:text>
      <xsl:apply-templates select="wsx:Details/*"/>
   </xsl:template>

   <!-- Handle a single forecast -->
   <xsl:template match="wsx:WeatherData[*]">
      <xsl:text>  - </xsl:text>
      <xsl:value-of select="wsx:Day"/>
      <xsl:text>:&#09;</xsl:text>
      <xsl:value-of select="wsx:MinTemperatureC"/>
      <xsl:text> - </xsl:text>
      <xsl:value-of select="wsx:MaxTemperatureC"/>
      <xsl:text>&#10;</xsl:text>
   </xsl:template>

</xsl:stylesheet>
