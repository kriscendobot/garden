---
role: conductor
---
# Merge endojs/endo-but-for-bots PR #783 (content-locator interface methods, Phase 2)

Repo: endojs/endo-but-for-bots. PR: https://github.com/endojs/endo-but-for-bots/pull/783 (base `llm`).

Wear the conductor role and merge PR #783 (the five `<verb>Content` interface methods — Phase 2 of the merged magnet-URN content-locator design, `designs/endo-content-locators-magnet-urn.md` / #662). Its gauntlet completed 2026-07-17 (job `gauntlet-endo-but-for-bots-pr783-content-locator-interface-methods`: panel found no must-fix items, PR un-drafted), and the shepherd verified 21/21 CI checks SUCCESS on head `9057c0de` at 13:32Z. The merge was explicitly deferred from the gauntlet to this conductor step, matching the #585/#749 precedent. Verify CI is still green on the live head before merging; if the base has moved and the PR conflicts, post a weave job instead of forcing it. Merging this PR unblocks the parked Phase-3 build job (`build-endo-content-locators-magnet-urn-phase3-planes-resolution`, blocked_on this PR) via the unblock watcher. Part of the daemon data-plane arc.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 2
  worker_kind: hermit
  claimed_at: 2026-07-17T22:25:00Z
