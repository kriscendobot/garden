I've routed kriskowal's "weave and send back to the ferry" on PR #1349 into a two-step orchestration on the board. Neither step has run yet.

**Preflight:** `pr-feedback-preflight.sh` exited 0, meaning no other gardener had already handled this comment.

**Why this weave isn't another no-op:** the 2026-10-25 weave (`endojs-endo-but-for-bots-pr1349-weave`) found nothing to do. The fork's `master` is stuck at `6ee3fda`, the same commit as the PR's base `master-6ee3fda`. The ferry target is upstream `endojs/endo` `master`, which is now at `ebc7904d87b1`, and the fork already has a frozen copy of it as `master-ebc7904`. So the weave job is told to rebase onto that upstream tip.

**Posted:** orchestration `endojs-endo-but-for-bots-pr1349-weave-ferry-20261027` (serial; it halts if a step fails). Both steps are parked in `jobs/plan/` and only the orchestrate watcher promotes them:
1. **`endojs-endo-but-for-bots-pr1349-weave-20261027`** (weaver):
   - Check that `master-ebc7904` still matches upstream master; if upstream has moved, snapshot the new tip.
   - Rebase the head, resolve conflicts, force-push, and move the PR's base field to the new snapshot.
   - Get CI green at the new head, then post one summary comment on the PR.
2. **`endojs-endo-but-for-bots-pr1349-ferry-restage-20261027`** (gardener):
   - Update the ferry directive that's already staged at `jobs/ferry/endojs-endo-but-for-bots-pr1349.md` with the new base and head.
   - Mark its earlier preconditions satisfied: `...-fix-maintainer-findings-20261027` is in `tada/`, and the changeset correction landed as `91cca8a551`.
   - Add this comment to the directive's authorization record. It keeps the existing `identity_switch_authorized` value and doesn't create a new one.
   - Require green CI at the rebased head; if it isn't green, stop with a blocked report instead of marking the ferry ready.
   - Reply on the PR telling the maintainer to run `scripts/ferry.sh` on the credentialed host.

**Note:** to confirm the orchestration landed, I ran one read-only `git fetch` and `git show` inside the `journal/` worktree under the garden root. Nothing was changed there.

**Follow-up:** after step 2 finishes, the maintainer runs `scripts/ferry.sh` on the credentialed host.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1349-0282c446.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 24 tokens (683853 cached reads)
- Output: 5554 tokens
- Cost: $0.7069946
- Wall-clock: 79s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
