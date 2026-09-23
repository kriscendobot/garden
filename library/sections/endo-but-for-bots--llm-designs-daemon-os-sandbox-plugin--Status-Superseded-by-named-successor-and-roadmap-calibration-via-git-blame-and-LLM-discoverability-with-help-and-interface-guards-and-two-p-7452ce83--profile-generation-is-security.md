---
title: §Profile-generation-is-security-critical
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
**Profile generation is security-critical.** The SBPL and bwrap
argument generators must be carefully audited to prevent injection.
Paths in endowment descriptors must be validated and canonicalized
before interpolation into SBPL strings or command arguments.
```

§Borrowable-pattern: §when-a-design-generates-code-or-config-for-an-external-tool, §name-the-injection-risk + §name-the-canonicalization-requirement. §The-generator-is-the-most-security-critical-part.

§Sibling to cycle 220 familiar-localhttp-protocol's §six-layer-defense-in-depth — both designs §security-discipline-with-explicit-named-risks.
