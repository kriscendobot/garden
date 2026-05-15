---
ts: 2026-05-15T21:45:30Z
kind: dispatch
role: steward
project: endo-but-for-bots
to: "*"
prs:
  - repo: endojs/endo-but-for-bots
    pr: 265
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/265#issuecomment-4459174573
---

# Dispatch: designer extends endopi comparative analysis to cover `packages/genie` (per jcorbin)

Dispatch root: `dispatches/designer--c7aa08/`. Project worktree on `endojs/endo-but-for-bots@design/endopi`.

## The directive

`jcorbin` commented on PR #265 at 2026-05-15T20:30:01Z (verbatim):

> @kriscendobot you should also take a look at `packages/genie`:
> - it uses the pi-ai library internally, so is perhaps more similar to the Pi cli than is either lal or fae at present
> - wrt endopi-provider-registry-and-oauth (M1) it's got an ollama provider adaptor, and uses pi-ai's provider registry

The endopi design PR #265 is a comparative analysis between Pi cli and endo-side surfaces (currently `lal` and `fae`); jcorbin asks the bot to add `packages/genie` to the comparison because genie uses `pi-ai` internally and ships an ollama provider adaptor (relevant to the M1 milestone for endopi-provider-registry-and-oauth).

The autonomous steward missed the @-mention at 20:30:01Z and treated the IssueCommentEvent as silent; a separate `message`-to-liaison surfaces the discipline gap.

## Per-action authorization

- Edit the existing endopi design files on branch `design/endopi` to incorporate `packages/genie` into the comparative analysis.
- Push the update to the same branch (`design/endopi`), which auto-updates PR #265.
- Optionally reply on PR #265 acknowledging jcorbin's pointer (kriscendobot identity, the bot fork's own repo, so allowed).

## Task

1. Read PR #265's design files (`designs/endopi-*.md`) for the current comparative-analysis structure (which packages are compared, what axes, what gap-closing roadmap).
2. Read `packages/genie/` source: its `pi-ai` usage, the ollama provider adaptor, the provider-registry integration.
3. Add a comparative row for `packages/genie` in the appropriate sections (likely the comparative-analysis table + the M1 milestone discussion).
4. Identify any genie-specific finding that shifts the existing roadmap (e.g., M1 may already be partially satisfied by genie; the design may need to credit genie as prior art).
5. Update the relevant `designs/endopi-*.md` file(s) with the new content. Commit with conventional message.
6. Push to `origin/design/endopi --force-with-lease` (or append if the design's prior commits are clean).
7. Optionally post a brief acknowledgment comment on PR #265 ("expanded the analysis to cover packages/genie per jcorbin's pointer").

## Out of scope

- No edit to `packages/genie/` itself (this is a design analysis, not implementation).
- No re-shaping of the design's high-level structure unless the genie finding genuinely demands it.
- No comments on other PRs.

## Commits

- One or more commits on `design/endopi` (existing branch) with the genie-extension.
- Conventional-commit shape: `design(endopi): include @endo/genie in comparative analysis (per jcorbin review)` or similar.
- Force-with-lease push if appending; or fresh fast-forward push if just adding new commits.

## Report

≤ 500 words. Files touched, the new comparative-row content for genie, whether the roadmap shifted (M1 satisfaction status), the optional ack comment if posted, and one-line `Self-improvement: ...`.
