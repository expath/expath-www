import module namespace http = "http://expath.org/ns/http-client";

(: credentials :)
declare variable $username := 'guest';
declare variable $password := 'guest';

(: document to retrieve, and document to upload :)
declare variable $in  := '/db/tmp/in.xml';
declare variable $out := '/db/tmp/out.xml';

(: URI of the REST interface of eXist instance :)
declare variable $rest := 'http://localhost:8080/exist/rest';

(: the transform rule :)
declare function local:transform($doc as document-node()) as document-node()
{
  document {
    <hello> {
      $doc//who/string(.)
    }
    </hello>
  }
};

(: retrieve the input doc :)
declare function local:get-in() as document-node()
{
  let $req := <http:request href="{ $rest }{ $in }"
                            method="get"
                            username="{ $username }"
                            password="{ $password }"
                            auth-method="basic"
                            send-authorization="true"/>
    return
      (: error checking is left as an exercise :)
      http:send-request($req)[2]
};

(: upload the output doc :)
declare function local:put-out($doc as document-node()) as item()*
{
  let $req := <http:request href="{ $rest }{ $out }"
                            method="put"
                            username="{ $username }"
                            password="{ $password }"
                            auth-method="basic"
                            send-authorization="true">
                 <http:body media-type="application/xml"/>
              </http:request>
    return
      (: error checking is left as an exercise :)
      http:send-request($req, (), $doc)
};

(: retrieve a doc, transform it and upload the result :)
let $doc         := local:get-in()
let $transformed := local:transform($doc)
  return
    local:put-out($transformed)
