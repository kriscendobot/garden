---
title: "Two threads of capability thinking: operating systems versus the lambda calculus"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2001-July/
source_snapshot: http://web.archive.org/web/20060613194941id_/http://www.eros-os.org/pipermail/cap-talk/2001-July.txt.gz
source_content_sha256: 7e0ec8b293ccc94a2fbef27573b7a83d5e5ab9a38cb00d46e2f0531776f6931e
source_authors: [Mark S. Miller, Richard Uhtenwoldt]
source_date: 2001-07-12
thread_subject: "immutable data"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-theory, capability-security]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: Prompted by Richard Uhtenwoldt's enthusiasm for Jonathan Rees's W7 secure-Scheme paper, Mark Miller (2001-07-12) gives a compact history-of-ideas that reframes the whole field: there have been two independent threads of capability thinking, one rooted in operating systems and citing Lampson's 1971 "Protection" paper, and one rooted in the lambda calculus. The lambda thread yields better formalisms and better ways of thinking, and the best capability OSes (KeyKOS, EROS) are really better described in lambda-calculus and Actors terms than in the Lampson access-matrix terms usually used for them. The section also captures the operative slogan of Rees's paper (if a programmer cannot name an authority, she cannot exercise it), the observation that Scheme stayed "almost secure" by staying close to lambda, that Concurrent Prolog was a third independent invention of capability computation, and the immutable-versus-mutable-data discussion (Scheme, ML, and E's first-class Slot) that motivated the thread.

## The two threads

Miller: "there have been two threads of capability thinking in computer science: 1) that rooted in operating systems and citing Butler Lampson's paper Protection (or papers derived from this paper) either as the correct definition or as the definition gone bad, or 2) that rooted in the lambda calculus. The lambda thread yields much better formalisms as well as better ways of thinking about capabilities. The best capability OSes, KeyKOS and EROS, though typically described with Lampson-esque models, are actually much better described in terms of the lambda calculus and Actors."

On Actors and independent invention: "Hewitt's original Actors still seem to me like the clearest formal statement of the capability computation model. But ... there are no references between his work of the 70s and the capability OS work happening at the same time. And I do not think Hewitt ever says capability. It looks to me like a completely independent discovery." Miller counts Concurrent Prolog (Udi Shapiro) as a third independent invention "in a horn-clause inference context."

On Scheme: "Scheme, which was inspired by Actors, seemed to only pick up about half of what was valuable about Actors ... The half Scheme forgot includes capability security, transparent distribution, event-loop concurrency, everything is an object. However, by sticking faithfully to the spirit of the lambda calculus, Scheme miraculously remained almost secure during the decades when no one cared about this."

## Rees's W7 and the naming slogan

Uhtenwoldt on why Rees's paper (`mumble.net/jar/pubs/secureos/`) finally made strong capabilities click for him: "The paper shows how a programmer can exploit the principle that if a programmer cannot name an authority, she cannot exercise that authority." He credits it with an "elegant (low cost in program complexity) solution to a bunch of problems," his favorite being the installer that overwrites a competitor's config without asking. Miller: "Rees's paper is a glorious rediscovery of the capability security latent in Scheme, and in similarly almost pure lambda languages ... Now if we can only get the OS folks to think first in these terms, rather than the broken Lampson ones."

## Immutable data: Scheme, ML, and E's Slot

The thread's technical spine is that naming a chunk of immutable data is exactly what sensory / read-only capability programming needs, and Scheme makes it awkward because "a variable is always bound to a location; a location is always mutable." Uhtenwoldt contrasts ML, where immutable values are the default and mutability is an explicit `ref`. Miller reports E made the same choice: "a variable in E is by default immutable. A mutable variable is seen as being, under the covers, an unnamed immutable variable designating a Slot object," a first-class reification of Scheme's location (like ML's `ref`). He describes E's "soft typing" (a `ValueGuard` coerces on `def`, a `SlotGuard` builds the Slot on `var`) and the "final normal form" transform that rewrites every `var` away into an explicit Slot. Concurrent Prolog progeny such as ToonTalk are noted as "fine capability systems."

## Translation

| cap-talk 2001 term | Endo / modern reading |
|---|---|
| lambda-calculus thread | the object-as-closure model underlying E, Joule, W7, and SES |
| Lampson access-matrix thread | the ACL/access-control-list framing the ocap literature argues against |
| "cannot name an authority => cannot exercise it" | the reachability axiom (only connectivity begets connectivity) at the language level |
| E Slot | first-class mutable cell; the ancestor of reified variable bindings |
| soft typing / ValueGuard | runtime-checked guards (Endo pattern guards, `M.arrayOf`-style coercion) |

Source: [cap-talk 2001-July archive](http://www.eros-os.org/pipermail/cap-talk/2001-July/) (Internet Archive original-bytes snapshot `web/20060613194941id_/.../2001-July.txt.gz`, sha256 `7e0ec8b2`), messages by Richard Uhtenwoldt and Mark S. Miller, 2001-07-12 to 2001-07-13.
