import module namespace http = "http://expath.org/ns/http-client";

declare namespace h ="http://www.w3.org/1999/xhtml";

let $res := http:send-request(
              <http:request href="http://xmlprague.cz/" method="get"/>)
  return (
    $res[1],
    $res[2]//h:title
  )
