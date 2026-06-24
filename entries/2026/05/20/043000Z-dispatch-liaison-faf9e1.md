---
ts: 2026-05-20T04:30:00Z
kind: dispatch
role: liaison
project: endo-but-for-bots
to: fixer
prs:
  - repo: endojs/endo-but-for-bots
    pr: 109
    role: target
  - repo: endojs/endo
    pr: 3256
    role: source
---

# Dispatch: fixer regenerates composite tsconfig files on endo-but-for-bots#109

Dispatch root: `dispatches/fixer--faf9e1/`. Project worktree on `endojs/endo-but-for-bots@feat/syrups-package` (head `a05d57b8e`).

Maintainer directive (2026-05-20): *"Please address the CI failure on https://github.com/endojs/endo/pull/3256 in our mirror of that PR."*

Our mirror = [endojs/endo-but-for-bots#109](https://github.com/endojs/endo-but-for-bots/pull/109), branch `feat/syrups-package`, head `a05d57b8e`. Same content as upstream #3256.

## Failure signature

Lint workflow on upstream #3256 (job [76878906105](https://github.com/endojs/endo/actions/runs/26138559968/job/76878906105)) — `lint` step passes with 2 unrelated warnings, but the next step **`yarn build:types:check`** fails:

```
Missing: packages/syrup-frame/tsconfig.composite.json
Drift detected: packages/ocapn/tsconfig.composite.json
Drift detected: tsconfig.composite.json

Run `yarn build:types:gen` to regenerate composite tsconfig files.
```

## Task

Read `garden/roles/COMMON.md` + `garden/roles/fixer/AGENT.md` first.

1. **Reproduce locally**: run `yarn install` then `yarn build:types:check` in the project worktree. Confirm the same three issues surface.

2. **Regenerate**: run `yarn build:types:gen` per the script's own self-remediation hint. This should:
   - Create `packages/syrup-frame/tsconfig.composite.json` (the new package's composite file).
   - Update `packages/ocapn/tsconfig.composite.json` (drift — likely a reference to the new `@endo/syrup-frame` package).
   - Update root `tsconfig.composite.json` (drift — adds the new package to the project-references list).

3. **Verify**: re-run `yarn build:types:check`; should now pass cleanly. Also run `yarn lint` to confirm no regression.

4. **Commit and push**:
   - Single commit: `chore(syrup-frame,ocapn): regenerate composite tsconfig files for new package`.
   - Force-push with `--force-with-lease=feat/syrups-package:a05d57b8e` to update PR #109.
   - Per today's recurring self-improvement: commit + push BEFORE extended local validation. Local-validation work after the push is fine.

5. **Reply nothing on upstream #3256** — the bot's mirror is the working surface; the boatman ferries upstream when the maintainer authorizes. The fix doesn't need a comment on either side; the CI rerun on the new head is the visible signal.

## Per-action authorization

Standing on endo-but-for-bots: force-push to `feat/syrups-package` with lease. READ-ONLY on `endojs/endo`.

## Out of scope

- No PR body / title edits.
- No upstream ferry.
- No comment posting on either repo.
- No source changes beyond the regenerated tsconfig files. If `yarn build:types:gen` touches anything else, surface and stop.

## Report

≤ 300 words: files generated/modified, commit SHA, new head SHA after force-push, local `build:types:check` outcome post-fix, one-line `Self-improvement: ...`.
