---
title: "Solve CSRF by making references unforgeable, not unshareable (Zooko / Tahoe)"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2009-March/
source_snapshot: http://web.archive.org/web/2id_/http://www.eros-os.org/pipermail/cap-talk/2009-March.txt.gz
source_content_sha256: 1fc3830753ef60b463368e43af520bebbeb2040e1e905c1d4f4ac9c0110803d9
source_authors: [zooko, John Carlson, Mark Miller, Tyler Close, David-Sarah Hopwood]
source_date: 2009-03-24 to 2009-03-27
thread_subject: "solve CSRF by making references unforgeable, not unshareable"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-security]
status: current
notes: "Derived summary, not the original messages. Quotes Zooko's hacktahoe.org/csrf.html."
---

Abstract: Prompted by a question from Mark Miller about Tahoe's experience with CSRF and webkey-style capabilities-in-URLs, Zooko posts an aphorism and its justification (from `hacktahoe.org/csrf.html`): **"Solve CSRF attacks by making references unforgeable, not by making them unshareable."** The insight is that a Cross-Site Request Forgery attack, seen at the level of information flow, *looks exactly like sharing*: a party presents a message (a form, a hyperlink, a page with JavaScript) to a victim, who then sends an authority-wielding request to a site that has an effect. The only difference between the CSRF attacker and a helpful friend is intent — the attacker wants to harm the receiver. Because attack and legitimate sharing are structurally identical, defenses that try to *prevent sharing* (unguessable tokens whose whole point is that they must not be passed on) are fighting the wrong property; the right fix is to make the *reference itself unforgeable* so that only a party who was genuinely given the capability can wield it, and sharing it is a deliberate, visible act rather than an ambient side effect of the browser attaching a cookie. This is the capability reading of CSRF, and the direct complement to Tyler Close's "ACLs don't" treatment of CSRF as a confused-deputy problem.

## CSRF is structurally identical to sharing

Zooko's figures make the point. In a CSRF attack, the bad guy sends the victim a message (form / hyperlink / JavaScript), the victim's browser sends an authority-wielding request to the site, and the site acts: "The victim already had the authority to do that thing, such as to delete her private files, but she didn't realize what the form or hyperlink was going to do when she clicked on it." In legitimate sharing, a *friend* sends the same kind of message and the same request fires when clicked. The two flows differ only in the sender's intent — which no server-side check can see.

## The aphorism

"There is a general principle here which deserves to be more widely appreciated. A CSRF attack looks, under the hood, a lot like sharing. (The difference is that the sharer intends to harm the receiver.)... This insight leads us to propose the following aphorism: **Solve CSRF attacks by making references unforgeable, not by making them unshareable.**" The conventional CSRF defense (anti-forgery tokens designed to be un-passable) tries to make requests *unshareable*, which both fails against a genuine sharing-shaped attack and breaks the web's legitimate sharing. The capability defense makes the authority-bearing reference *unforgeable*: the attacker cannot manufacture a reference the victim did not deliberately convey, and ambient authority (the cookie the browser attaches automatically) is removed as the thing being exploited.

## Bearing on Endo and web gateways

The thread pairs with Chip Morningstar's [`webkeys-vs-the-web`](cap-talk-2009-2012--webkeys-vs-the-web.md) worry (a session cookie that carries authority is "in essence a webkey held in a cookie" — exactly the forgeable-because-ambient surface Zooko says to remove) and with Tyler Close's paper treatment of CSRF/clickjacking/click-fraud as confused-deputy manifestations (the [`papers--close-acls-dont-2009`](../concepts/confused-deputy.md) cluster). For Endo/OCapN, the operative discipline is the same: authority is conveyed only by handing over an unforgeable reference, never by an ambient credential the transport attaches on every request — so "sharing" is always an explicit capability delegation the holder chose, and there is no ambient authority for a forged message to ride. See [[web-key]] and [[confused-deputy]].

Source: [cap-talk 2009-March archive](http://www.eros-os.org/pipermail/cap-talk/2009-March/) (Internet Archive original-bytes `id_` snapshot of `2009-March.txt.gz`, sha256 `1fc38307`), thread "solve CSRF by making references unforgeable, not unshareable", 2009-03-24 to 2009-03-27, quoting `hacktahoe.org/csrf.html`.
