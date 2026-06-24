---
source: docs/platform-specific.md
source_repo: MetaMask/ocap-kernel
source_url: https://github.com/MetaMask/ocap-kernel/blob/main/docs/platform-specific.md
source_path: docs/platform-specific.md
source_commit: a3eff0efb70ba5f4c5919290aa295fe32138df4f
section_kind: doc
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - daemon
  - tooling
  - getting-started
genre: §sibling-implementation-comparison
cycle: 165
lane: comments
status: current
title: §Two-platforms-Node-and-browser-as-canonical-targets
parent: metamask-ocap-kernel--docs-platform-specific-md--platform-obvious-vs-platform-implicit-exports-with-six-step-contributor-guide-for-Node-browser-split
---

> *Currently, the kernel targets two primary platforms:
> Node.js - Server-side JavaScript runtime; Browser -
> Client-side web environment.*

§Two-platform-canon. §Node-as-server-side; §browser-as-
client-side. The doc acknowledges these are the *current*
targets — §implicit-extensibility (additional platforms
could be added) but no commitment to them.

§Endo-comparison: Endo's daemon is Node-only; the
EndoTether (cycles 145, 147 et al.) is the browser
counterpart. The two-platform shape is the same; ocap-
kernel's version is more *coupled* (kernel runs on both
platforms; one or the other is chosen per deployment).
Endo's version is *split-roles* (daemon-on-Node + tether-
on-browser as cooperating components, not alternates).
