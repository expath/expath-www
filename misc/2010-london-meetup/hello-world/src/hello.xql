(: target namespace: http://example.org/ns/hello-world :)

module namespace h = "http://example.org/ns/hello-world";

declare function h:greetings($who as xs:string)
{
  concat('Hello, ', $who, '!')
};
