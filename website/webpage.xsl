<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns="http://www.w3.org/1999/xhtml"
                exclude-result-prefixes="xs"
                version="2.0">

   <xsl:output method="html" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>

   <xsl:template match="webpage">
      <html xml:lang="en">
         <head>
            <xsl:apply-templates select="title"/>
            <meta name="DC.language" scheme="ISO 639-2/T" content="eng" />
            <meta name="DC.publisher" content="Florent Georges" />
            <meta name="DC.creator" content="Florent Georges" />
            <meta name="Author" content="Florent Georges" />
            <meta name="DC.identifier" content="http://www.expath.org/" />
            <meta name="DC.title" content="EXPath - Standards for Portable XPath extensions" />
            <meta name="DC.description"
               content="EXPath - Collaboratively Defining Open Standards for Portable XPath extensions" />
            <meta name="description"
               content="EXPath - Collaboratively Defining Open Standards for Portable XPath extensions" />
            <meta name="keywords"
               content="EXPath XPath XQuery XSLT functions standards open collaborative portable extensions XML development" />
            <link rel="stylesheet" type="text/css" href="default.css" />
         </head>
         <body>
            <div id="upbg"></div>
            <div id="outer">
               <div id="header">
                  <div id="headercontent">
                     <h1>EXPath</h1>
                     <h2>(: <i>Collaboratively Defining Open Standards for Portable XPath extensions</i> :)</h2>
                  </div>
               </div>
               <form method="get" action="search.xql">
                  <div id="search">
                     <input type="text" class="text" maxlength="64" name="keywords" value="" />
                     <input type="submit" class="submit" value="Search" />
                  </div>
               </form>
               <div id="headerpic"></div>
               <div id="menu">
                  <ul>
                     <li>
                        <a href="index.xml" title="EXPath Home" class="active">Home</a>
                     </li>
                     <li>
                        <a href="about.xml" title="About EXPath">About</a>
                     </li>
                     <li>
                        <a href="lists.xml" title="EXPath Mailing Lists">Mailing lists</a>
                     </li>
                     <li>
                        <a href="modules.xml" title="Modules">Modules</a>
                     </li>
                     <li>
                        <a href="resources.xml" title="Resources">Resources</a>
                     </li>
                     <li>
                        <a href="contact.xml" title="EXPath Contact">Contact</a>
                     </li>
                  </ul>
               </div>
               <div id="menubottom"></div>
               <div id="content">
                  <xsl:apply-templates select="* except title"/>
               </div>
            </div>
         </body>
      </html>
   </xsl:template>

   <xsl:template match="section">
      <div class="normalcontent">
         <xsl:apply-templates select="title"/>
         <div class="details"></div>
         <div class="contentarea">
            <xsl:apply-templates select="* except title"/>
         </div>
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

   <xsl:template match="link">
      <a>
         <xsl:copy-of select="@*"/>
         <xsl:apply-templates/>
      </a>
   </xsl:template>

</xsl:stylesheet>
