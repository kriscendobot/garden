---
title: "E-style membranes in JavaScript, and fine-grained object views"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2012-March/
source_snapshot: http://web.archive.org/web/2id_/http://www.eros-os.org/pipermail/cap-talk/2012-March.txt.gz
source_content_sha256: 6deacabd27bcb3ca4c363ea790ca8569dd9d5c871cf421de257fec803a82ce29
source_authors: [Tom Van Cutsem, David Wagner, Mark Miller]
source_date: 2012-03-30
thread_subject: "Membranes"
ingested: 2026-09-16
ingested_by: scholar
topics: [hardened-javascript, patterns, revocation, capability-security]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: Tom Van Cutsem announced an introductory write-up of E-style membranes implemented in JavaScript, offered as a demonstration that you can create *revocable object-capabilities over entire object graphs* — not just a single object, but every object transitively reachable through it. David Wagner welcomed it and pointed to the research paper "Object Views: Fine-Grained Sharing in Browsers" (Meyerovich, Porter Felt, and Miller, WWW 2010), which uses membranes to implement sophisticated fine-grained access control over JavaScript objects. The exchange is short but marks the moment E's membrane pattern is shown to be practical in JavaScript, using the (then-emerging) Proxy machinery to interpose on every message crossing a boundary between two subgraphs of objects.

## Membranes make revocation transitive

The load-bearing property is transitivity. A bare revocable forwarder revokes access to *one* object, but any object that the target returns or accepts as an argument escapes the forwarder and remains reachable after revocation. A membrane closes this by wrapping every object that crosses the boundary in a matching membrane proxy, so that the entire object graph reachable through the initial reference is revoked *together* when the membrane is cut. This is exactly the completeness requirement the [modeling-capability-propagation-and-horton](cap-talk-2009-2012--modeling-capability-propagation-and-horton.md) thread showed a logging membrane failing when a raw reference leaked through an exception: a membrane is only sound if nothing — argument, return value, or thrown value — crosses it un-wrapped. Van Cutsem's JavaScript implementation and the "Object Views" paper both rest on interposing generically on every crossing, which is why Proxy-style virtualizability (the language feature Kevin Reid named in [language-support-for-object-capabilities](cap-talk-2009-2012--language-support-for-object-capabilities.md)) is the enabling primitive.

## Fine-grained sharing without copying

The "Object Views" direction is the second point: membranes are not only for revocation but for *attenuation* — presenting a caller a restricted *view* of a shared object graph (read-only, or with some methods hidden or transformed) without duplicating the underlying state. Fine-grained sharing in a browser mashup means one page can hand another a live but constrained view of its objects, with the membrane enforcing the restriction on every access. This is the pattern that lets mutually-suspicious code share structured data safely.

## Bearing on Endo

This thread is the immediate technical antecedent of Endo's membrane machinery. Tom Van Cutsem went on to co-author the JavaScript Proxy specification and much of the SES membrane work, and the "revocable ocaps over entire object graphs via Proxy" construction described here is the same one SES/Endo ship for revocation and for crossing trust boundaries. Endo relies on exactly the transitivity property this thread names: a caretaker or membrane must wrap everything crossing the boundary so that revocation is complete and an attenuated view cannot be escaped by fishing out a raw inner reference. The "Object Views" fine-grained-view idea is the ancestor of Endo's attenuating facets and read-only views — presenting a narrowed live view rather than a copy — and the whole approach depends on `harden()` and frozen intrinsics to guarantee the membrane cannot be bypassed by monkey-patching the objects it wraps.

Source: [cap-talk 2012-March archive](http://www.eros-os.org/pipermail/cap-talk/2012-March/) (Internet Archive original-bytes `id_` snapshot of `2012-March.txt.gz`, sha256 `6deacabd`), thread "Membranes", 2012-03-30.
