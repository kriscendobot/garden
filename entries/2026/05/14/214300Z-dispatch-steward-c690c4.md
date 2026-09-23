---
ts: 2026-05-14T21:43:26Z
kind: dispatch
role: steward
project: endo-but-for-bots
to: "*"
prs:
  - repo: endojs/endo-but-for-bots
    pr: 109
    role: source
---

# Dispatch: fixer cleans up "syrups" → "syrup-frame" rename remnants on PR #109

Dispatch root: `/home/kris/dispatches/fixer--c690c4`.

Trigger: kriskowal at endojs/endo-but-for-bots#109 (2026-05-14T21:42:35Z): "Please search for lingering remnants of the term 'syrups' and replace them with 'syrup-frame'."

The PR previously renamed `@endo/syrups` → `@endo/syrup-frame`; this directive is the follow-up to catch lingering uses (docstrings, comments, identifiers, README, changesets, file headers, etc.).

Per-action authorization: push fixup commits to feat/syrups-package; reply to the directive comment with a summary.

Task: grep the PR's tree for occurrences of "syrups" (case-insensitive) and rename to "syrup-frame" where the rename is appropriate. Be careful to PRESERVE intentional uses: the wire-format name (the  option), the protocol name in design context, references to Syrup the data format. Only rename when "syrups" refers to the PACKAGE or its identifiers.

Hard escalation: more than ~5 files of substantive changes → handoff via message.

NOT in scope: re-request review (maintainer's directive scoped to the rename pass); un-draft.

Report: files touched + SHAs, items intentionally NOT renamed (and why), CI rollup, one-line self-improvement.

Teardown: steward runs `skills/dispatch-worktree/dispatch-teardown.sh "/home/kris/dispatches/fixer--c690c4"` on return.
