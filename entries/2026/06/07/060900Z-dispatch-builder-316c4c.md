---
ts: 2026-06-07T06:09:00Z
kind: dispatch
role: steward
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: builder
dispatch_root: /home/kris/dispatches/builder--316c4c
refs:
  - entries/2026/06/07/060700Z-dispatch-researcher-df145e.md
  - entries/2026/06/07/060236Z-result-researcher-df145e.md
  - https://github.com/endojs/endo/pull/3226
  - https://github.com/endojs/endo-but-for-bots/pull/57
---

# dispatch: builder — duplicate endo#3226 onto bot llm branch

User directive (2026-06-07): *"Please create a duplicate of
https://github.com/endojs/endo/pull/3226 except based on the llm
branch."*

The bot fork already carries a master-based mirror at PR #57
(`kriskowal-marshal-binary`); this dispatch opens a parallel
duplicate against `llm`.

## State at dispatch time

- **Upstream PR `endo#3226`**: `feat(marshal,pass-style): admit
  immutable ArrayBuffer through codecs`, branch
  `kriskowal-marshal-binary`, head `abc1010` (a fixup-squash atop
  feat commit `0b55322`). 16 files. Updated 2026-05-12.
- **Bot fork PR #57**: master-base mirror, same branch name
  `kriskowal-marshal-binary`. Carries content updates beyond the
  upstream original (judge followup, b0b5cafe docs hex fix). Per
  the researcher: substance-level updates travel to the duplicate;
  PR-shell-level items stay behind.
- **Bot llm tip**: `2bd9e0cb` (current `origin/llm`).

## Library and project references

(Inlined verbatim from researcher `df145e`'s
`## Library and project references` section per the steward role's
researcher-precedence rule.)

### Project context (endo-but-for-bots)

- [`journal/projects/endo-but-for-bots/README.md`](../../projects/endo-but-for-bots/README.md) § *Rules of engagement* — the canonical convention names `llm` as the **designs** branch and `master` as the **implementations** branch. The example `#232` (Node-18-drop **design** on llm) / `#246` (Node-18-drop **master-base** mirror) is the reverse shape from this dispatch. Duplicating a master-shape source PR onto `llm` is unusual; the maintainer's directive overrides the convention for this duplicate's roadmap-visibility purpose. **Title and body must explicitly label "llm-base mirror of #57" to surface the intent.**
- [`journal/projects/endo-but-for-bots/README.md`](../../projects/endo-but-for-bots/README.md) § *Standing authorizations* — repo-scoped relaxation. The builder may post the PR body, comments, cross-refs on this repo without per-action authorization in the dispatch.
- [`journal/projects/endo-but-for-bots/README.md`](../../projects/endo-but-for-bots/README.md) § *Authority structure* — every commenter on this repo is maintainer-equivalent. Relevant when the duplicate draws a review.

### Past mirror precedents

- The **inverse-direction** mirror at `#126` (llm-base, ci-no-npm-lifecycle) → `#250` (master-base mirror, branch `ci/no-npm-lifecycle-master`). The naming convention `ci: <topic> (master-base mirror of #126)` lands the cross-reference in the title; invert to `<topic> (llm-base mirror of #57)` for this dispatch.
- **`#56` was withdrawn 2026-05-06**. It was the prior llm-side sibling of `#57` (`feat(marshal): admit immutable ArrayBuffer through codecs`, base `design/endo-xorshift`). The journal does not record the reason ("withdrawn by maintainer"). **The PR body should explicitly note the prior-withdrawn context** so the maintainer can speak to whether they want this new duplicate kept or withdrawn — surface, do not silently re-introduce.

### Master-into-llm sync precedents whose conflict surface may overlap

- The recurring `packages/marshal/*` + `packages/pass-style/*` paths are exactly where master-into-llm syncs hit drift. The duplicate's cherry-pick may face llm-side divergences (recent llm merges, eslint-plugin-import-x partial revert, `ocapn-default-cbor`/`makeClient`/`registerNetlayer` API drift).
- The 2026-05-21 weaver on `#57` added `chore: regenerate composite tsconfig files` to satisfy the `Check composite tsconfig files are up to date` lint gate. **Run `node scripts/generate-composite-tsconfigs.mjs --check` on the duplicate's tree and add the same chase commit if the gate is present on `llm`.**

### PR-shape conventions on llm-targeting PRs

- [`garden/skills/frozen-base-branch/SKILL.md`](../../../garden/skills/frozen-base-branch/SKILL.md) — every fork-side PR uses a frozen base named `<base>-<7-char-short-sha>`. **Use `llm-2bd9e0c`** as the frozen base for this duplicate. Non-negotiable.
- [`garden/skills/pr-formation/SKILL.md`](../../../garden/skills/pr-formation/SKILL.md) — title carries the conventional-commit prefix; body fetches the `llm`-branch PR template; behavior-over-diff; no checklists; no methodology leak.
- [`garden/skills/pre-pr-checklist/SKILL.md`](../../../garden/skills/pre-pr-checklist/SKILL.md) and [`garden/skills/pre-push-gates/SKILL.md`](../../../garden/skills/pre-push-gates/SKILL.md) — pre-existing branch-state findings from `#57` (yarn format, em-dashes, filename-no-stutter, SECURITY.md hash divergence, etc.) will be inherited on cherry-pick. **Surface in the result rather than chasing under the duplicate's banner.**
- [`garden/skills/pr-creation-flow/SKILL.md`](../../../garden/skills/pr-creation-flow/SKILL.md) — opens DRAFT per the standard flow.

