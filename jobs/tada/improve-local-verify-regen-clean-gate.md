Pushed cleanly on the first attempt. The work is complete.

## Completion report

**Job:** `improve-local-verify-regen-clean-gate` — harden `scripts/jobs/gardening/local-verify.sh` with a codegen-then-clean gate.

**What I did**

Made the two requested changes to `local-verify.sh`, plus test and doc updates:

1. **Added a `codegen` step to `STEPS`** (now `format lint build codegen test docs`) with candidates `gen:code-mode-types codegen gen generate build:types`, so a project's generators run as part of the gate rather than being left to an agent's memory.

2. **Added a codegen-then-clean gate** after all steps: it checks `git -C "$wt" status --porcelain`, and if the worktree became dirty it fails with `STEP codegen left tree dirty: generated artifacts are stale — commit the regen`, emits a SHA-captured `git diff --stat` (plus the porcelain status so a new untracked artifact is visible too) via `capture_blob` — raw diff never reaches stdout — and increments `failures`. Stays silent-on-success and content-addresses the failure, within local-verify's existing discipline.

**What changed**
- `scripts/jobs/gardening/local-verify.sh` — codegen step, candidates, dirty gate, header comment.
- `scripts/jobs/test/local-verify-test.sh` — 2 new fixtures (staled-artifact regen fails the gate with a SHA-captured diff and no raw diff on stdout; up-to-date regen stays silent/exit 0). **17/17 pass**; `bash -n` and `shellcheck` clean on both files.
- `skills/local-verify/SKILL.md` — documented the step, the gate, the candidate table row, the `LOCAL_VERIFY_CODEGEN` override, the mutating-format pitfall interaction, a dated field note, and bumped `updated`.

**Notes / follow-ups**
- The dirty check is generic by design: a mutating `format` step (no check variant) will also trip the gate. This is intended discipline (an unformatted/unregenerated commit is caught locally); I documented it in Pitfalls. No follow-up required, but worth watching if any project relies on local-verify to silently auto-format.

Committed as `8c8c8728ec` and pushed to `origin/main2` (CAS push succeeded first attempt).
