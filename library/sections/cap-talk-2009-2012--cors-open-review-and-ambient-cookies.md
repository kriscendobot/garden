---
title: "CORS open review: ambient cookies, legacy requests, and confused-deputy diagrams"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2009-October/
source_snapshot: http://web.archive.org/web/2id_/http://www.eros-os.org/pipermail/cap-talk/2009-October.txt.gz
source_content_sha256: 68456a3c01818f7a9058548bacac397ab922bcebceacde003f2bd129662a02f0
source_authors: [Doug Schepers, Mark Miller, David-Sarah Hopwood, Adam Barth, Sandro Magi, Toby Murray]
source_date: 2009-10-07 to 2009-10-13
thread_subject: "CORS and GIFAR attacks / Open Review of the CORS Specification"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-security, cap-talk-open-questions]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: The October CORS review turns a standards disagreement into two separable questions. Compatibility asks which cross-origin requests browsers already permit and requires preflight only for newly enabled request shapes that might surprise legacy servers. Authority asks whether automatically attached cookies let a requesting page exercise the target origin's ambient credentials, reproducing the browser confused deputy. Hopwood proposes a simpler response-opt-in design that does not expand the request set; Barth defends preflight for custom headers and methods used by deployed applications. The participants agree that the debate needs explicit diagrams or formal models, but do not converge on whether CORS's added features justify its complexity or adequately address ambient cookie authority.

## Compatibility and authority are different constraints

Adam Barth explains preflight as a compatibility guard. Ordinary forms can already send some cross-origin GET and POST requests, but cannot attach arbitrary custom headers or issue every method. Existing servers may rely on those absences, so a new browser API cannot silently widen the request vocabulary.

David-Sarah Hopwood argues that most useful sharing needs only to let the requesting page *read* a cross-origin response. If the request set is not expanded, the server can opt in with a response header and avoid preflight. Barth identifies this as close to the deployed `XDomainRequest` shape and frames the standards choice as features versus complexity.

The deeper objection is ambient authority. Browsers automatically attach cookies applicable to the target rather than requiring the requesting page to designate which credential it intends to use. CORS can therefore make cross-origin composition depend on the target origin's ambient session authority. GIFAR and XSS discussions expose a threat-model dispute: should the client be assumed hostile, and which failures belong to CORS versus the surrounding Web model?

## Making the argument legible

Doug Schepers asks the capability community for diagrams because both camps are talking through jargon and implicit models. Miller points to confused-deputy diagrams, Tyler Close's `ACLs don't` matrix, and Fred Spiessens's formalization and SCOLLAR work. The methodological result matters: a standards security claim should enumerate principals, requests, credentials, and the moment authority is selected, not rely on origin vocabulary alone.

## Bearing on Endo

An Endo web gateway should treat preflight compatibility and capability selection as different layers. Preserving legacy request behavior does not justify ambient credential attachment. A compartment or remote client should explicitly designate the narrow credential or facet used for a request, and validation should happen before a deputy combines caller-controlled destination data with its own session authority. Open question 46 records the unresolved standards tradeoff.

Source: [cap-talk 2009-October archive](http://www.eros-os.org/pipermail/cap-talk/2009-October/) (Internet Archive original-bytes `id_` snapshot of `2009-October.txt.gz`, sha256 `68456a3c`), threads "CORS and GIFAR attacks" and "Open Review of the CORS Specification", 2009-10-07 to 2009-10-13.
