---
ts: 2026-05-14T09:49:16Z
kind: result
role: shepherd
worktree: dispatches/shepherd--699c9b/project
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
prs:
  - repo: endojs/endo-but-for-bots
    pr: 135
    role: source
refs:
  - entries/2026/05/14/094300Z-dispatch-steward-699c9b.md
  - entries/2026/05/14/090812Z-result-fixer-0cbacb.md
---

# Shepherd: PR #135 lint CI failure resolved

Single-step diagnose-and-fix on the post-fixer lint failure.

## Root cause

The `lint` job's failing step is `Check SECURITY.md uniformity`, which runs `bash scripts/check-security-md.sh`. That script (introduced upstream as PR #228, landed on `llm` base) requires every package with a `package.json` to have a byte-identical `SECURITY.md` alongside it.

The PR's base `llm` recently grew two new packages, `packages/harden-test/` and `packages/hex-test/` (from the harden and hex devDep-cycle break, #211 and the harden-test counterpart). Neither shipped with a `SECURITY.md`. The check runs on the synthetic merge ref (PR head merged into base), so even though `feat/mount-core` predates those packages, the merge tree has them, and the check fails.

Why local lint passed in the fixer's worktree: the check is a CI-only step wired into `.github/workflows/ci.yml`'s `lint` job, not `yarn lint`. The fixer's `npx corepack yarn lint` exits 0 cleanly. Same pattern observed on another open PR (#243) targeting `llm`, confirming this is base-state breakage that any in-flight PR will trip on until either (a) base adds the missing files or (b) each PR adds them in its own merge tree.

The `llm` base itself isn't directly tested by CI (the workflow's `on.push.branches` is `[master]` only), so the breakage went undetected on push to base; it only surfaces on PR runs against `llm`.

## Fix

Smallest fix: add `packages/harden-test/SECURITY.md` and `packages/hex-test/SECURITY.md` on the PR head, copied verbatim from the canonical `packages/daemon/SECURITY.md` (sha256 `071c74499d6d695e590ea3816ab579cb2e40639adcf7cf75e2702c732071f41d`, byte-identical to all 51 existing `packages/*/SECURITY.md` files).

The two package directories don't exist on `feat/mount-core` (those packages were introduced on base after the PR branched). The new SECURITY.md files create the directories on the PR head; the merge with `llm` lands them next to the existing `package.json` / `tsconfig.json` / `test/` siblings, so the script's first-pass presence check passes and the second-pass hash check finds them on the canonical hash.

## Commit pushed

```
bc599604528a0dd823f567bbee35f0cc64e8a1eb
  ci(security-md): add SECURITY.md for harden-test and hex-test packages
```

Two files, 76 insertions. Well within the shepherd's 5-file budget. No workspace topology changes, no test deletions, no `--no-verify`, no `continue-on-error`.

Branch head pushed to `endojs/endo-but-for-bots` `feat/mount-core` as `bc5996045` (was `612dc601f`).

## CI status

Mid-run on the new head at entry write time (`IN_PROGRESS=20 QUEUED=4 SUCCESS=1` rollup; `lint` job at `runs/25853479608`). Will update the dispatcher in this entry's tail when the run terminates, or by a follow-on `result` entry if I'm reaped before convergence. The expected outcome is the same 22/23 SUCCESS pattern as before, plus a now-passing `lint`, i.e. 23/23 SUCCESS.

## Out-of-scope observation for the orchestrator

The underlying defect is on the `llm` base branch: `packages/harden-test/` and `packages/hex-test/` were added without their `SECURITY.md` sidecars after the uniformity check landed. Every open PR against `llm` (e.g. #243, observed) trips the same red. The clean fix is a one-shot commit on base adding the two files; that retires the per-PR workaround. The garden's authority chain routes through the maintainer, so flagging here rather than acting upstream. Recording for the steward to consider whether to surface this to kriskowal (or wait for the maintainer to notice on the next PR merge).

Self-improvement: the `pre-pr-checklist` skill currently lists `yarn lint` as the local lint gate, but `Check SECURITY.md uniformity` is a CI-only step that local lint will not catch; either bake the SECURITY check into the local `yarn lint` rollup, or add a checklist line "no new packages without SECURITY.md" so reviewers (and the fixer's pre-push pass) catch base-side breakage before CI surfaces it.
