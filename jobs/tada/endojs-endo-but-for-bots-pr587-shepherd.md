Everything is now conclusive. Final state:

- **One lint check → green** (run `...741`): my prettier fix cleared the PR's actual defect.
- **Other lint check → red** (run `...748`): 9 eslint parsing errors, all in `packages/where` and `packages/zip` — the alphabetically-last packages, untouched by this PR.

This is the documented typescript-eslint `useProjectService` scaling ceiling on the large `llm` base branch (the PR targets `llm`, which is +1879 commits vs master; master itself lints green). It is a lint-infrastructure impasse on a shared branch, not a defect in this PR's diff, and fixing it means editing the shared eslint/tsconfig projectService config — a structural decision I must not bundle into this feature PR, and I must not push to the `llm` branch (outside this PR's head). That is a shepherd hard escalation point.

The substantive shepherd work is complete: I found and fixed the PR's real CI defect and drove that check green; the residual red is out-of-scope shared-branch infra, handed off with a classification.

---

**Shepherd report — endojs/endo-but-for-bots PR #587**

**What I did**
- Re-fetched live CI: two `lint` jobs were red; all other checks (tests, build, xs, etc.) green.
- Root-caused both lint failures to a single Prettier formatting violation in `packages/eslint-plugin/test/prefer-make-exo.test.js` (a collapsed `errors:` array). The `lint:prettier && lint:eslint` short-circuit meant this masked a second failure.
- Fixed it in an isolated project worktree with `prettier --write`, verified `--check` clean, committed `chore(eslint-plugin): prettier-format prefer-make-exo test`, and pushed to the PR head branch `lint-prefer-makeexo-over-far` (head now `1a6ff32`).
- Watched the re-run: the Prettier fix cleared its lint check (run `...741` → success) and unmasked the eslint step.

**What changed**
- 1 commit on the PR head (`1a6ff32`), 1 file, +1/−4 (formatting only). No behavior change.
- Rollup on head `1a6ff32`: 23 SUCCESS, 1 FAILURE.

**Residual failure (out of scope — escalating)**
- The remaining red `lint` job (run `...748`) fails with 9 typescript-eslint parsing errors — *"none of those TSConfigs include this file"* — exclusively on `packages/where/*` and `packages/zip/*`. This PR's diff (4 files, all in `packages/eslint-plugin`) touches neither.
- This is the known `useProjectService` scaling ceiling that drops the alphabetically-last packages on a large whole-repo lint. The PR's base is the `llm` integration branch (+1879 commits vs master); **`master` itself lints green (2026-06-29)**, so the ceiling is tripping on the `llm` merge-ref, not on this change. Matches the documented recurring endo lint-infra drift (`llm` lint drifts uncaught because ci.yml doesn't run on llm pushes).
- Not fixer-fixable (root cause outside the diff); fixing it requires editing the shared eslint/tsconfig projectService config — a structural decision that must not be bundled into this feature PR, and must not be pushed to the shared `llm` branch from a PR-scoped shepherd.

**Escalation classification: `next: liaison`** — the residual red is a lint-infrastructure impasse on the shared `llm` base branch (projectService ceiling on `where`/`zip`). It should be fixed on its own lint-infra PR against `llm` (unblocks every PR targeting `llm`, not just #587), pending a maintainer decision on approach. This PR's own CI defect is fixed and green.

**Follow-up:** open a dedicated lint-infra job/PR against `llm` to raise or reconfigure the typescript-eslint projectService coverage so `where`/`zip` are included at whole-repo scale.
