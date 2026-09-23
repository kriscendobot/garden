---
ts: 2026-05-14T20:48:49Z
kind: dispatch
role: liaison
project: agoric-sdk
to: "*"
prs:
  - repo: Agoric/agoric-sdk
    pr: 12659
    role: source
---

# Dispatch: builder mirrors Agoric/agoric-sdk#12659 onto the kriscendobot fork with turadg's aliasing fix applied

Dispatch root: `dispatches/builder--0d4cad/`. Project worktree on `kriscendobot/agoric-sdk@feat/migrate-eslint-plugin-import-x` (detached at `c2200be7`, fetched from `Agoric/agoric-sdk:feat/migrate-eslint-plugin-import-x`).

This is the **first active engagement** on `agoric-sdk`. The project's `journal/projects/agoric-sdk/README.md` describes the prior posture as *passive standing watch*; the user (2026-05-14) directed the bot to create a mirror of Agoric/agoric-sdk#12659 on the kriscendobot fork and apply turadg's feedback locally via the garden's PR workflow.

The PR-creation chain runs end-to-end on the fork: builder (this dispatch) → cleaner → judge (12-seat code panel) → fixer-loop → judge un-drafts. The maintainer reviews the un-drafted fork PR; once approved, the boatman ferries to Agoric/agoric-sdk#12659.

## What landed in agoric-sdk#12659 (kriskowal's branch at `c2200be7`)

100 files changed; the substance migrates `@agoric/eslint-config` from `eslint-plugin-import` to `eslint-plugin-import-x`. turadg's pointer at <https://github.com/Agoric/agoric-sdk/pull/12659#issuecomment-...> (today) links the feedback shape from endojs/endo#3255: prefer aliasing over suppression. Our analogous mirror at endojs/endo-but-for-bots#226 implemented the aliasing as a catalog-level `eslint-plugin-import: 'npm:eslint-plugin-import-x@4.16.2'` (commit `1e4f819a`), then addressed 11 lint findings the stricter `unrs-resolver` surfaced (commits `f38d828b` + `5ea8d7e7`). Same approach applies here.

## Per-action authorization

- Per-action push to `kriscendobot/agoric-sdk` (the fork's `feat/migrate-eslint-plugin-import-x` branch).
- Per-action open of a draft PR on `kriscendobot/agoric-sdk` against its `master`.
- READ-ONLY on `Agoric/agoric-sdk`. **No comment on `Agoric/agoric-sdk#12659`** in this dispatch; the substantive comment will route via the boatman later when the fork-side work is reviewed.

## Task

1. **Read the design + the precedent.** Read kriskowal's diff at `c2200be7` (the current head of the feature branch on Agoric/agoric-sdk, which is also the dispatch's worktree's HEAD). Read the analogous bot-side commits on `endo-but-for-bots#226`: `1e4f819a` (catalog-level aliasing), `f38d828b` (the lint fixes for the stricter resolver), `5ea8d7e7` (yarn.lock churn). The Agoric-side fix follows the same shape.

2. **Inspect the current state.** Does kriskowal's branch already apply the aliasing approach, or does it still use rule-suppression? Run `git diff master..HEAD -- '**/eslint*' '**/package.json' '**/pnpm-lock*' '**/yarn*'` in the worktree to read what changed. If aliasing is already present, the fixer-style cleanups are the only remaining work; if not, apply both the aliasing and the cleanups.

3. **Apply turadg's aliasing.** If not already present, the canonical shape is to alias `eslint-plugin-import` to `eslint-plugin-import-x@^4` at the package-manager level (in agoric-sdk this is `pnpm` per `pnpm-lock.yaml`, not yarn — the syntax for pnpm aliasing differs from yarn's. Verify by looking at the existing `package.json` and `pnpm-workspace.yaml` for the project's conventions). Document the aliasing in a commit message that references turadg's #3255 comment + endo-but-for-bots#226's catalog-level pin.

4. **Apply the stricter-resolver cleanups.** Run `pnpm lint` (or whatever the project's lint command is — `yarn lint`, `pnpm run lint`, etc.) against the rebased branch. The 11 findings on endo-but-for-bots#226 may or may not have analogues here; expect some, address them mechanically. Distinguish PR-introduced issues from pre-existing ones (use `git diff master..HEAD` for the boundary).

5. **Local validation.** All test commands the project uses (`pnpm test`, `yarn workspace ... test`, etc.). Note pre-existing failures; do not silence.

6. **Push to the fork.** `git push origin HEAD:refs/heads/feat/migrate-eslint-plugin-import-x` where `origin` is `kriscendobot/agoric-sdk` (the dispatch worktree's `origin` is the fork bare clone). Force-push only if rebasing; first push is a non-force.

7. **Open the draft PR on `kriscendobot/agoric-sdk`.** Base: `master`. Title mirrors kriskowal's PR title with the substance shift: `chore(eslint-config): alias eslint-plugin-import to import-x@4 (mirror of Agoric/agoric-sdk#12659 + turadg feedback)`. Body cites both #12659 and the turadg pointer + endo-but-for-bots#226's experience. Mark draft per the new PR-creation flow.

8. **Boatman pre-stage**: do NOT open a cross-fork PR on Agoric/agoric-sdk#12659 from this fork branch. The boatman runs that later under the kriskowal identity, after the fork-side panel review + fixer-loop completes.

## Out of scope

- No comment on Agoric/agoric-sdk#12659.
- No un-draft of the fork PR (judge un-drafts after the panel loop terminates).
- No reviewer requested on the fork PR (this is internal-review-first per the new flow).
- No re-render of `journal/projects/agoric-sdk/README.md` — the posture-shift from passive standing watch to active engagement is a separate gardener-track edit.

## Report

≤ 300 words: the fork PR URL, branch head SHA, the aliasing shape applied (pnpm-aliasing vs flat-config plugin map), the lint findings count, CI status if observable, one-line `Self-improvement: ...`.
