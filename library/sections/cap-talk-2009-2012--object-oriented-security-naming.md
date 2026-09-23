---
title: "Object-oriented security: renaming the discipline to reach OO programmers"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2010-March/
source_snapshot: http://web.archive.org/web/2id_/http://www.eros-os.org/pipermail/cap-talk/2010-March.txt.gz
source_content_sha256: 1116e16a6279169b5cc8189a8e245cffe40bf1f47cc567537ccc53803ed979d0
source_authors: [Kenton Varda, Kevin Reid]
source_date: 2010-03-03 to 2010-03-04
thread_subject: "object-oriented-security.org"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-theory, cap-talk-open-questions]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: The single largest thread of March 2010 (around 74 messages) began when Kenton Varda registered `object-oriented-security.org` and proposed rebranding object-capability security as "object-oriented security." His argument is a teaching argument: capability security "is really just a special case of object-oriented design," yet it "takes a considerable amount of thinking before people get it," whereas "object-oriented security" is self-describing to any OO programmer, converts the concept "from something foreign into something familiar," and inherits OOP's positive connotations. He proposed the site define the term, aggregate design patterns, teach the style, and champion projects. The pushback, led by Kevin Reid, is the counter-case the library records as a genuine and never-fully-settled dispute: renaming loses accumulated recognition, "object-oriented security" is *too generic* (it does not distinguish the ocap approach from call-stack-inspection security, the very model ocap opposes), and the field's deeper need is not marketing but "APPLICATIONS and LIBRARIES and other forms of RUNNING CODE and LIVE DEMOS."

## The case for the rename

Varda's premise is the one the Endo lineage agrees with: object-capability security is a special case of good object-oriented design, so any explanation "should start from OOP and ceaselessly stress this relationship." The name "object-oriented security" carries that relationship in the label. He notes he cleared the idea with Mark Miller and other capability advocates at Google first, and observes that "capability-based security" and "object-capability security" mean nothing to someone who does not already understand "capability," while "object-oriented security" has a chance of being correctly interpreted by someone who has never heard of capabilities.

## The case against

Reid's objection has two prongs. First, term proliferation is costly: "every time you change terms you lose what progress you have," because people cannot connect the new term to what they previously heard was interesting, and the field has advanced partly by *almost not naming it at all*. He is fine with "Object-Oriented Security" as the name of a *site* advocating object-capability security, but not as a replacement for the established short form "ocap." Second, and more technically, the name is too generic: it "does not have any components which distinguish our approach from any other concept of security within an object-oriented system, particularly ones which are call-stack-examination based." That is a pointed objection, because stack-inspection security (Java's model) is precisely the ambient-authority approach ocap rejects, and a name that fails to exclude it fails at its one job. Reid's closing pivot, that the field needs running code and live demos more than marketing, is the thread's most-quoted line.

## Bearing on Endo

The productive half of Varda's thesis is now Endo orthodoxy: object-capability security *is* disciplined object-oriented programming (unforgeable references, no ambient authority, authority carried by held [[object-capability]] references), and the best way to teach it is from OO intuitions. The naming half stayed unsettled, which is why it is an open question rather than settled doctrine: the community kept "ocap" and "object-capability," not "object-oriented security," and Reid's generic-name objection is the reason. The dispute is the same terminology fault line the [cap-talk-2009-2012--cookies-as-ambient-authority](cap-talk-2009-2012--cookies-as-ambient-authority.md) section records for URL-borne secrets, generalized to the discipline's own name (see open question 50). Reid's "running code over marketing" point also prefigures the garden's own bias toward demonstrated, executed evidence over argued claims.

Source: [cap-talk 2010-March archive](http://www.eros-os.org/pipermail/cap-talk/2010-March/) (Internet Archive original-bytes `id_` snapshot of `2010-March.txt.gz`, sha256 `1116e16a`), thread "object-oriented-security.org", 2010-03-03 to 2010-03-04.
