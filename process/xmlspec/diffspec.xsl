<?xml version="1.0" encoding="UTF-8"?>

<!--
   Home for the XML Spec format: http://www.w3.org/2002/xmlspec/
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.w3.org/1999/xhtml"
                xmlns:h="http://www.w3.org/1999/xhtml"
                xmlns:fg="http://www.fgeorges.org/xmlspec"
                exclude-result-prefixes="fg h"
                version="2.0">

   <!--
      TODO: Add support for Google Analytics.  To do so, must add the following scripts in the webpage:

      <xsl:if test="exists($analytics-id)">
         <script type="text/javascript">
            var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
            document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
         </script>
         <script type="text/javascript">
            try {
               var pageTracker = _gat._getTracker("<xsl:value-of select="$analytics-id"/>");
               pageTracker._trackPageview();
            } catch(err) {}
         </script>
      </xsl:if>
      
      providing we have the following parameter:
      
      <xsl:param name="analytics-id" as="xs:string?" select="'UA-5463082-2'"/>
   -->

   <xsl:import href="diffspec-orig.xsl"/>

   <xsl:output method="xhtml"/>

   <xsl:param name="additional.css">
      <!-- Parameter overriding cannot use the overrode param.  So I
           first include the original value copied and pasted from the
           original diffspec.xsl... -->
      <xsl:if test="$show.diff.markup != 0">
         <xsl:text>
            div.diff-add  { background-color: #FFFF99; }
            div.diff-del  { text-decoration: line-through; }
            div.diff-chg  { background-color: #99FF99; }
            div.diff-off  {  }

            span.diff-add { background-color: #FFFF99; }
            span.diff-del { text-decoration: line-through; }
            span.diff-chg { background-color: #99FF99; }
            span.diff-off {  }

            td.diff-add   { background-color: #FFFF99; }
            td.diff-del   { text-decoration: line-through }
            td.diff-chg   { background-color: #99FF99; }
            td.diff-off   {  }
         </xsl:text>
      </xsl:if>
      <!-- ...then the EXPath spec specific stuff. -->
      code.function { font-weight: bold; }
      code.type { font-style: italic; }
      body {
        background-image: url(http://www.expath.org/images/logo-candidate.png);
      }
   </xsl:param>

   <xsl:template match="/">
      <xsl:variable name="res" as="item()*">
         <xsl:next-match/>
      </xsl:variable>
      <xsl:apply-templates select="$res" mode="postproc"/>
   </xsl:template>

   <!-- Ignore status. -->
   <xsl:template match="status"/>

   <!-- Original stylesheet ignores subtitle (a bug IMHO.) -->
   <xsl:template match="subtitle">
      <xsl:apply-templates/>
   </xsl:template>

   <!-- Put < and > outside of the link. -->
   <xsl:template match="email">
      <xsl:text> </xsl:text>
      <xsl:text>&lt;</xsl:text>
      <a href="{@href}">
         <xsl:apply-templates/>
      </a>
      <xsl:text>&gt;</xsl:text>
   </xsl:template>

   <!-- Make each link in prevlocs appears on its own line -->
   <xsl:template match="prevlocs/loc">
      <xsl:apply-imports/>
      <br/>
   </xsl:template>

   <xsl:template match="fg:function">
      <code class="function">
         <xsl:apply-templates/>
      </code>
   </xsl:template>

   <xsl:template match="fg:type">
      <code class="type">
         <xsl:apply-templates/>
      </code>
   </xsl:template>

   <!--
      Mode: postproc
      Post-process the original output, based on the Modified Identity
      design pattern.
   -->

   <xsl:template match="node()" mode="postproc">
      <xsl:copy>
         <xsl:copy-of select="@*"/>
         <xsl:apply-templates select="node()" mode="postproc"/>
      </xsl:copy>
   </xsl:template>

   <!-- What the fuck is that helpful for? -->
   <xsl:template match="h:head/h:link" mode="postproc"/>

   <xsl:template match="h:head/h:title" mode="postproc">
      <xsl:copy-of select=".|../h:link"/>
   </xsl:template>

   <xsl:template match="h:div[@class eq 'head']" mode="postproc">
      <p>
         <a href="http://www.expath.org/">
            <img src="http://www.expath.org/images/expath-icon.png"
                 alt="EXPath" height="32" width="32"/>
         </a>
      </p>
      <xsl:next-match/>
   </xsl:template>

</xsl:stylesheet>
