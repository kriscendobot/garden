---
ts: 2026-05-15T03:46:59Z
kind: result
role: fixer
project: endo-but-for-bots
prs:
  - repo: endojs/endo-but-for-bots
    pr: 107
    role: target
  - repo: endojs/endo-but-for-bots
    pr: 75
    role: base
refs:
  - entries/2026/05/15/031429Z-dispatch-liaison-2d2bbd.md
---

# Result: fixer rebased + shepherded + retconned #107

## Rebase outcome

Fetched `endo-upstream`; `origin/kriskowal-random-chacha12` already at `8eb479120` (the post-reverse-ferry head from `025204Z-result-fixer-346b46.md`). Old #75 base (`b0d9f31ce` and ancestors) was entirely rewritten by the reverse-ferry, so #107's two commits (`fff385dd4` feat + `d24a854d6` lockfile) had to replay onto a parallel commit chain sharing only `c2fc02eb8` as ancestor.

`git rebase --onto 8eb479120 b0d9f31ce d24a854d6`: zero conflicts. Both commits replayed cleanly; the new package's files don't intersect the reshaped surface in #75. Pushed `--force-with-lease=design/random-pure-rand-v8-interface:d24a854d6` to head `5818c340a`. Lease accepted.

## Shepherd outcome

CI on `5818c340a` ran the full 27-check matrix (build, lint, zizmor, test × {18,20,22,24}.x × {ubuntu,macos}-{latest,15}, test-async-hooks, cover, test262, test-hermes, test-xs, viable-release, test-ocapn-python, check-action-pins, dependabot.yml). All 27 SUCCESS. Note: dispatch entry called out `test-ocapn-guile-interop` as the gating signal, but that check is not in this PR's matrix; `test-ocapn-python` is the ocapn check that ran (and passed).

## Retcon outcome

Tagged pre-retcon SHA. `git reset --mixed 8eb479120` left 15 files staged across designs/, packages/random-fast-check/, yarn.lock. Restaged in three commits:

```
bd72a358f feat(random-fast-check): new package with v5 + v8 pure-rand adapters
6c53e600a docs(random-fast-check): design proposal for v8 interface and package split
e81b4a450 chore: Update yarn.lock
```

Per the retcon skill: one commit per affected package (random-fast-check has both implementation and tests bundled, 13 files), one commit for the design note (the documentation-only bucket), one commit for the lockfile.

## Net-diff invariance

Verified. Pre-retcon `git diff 8eb479120..5818c340a --shortstat` = `15 files changed, 1545 insertions(+)`. Post-retcon `git diff 8eb479120..e81b4a450 --shortstat` = `15 files changed, 1545 insertions(+)`. Cross-check `git diff 5818c340a..e81b4a450 --stat` = empty (identical trees).

## Push and CI re-convergence

`git push --force-with-lease=design/random-pure-rand-v8-interface:5818c340a` to new head `e81b4a450`. Lease held. CI re-ran the full matrix on `e81b4a450`; converged GREEN at 03:46:55Z with 26/26 SUCCESS (one fewer than the prior run; the dependabot.yml check was a one-shot success on the prior push and didn't re-run).

## Final head SHA

`e81b4a4509f9e8fa37f2b8f8154833026edc4fb7`

## Per-action authorization respected

No comments on #107. READ-ONLY on `endojs/endo` honored. No un-draft. The dispatch said the liaison adds the bulletin row; this report is the input.

Self-improvement: nothing this time. The retcon skill's procedure mapped cleanly to a small PR (one package + one design + lockfile). The skill's grouping-decisions section already covers the "documentation-only files" bucket I used for the design note, so no new pitfall or refinement to land.
