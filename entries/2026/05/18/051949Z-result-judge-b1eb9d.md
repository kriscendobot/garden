---
ts: 2026-05-18T05:19:49Z
kind: result
role: judge
worktree: dispatches/judge--b1eb9d
repo: endojs/endo-but-for-bots
project: endo
refs:
  - entries/2026/05/18/051522Z-dispatch-judge-b1eb9d.md
  - entries/2026/05/18/051041Z-result-cleaner-e31b72.md
---

## PR #281 judged: ephemeral GC roots for suspended-worker snapshots

Panel kind: **code-panel** (16 seats).
Panel execution: **in-band-fallback** (no `Agent` / `Task` tool surfaced in this judge dispatch; each seat's block was written sequentially against the per-seat role file in `garden/roles/<seat>/AGENT.md`).
Head reviewed: `d400f8b07` on `feat/xs-worker-snapshot-cas-gc-roots-20260518-044324`.
CI: 25 of 25 required checks green on the reviewed head.

### Verdict

| Bucket | Count |
|---|---|
| Must-fix | 0 |
| Should-fix | 4 |
| Out of scope (follow-up) | 5 |

Per-seat verdict count: 16 of 16 seats returned `comment-only` after dedupe. No seat surfaced a must-fix; the four should-fix items were dual-surfaced by the assessor, prover, saboteur, and breaker (release-then-restore window, double-suspend leak, set_cas silent overwrite, cancel_suspended without a callsite). The aggregated panel body was 2510 words after trim, within the 1600 to 2600 target band for a sixteen-seat code panel.

### Fixer rounds

Zero. The terminating verdict was reached on the first round.

### Submission

One formal `gh pr review --comment` was submitted to PR #281. The `--comment` form was used per the self-PR limitation in `skills/panel-review/SKILL.md` § Pitfalls (`kriscendobot` is both author and reviewer; `--request-changes` and `--approve` would be blocked by GitHub). The body carries an explicit "Must-fix before merge" heading with "None" inline so the orchestrator's dispatch matrix sees the empty must-fix.

### PR state

Un-drafted via `gh pr ready 281 --repo endojs/endo-but-for-bots`. Confirmed: `isDraft: false, state: OPEN`. The PR is now in the maintainer's review queue.

### Notes for the next Rust-side judge cycle

1. **Panel composition for Rust-only PRs is signal-thin on several seats.** The typist, packager (yarn-lock branch), curator (`exports`-map), and migrator (peer-dep cascade) seats produce few findings on a Rust-only diff because their primary surfaces are JS-side. The high-signal seats on this PR were assessor, prover, saboteur, breaker, locksmith, archivist, and (paranoid-extra) wire-watcher. A future maintainer directive could name a smaller composition (six to eight seats) for Rust-only PRs to keep aggregation crisp. Recording in the bulletin for the next Rust-side judge cycle to consider; not a panel finding.

2. **Build-prereq footnote.** The PR's tests run under `cargo test` only; the design's *Remaining* integration test still gates on the JS bundles (`ses_boot.js` / `worker_bootstrap.js` / `daemon_bootstrap.js`) being buildable from a fresh checkout. The cleaner's prior message at `entries/2026/05/18/051155Z-message-cleaner-e31b72.md` records the same gap. The judge concurs the integration test is out of scope for this PR; the should-fix on the release-then-restore race window is the unit-level proxy for the integration test's load-bearing claim.

3. **The `take_suspended` doc comment names the precondition the supervisor does not enforce** ("the caller is then responsible for either restoring the machine from the snapshot consuming the file before any GC runs, or for re-retaining the hash if the snapshot needs to live past this call"). This is the seam between Phase 2 (single-caller GC) and Phase 3 (cross-process GC arbitration). Tagging it here so the next Phase 3 builder finds the seam without re-deriving it.

4. **In-band-fallback runtime cost.** Writing sixteen seat blocks one at a time, plus the aggregation pass, plus the two journal-sync rounds, ran roughly four minutes in wall clock. The concurrent-dispatch form would have absorbed the same word budget in well under a minute. Recording so the orchestrator can prefer harnesses that surface the `Agent` / `Task` tool when the panel is the dominant cost on a chain.

Self-improvement: nothing structural this time; the in-band-fallback procedure on `roles/judge/AGENT.md` worked as written and the four-seat overlap on the same finding (release-then-restore window) was deduped cleanly per `skills/panel-review/SKILL.md` § Aggregation. The Rust-only panel-composition observation is a candidate maintainer-facing message but does not warrant a structural change to the judge or the panel-review skill; the orchestrator has the per-PR composition-override knob already.
