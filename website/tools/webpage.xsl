<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns="http://www.w3.org/1999/xhtml"
                xmlns:h="http://www.w3.org/1999/xhtml"
                exclude-result-prefixes="xs"
                version="2.0">

   <xsl:output
       method="html"
       encoding="UTF-8"
       doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>

   <!--xsl:variable name="root" as="xs:string?" select="
       if ( /webpage/@root ) then concat(/webpage/@root, '/') else ()"/-->

   <!-- By default, copy XHTML elements. Simple way to escape the XML format. -->
   <xsl:template match="h:*">
      <xsl:copy>
         <xsl:copy-of select="@*"/>
         <xsl:apply-templates/>
      </xsl:copy>
   </xsl:template>

   <xsl:template match="webpage">
      <xsl:param name="menu" as="element(menu)"/>
      <xsl:variable name="root" select="if ( exists(@root) ) then concat(@root, '/') else ()"/>
      <html xml:lang="en">
         <head>
            <xsl:apply-templates select="title"/>
            <meta name="DC.language" scheme="ISO 639-2/T" content="eng" />
            <meta name="DC.publisher" content="Florent Georges" />
            <meta name="DC.creator" content="Florent Georges" />
            <meta name="Author" content="Florent Georges" />
            <meta name="DC.identifier" content="http://www.expath.org/" />
            <meta name="DC.title" content="EXPath - Standards for Portable XPath Extensions" />
            <meta name="DC.description"
               content="EXPath - Collaboratively Defining Open Standards for Portable XPath Extensions" />
            <meta name="description"
               content="EXPath - Collaboratively Defining Open Standards for Portable XPath Extensions" />
            <meta name="keywords"
               content="EXPath XPath XQuery XSLT functions standards open collaborative portable extensions XML development" />
            <link rel="stylesheet" type="text/css" href="{ $root }style/default.css"/>
            <link rel="stylesheet" type="text/css" href="{ $root }style/serial-oxygen.css"/>
         </head>
         <body>
            <div id="upbg"/>
            <div id="outer">
               <div id="header">
                  <div id="headercontent">
                     <h1>EXPath</h1>
                     <h2>(: <i>Collaboratively Defining Open Standards for Portable XPath Extensions</i> :)</h2>
                  </div>
               </div>
               <form method="get" action="search.xql">
                  <div id="search">
                     <input type="text" class="text" maxlength="64" name="keywords" value="" />
                     <input type="submit" class="submit" value="Search" />
                  </div>
               </form>
               <div id="headerpic"/>
               <div id="menu">
                  <xsl:call-template name="menu">
                     <xsl:with-param name="root" select="$root"/>
                     <xsl:with-param name="menu" select="$menu"/>
                  </xsl:call-template>
               </div>
               <div id="menubottom"/>
               <div id="content">
                  <xsl:apply-templates select="* except title"/>
               </div>
               <div id="footer">
                  <div class="left">
                     <a href="http://validator.w3.org/check?uri=referer">
                        <img src="{ $root }images/valid-xhtml11.gif" alt="Valid XHTML 1.1" height="31" width="88" style="border: 0;" />
                     </a>
                     <a href="http://jigsaw.w3.org/css-validator/validator?uri=http://www.expath.org/style/default.css">
                        <img src="{ $root }images/valid-css.gif" alt="Valid CSS!" style="border: 0;" />
                     </a>
                  </div>
                  <div class="right">
                     <div>Powered by: <a href="http://www.exist-db.org/">eXist</a></div>
                     <div>Design by: <a href="http://www.nodethirtythree.com/">NodeThirtyThree Design</a></div>
                     <div><a href="{ $root }credits.html">Credits</a></div>
                  </div>
               </div>
            </div>
         </body>
      </html>
   </xsl:template>

   <xsl:template name="menu">
      <xsl:param name="page" select="."/>
      <xsl:param name="menu" as="element(menu)"/>
      <xsl:param name="root" as="xs:string?"/>
      <!--xsl:variable name="menu.items" as="element()+">
         <item name="index" title="EXPath Home">Home</item>
         <item name="news" title="EXPath News">News</item>
         <item name="lists" title="EXPath Mailing Lists">Mailing lists</item>
         <item name="modules" title="Modules">Modules</item>
         <item name="resources" title="Resources">Resources</item>
      </xsl:variable>
      <ul>
         <xsl:for-each select="$menu.items">
            <li>
               <a href="{ $root }{ @name }.html" title="{ @title }">
                  <xsl:if test="@name eq $page/@menu">
                     <xsl:attribute name="class" select="'active'"/>
                  </xsl:if>
                  <xsl:copy-of select="node()"/>
               </a>
            </li>
         </xsl:for-each>
      </ul-->
      <ul>
         <xsl:for-each select="$menu/*">
            <li>
               <a href="{ @href }" title="{ @title }">
                  <xsl:if test="@name eq $page/@menu">
                     <xsl:attribute name="class" select="'active'"/>
                  </xsl:if>
                  <xsl:copy-of select="node()"/>
               </a>
            </li>
         </xsl:for-each>
      </ul>
   </xsl:template>

   <xsl:template match="section">
      <div class="normalcontent">
         <xsl:apply-templates select="title"/>
         <div class="contentarea">
            <xsl:apply-templates select="* except title"/>
         </div>
      </div>
   </xsl:template>

   <!-- TODO: Should be done for adjacent elements only! -->
   <xsl:template match="primary[exists(preceding-sibling::primary)]" priority="2"/>

   <!-- TODO: Should be done for adjacent elements only! -->
   <xsl:template match="primary">
      <div id="primarycontainer">
         <div id="primarycontent">
            <xsl:for-each select="../primary">
               <div class="post">
                  <xsl:apply-templates select="title"/>
                  <div class="contentarea">
                     <xsl:apply-templates select="* except title"/>
                     <div style="clear: both;"/>
                  </div>
               </div>
               <div class="divider2"/>
            </xsl:for-each>
         </div>
      </div>
   </xsl:template>

   <!-- TODO: Should be done for adjacent elements only! -->
   <xsl:template match="secondary[exists(preceding-sibling::secondary)]" priority="2"/>

   <!-- TODO: Should be done for adjacent elements only! -->
   <xsl:template match="secondary">
      <div id="secondarycontent">
         <xsl:for-each select="../secondary">
            <xsl:variable name="content" as="element()+">
               <xsl:apply-templates select="title"/>
               <div class="contentarea">
                  <xsl:apply-templates select="* except title"/>
               </div>
            </xsl:variable>
            <xsl:choose>
               <xsl:when test="@box/xs:boolean(.)">
                  <div class="box">
                     <xsl:copy-of select="$content"/>
                  </div>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:copy-of select="$content"/>
                  <div class="divider2"/>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:for-each>
      </div>
   </xsl:template>

   <xsl:template match="webpage/title">
      <title>
         <xsl:apply-templates/>
      </title>
   </xsl:template>

   <xsl:template match="section/title">
      <h3>
         <strong>
            <xsl:apply-templates/>
         </strong>
      </h3>
   </xsl:template>

   <xsl:template match="primary/title|secondary/title">
      <h4>
         <xsl:apply-templates/>
      </h4>
   </xsl:template>

   <xsl:template match="image">
      <img class="left">
         <xsl:copy-of select="@*"/>
         <xsl:apply-templates/>
      </img>
   </xsl:template>

   <xsl:template match="para">
      <p>
         <xsl:apply-templates/>
      </p>
   </xsl:template>

   <xsl:template match="list">
      <ul>
         <xsl:apply-templates/>
      </ul>
   </xsl:template>

   <xsl:template match="item">
      <li>
         <xsl:apply-templates/>
      </li>
   </xsl:template>

   <xsl:template match="link">
      <a>
         <xsl:copy-of select="@*"/>
         <xsl:apply-templates/>
      </a>
   </xsl:template>

   <xsl:template match="code">
      <code>
         <xsl:apply-templates/>
      </code>
   </xsl:template>

   <xsl:template match="divider">
      <div class="divider1"/>
   </xsl:template>

   <xsl:template match="details">
      <div class="details">
         <xsl:apply-templates/>
      </div>
   </xsl:template>

   <xsl:template match="sample">
      <xsl:copy-of select="document(@href)"/>
   </xsl:template>

</xsl:stylesheet>
