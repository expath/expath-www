module namespace h = "http://fgeorges.org/tmp/hello";

import module namespace functx = "http://www.functx.com";

declare function h:hello($who as xs:string) as xs:string
{
  concat('Hello, ', functx:capitalize-first($who), '!')
};
