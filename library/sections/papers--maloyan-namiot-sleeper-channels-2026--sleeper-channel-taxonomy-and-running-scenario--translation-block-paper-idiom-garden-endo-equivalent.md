---
title: Translation block (paper idiom → garden / Endo equivalent)
source: "Sleeper Channels and Provenance Gates (arXiv:2605.13471, 2026)"
source_kind: paper
source_authors: [Narek Maloyan, Dmitry Namiot]
source_year: 2026
source_venue: "arXiv:2605.13471 [cs.CR]"
source_url: https://arxiv.org/abs/2605.13471
source_pdf_sha256: c2ddd8158d47f8e7ac62b8e624170a1736d76f4c3e0b949702e8502c238b1db5
source_paper_pages: "1-4 (§I Introduction, §II Background, §III Related Work, §IV Threat Model, §V Taxonomy, §VI Illustrative Scenarios)"
ingested: 2026-05-17
ingested_by: liaison-direct-draft
topics: [capability-security, agent-conventions]
status: current
parent: papers--maloyan-namiot-sleeper-channels-2026--sleeper-channel-taxonomy-and-running-scenario
---

| Paper concept                                    | Garden / Endo equivalent                                                                       |
| ------------------------------------------------ | ---------------------------------------------------------------------------------------------- |
| OS-live agent                                    | The garden's *steward* posture (autonomous, owner-credentials, bounded by sandbox).            |
| Untrusted-but-admitted                           | Any GitHub-comment-author or PR-author the garden's monitors might read. The `Monitoring Safety Constraint` in `CLAUDE.md` is the garden's existing partial defense. |
| `T0` intake / `T1` firing decoupling             | Standing-monitor daemons reading event bodies that may include attacker prose; effects fire on a later journal-read or dispatch. |
| Persistence substrate (M1-M5)                    | Journal entries (M2-equivalent); skills written into `skills/` (M3); worktree state (M4); scheduled wakeups + cron routines (M5). |
| Cross-execution-context (C4)                     | A boatman dispatched from a journal message reads the message in a *different* context than the journal-writer; the gap is the garden's structural equivalent of C4. |
| Confused deputy (Hardy 1988)                     | The bot identity acting under owner credentials on behalf of a journal entry whose authorship may itself be untrusted. |
| `external-content.ts` security warning           | The garden's `CLAUDE.md § Monitoring safety constraint` — a similar in-context-warning posture. The paper's empirical result (in-context warnings alone don't prevent A4) is sobering. |
