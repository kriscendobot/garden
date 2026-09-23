---
kind: message
role: botanist
host: endolinbot2
at: 2026-06-30T23:21:39Z
---
project: endo-but-for-bots
repo: endojs/endo-but-for-bots

# Dependabotany TERMINAL verdict: endojs/endo-but-for-bots#197 — MERGE-NOW (embargo lifted, merged onto `llm`)

One-time embargo reevaluation `dependabotany-recheck-endo-but-for-bots-pr197`
(gardener 45, endolinbot2), fired at the maintainer's proposed time per
[kriskowal 2026-06-25](https://github.com/endojs/endo-but-for-bots/pull/197#issuecomment-4803509507).
This is the **terminal** verdict on #197: it **removes #197's row from the
dependabotany ledger**. Recover the cumulative posture with:

```sh
grep -rl '^project: endo-but-for-bots$' journal/entries/ | xargs grep -l '^# Dependabotany'
```

## Verdict: MERGE-NOW — executed

Supersedes the **EMBARGO-2026-06-30** floor set by the 2026-06-24T16:22Z
re-botany (`entries/2026/06/24/162209Z-message-botanist-76a8f8.md`). The maturity
gate that was the sole blocker has passed; the merge gate is fully satisfied and
the PR is **MERGED**.

| PR | Headline | Verdict | Disposition |
|---|---|---|---|
| [197](https://github.com/endojs/endo-but-for-bots/pull/197) | electron `^42.0.1` → resolved `42.5.0` in `@endo/familiar` (+ maintainer ESM rework; base `llm`) | **MERGE-NOW** (terminal) | **MERGED** onto `llm` 2026-06-30T23:20:28Z, merge commit `f98d663911d6c5f278466ee0e3c67bf6aececc97` |

### Gate (all legs held, assessed 2026-06-30T23:19Z)

- **Maturity ≥7d — now met.** electron `42.5.0` (pub 2026-06-23T19:55:53Z, floor 19:55Z, crossed ~3.4h prior); `@electron-internal/extract-zip@1.0.4` (pub 2026-06-23T22:43:17Z, floor 22:43Z, crossed ~37m prior); `@electron/get@5.0.0` (69d); `undici@7.28.0` (15d).
- **Caret-freshness trap cleared.** `42.5.1` (2026-06-29) and `42.5.2` (2026-06-30T19:01Z, ~4h) now exist on npm, so `^42.0.1` would re-resolve to `42.5.2` on a fresh `yarn`. It did not slip in: the committed lockfile pins matured `42.5.0`, and the pre-merge `gh pr update-branch` (git merge, no `yarn` re-resolution) preserved `electron@npm:42.5.0` at the merge head `c777659c12` (verified).
- **OSV/GHSA — clean, not CVE-repairing.** No advisory on any of the four moved versions. Maturity was the only constraint.
- **CI green against current `llm`.** Branch was 223 behind with a stale 2026-06-24 rollup; refreshed via `update-branch` (preserving 42.5.0) and re-shepherded. All **22 check-runs `success`** at fresh head `c777659c12`; `MERGEABLE` / `CLEAN`. Then conducted `--merge`.

### Schedule state

- One-time job `dependabotany-recheck-endo-but-for-bots-pr197` self-clears on completion (no recurring schedule file existed for it).
- Standing daily `schedules/dependabotany-recheck-endo-but-for-bots.md` **retained** as the heartbeat backstop per the job spec. With #197's terminal verdict the ledger now holds **no embargoed OPEN endo-but-for-bots rows**; the daily sweep is permitted to be pruned once that remains true, but is left in place as the backstop for the next embargo.

Verdict comment posted: https://github.com/endojs/endo-but-for-bots/pull/197#issuecomment-4848708252
