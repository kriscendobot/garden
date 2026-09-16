---
title: "Webkeys vs. the web: where a browser holds the powerbox when authority rides in URLs"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2009-March/
source_snapshot: http://web.archive.org/web/2id_/http://www.eros-os.org/pipermail/cap-talk/2009-March.txt.gz
source_content_sha256: 1fc3830753ef60b463368e43af520bebbeb2040e1e905c1d4f4ac9c0110803d9
source_authors: [Chip Morningstar, Kevin Reid, Mark Miller, Tyler Close, David-Sarah Hopwood]
source_date: 2009-03-22 to 2009-03-31
thread_subject: "Webkeys vs. the web"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-security, cap-talk-open-questions]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: Chip Morningstar surfaces a design problem that recurs the moment all authority is carried by webkeys (unguessable HTTPS URLs that are capabilities). If a thing's authority *is* its URL, then a browser can only hold authority in three places: bookmarks, browse history, or the state of an open page (its links and its JavaScript objects). Those three are the roots of the browser's powerbox — but bookmarks and history are unreliable roots for a web UI, because the user may arrive from a different browser or may never have bookmarked the right things. Chip's clever fix — have the *server* hold the powerbox and hand it back after a password login — founders on ordinary navigation: when the user follows a link to a page that does not itself hold the user's authorities, the previous page's memory state (and its authorities) is gone, and there is no way to synthesize a "Home" link because building one would need the home webkey the new page lacks. He offers two unsatisfying escapes, both of which trade away either the web's nature or the capability discipline. The thread is a primary-source statement of the tension between "capabilities-in-URLs" and the stateless, bookmarkable, linkable architecture of the Web — the problem Endo's OCapN locator/sturdyref split and web-facing gateways still have to answer.

## The three roots of browser authority

"If all authority is carried via webkeys, then to get at anything a user needs to know the thing's URL. Looking at this from the perspective of the web browser, there are three places it can hold onto webkeys: (1) in bookmarks, (2) in the browse history, or (3) in an open page, either in links that are actually on the page or in the memory state of Javascript objects loaded from that page. These are the roots of the browser's authority." Everything else is reachable by following links from those roots.

## Why bookmarks and history are unreliable roots

A web UI cannot rely on (1) or (2) to hold the user's root authorities "because the user might not be coming to the site using the same browser as last time, and even if they did they might not have thought to bookmark the right things" — and support cannot lecture users about what they "should have" bookmarked. So Chip proposed a server-held powerbox with a password-authenticated login that returns the user's bundle of root authorities. "It was so clever and elegant, I went off and designed a whole API..."

## The navigation break

"...But what happens when they navigate to another page? At that point, the memory state of the page they were on is lost and they get a whole new memory state loaded from the new page." If the new page was reached by following a link to something that does not hold the user's authorities, the user is stranded — history is stipulated too hard for average users to navigate back through. Worse, the standard remedy, a "Home" link on every page, itself requires the page to already hold the user's home webkey, which is exactly what it lacks. "What's a capability-oriented guy supposed to do?"

## The two unsatisfactory escapes

- **Approach #1: never leave the home page.** All navigation happens via scripted fetches of particular data bundles. This preserves the capability model but "breaks the web nature" — you cannot bookmark pages you visit or snapshot their URLs to share as links.
- **Approach #2: a powerbox module plus a session cookie on every page.** Each page includes a powerbox module; a session cookie lets the backend populate it with *your* authorities when you load it and *mine* when I do. But "the session cookie in this scenario ends up being, in essence, a webkey that is held in" the cookie — which reintroduces the ambient, automatically-attached authority (and the CSRF/confused-deputy surface) that webkeys were supposed to remove, since the browser sends the cookie on every request whether the user intended the action or not.

## Bearing on Endo / OCapN

The dilemma is structural, not incidental: a capability whose whole representation is a URL is bookmarkable and linkable (a strength) but has nowhere stable to *live* in a browser session (the weakness Chip names). Endo's OCapN keeps the founding-era split (see [[web-key]] and [`cap-talk-2000-2001--off-line-capability-representation-vs-on-line-protocol`](cap-talk-2000-2001--off-line-capability-representation-vs-on-line-protocol.md)) between an off-line *representation* (a sturdyref/locator you can store or paste) and the on-line *protocol* (CapTP) that makes possession authorize invocation — precisely so that a durable, shareable reference is a different artifact from the live session authority, and so a web gateway can decide deliberately where the powerbox lives rather than defaulting it into an ambient cookie. Approach #2's "session cookie is really a webkey" observation is the same hazard Zooko's [`solve-csrf-unforgeable-not-unshareable`](cap-talk-2009-2012--solve-csrf-unforgeable-not-unshareable.md) thread dissects.

Source: [cap-talk 2009-March archive](http://www.eros-os.org/pipermail/cap-talk/2009-March/) (Internet Archive original-bytes `id_` snapshot of `2009-March.txt.gz`, sha256 `1fc38307`), thread "Webkeys vs. the web" (and its "problem #2" continuation), 2009-03-22 to 2009-03-31.
