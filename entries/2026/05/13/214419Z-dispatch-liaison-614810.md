---
ts: 2026-05-13T21:44:19Z
kind: dispatch
role: liaison
project: cosgov
to: "*"
prs:
  - repo: dcfoundation/cosmos-proposal-builder
    pr: 79
    role: source
---

# Dispatch: builder mirrors cosgov PR #79 in our fork and posts next-steps comment

Dispatch root: `dispatches/builder--cosgov-pr-79-findings--20260513-214347--614810/`. Project worktree at `kriscendobot/cosgov@main`. Fork name is `kriscendobot/cosgov` (short name, not `cosmos-proposal-builder`).

**Per-action authorization (forwarded)**: kriskowal in this session asked to "create a workspace in our fork of cosgov and mirror the PR described in the file cosgov-prompt.md" and "comment on the PR with advised next steps to hand off to the maintainers." Authorizes pushing branches to kriscendobot/cosgov and posting one comment on dcfoundation/cosmos-proposal-builder#79.

## Hand-off source

The detailed task description lives at `/home/kris/cosgov-prompt.md` (NOT in your dispatch root — it is host-level state). Read it as a description of PR #79's current content and the maintainer's findings 1-6 to apply. Note that the prompt was authored for a different agent's filesystem (`/home/kris/cosgov-estimation`) which does not exist in this garden; use our fork's project worktree as your filesystem instead.

## Task

1. Mirror PR #79's current head into our fork:
   - `gh pr view 79 -R dcfoundation/cosmos-proposal-builder --json headRefOid,headRefName,headRepositoryOwner,baseRefName` to confirm the head SHA (was `4c08d9ce740f4b9f9b14c9c79a58e4c8e0900f8c` at dispatch time; verify).
   - Fetch the head into your project worktree from upstream `dcfoundation/cosmos-proposal-builder`. Add upstream as a remote: `git -C project remote add upstream https://github.com/dcfoundation/cosmos-proposal-builder.git && git -C project fetch upstream pull/79/head:pr-79`.
   - Branch off the same merge base in `kriscendobot/cosgov`: `git -C project checkout -b preflight-balance-check-chunked-bundles upstream/main; git -C project merge --ff-only pr-79`. This brings the PR's current content onto a topic branch ready for further edits.

2. Apply findings 1-6 from `/home/kris/cosgov-prompt.md` § "Your task: implement findings 1–6 from the aggregated review". Read each finding carefully; apply edits per the prompt's specification. The prompt authorizes (and asks for) `Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>` in the commit trailer — that is the maintainer's explicit instruction for this dispatch and overrides the garden's default no-Claude-trailer rule for this single engagement. Use it.

3. Run the validations the prompt names: `yarn tsc --noEmit`, `yarn lint`, `yarn test:unit --run`. All must be clean (per the prompt, the 3 pre-existing fast-refresh lint warnings are tolerated).

4. Single commit on `preflight-balance-check-chunked-bundles` with the findings applied. Push to `kriscendobot/cosgov`: `git -C project push origin preflight-balance-check-chunked-bundles:refs/heads/preflight-balance-check-chunked-bundles`.

5. Post one comment on `dcfoundation/cosmos-proposal-builder#79` summarizing the findings as advised next steps for the maintainers. Body:
   - Open: "We applied the following findings against PR #79 in a workspace on `kriscendobot/cosgov` (branch `preflight-balance-check-chunked-bundles`); the diff is at <branch-compare-URL>."
   - Findings as numbered bullets (1-6 from the prompt), framed as suggestions; cite the specific files and line numbers.
   - Out-of-scope items the prompt lists, framed as "we did not pursue these intentionally."
   - Closing one-liner: "Reviewers can pull the branch into a local checkout to evaluate the proposed edits."
   - The comment is one-shot. No follow-up replies in this dispatch.

6. Use `gh pr comment 79 -R dcfoundation/cosmos-proposal-builder --body "$(cat <<'EOF' ... EOF )"`.

## Out of scope

- Do NOT open a PR against dcfoundation/cosmos-proposal-builder. The fork-side branch is the proposal artifact; the comment is the hand-off.
- Do NOT make further comments after the one summary comment.
- Do NOT pursue the prompt's out-of-scope items (BigInt migration, in-flight guard, refetch-in-validateCost, stale-closure mitigation, JSDoc, helper extraction, negative-cost hardening). They are explicitly listed as out of scope in cosgov-prompt.md.
- Do NOT skip hooks, force-push, or otherwise bypass safety. If a hook fails, fix the underlying issue.

## Result entry

`journal/entries/2026/05/13/<HHMMSS>Z-result-builder-<short-id>.md`: branch push SHA, comment URL, which findings landed cleanly, which (if any) needed deviation from the prompt's exact specification (and why), final CI status if you watched it (the prompt says push and watch; if CI runs trigger automatically, capture the run state but don't loop waiting).

## Return

≤ 400 words: branch push SHA, comment URL, per-finding status (applied / deviated / skipped), final yarn-test verdict locally, one-line self-improvement.
