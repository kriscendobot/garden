# Foreman: post a maintainer-inbox notice once per distinct state, not every tick

**Garden's own repo** (`kriskowal/garden`, `main2`): isolated worktree off
`origin/main2`, push directly, no PR (garden-infra convention).

## Why (maintainer-observed, 2026-07-13)

When the board is bottlenecked on maintainer merge/review, the foreman has little
to promote, so **every tick it re-posts a near-identical milestone/bottleneck
notice** to the maintainer inbox ("M2/M3 stalled on merge", "one merge from
complete", the #719-vs-#263 decision, ...). Slightly reworded each time, these
flood the maintainer inbox — the actionable signal is real but should be stated
**once per distinct state**, not every few minutes. The leader liaison has had to
add layered content filters just to suppress the repeats; fix it at the source.

**Precedent to mirror:** `scripts/jobs/identity-drift-guard.sh` posts its loud
maintainer-inbox report **once per distinct drift signature** (a marker under
`$GARDEN_STATE`, `GARDEN_IDENTITY_DRIFT_MARKER`), re-posting only when the signature
changes or clears. Apply the same discipline to the foreman's maintainer-inbox
notices.

## What to change

In the foreman (`scripts/jobs/foreman.sh` and/or its handler
`scripts/jobs/handlers/foreman-claude.sh` — locate where it posts a
milestone/bottleneck notice to `inbox/maintainer/`):

- **Compute a stable signature** of the notice's *substance* — e.g. the milestone
  id + the set of blocking/mergeable PR numbers + the decision at issue (NOT the
  prose, which varies, and NOT a timestamp). Two ticks that describe the same
  underlying state must produce the same signature.
- **Record the last-posted signature** in a marker under `$GARDEN_STATE`
  (per-host, outside any reset-prone worktree, exactly like the drift guard).
- **Post only when the signature changes** (a new/closed PR, a resolved decision,
  a milestone advancing) or clears. An unchanged state posts **nothing**. When the
  state genuinely changes, post once and update the marker.
- Preserve the real signal: a genuinely new milestone decision (e.g. two
  alternative PRs appearing) still fires exactly once; a resolved one can fire a
  short "resolved/advanced" note once, then go quiet.

## Verify
- `bash -n` + `shellcheck -S warning` clean on the touched script(s).
- Show, via a focused harness or a code read, that: two consecutive ticks over the
  SAME board state post the maintainer notice **once, not twice**; a tick after the
  state changes (a PR added/closed) posts again exactly once; the marker lives under
  `$GARDEN_STATE`.
- Confirm no legitimate NEW milestone decision is swallowed (the signature must key
  on substance so a new decision changes it).

## Skills
- [self-improvement](../../skills/self-improvement/SKILL.md),
  [relative-paths](../../skills/relative-paths/SKILL.md),
  [no-comment-banners](../../skills/no-comment-banners/SKILL.md).

## Done
The foreman posts a maintainer-inbox milestone/bottleneck notice **once per distinct
state** (signature-marked under `$GARDEN_STATE`), re-posting only on a real change —
so an unchanged bottleneck no longer floods the inbox, while a genuinely new decision
still surfaces once. Committed and pushed to `main2`. The `tada` report gives the SHA,
the signature definition, and the dedup verification. Takes effect at the next deploy.
