## Botany review complete: `endojs/endo-but-for-bots` PR #558

**Verdict: MERGE-NOW.** Executed through the conductor spine; the merge did **not** land, blocked at the maintainer-approval gate (`reviewDecision=none`, the PR carries no review of any kind). PR is still OPEN, MERGEABLE/CLEAN, base `llm`.

### What the PR is
`softprops/action-gh-release` 3.0.0 to 3.0.1: one line in `.github/workflows/familiar-release.yml`. GitHub Actions ecosystem, so there is no manifest or lockfile change, no project transitive set, no new npm package, no license change, and nothing to install. The scripts-disabled install step is recorded as not-applicable rather than silently skipped.

### Gate legs, each checked
- **Pin verified.** `refs/tags/v3.0.1` resolves to `718ea10b132b3b2eba29c1007bb80653f286566b`, exactly what the PR pins. Descendant of v3.0.0 (`ahead=17 behind=0`), release not draft/prerelease, tagged-commit time consistent with the publish instant. No yanked-then-republished signal.
- **Source read, byte-exact.** `action.yml` is blob `ee219b7b52` at both tags (still `node24` / `dist/index.js`, no `pre`/`post` hook). `dist/index.js` differs by 33 bytes in one place: the esbuild CommonJS lazy-require shim gained a `try`/`catch` that clears the cache slot and rethrows. I fetched both blobs and confirmed mechanically that applying that single substitution to the v3.0.0 bundle reproduces the v3.0.1 bundle **byte for byte** (`patched == new`, 788476 -> 788509). That is esbuild 0.28.0 to 0.28.1 codegen, not action logic. No new network call, filesystem write, `child_process`, dynamic require, or telemetry.
- **Advisories.** No GHSA and no OSV record for the action, unversioned or at 3.0.1.
- **Maturity.** v3.0.1 published 2026-06-19T14:42:32Z, 39 days. Past the 7-day floor, so no embargo and no recheck one-shot.
- **CI.** 22/22 green, re-read against the head SHA by the spine. The runs are dated 2026-06-28 and the branch is 558 commits behind `llm`, so I checked the staleness instead of waving it off: the touched workflow file is blob `38a50aa635` at both the merge base and current `llm`, unmodified since before the branch was cut, so the post-merge content is exactly what `check-action-pins` and `zizmor` validated.

### Disposition
Spine output: `rollup-terminal total=22 failed=0 -> CI GREEN`, then `merge blocked: no maintainer approval`. Repo is bot-owned so this was an execution attempt, not a recommendation; the approval gate is intact by design.

### Artifacts
- Verdict comment: https://github.com/endojs/endo-but-for-bots/pull/558#issuecomment-5101267372
- Ledger entry: `entries/2026/07/28/073412Z-message-gardener-1973e3.md` (terminal technical verdict, **no** open embargo row, daily backstop untouched)
- Maintainer inbox: `20260728T073443Z-990c59`

No garden-side (`main2`) commits; this job needed none.

### Follow-ups
1. **One APPROVED review from an allowlist maintainer merges this immediately.** Nothing else stands in the way.
2. Siblings #556, #557, #268, #269 are the same watcher wave and will land in the same approval-gated state; one review pass clears the batch. Flagged in the maintainer note.
3. Upstream has v3.0.2 (2026-07-13, also mature) with no Dependabot PR yet. Not a reason to hold #558. I deliberately declined `@dependabot rebase`: it would likely re-target to 3.0.2 and invalidate this review, and the staleness it would cure is provably absent for the one file touched.

Self-improvement: nothing this time. The peer botanist on #269 already landed the lesson this run would have produced (record a terminal technical MERGE-NOW separately from the conductor approval gate, so a maturity ledger never mistakes an approval blocker for an embargo), and job `fu-endojs-endo-but-for-bots-pr868-dependabot-3` is already amending `roles/botanist/AGENT.md`.
