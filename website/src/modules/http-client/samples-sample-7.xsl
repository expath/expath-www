<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:http="http://www.expath.org/mod/http-client"
                xmlns:http-java="java:org.expath.saxon.HttpClient"
                xmlns:goog="http://www.fgeorges.org/ns/xslt/google"
                exclude-result-prefixes="#all"
                version="2.0">

   <!--
       Google information about authentication and contacts API:
       http://code.google.com/apis/accounts/docs/AuthForInstalledApps.html
       http://code.google.com/apis/contacts/developers_guide_protocol.html
   -->

   <xsl:output indent="yes"/>

   <!-- The account to use (the address email) -->
   <xsl:param name="account" as="xs:string" required="yes"/>
   <!-- The associated password, required -->
   <xsl:param name="pwd"     as="xs:string" required="yes"/>

   <!--
       Utility: check for error in HTTP response.
   -->
   <xsl:function name="goog:check-error">
      <!-- the HTTP response element -->
      <xsl:param name="response" as="element(http:response)"/>
      <!-- message in case of error -->
      <xsl:param name="message" as="xs:string"/>
      <xsl:variable name="status" select="xs:integer($response/@status)"/>
      <xsl:if test="not($status ge 200 or $status le 299)">
         <xsl:sequence select="
             error((), concat($message, ': ', $response/@message))"/>
      </xsl:if>
   </xsl:function>

   <!--
       The authentication parameters, as simple param elements.
   -->
   <xsl:function name="goog:auth-params" as="element(param)+">
      <!-- the email (user account) -->
      <xsl:param name="email" as="xs:string"/>
      <!-- the password -->
      <xsl:param name="pwd" as="xs:string"/>
      <!-- $email can be abbreviated if @gmail.com -->
      <xsl:variable name="full-email" select="
          if ( contains($email, '@') ) then
            $email
          else
            concat($email, '@gmail.com')"/>
      <!-- the param elements -->
      <param name="Email">
         <xsl:value-of select="$full-email"/>
      </param>
      <param name="Passwd">
         <xsl:value-of select="$pwd"/>
      </param>
      <param name="source">fgeorges.org-contacts-1</param>
      <param name="service">cp</param>
      <param name="accountType">
         <xsl:value-of select="
             if ( ends-with($full-email, '@gmail.com') ) then
               'GOOGLE'
             else
               'HOSTED_OR_GOOGLE'"/>
      </param>
   </xsl:function>

   <!--
       Authenticates to the Google server, and returns the
       authentication token.
   -->
   <xsl:function name="goog:auth-token" as="xs:string">
      <!-- the email (user account) -->
      <xsl:param name="email" as="xs:string"/>
      <!-- the password -->
      <xsl:param name="pwd" as="xs:string"/>
      <!-- the endpoint -->
      <xsl:variable name="endpoint" as="xs:string" select="
          'https://www.google.com/accounts/ClientLogin'"/>
      <!-- the http request element -->
      <xsl:variable name="request" as="element()">
         <http:request method="post" href="{ $endpoint }">
            <http:body content-type="application/x-www-form-urlencoded">
               <xsl:for-each select="goog:auth-params($email, $pwd)">
                  <xsl:value-of select="@name"/>
                  <xsl:text>=</xsl:text>
                  <xsl:value-of select="encode-for-uri(.)"/>
                  <xsl:if test="position() ne last()">
                     <xsl:text>&amp;</xsl:text>
                  </xsl:if>
               </xsl:for-each>
            </http:body>
         </http:request>
      </xsl:variable>
      <!-- send the request and get the response -->
      <xsl:variable name="response" select="http-java:send-request($request)"/>
      <!-- was the request ok? -->
      <xsl:sequence select="goog:check-error($response[1], 'Error while login')"/>
      <!-- get the auth token in the response -->
      <xsl:sequence select="
          substring-after(
            tokenize($response[2], '&#10;')
              [substring-before(., '=') eq 'Auth'],
            '=')"/>
   </xsl:function>

   <!--
       Get a simple feed content.
       
       Send to the right endpoint (regarding the feed), a simple HTTP
       GET, with the right HTTP header for authorization (defined by
       Google).  Then check the response, and if everything was ok,
       parse the XML result.
   -->
   <xsl:function name="goog:get-feed" as="element()">
      <!-- the authentication token -->
      <xsl:param name="auth" as="xs:string"/>
      <!-- the feed name -->
      <xsl:param name="feed" as="xs:string"/>
      <!-- the endpoint -->
      <xsl:variable name="endpoint" as="xs:string" select="
          concat('https://www.google.com/m8/feeds/',
                 $feed,
                 '/default/full?max-results=1000')"/>
      <!-- the http request element -->
      <xsl:variable name="request" as="element()">
         <http:request method="get" href="{ $endpoint }">
            <http:header name="Authorization" value="GoogleLogin auth={ $auth }"/>
         </http:request>
      </xsl:variable>
      <!-- send the request and get the response -->
      <xsl:variable name="response" select="http-java:send-request($request)"/>
      <!-- was the request ok? -->
      <xsl:sequence select="goog:check-error($response[1], 'Error while getting groups')"/>
      <!-- get the response as an xml element -->
      <xsl:sequence select="$response[2]/*"/>
   </xsl:function>

   <!--
       Main template: authenticates, then gets contacts and groups.
   -->
   <xsl:template name="main">
      <contacts-and-groups>
         <!-- the authentication token -->
         <xsl:variable name="auth" select="goog:auth-token($account, $pwd)"/>
         <!-- the contacts -->
         <xsl:sequence select="goog:get-feed($auth, 'contacts')"/>
         <!-- the groups -->
         <xsl:sequence select="goog:get-feed($auth, 'groups')"/>
      </contacts-and-groups>
   </xsl:template>

</xsl:stylesheet>
