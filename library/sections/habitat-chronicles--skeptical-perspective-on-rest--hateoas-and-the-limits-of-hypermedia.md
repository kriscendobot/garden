---
title: HATEOAS and the limits of hypermedia for machine clients (and the GET-abuse temptation)
source_kind: web-essay
source_url: https://habitat-chronicles.com/2017/11/a-slightly-skeptical-perspective-on-rest/
source_content_sha256: b2248ed5e0aab5476282172f0e0b86c4a9580ce760045d93b3094072641329a2
source_author: Chip Morningstar
source_date: 2017-11-24
ingested: 2026-07-11
ingested_by: scholar
topics: [networking, distributed-objects]
status: current
---

## Abstract

Morningstar's critique of **HATEOAS** ("hypermedia as the engine of application state"),
prefaced by the practical GET-abuse it partly explains. On the practical side ("REST vs.
the code monkeys"): a touted benefit of using HTTP is that developers can leverage the
**web browser** as a client, typing URLs to test and debug — but the browser gives ready
access mostly to **GET** and hides most headers, so lazy developers "simply violate the
rules," cramming everything into the URL and doing everything with GET (abetted by
backends like PHP that interchange GET/POST and query-string/body parameters
transparently). REST partisans decry this as violating safety and idempotency and
interfering with caching; Morningstar agrees they are "surely right" and you "probably
should care" — while noting RFC 2616 uses "SHOULD," not "MUST," and much of the web's
pipeline never actually enforces these rules. On HATEOAS proper: it contains "a really
good idea and a really bad idea all tangled up in each other." The **good idea** — deliver
the possible next-state links *in each response* rather than baking them into the client —
genuinely reduces client-side dependencies and lets you relocate, split, or merge services
after the client is locked down ("a major benefit REST brings to the enterprise"). The
**bad idea** is the human-web analogy: *we present all the options, you pick one, we
present new options*. That works for **humans** — "general-purpose context interpreters"
who come "prepackaged with a large, general-purpose ontology" and can read the documentary
information on a page — but **machines are blind**: a program has only enough interpretive
ability to make sense of what it already expects. The available transitions are
**referenced but not described**; the metadata that *is* provided is interpreted by a
client-side developer at *application-development time*, not by an end user at
*application-use time* — a "profoundly different" gap. "**In the REST case the client must
be anticipatory whereas in the web case the client (the human user) can be reactive.**"

## Content

### REST vs. the code monkeys (the GET-abuse temptation)

A touted side benefit of using HTTP as the application protocol is that developers can
**leverage the web browser**: since the browser speaks HTTP, it can speak to a RESTful
service directly, with the browser UI playing the role of client (distinct from
JavaScript in the browser being the client). This makes it easy to try things out — for
testing, debugging, and experimentation — by typing URLs and looking at what comes back.
Unfortunately, the only verb you typically have ready access to this way is **GET**, and
even then you cannot control the headers the browser attaches nor gracefully see
everything the server sends back. HTTP is a complex protocol with lots of bells and
whistles, and the browser UI exposes only a portion of it.

You could write a JavaScript app in the browser to provide the missing affordances (many
such tools exist), but "sometimes it's easier, when you are a lazy developer, to simply
violate the rules and do everything in a way that leverages the affordances you have ready
access to." Thus we get service APIs that **put everything into the URL and do everything
using GET** — behavior "aided and abetted" by backend tools like PHP that transparently
interchange GET and POST and treat form-submission (body) parameters and query-string
(URL) parameters equivalently. REST partisans decry this as unforgivable sloppiness that
violates safety and idempotency and interferes with caching. To the extent you care about
these things they are "surely right," and prudence suggests you probably should care. On
the other hand, Morningstar is "not sure we can glibly say that the sloppy developers are
completely wrong either": **RFC 2616** speaks of the safety and idempotency of GET with
"SHOULD" rather than the "more sacrosanct MUST," and nothing in many embodiments of the
conventional web pipeline actually enforces these rules — they are "principally observed
as conventions of the medium."

### HATEOAS is a lie (but there will be cake)

A big idea behind REST is expressed in "hypermedia as the engine of application state,"
often rendered as the "dreadful abbreviation **HATEOAS**." Here Morningstar finds "a
really good idea and a really bad idea all tangled up in each other." The notion draws an
analogy to how the web works with humans: the user is presented with a page offering
options (click a button, submit a form, abandon the interaction); behind each is a link
used for a GET or POST, fetching a new page that presents a new set of options — "lather,
rinse, repeat." Each page represents the current state of the dialog. **Implicit in this
is that the allowed state transitions are explicitly represented on the page itself**,
without reference to context held elsewhere. HATEOAS embraces the same model for
machine-to-machine interaction: each reply should contain the links to the possible next
states, rather than having them baked into the client or computed from an externally
specified rule set.

**The good idea.** Glossing over that the human-web model is itself "a bit of a fiction"
(more so as Ajax dominates), it is close enough to be very useful. The big benefit is
building **fewer dependencies into the client**: because we deliver specific URIs with
each response, we retain flexibility to change them even after the client is locked down —
free to relocate services to different hosts or vendors, to refactor services apart or to
merge them together. "All this is quite valuable and is a major benefit that REST brings
to the enterprise."

**The bad idea.** The human-case model does not entirely work in the machine case:
*present all the options, you pick one, causing a new set of options* is broken because
"machines can't quite do this." **Humans are general-purpose context interpreters**,
whereas **machines are typically much more limited**. A piece of software typically has a
specific purpose and contains only enough interpretive ability to make sense of
information it is "already expecting to receive." Web interfaces need only present humans a
set of alternatives that make enough sense that people can figure out what to do;
interfaces for machines must present information "more or less exactly what the recipient
was expecting." Put another way, **the human comes prepackaged with a large,
general-purpose ontology, whereas client software does not.** Much of what appears on a
web page is documentary information that lets a person figure things out; "computers are
not yet able to parse these at a semantic level in the general case." This is papered over
by the passive-verb tendency ("the application transitions to the state identified by URI
X"), which captures nothing about *how* the application determined which URI to pick next.
"We know how humans do it, but machines are blind."

The gap widens when an operation entails not just an endpoint (URI) but a set of
parameters encoded into a POST body. On the web, the server vends a `<FORM>` of `<INPUT>`
elements a human can make sense of; absent AI, "this is beyond the means of a programmed
client." There is "a whole layer of protocol and metadata that the human/web interaction
incorporates inline that a REST service interface has to handle out of band." **The
available state transitions are referenced, but not actually described**; and to the
extent descriptive metadata *is* provided (e.g., a URI in a `rel` attribute), it is
interpreted by a client-side developer **at application-development time**, whereas in the
human web case it is interpreted by the end user **at application-use time**. This is
"profoundly different": a huge difference in the time-of-analysis to time-of-use gap, and
in the web case the analyzer and the user are the same entity while in the REST case they
are not. **"In particular, in the REST case the client must be anticipatory whereas in the
web case the client (which is to say, the human user) can be reactive."**

Source: [A Slightly Skeptical Perspective on REST](https://habitat-chronicles.com/2017/11/a-slightly-skeptical-perspective-on-rest/) by Chip Morningstar, 2017-11-24 (content sha256 `b2248ed5`).
