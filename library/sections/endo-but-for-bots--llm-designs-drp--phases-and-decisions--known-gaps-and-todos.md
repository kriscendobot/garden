---
title: Known Gaps and TODOs
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

- [ ] Decide whether `formulaChangeTopic` should be extended to carry edge events, or a sibling `formulaGraphChangeTopic` should be added.
- [ ] Confirm that path equality over group members is the right stable-key for diffing — or whether we should hash the labeled path.
- [ ] Decide how to render labels for `union` group composition (groupMembers > 1) in the CLI and UI.
- [ ] Spec the deny-list for disincarnation; possibly encode as `disincarnationPolicy` on the host with sensible defaults.
- [ ] Integration test for the case where a pet name removal produces a cycle break (group composition changes).

Source: [designs/daemon-retention-paths.md](https://github.com/endojs/endo-but-for-bots/blob/a0a4305b63f44e02e49a985243da67641fbc5552/designs/daemon-retention-paths.md) at commit `a0a4305b` on branch `llm`.
