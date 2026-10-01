## Report: #1397/#1398 restacked onto the new #1396 tip, bases moved, #1398 lint green

The job's planned base moves were out of date. Since the handoff, #1396's head had moved from `4330ae6` to `14e9810` (one new commit, "fix(captp): type the SturdyRef enlivener presence so lint:types passes", in `packages/captp/src/captp.js`). As the job said to do in that case, I froze the bases at the current lower-layer tips and restacked instead of using the bases named in the spec.

**What I did**
- **Restack:** in an isolated project worktree, rebased layer 7 (#1397) onto `14e9810` and layer 8 (#1398) onto the new layer 7. Both rebases were clean, with no conflicts.
- **New frozen base branches pushed:**
  - `build/sturdyref-captp-construct-14e9810` = `14e9810335`
  - `build/sturdyref-ocapn-enliven-0e0b333` = `0e0b333c19`
- **PR heads force-pushed**, with a lease check against the old SHAs:
  - `build/sturdyref-ocapn-enliven`: `b0729525d` → `0e0b333c19`
  - `build/sturdyref-daemon-formula`: `a79dcfc20` → `47762f41d6`
- **PR base fields moved** (`gh pr edit` worked from endolin):
  - #1397 → `build/sturdyref-captp-construct-14e9810`, now MERGEABLE
  - #1398 → `build/sturdyref-ocapn-enliven-0e0b333`, now MERGEABLE and 2 commits ahead of its base
- **#1398 CI restarted:** the head push landed while #1398 still pointed at its old, conflicting base, so GitHub started no `pull_request` runs (the earlier head `a79dcfc` had none either). I closed and reopened the draft PR to start them; this changed no commits.

**#1398 lint result:** the CI run 36797346174 `lint` job completed successfully on `47762f41d`. That covers `yarn lint`, build API docs, the composite TypeScript declarations build and the opt-in TypeScript contracts. No fix was needed. Guile interop, IronHorse sanitizers, the security audit and mutual-dependency-versions are also green.

**Still open**
- The rest of the main CI workflow had not finished when I stopped, on both #1397 (`0e0b333`) and #1398 (`47762f41d`). At the last snapshot, run 36797346174 had 12 jobs passed, 7 skipped and 7 not yet finished. Watching those to a result belongs to the existing gauntlet jobs for these PRs (`ebfb-sturdyref-layer8-daemon-formula-20260930-gauntlet-clean`, among others).
- The old frozen bases (`build/sturdyref-captp-construct-4330ae6`, `build/sturdyref-ocapn-enliven-b072952`, `…-7a34114`, `…-267b1aa`) are no longer used by any PR and can be deleted.
- Host oros-studio-garden-ce242c49's bot PAT still gets a 403 when editing endojs PRs, so PR-edit jobs need to keep running on endolin until that is fixed.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1397-1398-sturdyref-rebase-bases.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (1009848 cached reads)
- Output: 7431 tokens
- Cost: $0.7879096000000002
- Wall-clock: 2162s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
