---
title: "Hiding webkeys from the address bar: the sharing hazard and the mashup tension"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2009-April/
source_snapshot: http://web.archive.org/web/2id_/http://www.eros-os.org/pipermail/cap-talk/2009-April.txt.gz
source_content_sha256: c48f9016fa7c39dbb07c92d00ac253a518ce853c4e757c10ac12d7b9c47005d1
source_authors: [Alan Karp, Charles Landau, Ihab Awad, Raoul Duke, James A. Donald]
source_date: 2009-04-01 to 2009-04-09
thread_subject: "Webkeys vs. the web"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-security, cap-talk-open-questions]
status: current
notes: "Derived summary, not the original messages. April continuation of the March 'Webkeys vs. the web' thread; see the March section for the browser-authority root problem."
---

Abstract: The April 2009 continuation of "Webkeys vs. the web" narrows from *where* a browser holds authority (the March problem) to a sharper operational hazard: users share the URL in the address bar precisely *because* they have learned that an ordinary URL, by itself, conveys no authority. Ihab Awad states the rule the thread converges on: "any URLs that *do*, by themselves, convey authority must not be displayed in a browser's address bar." Alan Karp extends it — not even in the page source, because people Copy Link — and reports a live SCoopFS incident where a user, meaning to send a use-once invitation from a form field, instead copied the webkey from the address bar and handed over authority to her whole inbox. Karp's underlying claim is a mental-model one: people do not think of URLs as carrying authority (his example: emailing a friend your bank's *login-page* bookmark is harmless because it leads to a login, but the same gesture with a webkey gives away your money). The countervailing pressure, from Charles Landau, is that hiding webkeys from the user precludes the mashups that motivated webkeys in the first place; and Raoul Duke's objection that a plaintext cap in a URL is exposed to packet sniffers anyway sets the discussion's TLS-transport assumption in relief.

## The rule the thread converges on

Raoul Duke voiced the confusion that forces the restatement: webkeys "can be shared" yet the UI's whole desire is to make them "*not* shared" — the two feel at odds. Ihab Awad resolves it by locating the hazard in a learned user expectation rather than in the URL itself:

> The URL that is in the browser's address bar is dangerous because users share it with the expectation that it, by itself, conveys no authority. Thus any URLs that *do*, by themselves, convey authority must not be displayed in a browser's address bar.

Karp sharpens the boundary: "Or even in the page source. People can and do Copy Link." So the containment target is not merely the address bar but every surface from which a user can lift a URL and paste it into a message believing it inert.

## Why this is a UI problem, not a crypto problem

Karp's argument is about mental models, not confidentiality. People trust their bank bookmark for anti-phishing reasons, but that "is not the same thing as keeping their bookmarks private because they carry authority." His concrete case:

> You might like the online bank I use. Here's my banking bookmark. `https://investing.schwab.com/...` Go set up an account.

That gesture is safe only because the link lands on a *login page* — the authority is gated behind authentication. "Had that been a webkey, you'd be able to take my money." The web-key design collapses the login gate into the URL, so the ingrained "a link is just a name, share it freely" habit becomes a live authority-leak.

The SCoopFS experience report grounds this: its single-page Flash UI holds every item's webkey in ActionScript variables, so View Source shows only the script filename, and users see a webkey in only two places — the bookmark to their mailbox (currently sharable, "but it shouldn't be") and the one-use webkey to set up a new Pal. One user "mistakenly copied the webkey from the address bar instead of the form field" and thereby sent Karp the webkey to her inbox — the exact address-bar leak the rule is meant to prevent. The team's fix was to encapsulate even the one-use invite webkey in a file rather than show it.

## The mashup tension (unresolved)

Charles Landau pushes back: it should still "be possible with a little work for the user to get the actual text of a webkey, otherwise you are precluding the sort of mashups that were a major motivation for webkeys." Karp's reply concedes only that delegation "may require transferring a webkey to another module, but it can be a separately revocable webkey rather than the one that appears on the page" — deliberately-issued, attenuated, revocable delegation rather than casual copy-paste of the live key. Whether an approach that hides all webkeys can still be *general* (support arbitrary mashups) he leaves explicitly open: "Whether or not our approach is general is an open question." Raoul Duke's packet-sniffer objection — a plaintext cap in a URL is exposed in transit anyway — names the standing assumption that web-keys ride an authenticated, encrypted transport, so the residual threat is the human sharing surface, not the wire.

## Bearing on Endo

The lesson carries directly to any Endo surface that mints URL-bearing capabilities for a browser (an ocap gateway handing out invitation URLs, a powerbox handing a web app an authority). The address-bar/copy-link hazard says: a bearer capability that lands in a user-visible, user-copyable location will eventually be shared as if it were an inert name, so authority-bearing URLs want a delivery channel the user cannot casually lift and paste (a file, a form field, a deliberate "share this capability" affordance), and casual re-sharing should mint a *fresh, attenuated, revocable* delegation rather than expose the live key. See the [[web-key]] and [[powerbox]] concepts and the March [webkeys-vs-the-web](cap-talk-2009-2012--webkeys-vs-the-web.md) section for the browser-authority-root half of the problem.

Source: [cap-talk 2009-April archive](http://www.eros-os.org/pipermail/cap-talk/2009-April/) (Internet Archive original-bytes `id_` snapshot of `2009-April.txt.gz`, sha256 `c48f9016`), thread "Webkeys vs. the web", 2009-04-01 to 2009-04-09.
