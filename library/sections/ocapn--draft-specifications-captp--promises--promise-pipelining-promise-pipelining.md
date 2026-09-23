---
title: "[Promise pipelining](#promise-pipelining)"
source: "draft-specifications/CapTP Specification.md"
source_repo: kriscendobot/ocapn
source_commit: 8704f69e01f93701de8bc5eb4bb22b9927a2665a
source_date: 2026-03-12
source_authors: [Jessica Tallon]
ingested: 2026-05-14
ingested_by: scholar
project: ocapn
topics: [ocapn, captp, eventual-send]
status: current
notes: Maps to library/sections/endo--pkg-eventual-send-readme--handled-promise.md and library/sections/endo--pkg-eventual-send-readme--promise-pipelining.md.
parent: ocapn--draft-specifications-captp--promises
---

When an [`op:deliver`](#opdeliver) message is sent and a result is pending, it
is often desirable to use this result. One way to do this would be to wait until
the promise has been resolved and then send the next message to the result.
While this approach can be taken within OCapN, promise pipelining is preferred.
When a message is sent with an `answer-pos` specified, the promise on the remote
session can then be referenced and messaged with the
[`desc:answer`](#desc-answer) descriptor. When a promise is fulfilled to an
object, messages sent to the promise will be delivered to that object.

### Promise pipelining by example

In this example we send an initial message to the object exported at position
`5` (a factory builder) and tell the remote session to export the promise at
answer position `3` (a car factory), then we send a message to the promise at
that answer position to make a car and export it at answer position `4`, finally
we send a message to the promise of a car at answer position `4` to drive it.

We set the `resolve-me-desc` in the first two messages to false because we won't
need the peer to send us a reference to the car factory or to the car. We do 
provide a `resolve-me-desc` for the third message so the peer sends us the 
driving noise.

The messages delivered are as follows:

```
<op:deliver <desc:export 5> ['make-car-factory] 3 false>>
<op:deliver <desc:answer 3> ['make-car] 4 false>
<op:deliver <desc:answer 4> ['drive] 5 <desc:import-object 17>>
```

In this way, it is not necessary to wait to dispatch messages until the promise
has been resolved. Messages can just be sent in advance to a promise of the
eventual object as they normally would to its eventual resolution. This also
improves efficiency by reducing the number of round trips needed to perform the
same task. Take the above example of a car factory which produces a car, the car
then can be driven which will produce a noise. Without promise pipelining this
would look something like this:

1.  Send message to create car factory
2.  Get back a reference to the car factory once it is made
3.  Send message to car factory to make a car
4.  Get back a reference to the car
5.  Send message to car to drive
6.  Get back the driving noise.

This is compared to when you use promise pipelining:

1.  Send message to create car factory
2.  Send message to car factory promise to make a car
3.  Send message to car promise to drive
4.  Get back driving noise

The other CapTP session, which is making the car factory, car, and finally car
noise, is able deliver those messages immediately to the local objects on their
side as they become fulfilled and send the car noise back at the end.

Source: `draft-specifications/CapTP Specification.md` at commit `8704f69e` (held at kriscendobot/ocapn).