### PR #57's content trail — what travels and what stays behind

- **Travels**: the upstream substance (the 16 files of the codec admission), plus the bot-side substantive fixes (the b0b5cafe positive-hex example in `packages/marshal/docs/smallcaps-cheatsheet.md:13`), plus any judge-recommended substance fixes that are not PR-shell.
- **Stays behind**: pruner's "PR-body Documentation Considerations mild padding" item is specific to `#57`'s body; migrator's "Agoric-SDK release-notes mention" is tied to whichever single PR actually lands. The duplicate's body fresh-writes.

### Upstream provenance

- The companion ferry of `#73` → `endojs/endo#3265` named `endojs/endo#3226` as the codec-admission upstream PR. **Cite `endojs/endo#3226` as the upstream reference and bot fork's `#57` as the master-base sibling** in the duplicate's body.

## Task

In your `project/` worktree (currently at `origin/llm` tip
`2bd9e0cb`):

1. **Add the upstream remote** (idempotent):
   `git remote add endo-upstream https://github.com/endojs/endo.git`.
2. **Fetch upstream's PR branch**:
   `git fetch endo-upstream kriskowal-marshal-binary`. Confirm tip
   = `abc1010` (or its current value).
3. **Create the frozen base branch** for the duplicate:
   `git checkout -b llm-2bd9e0c origin/llm`. Push it:
   `git push origin HEAD:llm-2bd9e0c`. This is the frozen-base
   snapshot the duplicate's PR will target.
4. **Create the duplicate head branch** off the frozen base:
   `git checkout -b kriskowal-marshal-binary-llm llm-2bd9e0c`.
5. **Cherry-pick the upstream PR's commits onto the head branch**:
   `git cherry-pick 0b55322 abc1010` (or
   `git cherry-pick endo-upstream/kriskowal-marshal-binary` for
   range form). Resolve conflicts per
   [`skills/conflict-resolution/SKILL.md`](../../skills/conflict-resolution/SKILL.md).
   Expected conflict surface: `packages/marshal/*`,
   `packages/pass-style/*`, possibly changeset + yarn.lock.
6. **Apply the b0b5cafe fix** (positive-hex example) on top:
   read `packages/marshal/docs/smallcaps-cheatsheet.md:13` and
   replace any `0xdeadbeef`/`0xcafebabe`-style example with
   `*b0b5cafe`. Standalone commit.
7. **Composite-tsconfig check**: run
   `node scripts/generate-composite-tsconfigs.mjs --check`. If the
   check fails, add a `chore: regenerate composite tsconfig files`
   commit per the 2026-05-21 precedent.
8. **Pre-push gates**: run `corepack yarn pre-push --summary` (or
   whatever the canonical invocation is) and record any pre-existing
   findings in the result. Do NOT chase them under the duplicate's
   banner.
9. **Push** the duplicate head:
   `git push origin HEAD:kriskowal-marshal-binary-llm`.
10. **Open the PR DRAFT**:
    ```
    gh pr create -R endojs/endo-but-for-bots \
      --base llm-2bd9e0c \
      --head kriskowal-marshal-binary-llm \
      --draft \
      --title "feat(marshal,pass-style): admit immutable ArrayBuffer through codecs (llm-base mirror of #57)" \
      --body <body>
    ```
    Body should:
    - One-line statement of intent: roadmap-visibility duplicate
      of PR #57 on `llm`.
    - Cite upstream `endojs/endo#3226` as the original.
    - Cite bot fork `#57` as the master-base sibling.
    - **Note the prior-withdrawn `#56`** so the maintainer can
      speak to whether to keep this duplicate or withdraw.
    - Per `pr-formation/SKILL.md` § Behavior-over-diff: describe
      the substance (immutable ArrayBuffer admitted through
      smallcaps + ocapn-CBOR codecs) without diff numerology.
    - Note any conflict resolutions taken on the cherry-pick.

## Authorizations (per-action, forwarded by steward)

- **Push** the frozen-base branch `llm-2bd9e0c`, the head branch
  `kriskowal-marshal-binary-llm`. Implicit.
- **Open the DRAFT PR**. Implicit.
- **Post the draft-PR body** (`endo-but-for-bots` standing broad-
  comment authorization).

## Out of scope

- Do NOT shepherd CI to green.
- Do NOT chase pre-existing branch-state findings under this PR's
  banner.
- Do NOT silently re-introduce content the panel/judge already
  flagged on `#57` as PR-shell padding (pruner's item, etc.).

## Deliverable

A `result` entry under `journal/entries/2026/06/07/` naming:

- The frozen-base branch name + SHA, the duplicate head branch
  name + SHA, the opened PR number + URL.
- File-by-file conflict-resolution notes for the cherry-pick.
- Whether the composite-tsconfig chase commit was needed.
- Pre-existing branch-state findings the duplicate inherited
  (surface, do not chase).
- A `Self-improvement: ...` line.

End your turn with a concise summary back to the orchestrator. The
orchestrator tears down your dispatch root on return.
