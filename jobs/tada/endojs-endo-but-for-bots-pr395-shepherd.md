Shepherd job complete. Report:

## Shepherd report — endojs/endo-but-for-bots PR #395

**Diagnosis (original state).** The red CI that minted this job was a month-stale run (2026-06-03) — failing `lint`, `test` across the full node matrix (20/22/24.x × ubuntu/macos), `cover`, and `test-xs`. But re-fetching the live PR state showed the real blocker: PR #395 (gateway phase-7, a stacked DRAFT on #394/phase-6) was `mergeable_state: dirty` (**CONFLICTING**). Per the shepherd role's *Conflicting PRs block CI dispatch* norm, GitHub creates no merge ref for a conflicting PR, so no `pull_request` workflow dispatches on new pushes — any shepherd fix would never run. A shepherd cannot drive a conflicting PR green; that is a **weaver** task.

**Action taken.** Reclassified `next: weaver` and posted a hand-off job `endojs-endo-but-for-bots-pr395-weave` (identity `endojs/endo-but-for-bots#395:conflict:515f7cf`) with full stack context (base = #394/phase-6, in-flight and `unstable`; #395 diverged from the current phase-6 head).

**Resolution.** A peer gardener claimed and completed that weaver job (now in `jobs/tada/`). The rebase force-pushed a fresh non-conflicting head `6cbc91b`; #395 is now `mergeable: true, mergeable_state: unstable`, and a fresh CI run is dispatching — **all 25 checks in-progress, zero completed failures** on the new head.

**Disposition.** The triggering red was on a now-superseded conflicting head that no longer exists. Nothing red remains to fix; CI is propagating on the fresh head. `next: none` — CI is re-running post-rebase; if the fresh run lands red on `6cbc91b`, the leader's CI-status watcher will auto-mint a new shepherd job for the new failures (the designed mechanism). Spin-waiting the full matrix here would be the "watch-only" anti-pattern the role forbids.

**Follow-ups.** None required from me. The stack (#394 phase-6 is `unstable`, being shepherded by a peer; #395 phase-7 now depends on it cleanly) resolves through the normal per-PR shepherd jobs.
