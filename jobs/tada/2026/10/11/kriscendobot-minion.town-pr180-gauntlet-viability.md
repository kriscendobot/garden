PR #180 can enter the gauntlet: it is open, has not been superseded, and the gap it fills is still listed as unfinished on `main`.

**PR facts:** OPEN and draft. Title: "feat(git-remote): bind partitions into Endo guest inventories". Head is `design/git-remote-endo-binding` @ `1f7f463a`. Base is `main-c7bdf20`, a frozen snapshot of the commit that merged #176. The PR was opened 2026-10-11T03:26Z. It has no reviews or comments yet.

**Deciding question:** Is the live Endo guest-inventory/MCP binding for git-remote partitions (deferred item 2 in `designs/git-remote-capability-increment-1.md`) still missing from current `main`, with no other change implementing it?

**Answer: yes.**

**Evidence:**
- **Base is current:** `main` is 0 commits ahead of `c7bdf201`, so nothing has landed since the PR's base was frozen.
- **Not built on `main`:** `src/endo/git-remote/` on `main` contains only `app`, `capability`, `config`, `git-backend`, `git-http`, `main`, `partition-store` and `projection`. The `control.ts` and `git-caplet.ts` that this PR adds are not there.
- **Design still lists it as deferred:** on `main`, the design says partitions are "not yet a pet-named ocap in the live Endo guest inventory, nor minted/adopted over MCP", and provisioning is still the operator-only path. That is exactly the gap this PR fills.
- **No competing PR:** the other open git-remote PRs are complements, not replacements:
  - #178 adds resource caps (deferred item 3). This PR depends on it, and the dependency is recorded in its evidence ledger.
  - #177 is the served-clip design, which is increment 5.
- **Premise holds:** the git-remote arc was planned on 2026-10-10 (garden commit `6021144b5fb`), and #176 merged its production-validation phase on 2026-10-11, so the motivating need is current.

**Note for later stages:** #180 depends on #178's caps landing first, so it may need re-pinning (a weave) once #178 merges. That is ordering, not a reason to stop.

No changes were made; this stage only gathered evidence.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr180-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (175786 cached reads)
- Output: 1501 tokens
- Cost: $0.4291212
- Wall-clock: 21s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
