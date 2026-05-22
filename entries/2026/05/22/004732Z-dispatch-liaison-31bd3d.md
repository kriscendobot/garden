---
ts: 2026-05-22T00:47:32Z
kind: dispatch
role: liaison
project: endo-but-for-bots
to: builder
prs:
  - repo: endojs/endo
    pr: 3032
    role: source
---

# Dispatch: builder mirrors endojs/endo#3032 (Cancellation primitive) onto endo-but-for-bots@llm

Dispatch root: `dispatches/builder--31bd3d/`. Project worktree on `endojs/endo-but-for-bots@llm` (detached at `68246ad92`).

Maintainer directive (2026-05-22): *"Please mirror https://github.com/endojs/endo/pull/3032 based on the llm branch."*

## What landed in endojs/endo#3032 (kriskowal's branch)

Upstream PR <https://github.com/endojs/endo/pull/3032>:

- Author: kriskowal
- Title: "Cancellation primitive"
- Source branch: `kriskowal-cancel` (already fetched into the project worktree as `endo-upstream/kriskowal-cancel`)
- Base on upstream: `master`
- 35 files, +1703 / -25
- Introduces new `@endo/cancel` package: `makeCancelKit`, `allMap`, `anyMap`, `delay`, `makeDelay`, `toAbortSignal`, `fromAbortSignal`
- Touches `@endo/pass-style/src/safe-promise.js` to allow a non-enumerable `cancelled` getter on promises (the cancellation token shape)
- Refactors `@endo/daemon` and `@endo/cli` to use `makeCancelKit` instead of `makePromiseKit`-for-cancellation

## Task

1. Read `garden/roles/COMMON.md`, then `garden/roles/builder/AGENT.md`. Note especially the norm "A design that lives on the roadmap branch is read, not branched-from" — that norm describes the default; **the maintainer's explicit directive in this dispatch overrides it.** Base off `llm`, not `master`, for this mirror.
2. Read `garden/skills/library-lookup/SKILL.md`, `garden/skills/pre-push-gates/SKILL.md`, `garden/skills/pr-formation/SKILL.md`.
3. Inspect what currently exists on `llm` that overlaps:
   - `packages/cancel/` (if any)
   - `packages/pass-style/src/safe-promise.js` (the file the upstream change patches; `llm` may have already diverged)
   - `packages/daemon/` and `packages/cli/` for the call-site refactor surface
   - The recently-superseded `designs/endo-gateway.md` / new `designs/gateway-package.md` aren't relevant here; mention only if a citation surfaces.
4. **Apply the upstream diff onto `llm`**. Two equivalent shapes; pick whichever produces the cleanest commit history:
   - **a)** `git checkout -b mirror/3032-cancel`; `git cherry-pick <range>` from `endo-upstream/kriskowal-cancel` onto `llm` HEAD, resolving conflicts package-by-package. This preserves the upstream commit grouping.
   - **b)** `git checkout -b mirror/3032-cancel`; squash the upstream diff into a small number of grouped commits matching the project's per-package convention (`feat(cancel): ...`, `feat(pass-style): allow cancelled getter ...`, `refactor(daemon): adopt makeCancelKit`, `refactor(cli): adopt makeCancelKit`, plus a separate `chore: Update yarn.lock`). This trades commit-history fidelity for a tidier mirror diff.
   - The existing precedent on this repo is the `mirror/3036-exo-stream` branch (PR #330) — read its commit shape (`git log --oneline mirror/3036-exo-stream ^llm`) before picking. As of 2026-05-21 it carries 2 commits: a `refactor(daemon)` re-export commit + a `fix(exo-stream): postpack` follow-up. That suggests **shape (b)** with a refactor-style grouping is the local convention; follow it unless conflicts make (a) cheaper.
5. Resolve any `llm`-vs-`master` divergence. `llm` carries design-PR-only changes and some refactors that haven't been ferried back to `master`; expect mostly clean application of the cancel diff, but conflicts in `packages/daemon/src/` are possible if `llm` already touched the same call sites.
6. **Local validation.**
   - `yarn install` (the cancel package adds new workspace entries).
   - `cd packages/cancel && npx ava` (the new package's own tests).
   - `cd packages/pass-style && npx ava` (the safe-promise change).
   - `cd packages/daemon && npx ava test/endo.test.js --timeout=120s` (the daemon call-site refactor).
   - `yarn lint` at root.
   - `yarn docs` or `yarn typecheck` if available.
   - Run `garden/skills/pre-push-gates/<script>` (or its inline procedure) before the first push.
7. **Commit shape.**
   - Implementation commits per package (feat / refactor / fix).
   - **Separate** `chore: Update yarn.lock` commit (per `garden/skills/yarn-lock-separate-commit/SKILL.md`).
   - Conventional-commit messages with the upstream PR number cited in the body (`Mirror of endojs/endo#3032.`).
8. **Push to the fork.** `git push origin HEAD:refs/heads/mirror/3032-cancel`. First push is non-force.
9. **Open the draft PR on `endojs/endo-but-for-bots`.** Base: `llm`. Title: `feat(cancel): @endo/cancel cancellation primitive (mirror of endojs/endo#3032)`. Body uses kriskowal's upstream PR body as the starting point (copy verbatim, plus a leading paragraph that names the mirror relationship). Mark draft per `pr-creation-flow`.
10. **Do NOT** cross-post on `endojs/endo#3032`. The boatman handles upstream cross-references later.

## Per-action authorization

- Push to `endojs/endo-but-for-bots:mirror/3032-cancel` (the fork the bot owns).
- Open draft PR on `endojs/endo-but-for-bots` against `llm`.
- READ-ONLY on `endojs/endo`. No comments anywhere outside the new PR's own body.

## Out of scope

- No comment on `endojs/endo#3032`.
- No un-draft of the mirror PR (the steward's PR-creation-flow scan picks up the orphan DRAFT per the 2026-05-21 norm; cleaner / judge / fixer-loop / un-draft runs from there).
- No upstream ferry. The boatman ferries the cleaned-up mirror back upstream later, if and when the maintainer authorizes it (and only if the mirror produces a meaningfully different artifact than #3032 itself — otherwise the upstream PR is already its own ferry).
- No re-render of any project README.

## Report

≤ 400 words. The fork PR URL + head SHA. The commit shape chosen (cherry-pick range vs. per-package re-formation). Any conflict resolutions on the `llm`-vs-`master` boundary. Local test status (pass/fail per command). One-line `Self-improvement: ...`.
