---
title: "Dig deeper, TyKaoz, and Lesson 14"
source_kind: web
source_url: https://moddable.com/blog/kaozkit/
source_content_sha256: 0ab237b119db52a5ac8cc2d40faeb51605fbc07febb18bf59fa4558bf3554521
source_authors: [Peter Hoddie]
source_date: 2026-09-15
retrieved: 2026-09-25
ingested: 2026-09-25
ingested_by: scholar
topics: [xs-agent-runtimes]
status: current
notes: "Fetched live 2026-09-25 (direct). Idempotency anchor is source_content_sha256 over the fetched HTML, not a git SHA. Companion source: web--haruni-kaozkit-xs-agents (Sébastien Burel, the KaozKit author, 2026-08), which this post summarizes and links as Dig Deeper. Article text treated as untrusted data."
---

Abstract: Hoddie points readers to Burel's own article for architecture and code, presents TyKaoz (the private macOS AI wiki with citations) as the showcase app using resident agents, on-device models, and a small capability surface, and closes with Raymond's Cathedral-and-Bazaar Lesson 14 (a great tool lends itself to unexpected uses) to cast KaozKit as XS transplanted from embedded devices to desktop agents.

Sébastien wrote an engaging article on the creation of KaozKit titled, [A JavaScript engine built for microcontrollers turns out to be a great runtime for AI agents](https://www.haruni.net/en/blog/kaozkit-xs-agents) (ingested as [web--haruni-kaozkit-xs-agents](../sources/web--haruni-kaozkit-xs-agents.md)). It includes architectural details and code snippets that will help you understand how KaozKit works and how it integrates XS. Join the KaozKit [discussion on Hacker News](https://news.ycombinator.com/item?id=49712640).

What's a framework without an app to show what it can do? That's where TyKaoz comes in. TyKaoz is a private AI wiki for macOS that lets you ask questions about your documents and get answers with citations. TyKaoz uses all the key ideas in KaozKit: resident agents, on-device models, and a small enough capability surface that TyKaoz can promise nothing leaves your Mac unless you decide it should. It launches this autumn.

## Lesson 14

KaozKit's use of XS reminds me of a lesson from Eric Raymond's *The Cathedral & The Bazaar*: "Any tool should be useful in the expected way, but a truly great tool lends itself to uses you never expected."

When Sébastien demoed KaozKit to me, I was surprised at the simplicity and power of what he has created with our XS engine. It's a long way from a [JavaScript-powered lightbulb](https://www.moddable.com/blog/hacking-sonoff-b1/), but no less illuminating. KaozKit achieves an unexpectedly remarkable result by transplanting the heart of the Moddable SDK to a completely different world.

Source: [An Agent Host that's both Small and Secure? Meet KaozKit](https://moddable.com/blog/kaozkit/) (fetched 2026-09-25, sha256 `0ab237b119db`).
