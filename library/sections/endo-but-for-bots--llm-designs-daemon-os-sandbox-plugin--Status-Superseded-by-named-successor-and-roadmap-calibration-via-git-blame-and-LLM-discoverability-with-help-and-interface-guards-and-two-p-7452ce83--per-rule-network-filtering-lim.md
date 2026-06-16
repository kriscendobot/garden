---
title: §Per-rule-network-filtering-limitation as §honest-disclosure
source-slug: endo-but-for-bots--llm-designs-daemon-os-sandbox-plugin
section-id: Status-Superseded-by-named-successor-and-roadmap-calibration-via-git-blame-and-LLM-discoverability-with-help-and-interface-guards-and-two-platform-backends
url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/daemon-os-sandbox-plugin.md
authors: [Kris Kowal (prompted), Joshua T Corbin (revised)]
repo: endojs/endo-but-for-bots
path: designs/daemon-os-sandbox-plugin.md
total-lines: 544
status: Superseded by endo-posix-sandbox (2026-05-07)
ingest-cycle: 228
ingest-date: 2026-06-08
lane: designs
parent: endo-but-for-bots--llm-designs-daemon-os-sandbox-plugin--Status-Superseded-by-named-successor-and-roadmap-calibration-via-git-blame-and-LLM-discoverability-with-help-and-interface-guards-and-two-platform-backends
---

```
- **Network filtering granularity.** macOS SBPL can filter connections
  by CIDR and port natively via ip-filter rules. Linux `bwrap` alone
  can only toggle network namespace sharing (all-or-nothing). To enforce
  the per-rule CIDR/port restrictions expressed in `allowOutbound` and
  `allowInbound` on Linux, the backend must either set up nftables rules
  inside a network namespace, use Landlock network scoping (Linux ≥ 6.3),
  or delegate to a container runtime that provides its own network
  namespace. The initial Linux implementation falls back to
  all-or-nothing network sharing when fine-grained rules cannot be
  enforced and logs a warning.
```

§Honest-disclosure-of-platform-limitation + §three-named-future-paths-to-fix-it (nftables + Landlock + container runtime) + §the-initial-implementation-falls-back-to-all-or-nothing-and-logs-a-warning.

§Borrowable-pattern: §when-the-design-can-promise-less-on-one-platform-than-another, §name-the-asymmetry + §name-the-future-paths-to-fix-it + §name-the-current-fallback-behavior + §name-the-warning-emitted.

§Sibling to cycle 220 familiar-localhttp-protocol's §Research-needed-section. §Both designs §honest-acknowledgment-of-incomplete-implementation. §Cycle-220 names verification gaps; cycle-228 names implementation gaps.
