Panel round 4 complete. Here is my report.

---

## Panel round 4 — endojs/endo-but-for-bots PR #1100

**Disposition: must-fix** (panel.sh exit 0, genuine verdict).

### What I did
- Resolved the PR head (`endojs:kriscendobot-exo-stream-drop-base64`, base `llm-387ea66` / `387ea661…`) and set up an isolated project worktree at the PR head (`31a0a96b7e`, which already carries the round-3 fixes).
- Ran the panel in single-round mode (`GARDEN_PANEL_SINGLE_ROUND=1`) against that worktree, passing the PR baseRefOid (not a stale `origin/<baseRef>`). It fanned **30 seats** and aggregated cleanly: **22 request-changes, 3 comment-only, 2 approve**. `record-meta`: `disposition=must-fix, exit_code=0`, empty decider stderr — a genuine verdict, not a sensor failure.
- The raw aggregate (114 KB) exceeds GitHub's 65536-char review-body limit, so I composed a review body (`review.md`, 63894 chars) that leads with a **complete must-fix index** (every must-fix finding extracted verbatim, so the fixer loses nothing) followed by the per-seat aggregate truncated to fit.
- Posted it as a `gh pr review`. `--request-changes` was blocked by GitHub ("Can not request changes on your own pull request" — the self-authored bot PR), so it fell back to `--comment` (rc=0). The body carries the `### Must-fix before merge` heading that downstream automation keys on for bot-authored PRs. Verified live: review at `2026-09-17T03:39:22Z`, `COMMENTED`, 63702 chars.

### Notes / follow-ups
- A transient **secondary** GitHub rate limit (bot user 279080640) blocked the first posts; primary `rate_limit` showed 5000/5000. It cleared after ~120s on a backoff loop.
- Dominant must-fix theme across seats: `looksLikeReadableBlob`'s `text`-only branch admits sources with no `stream()`, but `mount.js` materializes every admitted source via `E(source).stream()` → runtime method-not-found; fix is to require `stream` on the `text` branch and mirror it in the published types/declarations. Other must-fix clusters: stale base64 prose in comments/READMEs, changeset bump-level incoherence (patch vs major) + missing write-side/perf-regression upgrade notes, an unreachable `isPassByCopyContainer` clause, a declared-but-unused `@fast-check/ava` dep with a weak codec test, benchmark-evidence gaps, and squashing the "panel round-N must-fix" commits. (Two seats self-retracted a `frozenBytes` byteOffset finding as unreproducible in a shared worktree — the fixer should treat that one with skepticism.)
- I did not fix, un-draft, or loop — this stage posts exactly one verdict and stops.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-exo-stream-drop-base64-stream-methods-gauntlet-resume-at-fix-20260917-panel-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 82 tokens (2716347 cached reads)
- Output: 21271 tokens
- Cost: $2.7707085000000005
- Wall-clock: 1858s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
