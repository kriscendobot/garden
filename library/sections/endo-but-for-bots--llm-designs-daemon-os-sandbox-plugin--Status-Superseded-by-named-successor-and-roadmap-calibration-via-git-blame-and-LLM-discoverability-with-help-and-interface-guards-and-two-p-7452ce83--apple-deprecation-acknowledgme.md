---
title: §Apple-deprecation-acknowledgment + §named-future-replacement
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
Note: `sandbox-exec` is marked deprecated by Apple but remains functional
and is still used internally by Apple (e.g. BlastDoor). The SBPL engine
is actively maintained as a private interface. Should Apple remove it in
a future release, the macOS backend can be updated to use the Endpoint
Security framework or a user-space FUSE-based approach.
```

§Honest-acknowledgment-of-platform-deprecation + §two-named-future-replacement-APIs (Endpoint Security framework + user-space FUSE). §Borrowable-pattern: §when-the-platform-API-is-deprecated-but-still-functional, §name-the-deprecation + §name-the-evidence-it-still-works (Apple still uses it internally for BlastDoor) + §name-the-future-replacement-paths.

§Sibling to cycle 220 familiar-localhttp-protocol's §`sandbox-exec` deprecation note (different design, same shape — §honest-acknowledgment-of-platform-deprecation). §Cycle-220-mentions-it-briefly; §cycle-228-treats-it-as-a-full-paragraph-with-named-replacement-paths.
