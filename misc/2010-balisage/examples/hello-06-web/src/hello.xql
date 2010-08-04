module namespace h = "http://fgeorges.org/tmp/hello";

declare namespace web = "http://expath.org/ns/webapp";

declare function h:home-servlet($request, $bodies)
{
  h:respond-html(
    <p>
       <form action="hello" method="get">
          <fieldset>
             <label>Name:</label>
             <input type="text" name="who"/>
          </fieldset>
       </form>
    </p>)
};

declare function h:hello-servlet($request, $bodies)
{
  h:respond-html(
    <p>Hello, { xs:string($request/web:param[@name eq 'who']/@value) }!</p>)
};

declare function h:respond-html($content as element())
{
  <web:response status="200" message="Ok">
     <web:body content-type="text/html" method="xhtml"/>
  </web:response>
  ,
  <html xmlns="http://www.w3.org/1999/xhtml">
     <head>
        <title>Hello</title>
     </head>
     <body> {
       $content
     }
     </body>
  </html>
};
