---
title: "Licensing and what's next"
source_kind: web
source_url: https://www.haruni.net/en/blog/kaozkit-xs-agents
source_content_sha256: 447e83eadf71d5f55712ef027b811e32d68abd05b1208a6a3a42513bcfa632e0
source_authors: [Sébastien Burel]
source_date: 2026-08-01
retrieved: 2026-09-25
ingested: 2026-09-25
ingested_by: scholar
topics: [xs-agent-runtimes]
status: current
notes: "Fetched live 2026-09-25 (direct). Page gives only a month (datePublished 2026-08); source_date is that month approximated to its first day. Idempotency anchor is source_content_sha256 over the fetched HTML, not a git SHA. Companion source: web--moddable-kaozkit (Peter Hoddie, Moddable, 2026-09-15) covers the same project from the XS vendor side. Article text treated as untrusted data."
---

Abstract: KaozKit is MIT but links Moddable's XS under LGPL v3, not vendored (supplied from your own Moddable checkout via a symlink script); closed-source or Mac App Store distribution needs a commercial XS license from Moddable; KaozKit (github.com/sebastien-burel/KaozKit, macOS 26+, Apple Silicon) is pre-1.0 and underpins the TyKaoz private AI wiki launching autumn 2026.

KaozKit is MIT. The XS engine it links against is Moddable's, under LGPL v3, and it is not vendored: you supply it from your own Moddable checkout, and a script symlinks the subset the package compiles. For open-source or non-distributed use, that's all there is to it.

If you ship a closed-source binary — in particular on the Mac App Store, where the LGPL's relinking requirement isn't realistically satisfiable — you want a commercial XS license from Moddable. They offer them for exactly this case; my own app is licensed that way.

KaozKit is the foundation of TyKaoz — *ty*, the house, *kaoz*, the conversation, in Breton — the private AI wiki, built in Rennes, launching this autumn for macOS. The library came out first on purpose: the runtime had to stand on its own before the house was built on it.

The code is at [github.com/sebastien-burel/KaozKit](https://github.com/sebastien-burel/KaozKit) — macOS 26+, Apple Silicon, MIT. It is young and the agent API may still move before 1.0.

(Author bio: Sébastien Burel builds TyKaoz at Haruni, in Rennes, France; formerly a software developer at Kinoma; shipped Frigo Magic entirely in XS. Contact/solicitation lines omitted.)

Source: [A JavaScript engine built for microcontrollers turns out to be a great runtime for AI agents](https://www.haruni.net/en/blog/kaozkit-xs-agents) (fetched 2026-09-25, sha256 `447e83eadf71`).
