# Orch #

Orch is a playground for experimenting with the Aeolus deployable XML format and Audrey, independent of any integration to Aeolus Conductor.

Orch consists of two parts:

1. A simple, stateless Sinatra server which can launch a deployable and return a URL representing the group of instances launched. This can be backed by any Deltacloud API.
2. A library which applications like Conductor can use to integrate the concept.

To run the server, simply do:

    $> ruby -I lib server.rb

To test it, first launch a Deltacloud server:

    $> deltacloudd -i mock -p 3002

and then e.g.:

    $> curl -i -X POST -H 'Accept: application/xml' --data-ascii "$(cat sample-deployable.xml)" 'http://mockuser:mockpassword@localhost:4567/?name=foo&realm=eu'
    HTTP/1.1 201 Created
    Location: /inst33,inst34
    ...
    <instances>
      <instance href='http://localhost:3002/api/instances/inst33' id='inst33'>
        ...
      </instance>
      <instance href='http://localhost:3002/api/instances/inst34' id='inst34'>
        ...
      </instance>
    </instances>

    $> curl -H 'Accept: application/xml' http://mockuser:mockpassword@localhost:4567/inst33,inst34
    <instances>
    ...
