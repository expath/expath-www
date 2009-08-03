xquery version "1.0";

import module namespace http = "http://www.expath.org/mod/http-client"
   at "http://www.expath.org/mod/http-client.xq";

http:send-request(
   <http:request href="http://www.balisage.net/" method="get"/>
)
