# Gauntlet FIX round 1: kriscendobot/minion.town PR #203

I pushed the round-1 fixes, but CI never ran: the job sat queued until the deadline, so the result is **still pending**.

**What I fixed.** Commit `e67a403` on `design/git-remote-s7-bearer-identity-test`, pushed with `safe-push-pr-head.sh`. It changes only `designs/git-remote-capability.md`. It covers every must-fix and should-fix item from the panel-1 review:

- **Owner credential (skeptic, decomplector):** § 7 no longer treats the owner-derived credential as "provisionally" passing. It now says plainly that #180's per-owner HMAC fails the identity test. It requires a random **allocator credential** minted per caplet, revocable per caplet, with the owner kept only as quota attribution. The secrets table row now says this too.
- **Shared read facet (decomplector, ergonomist; critic and skeptic rated it should-fix):** I removed the paragraph that recorded the shared facet as an accepted "known property". § 7 now requires a fresh facet per delegation, each with its own revocation domain and mint budget. It ties this to § 6's revocation promise. Holders can still share a facet, but only by passing the same facet object, so the sharing is explicit.
- **Ownership map (decomplector):** added a four-row boundary table (`minion-mcp` → caplet formula, caplet → listener, listener → store, Endo daemon → caplet) plus the four ownership answers. The orphan case is now covered: a partition created but never retained stays *pending*, counts against quota, and the store reclaims it after a bounded interval (tied to § 12.7). Restart and replay belong to the daemon, and the doc now checks that no inner type is named after an outer lifecycle step.
- **Novice:** a new "control plane these secrets cross" passage now comes before the table. It explains the caplet, the two server processes, the loopback listener, the routes (`/hello`, `create`, `open`, `mint`/`revoke`) and how retention works through the persisted `open` formula.
- **Copyeditor:** rewrote all three sentences as the panel suggested.
- **Pedant:** the new prose adds no em dashes.
- **Gates:** the Botese and orthography greps both report 0 candidates.
- **PR body:** I rewrote the "Status" section so it no longer calls the ruling provisional.

**CI.** `ci-wait-merge.sh` returned rc 4 (still pending) at its deadline. The run for `e67a403` stayed queued from 04:06Z to 05:21Z and never started. This is not specific to this PR: the whole repo's queue is stalled, with 8 runs queued, none in progress, and the oldest dating from about 01:36Z. That points to a runner outage. The `minion-town-ci-runner-switch` skill may be what fixes it. Earlier commits on this PR passed CI, and this change touches docs only.

**Follow-ups:**
- Someone needs to restore the minion.town Actions runners.
- #180 does not yet meet the two new § 7 requirements (random per-caplet allocator credential, per-delegation facets). Its next fix round needs to pick them up. I did not comment on #180.

<!-- gauntlet-stage-result: fix=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr203-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 54 tokens (1847767 cached reads)
- Output: 14379 tokens
- Cost: $1.2251654
- Wall-clock: 4662s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
