---
ts: 2026-05-14T01:01:55Z
kind: result
role: steward
project: endo-but-for-bots
to: "*"
refs:
  - entries/2026/05/14/003700Z-dispatch-steward-41ae71.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 228
    role: source
---

# Conductor stalled on OAuth scope; maintainer merged manually; #228 landed at `243e2328`

## Conductor result

The conductor dispatch (`003700Z-dispatch-steward-41ae71.md`) returned `STALLED` — not because the PR wasn't ready, but because the `kriscendobot` OAuth token lacks the `workflow` scope and PR #228 modifies `.github/workflows/ci.yml`. GitHub's GraphQL `mergePullRequest` refused with:

> refusing to allow an OAuth App to create or update workflow `.github/workflows/ci.yml` without `workflow` scope

The conductor verified everything else cleanly (APPROVED, MERGEABLE, CLEAN, 28/28 SUCCESS) before hitting the credential block. Subagent's report at `entries/2026/05/14/003904Z-result-conductor-af3cbc.md`; companion message-to-liaison at `entries/2026/05/14/003904Z-message-conductor-f3c1cc.md` with the two unstick options.

## Maintainer unstick

kriskowal exercised unstick option 1 (manual merge under their own credentials). PR #228 merged at `243e2328349649a8e3a347639f857e6fc08c2c021`, and then ferried upstream as `endojs/endo#3258` (filtered to the three divergent packages). The maintainer also ferried `#223` upstream as `endojs/endo#3257`.

## Dispatch root teardown

Done.

## Standing issue: bot needs `workflow` scope or a permanent unstick path

The stall is class-wide: any future PR that touches `.github/workflows/*` cannot be conductor-merged under the current bot credentials. The conductor subagent's unstick option 2 (grant `workflow` scope to the OAuth token) is the durable fix; option 1 (maintainer merges manually) is the per-instance workaround.

This is already routed to liaison via the conductor's own `message`. The steward will not duplicate.

## Self-improvement

The conductor role's *Loop* step 5 reject-stall list does not yet name the OAuth-`workflow`-scope class of refusal (the subagent noted this). Worth a one-line addition next time the gardener edits `roles/conductor/AGENT.md`. Not duplicating the routing; the conductor's own self-improvement note carries it.

The steward also observes: when the bot's credentials can't complete a merge and the maintainer steps in manually, the steward's bulletin and journal should still record the outcome — the daemon's `PullRequestEvent/merged` notification (which fired here at 00:46:03) is the trigger to write a result entry and clear bulletin tracking. No rule change needed; observation only.

Self-improvement: nothing for the role file this cycle.
