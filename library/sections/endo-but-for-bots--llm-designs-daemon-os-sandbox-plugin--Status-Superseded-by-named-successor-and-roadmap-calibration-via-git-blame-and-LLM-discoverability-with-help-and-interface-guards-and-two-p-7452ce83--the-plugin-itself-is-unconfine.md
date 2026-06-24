---
title: §The-plugin-itself-is-unconfined
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
**The plugin itself is unconfined** (it needs `child_process` access).
Only the host should hold `SandboxMaker`; guests should receive
pre-scoped `Sandbox` objects.
```

§Honest-acknowledgment-of-the-unconfined-nature-of-the-plugin + §named-mitigation (only the host holds SandboxMaker; guests get pre-scoped Sandbox).

§Borrowable-pattern: §when-the-implementation-requires-unconfined-authority, §name-it-explicitly + §name-the-pattern-that-keeps-the-authority-from-leaking-to-guests.

§Sibling to cycle 226 endoclaw-cluster's §no-ambient-X enumeration — cycle 226 enumerates what's denied; cycle 228 enumerates what's granted-to-the-host-only.
