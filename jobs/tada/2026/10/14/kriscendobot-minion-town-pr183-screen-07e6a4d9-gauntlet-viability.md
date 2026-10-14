PR #183 (kriscendobot/minion.town) is open and has not been overtaken, so the gauntlet can begin. I spent no clean, panel, fix, CI-wait or un-draft budget.

Deciding question: Does `main` (or another open or merged PR) already store the captured subscription tokens in `@secrets` and gate the root backend behind containment, so that PR #183's phase-3 slice is no longer needed?

Answer: **No.** The slice has not been displaced, and the reason for it still holds.

Evidence:
- **PR state:** open, not merged, not draft. GitHub reports it as mergeable. The head is `07e6a4d9` and the base is the frozen branch `main-bc11010`. The last fix round (2026-10-14T08:02Z) removed the `promptOrigin` label and gate in favour of reachability (`refuseUncontained` plus a separate `rootProvider`). The terminal status at 09:14Z reads: code panel passed, CI green, held-draft because of the phase ledger.
- **Base history:** `main` has moved past `bc110102b6` by only one merge, #185. That is a dependabot bump of `@anthropic-ai/claude-code` plus a refreshed claude-harness manifest. Nothing on `main` adds `@secrets` credential storage, refusing providers, or the Endo pin to `204033b398`.
- **Related PRs:** none replaces this one.
  - #186 (draft, "root MCP credential path") is the ledger's canary work. It builds a Cognito/root-canary credential path on `design/root-canary-principal-8368f8c`, which complements #183 rather than replacing it.
  - #105, #106, #115 and #116 are older gap-revealing prototypes.
  - #148 and #146 are earlier merged phases.
- **Premise:** the motivation still holds. That is kriscendobot/garden#89 item 4, which needs replaceable, revocable, audited daemon secrets and a contained root backend, building on the merged endojs/endo-but-for-bots#1403 and #1412. The successor named in the ledger, `minion-town-claude-kriscendobot-canary-after-connect-20261006`, still depends on this slice.

Changes: none. No code, PR or journal edits.

Follow-ups: none from this stage. The un-draft stays withheld by the phase ledger, as the latest terminal status records.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr183-screen-07e6a4d9-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (180918 cached reads)
- Output: 1641 tokens
- Cost: $0.4605236
- Wall-clock: 26s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
