---
ts: 2026-05-15T02:28:24Z
kind: dispatch
role: liaison
project: endo-but-for-bots
to: "*"
prs:
  - repo: endojs/endo-but-for-bots
    pr: 240
    role: target
refs:
  - entries/2026/05/15/022721Z-result-judge-862a3d.md
---

# Dispatch: fixer addresses judge's must-fix + should-fix on #240 (gamut step 4)

Dispatch root: `dispatches/fixer--3fad27/`. Project worktree on `endojs/endo-but-for-bots@feat/turbo-test-depends-on-build` (head `223aacfe1`).

Step 4 of the gamut on #240. Judge `862a3d` submitted COMMENT verdict (1 doc must-fix + 3 should-fix + 3 out-of-scope). The fixer addresses must-fix + should-fix; out-of-scope items defer.

## Items to address

**must-fix (1):**
- `turbo.json.md` and the PR body contradict the prior doc on whether turbo's dev-dep cycle check is fatal or warning. Repo pins `turbo: ^2.9.10`. The prior doc said turbo 2.9 demoted the cycle check from fatal to warning. The new doc/body framing says "fatal under turbo's cycle check" and the dry-run "refuses to compute a task graph". Resolve: either re-cite the demoted-to-warning rationale and explain the current non-zero exit, or update the framing.

**should-fix (3):**
- Credit `build`'s new `^build` edge for the transitive-cascade invariant (the doc currently frames `test`'s explicit `^build` as load-bearing; turbo's resolver carries the cascade through `build`'s edge regardless). Two-line rewrite.
- Name the CI consumer in the doc: `.github/workflows/ci.yml` `test` job (line 169, `yarn turbo run test --filter='...[origin/llm]'`) is the only turbo invocation. The `lint` job (lines 61-65) does not. One sentence.
- Commit subject enumerates only `test`; `build`'s new `^build` is half the change.

## Out of scope (do NOT address)

- Merge gating behind #206 cuts 1 and 4.
- Future CI step running `yarn turbo run build --dry=json`.
- Capturing clean dry-run as empirical evidence.

## Per-action authorization

Standing on endo-but-for-bots: push fixup commits + reply on the judge's review threads (or top-level comment summarizing the fixes).

## Task

1. Address each must-fix and should-fix item per the above.
2. **Per today's self-improvement** (filed at `015257Z`): commit + push BEFORE extended local validation.
3. Push with `--force-with-lease` if needed (or fast-forward push).
4. Reply on the judge's review with a thread-level summary citing the commit SHAs.

## Report

≤ 250 words: per-item disposition (one line each: doc-edit + commit-message-tweak), head SHA after push, one-line `Self-improvement: ...`. After this fixer returns, the liaison re-dispatches the judge (gamut step 5: re-review).
