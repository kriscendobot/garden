---
title: Design Decisions
source: designs/daemon-retention-paths.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: a0a4305b63f44e02e49a985243da67641fbc5552
source_date: 2026-05-01
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [daemon, capability-security]
status: current
notes: The "follow-family release pattern" — subscription-release-by-dropping-far-reference, no explicit `unsubscribe` — is the canonical Endo subscription discipline. The `pet:<name>` label-prefix decision is principled (keeps `RetentionPathSegment` flat; unambiguous because pet names can't start with `:`); contrast with adding a separate field. The locator-as-API-key choice (not pet-name) is the canonical identifier-discipline pattern — pet names are ambiguous (same name in multiple stores), locators are unique.
parent: endo-but-for-bots--llm-designs-drp--phases-and-decisions
---

1. **Host-only, not guest.** Surface elevation. A guest knowing how the host names things is a leak.
2. **`pet:<name>` label prefix instead of a separate field.** Keeps `RetentionPathSegment` flat; prefix is unambiguous and trivially parsed by both CLI and UI.
3. **Subscription-release via dropped far reference**, matching existing `follow*` methods. Avoids an explicit `unsubscribe` method.
4. **Microtask-coalesced deltas**, mirroring `retention-accumulator`. A `provideGuest` should produce *one* delta.
5. **Disincarnate/reincarnate are existing daemon operations**, merely surfaced in the UI. We are not introducing a new lifecycle verb.
6. **Locator (not pet-name) as the API key.** Pet names are ambiguous (the same name can live in multiple stores); locators are unique. The CLI accepts both for ergonomic reasons but resolves the pet name to a locator before calling the daemon.

Source: [designs/daemon-retention-paths.md](https://github.com/endojs/endo-but-for-bots/blob/a0a4305b63f44e02e49a985243da67641fbc5552/designs/daemon-retention-paths.md) at commit `a0a4305b` on branch `llm`.
