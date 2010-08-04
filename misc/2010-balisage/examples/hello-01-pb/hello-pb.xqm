import module namespace functx = "http://www.functx.com";

declare function local:hello($who as xs:string) as xs:string
{
  concat('Hello, ', functx:capitalize-first($who), '!')
};

<html xmlns="http://www.w3.org/1999/xhtml">
   <head>
      <title>Balisage example</title>
   </head>
   <body>
      <p> {
        local:hello('exist')
      }
      </p>
   </body>
</html>
