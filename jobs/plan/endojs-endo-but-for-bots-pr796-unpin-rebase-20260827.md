---
gate: orchestrated
orchestrated_by: pr796-unpin-shepherd-merge-20260827
priority: normal
posted_by: producer
posted_at: 2026-08-27T05:52:14Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
https://github.com/endojs/endo-but-for-bots/pull/796
("feat(daemon): hashline edit-format pure core + new @endo/crc32 checksum
package", head `feat/hashline-core`) is currently based on the pinned
branch `llm-ff6e0fe` (frozen-base-branch pinning), which the maintainer
reports has met its doom — this pin is stale/problematic. Its shepherd job
(`endojs-endo-but-for-bots-pr796-shepherd`) is stranded, quota-backoff-held
on a different host until the weekly reset, not actually progressing.

Grounding comment:
https://github.com/endojs/endo-but-for-bots/pull/796#issuecomment-5417405221

Unpin the base: repoint the PR's base back onto the ordinary `llm` branch
(off the stale pinned `llm-ff6e0fe`), rebase `feat/hashline-core` onto
current `llm`, and resolve any conflicts. Push the rebased head. This is
the first step of a 3-step chain (unpin+rebase -> shepherd -> merge); the
next two steps are separate orchestrated children.
