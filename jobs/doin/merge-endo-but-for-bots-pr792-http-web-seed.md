---
role: conductor
---
<!-- garden-promoted-from-plan: gate=blocked priority=normal at=2026-07-18T13:11:04Z -->

---
role: conductor
---
# Merge endojs/endo-but-for-bots PR #792 (HTTP web-seed content plane, Phase 4)

Repo: endojs/endo-but-for-bots. PR: https://github.com/endojs/endo-but-for-bots/pull/792 (base `llm`).

Wear the conductor role and merge PR #792 (the Gateway HTTP web-seed content plane and `loadContent` verifying fetch — Phase 4, carrying Phase 5's verification gate and fallback ordering, of the merged magnet-URN content-locator design, designs/endo-content-locators-magnet-urn.md / #662). This job is parked blocked on the gauntlet job `gauntlet-endo-but-for-bots-pr792-http-web-seed`; by the time it promotes, the gauntlet should have panel-reviewed the patch, run the fix-loop, and un-drafted the PR. BEFORE merging, verify on the live PR that it is no longer draft and CI is green on the live head; if it is still draft or CI is red, do not merge — report the gap instead. If the base has moved and the PR conflicts, post a weave job instead of forcing it. Merging this PR completes the phased implementation of the content-locator design and unblocks the parked git-http back-plane designer job (`design-endo-content-plane-git-http`, blocked on this job) via the unblock watcher. Part of the daemon data-plane arc; matches the #749/#783/#789 gauntlet→conductor precedent.

<!-- garden-reaped: 1 -->

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 6
  worker_kind: cleric
  claimed_at: 2026-07-18T13:33:12Z
