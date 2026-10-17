I checked PR #200 for viability, and it can proceed into the gauntlet. It is open, unmerged, still a draft, and nothing newer has displaced it. I spent nothing on clean, panel, fix, CI-wait or un-draft work.

**Deciding question:** Has a newer PR, design or `main` commit already reshaped the settings overlay or added account deletion, so that the premise of #200 (the closed-beta product pass, kriskowal 2026-10-17) no longer holds? **No.**

**Evidence:**
- **The PR:** #200, "feat(shell): three-item settings, Log out only with a recovery bond, account deletion", was opened 2026-10-17T07:38Z, about an hour before this check. Its head is `12d95057`. It has no reviews or comments, so nobody has rejected or redirected it.
- **Its base is current and unmerged:** #200 is stacked on #198 (base `feat/beta-home-splash-waitlist-bbf6c15`, the one landing at `/`). #198 is still OPEN, so the stack is intact.
- **`main` hasn't touched this area:** the newest commit is `bda7739d` (#194 clip-embed headers, 04:54Z). That is about framing clips, not the settings overlay, account deletion, recovery-bond gating or the guest-deletion endpoints.
- **The other open PRs are siblings in the same pass, not replacements:**
  - #199 (guest coupons) is the sibling the PR body names; #200 deliberately codes against a stub until #199 lands.
  - #201 (New Clip / pet-name inventory, opened 08:37Z) touches `shell.js`, `index.html` and the Caddy config, but its feature is the `+` New Clip path. It has no settings or deletion surface, so the most it causes is a later rebase conflict.
  - Nothing newer re-implements the settings view or `DELETE /api/guest`.
- **Its premises still hold:**
  - #199 is unmerged, so the stubbed invitation count is still the correct approach.
  - The production daemon's formula collection (`ENDO_GC`) is still off, which is why the PR keeps a durable deleted-guests list.
  - The chat clip (`mt-beta-chat-clip`), where mail is meant to move, hasn't landed yet.

**Follow-ups for later stages:**
- The PR will need a rebase once #198 merges (its base is the frozen `feat/beta-home-splash-waitlist-bbf6c15`).
- It will probably conflict with #201 in `shell.js`, `index.html` and `minion-town.caddy`.
- Before merge, the maintainer must run `deploy/aws/scripts/deploy-accounts-store.sh` to add the new DynamoDB index (deploy note 1 in the PR).

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr200-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (161485 cached reads)
- Output: 1507 tokens
- Cost: $0.412045
- Wall-clock: 24s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
