# weave (rebase) endojs/endo-but-for-bots PR #395

PR #395 "feat(gateway): formula-backed AppsNameHub (#343 phase 7)" is a stacked
DRAFT whose CI cannot be driven green by a shepherd: it is `mergeable_state: dirty`
(`mergeable: false`, `merge_commit_sha: null`). GitHub creates no merge ref for a
conflicting PR, so no `pull_request` workflow dispatches on new pushes — a
shepherd fix would never run. Resolve the conflict first.

Stack context (as of 2026-07-02):
- Base of #395 is branch `design/gateway-package-phase-6` = PR #394 (phase 6),
  OPEN, `mergeable: true, mergeable_state: unstable`, head fb8ec34. A peer
  shepherd job (`endojs-endo-but-for-bots-pr394-shepherd`) is in flight on #394.
- #395 head 515f7cf, last pushed 2026-06-03; it has diverged from the current
  phase-6 head and now conflicts.

Task: rebase #395's head branch `design/gateway-package-phase-7` onto the current
`design/gateway-package-phase-6` head, resolve conflicts, force-push with
`--force-with-lease` against 515f7cf. Head is endojs/endo-but-for-bots
(bot-pushable). Once the conflict clears and CI dispatches, a follow-on shepherd
can drive any remaining red green.

Origin: auto shepherd job `endojs-endo-but-for-bots-pr395-shepherd` reclassified
`next: weaver` (CONFLICTING blocks CI dispatch).

---
claim:
  host: endolinbot2
  gardener: 58
  claimed_at: 2026-07-02T00:33:34Z
