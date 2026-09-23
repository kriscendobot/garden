---
title: "The Origin header amplifies ambient authority: why CORS-style access decisions recreate the confused deputy"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2009-June/
source_snapshot: http://web.archive.org/web/2id_/http://www.eros-os.org/pipermail/cap-talk/2009-June.txt.gz
source_content_sha256: 5b9ecc12441b145590b2d016b15cc5aa279c342a736bd9c18258b3c633c13dda
source_authors: [Mark Miller, Bil Corry, Tyler Close, David-Sarah Hopwood]
source_date: 2009-06-03 to 2009-06-30
thread_subject: "Origin enables XSS to escalate to XSRF (was: security issue with XMLHttpRequest API compatibility) / CORS"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-security, cap-talk-open-questions]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: In the middle of the browser-security standards fight of 2009 (CORS, the Origin header, XHR compatibility), Mark Miller lays out the object-capability critique of origin-based cross-site access control: every current Origin proposal *amplifies* rather than fixes the browser's worst hazard, the abuse of ambient authority that creates confused-deputy conditions. His diagnosis rests on a fact about the page as a security boundary: "all scripts that execute on a page are implicitly allowed to exercise all the authority that this browser associates with that page's origin," yet pages routinely contain content — mashups, gadgets, ad libraries — "whose authorship does not correspond to the browser's notion of origin." Quoting Crockford's w2sp keynote, "A mashup is a self inflicted cross site script." The Origin header's whole purpose is to let a server make allow/deny decisions from the presented origin value, which means a script on a page from origin A can make a cross-origin request to server B and *exercise the authority B associates with A* — and if the browser still attaches B's ambient credentials (cookies), the design has also failed to fix the existing XSRF danger it purported to address. The thread is the mailing-list root of the argument SES/Caja would carry into browser standards: security must ride *unforgeable designated references*, not the *ambient* pairing of an origin string with browser-attached credentials.

## The core argument

The Origin header was proposed so servers could allow or deny cross-origin requests based on the requester's origin. Miller's objection is that this makes access a function of an *ambient*, browser-asserted attribute rather than of a designated capability:

> a script running on a page from origin A can now make a cross-origin request to a server at origin B and exercise the authority that this server associates with origin A. If some of these origin proposals still allow the browser to present the credentials (e.g., cookies) that browser associates with B, then, despite protestations to the contrary, we have also failed to address existing XSRF dangers.

Two ambient authorities stack here: the origin the browser vouches for (A), and the credentials the browser auto-attaches for the target (B). Cross-site request forgery is exactly the confused deputy — the browser is the deputy, wielding the user's B-authority on behalf of a page it should not trust — and origin-based access control leaves that deputy in place while adding a second attackable attribute.

## Why the page is the wrong boundary

The deeper point is that the browser's origin *is not the unit of authorship*. A modern page is a composite:

> pages contain content -- whether mashups, gadgets, or simple libraries -- whose authorship does not correspond to the browser's notion of origin ... The problem isn't the mixing of scripts representing different interests. The problem is that all scripts that execute on a page are implicitly allowed to exercise all the authority that this browser associates with that page's origin.

Crockford's slogan — "A mashup is a self inflicted cross site script" — captures that composing third-party code into a page voluntarily grants that code the page's full ambient origin-authority. The same-origin policy already carries this defect (Miller points at Close's "ACLs don't" material); the Origin/CORS proposals extend the defective model to cross-origin traffic instead of replacing it. This is the same "ambient authority is the hazard" thread as [defining-ambient-authority](cap-talk-2009-2012--defining-ambient-authority.md), applied to the concrete web platform.

## The direction of a fix

Miller notes that several proposals in the standards threads, "if combined and extended, point towards a solution" — the capability direction: cross-origin authority should ride an *unforgeable, designated* token (a web-key / capability URL that the recipient must have been explicitly given), not the browser's assertion of the caller's origin plus its automatic attachment of the target's cookies. That is the same principle as the March [solve-csrf-unforgeable-not-unshareable](cap-talk-2009-2012--solve-csrf-unforgeable-not-unshareable.md) thread: make the reference unforgeable so possession *is* authorization, rather than trying to police who is allowed to wield ambient authority.

## Bearing on Endo

This is the browser-platform motivation for the whole SES/Caja/Hardened-JavaScript program that becomes Endo. The lesson — a script that runs in a context is, by default, endowed with all of that context's ambient authority — is exactly what SES's `lockdown()` and compartmentalization reverse: a module or gadget composed into a page (or an Endo compartment) receives *only* the endowments explicitly passed to it, so third-party code cannot exercise the host's ambient authority merely by executing. The confused-deputy framing of CSRF is why Endo/OCapN authority travels as designated references rather than as ambient, auto-attached credentials. See the [[confused-deputy]] and [[ambient-authority]] concepts.

Source: [cap-talk 2009-June archive](http://www.eros-os.org/pipermail/cap-talk/2009-June/) (Internet Archive original-bytes `id_` snapshot of `2009-June.txt.gz`, sha256 `5b9ecc12`), thread "Origin enables XSS to escalate to XSRF" (and the CORS/XHR standards threads), 2009-06-03 to 2009-06-30.
