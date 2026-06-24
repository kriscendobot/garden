---
title: "daemon-os-sandbox-plugin — §Status-Superseded-by-named-successor + §roadmap-calibration-via-git-blame + §LLM-discoverability-with-comprehensive-help()-and-maximally-specific-interface-guards + §two-platform-backends-with-named-endowment-to-rule-table + §Test-Plan-with-Maybe-subsection + §named-future-stronger-isolation-mechanisms + §honest-acknowledgment-of-platform-deprecation"
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
kind: index
section_count: 17
---

Sections:

- [daemon-os-sandbox-plugin — Superseded historical proposal with rich LLM-discoverability discipline](endo-but-for-bots--llm-designs-daemon-os-sandbox-plugin--Status-Superseded-by-named-successor-and-roadmap-calibration-via-git-blame-and-LLM-discoverability-with-help-and-interface-guards-and-two-p-7452ce83--daemon-os-sandbox-plugin-super.md)
- [§Status-Superseded-by-named-successor (§new design-evolution shape)](endo-but-for-bots--llm-designs-daemon-os-sandbox-plugin--Status-Superseded-by-named-successor-and-roadmap-calibration-via-git-blame-and-LLM-discoverability-with-help-and-interface-guards-and-two-p-7452ce83--status-superseded-by-named-suc.md)
- [§Roadmap-calibration-via-git-blame (§rare-archaeological-shape)](endo-but-for-bots--llm-designs-daemon-os-sandbox-plugin--Status-Superseded-by-named-successor-and-roadmap-calibration-via-git-blame-and-LLM-discoverability-with-help-and-interface-guards-and-two-p-7452ce83--roadmap-calibration-via-git-bl.md)
- [§No-further-implementation-phase-is-planned-against-this-document](endo-but-for-bots--llm-designs-daemon-os-sandbox-plugin--Status-Superseded-by-named-successor-and-roadmap-calibration-via-git-blame-and-LLM-discoverability-with-help-and-interface-guards-and-two-p-7452ce83--no-further-implementation-phas.md)
- [§LLM-discoverability section (§novel-design-shape)](endo-but-for-bots--llm-designs-daemon-os-sandbox-plugin--Status-Superseded-by-named-successor-and-roadmap-calibration-via-git-blame-and-LLM-discoverability-with-help-and-interface-guards-and-two-p-7452ce83--llm-discoverability-section-no.md)
- [§Capability-flow as ASCII tree](endo-but-for-bots--llm-designs-daemon-os-sandbox-plugin--Status-Superseded-by-named-successor-and-roadmap-calibration-via-git-blame-and-LLM-discoverability-with-help-and-interface-guards-and-two-pl-7452ce83--capability-flow-as-ascii-tree.md)
- [§Two-platform-backends (macOS SBPL + Linux bwrap+seccomp)](endo-but-for-bots--llm-designs-daemon-os-sandbox-plugin--Status-Superseded-by-named-successor-and-roadmap-calibration-via-git-blame-and-LLM-discoverability-with-help-and-interface-guards-and-two-p-7452ce83--two-platform-backends-macos-sb.md)
- [§Apple-deprecation-acknowledgment + §named-future-replacement](endo-but-for-bots--llm-designs-daemon-os-sandbox-plugin--Status-Superseded-by-named-successor-and-roadmap-calibration-via-git-blame-and-LLM-discoverability-with-help-and-interface-guards-and-two-p-7452ce83--apple-deprecation-acknowledgme.md)
- [§Per-rule-network-filtering-limitation as §honest-disclosure](endo-but-for-bots--llm-designs-daemon-os-sandbox-plugin--Status-Superseded-by-named-successor-and-roadmap-calibration-via-git-blame-and-LLM-discoverability-with-help-and-interface-guards-and-two-p-7452ce83--per-rule-network-filtering-lim.md)
- [§Three-named-future-stronger-isolation-mechanisms (Landlock + container runtimes + Lightweight VMs)](endo-but-for-bots--llm-designs-daemon-os-sandbox-plugin--Status-Superseded-by-named-successor-and-roadmap-calibration-via-git-blame-and-LLM-discoverability-with-help-and-interface-guards-and-two-p-7452ce83--three-named-future-stronger-is.md)
- [§Test-Plan with §Maybe-subsection](endo-but-for-bots--llm-designs-daemon-os-sandbox-plugin--Status-Superseded-by-named-successor-and-roadmap-calibration-via-git-blame-and-LLM-discoverability-with-help-and-interface-guards-and-two-p-7452ce83--test-plan-with-maybe-subsectio.md)
- [§Five-section-Considerations (Security + Scaling + Test Plan + Compatibility + Upgrade)](endo-but-for-bots--llm-designs-daemon-os-sandbox-plugin--Status-Superseded-by-named-successor-and-roadmap-calibration-via-git-blame-and-LLM-discoverability-with-help-and-interface-guards-and-two-p-7452ce83--five-section-considerations-se.md)
- [§Profile-generation-is-security-critical](endo-but-for-bots--llm-designs-daemon-os-sandbox-plugin--Status-Superseded-by-named-successor-and-roadmap-calibration-via-git-blame-and-LLM-discoverability-with-help-and-interface-guards-and-two-p-7452ce83--profile-generation-is-security.md)
- [§The-plugin-itself-is-unconfined](endo-but-for-bots--llm-designs-daemon-os-sandbox-plugin--Status-Superseded-by-named-successor-and-roadmap-calibration-via-git-blame-and-LLM-discoverability-with-help-and-interface-guards-and-two-p-7452ce83--the-plugin-itself-is-unconfine.md)
- [Related material in the library](endo-but-for-bots--llm-designs-daemon-os-sandbox-plugin--Status-Superseded-by-named-successor-and-roadmap-calibration-via-git-blame-and-LLM-discoverability-with-help-and-interface-guards-and-two-p-7452ce83--related-material-in-the-librar.md)
- [§The-cycle-228-additions-to-the-design-evolution-record-family](endo-but-for-bots--llm-designs-daemon-os-sandbox-plugin--Status-Superseded-by-named-successor-and-roadmap-calibration-via-git-blame-and-LLM-discoverability-with-help-and-interface-guards-and-two-p-7452ce83--the-cycle-228-additions-to-the.md)
- [§Seven-cycles-on-confinement-substrates](endo-but-for-bots--llm-designs-daemon-os-sandbox-plugin--Status-Superseded-by-named-successor-and-roadmap-calibration-via-git-blame-and-LLM-discoverability-with-help-and-interface-guards-and-two-p-7452ce83--seven-cycles-on-confinement-su.md)
