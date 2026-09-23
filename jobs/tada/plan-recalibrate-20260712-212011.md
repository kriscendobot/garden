Weekly plan recalibration complete. Report follows.

## Weekly plan recalibration + grooming — Sunday 2026-07-12

Worked in an isolated worktree off `origin/journal2`; committed to `journal2` (`66b3895bf8`) and updated the endo redirect PR. All actions under bot identity (`kriscendobot`); agoric-sdk untouched.

**1. Reconcile (status/PR drift).** Ran `reconcile.sh` — **0 records flipped** (no newly-merged design PRs this week). Sanity-checked the two In-Progress records carrying a PR: `endo-but-for-bots#133` is still **OPEN** (correctly In Progress) and `#287` (daemon-message-streaming) is still **CLOSED-unmerged** with no replacement PR — both correctly left untouched by the merge-only auto-flip. The #287 drift was already flagged for the maintainer in the 2026-07-05 pass; state unchanged, so no redundant third note added.

**2. Velocity.** Trailing 7-day window (2026-07-05→07-12) merged **26 PRs, ~3.7/day**, spread evenly (1,4,11,2,5,0,3 by day) — no fleet-down availability gap like last week. Latency: fast review-queue cohort of 20 PRs, **median 0.76 d**; short tail of 6 at 8.3–25.9 d (last week's 40–70-day stragglers have drained). Kept `review-queue-latency-days: 1` — three consecutive passes now agree (1.15 → 0.90 → 0.76). S/M/L/XL day mapping left unchanged (per-design effort model; high throughput is a parallel-fleet signal). Logged the new entry in `velocity.md`.

**3. Roadmap projection.** Per-milestone calendar `target:` dates **intentionally left unstamped** again — the standing decision (documented in `velocity.md`): mapping single-dev effort-days onto wall-clock needs a parallelism factor the plan doesn't yet carry, and this week's even ~3.7/day cadence doesn't change that.

**4. Groom.** No dangling `depends_on` edges; validator clean (141 records, 0 errors, 0 warnings) before and after. Filed **3 clearly-placed unfiled designs** into milestones:
- `daemon-message-streaming` → **M9** (daemon side of the M9 chat streaming UX; its M9 dependents `chat-edit-message-ui`/`chat-pending-commands` build on it)
- `hardened-text-codecs-shim`, `hardened-url-shim` → **M2** (SES-intrinsic package hygiene, same lane as `endo-bytes`/`hex-package`/`base64-native-fallthrough`)

Each got a dated grooming note and refreshed `updated`. The remaining ~11 non-done unfiled designs (CLI verbs, XS-worker debug/snapshot, CAS/archive, outliner, etc.) were left unfiled — their milestone homes are genuinely ambiguous and guessing would pollute the rollups; **flagging for maintainer/design input**. Rollup effect: M2 6→8 members, M9 19→20.

**5. Re-render.** Regenerated `plan/README.md` from the groomed records (render prints to stdout — redirected into the file).

**6. Endo courtesy redirect.** Regenerated via `render-endo-redirect.sh`; output **differed** from the branch (deterministic diff: `filesystem-watchers` flipped to **Complete** 2026-07-09 during the week, plus refreshed `updated` dates on the git-capability designs and my 3 groomed records). Committed and pushed change-gated to the existing open redirect **PR #536** (`chore/plan-in-journal-endo-redirect`, base `llm`, `3d489bc6d..6554de0ec`) — reused across weeks as intended; PR remains the single open redirect. Not a no-op week, so the push was warranted.

**Follow-ups for the maintainer:** (a) decide whether to re-open implementation or retire `daemon-message-streaming` (#287 closed-unmerged, no replacement, flagged 2 weeks running); (b) milestone homes for the ~11 remaining unfiled non-done designs; (c) the still-uncalibrated parallelism factor blocking dated milestone targets.
