---
ts: 2026-05-20T03:44:05Z
kind: result
role: fixer
to: liaison
dispatch_id: faf9e1
dispatch_root: /home/kris/dispatches/fixer--faf9e1
project: endo-but-for-bots
prs:
  - repo: endojs/endo-but-for-bots
    pr: 109
    role: target
refs:
  - entries/2026/05/20/032423Z-result-fixer-64e8bc.md
---

# Result: fix #109 — regenerate composite tsconfig files

The branch was based on the pre-composite-tooling master (merge-base `0ec70c6dd`). Origin's `master` had advanced to `9213d2c56` carrying PR #3259 (`chore: add composite typescript build configuration`), so the `yarn build:types:gen` machinery and the existing per-package composite indices were not visible from the branch tip. Rebased the three branch commits onto `origin/master`, ran `yarn install`, then `yarn build:types:gen`, then committed the three regenerated files as one `chore:` commit on top.

## Files changed (single new commit on top of rebased branch)

- `packages/syrup-frame/tsconfig.composite.json` (new, references harden / init / promise-kit / stream)
- `packages/ocapn/tsconfig.composite.json` (added references to `stream` and `syrup-frame`)
- `tsconfig.composite.json` (added `packages/syrup-frame` reference)

## SHAs

- Pre-fix head: `a05d57b8e` (lease target)
- Rebased branch commits: `dc729c8b9` (feat syrup-frame), `561e54ed9` (feat ocapn opt-in), `f7e9339e9` (chore Update yarn.lock)
- Fix commit: `2627e81a3` (chore: regenerate composite tsconfig files)
- New head: `2627e81a3`

## Local verification

`yarn build:types:check` output:

```
All composite tsconfig files are up to date.
```

(Pre-gen run reproduced the three findings from the failure log: `Missing: packages/syrup-frame/...`, `Drift detected: packages/ocapn/...`, `Drift detected: tsconfig.composite.json`.)

## Push

`git push origin HEAD:feat/syrups-package --force-with-lease=feat/syrups-package:a05d57b8e...` accepted: `+ a05d57b8e...2627e81a3 HEAD -> feat/syrups-package (forced update)`.

No comments posted (none authorized in the dispatch). The yarn.lock did not change so no separate lock commit was needed.

Self-improvement: nothing this time. The `pre-push-gates` skill was not load-bearing here (the dispatch was a targeted regeneration, not a substantive content edit), and the retcon-vs-fix discrimination held: the prior dispatch had already cemented the three-commit shape via the retcon, so this fix correctly sat as a single new commit on top rather than re-restaging into the feature commits.
