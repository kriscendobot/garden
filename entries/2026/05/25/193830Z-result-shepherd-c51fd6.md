---
ts: 2026-05-25T19:38:30Z
kind: result
role: shepherd
worktree: dispatches/shepherd--5c7bcc/project
repo: endojs/endo-but-for-bots
project: endo
refs:
  - PR endojs/endo-but-for-bots#361
---

Shepherded PR #361 (fix(ocapn): port netlayer-tcp-syrup test from makeClient to makeOcapn).

Head SHA on entry: `2ecf40ed8974cdc2e67fb70c3311c24fc709a7db` (unchanged; no shepherd pushes).

Two failing checks at dispatch entry:

1. **`build` (workflow: Test project mutual dependency versions, run 26325519567)**: transient git-checkout flake. Submodule auth failed with `fatal: could not read Username for 'https://github.com': terminal prompts disabled` across all 3 retries on this PR's run; sibling runs on other branches in the same window all succeeded. Reran via `gh run rerun 26325519567 --failed`; rerun completed SUCCESS. Real flake, retired by rerun.

2. **`lint` (workflow: CI, run 26325519568 job 77502436402)**: real failure, **not introduced by PR #361**. The yarn lint step itself passed (warnings only, no errors). The exit-1 came from the next step `bash scripts/check-security-md.sh`:

   ```
   packages/bytes: SECURITY.md differs from canonical
   (sha256 d9acd9c2... vs 071c7449...)
   ```

   Cause: `packages/bytes/SECURITY.md` was added in commit `dd45f4a7f` (`feat(bytes): @endo/bytes package`, 2026-05-14, Kris Kowal) using `GitHub` (correct case) where every other package's SECURITY.md uses `Github`. The check-security-md.sh script picks the majority hash as canonical and flags bytes as the outlier. The drift exists on the base branch `llm` itself and blocks every open PR targeting `llm` (verified: #361, #362, #357 all show same `lint:FAILURE`; #340, #339 partial).

   The fix is out of scope for shepherd on PR #361 because: (a) the offending file is unrelated to PR #361's substance (PR touches only `packages/ocapn/test/netlayer-tcp-syrup.test.js`); (b) the proper fix belongs on a separate base-branch PR (either copy the majority `Github` body to `packages/bytes/SECURITY.md`, or fix the typo across all package SECURITY.md files); (c) fixing it on PR #361's head would conflate scopes and only unblock this single PR until other open PRs rebase past it.

**Verdict**: `handed-to-conductor` (with caveat).

The PR is APPROVED by kriskowal (2026-05-25T19:29:33Z), with explicit directive `@kriscendobot Please shepherd and hand off to conductor` (2026-05-25T19:29:58Z). The `llm` branch has no branch protection (verified: `gh api repos/endojs/endo-but-for-bots/branches/llm/protection` returns 404), so a conductor `gh pr merge --merge` will succeed despite `mergeStateStatus: UNSTABLE`. The maintainer approved AFTER the failure was visible, indicating awareness.

Recommended follow-up (separate dispatch, not on PR #361): a fixer PR against `llm` to resolve the SECURITY.md uniformity drift — preferred shape is to fix the `Github` -> `GitHub` typo across every package's SECURITY.md (matches the bytes intent and is a one-line sed across ~25 files), with the matching commit message convention used by PR #245 (`chore(bytes,...): align SECURITY.md` or similar). That fix unblocks `lint` for every open PR targeting `llm`.

CI run URLs:
- Mutual deps rerun (now green): https://github.com/endojs/endo-but-for-bots/actions/runs/26325519567
- Lint (failing on SECURITY.md): https://github.com/endojs/endo-but-for-bots/actions/runs/26325519568/job/77502436402

Self-improvement: nothing this time.
