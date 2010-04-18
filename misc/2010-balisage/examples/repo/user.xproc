<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:f="http://www.functx.com"
                version="1.0">

   <p:input port="parameters" kind="parameter"/>
   <p:input port="source"/>
   <p:output port="result"/>

   <p:xslt template-name="main">
      <p:input port="stylesheet">
         <p:document href="user.xsl"/>
      </p:input>
   </p:xslt>

</p:declare-step>
