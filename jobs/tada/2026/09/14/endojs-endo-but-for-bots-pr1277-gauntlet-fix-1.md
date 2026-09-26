CI is terminal and GREEN. All checks completed, my fix commit (3dbce00bd) is the head, and every non-skipped check succeeded. The fix stage is done.

## Completion report

**FIX round 1 — endojs/endo-but-for-bots PR #1277** ("design: invitation retention labels and pin lifecycle") — a docs-only design PR (`designs/daemon-retention-labels.md`, `designs/README.md`).

Applied the panel-1 must-fix/should-fix items in one commit (`3dbce00bd`), pushed as a review-feedback follow-up to the PR head via `safe-push-pr-head.sh`:

- **inviter definition** (copyeditor): defined *inviter* = the accepting host at first use.
- **worked encoding example** (novice): added a before/after of PR #1125's pin-key encoding — single-segment keeps exact `guest-<name>`, multi-segment is length-prefixed (`team-a/bob` → `guest-6_team-a3_bob`), with a hyphen-collision injectivity demo. Verified the scheme against #1125's actual code (`segment.length + '_' + segment`).
- **unsettled #1125 dependency** (skeptic, critic): noted #1125 is an unmerged draft, named the Phase 1/2 re-verification step, and explained why Invariants 1–3 survive an encoding revision.
- **atomic compare-and-remove primitive** (skeptic): named the guarded single-statement `DELETE … WHERE name = ? AND formula_id = ?` with a rows-affected check in the prune surface; cross-referenced from Invariant 5.
- **facet `help()` + error-idiom** (ergonomist): added `help()` to `InvitationRetentionPins`; explained the tri-state return vs sibling throw deviation.
- **Phase 3 stacking risk** (critic): flagged the stalled retention-paths #284 dependency and gave the ship-Phases-1/2/4-independently contingency.
- **jargon/ordering** (copyeditor, novice): defined *transient pin*, *legacy guest*, and the `-from-<handle-number>` suffix; reordered `assertPetName` before formulate/store; made "is rejected synchronously" passive; named the rejected general durable-Set alternative up front.
- **em-dash sentinel** (pedant): fixed the `designs/README.md` status-table cell (`-` → `—`). Also verified I introduced no prose em-dashes (used parentheses/periods instead).

Committed only the two design files with explicit pathspecs (left an unrelated yarn-install `packages/floot/package.json` normalization artifact uncommitted).

CI terminal and GREEN: `lint` and `zizmor` pass, all other jobs skip via docs path filters, 0 non-completed checks. Did not re-run the panel (the driver re-posts panel-2).

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1277-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 1 host(s)
- Input: 98 tokens (3590914 cached reads)
- Output: 23471 tokens
- Cost: $3.2761650000000007
- Wall-clock: 487s
- Model(s): claude-opus-4-8 ×3

<!-- garden-usage-end -->
