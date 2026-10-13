Round 7 of the review panel on kriscendobot/minion.town PR #180 came back **must-fix**: `panel.sh` exited 0 with that disposition. The verdict is posted on the PR.

**Run:** single-round code panel on head `8dfe189` against `origin/main-c7bdf20`, in an isolated project checkout. My first launch was capped at 10 minutes, too short for a panel, so I stopped it before it posted anything and reran it detached, polling until it finished. All 34 seats returned: 5 request changes, 8 approve, 21 comment-only.

**Blocking findings:**
- **decomplector (the one must-fix):** the panel flagged `createKey`/`createNamed` as a repeat; rounds 5 and 6 both patched it without asking whether it should exist. The seat says to remove it: allocate once with a plain `create()`, store ``E(git).open(`<partitionId>`)`` as the formula, and have `open` check the owner. It also asks to restore the design-doc sentence explaining why this doesn't use the existing `@sites`-style daemon power.
- **saboteur:**
  - The per-owner cap of 256 partitions never releases a slot.
  - Two concurrent `create` calls with the same pet name leave an orphaned partition that still counts against the cap.
  - Every provisioning overwrites a guest's existing `git` pet name.
  - A JSON parse error loses its cause.
- **breaker:**
  - The caplet never checks it is talking to the real control server, so a process squatting on the port could collect owner credentials and facet keys.
  - The same `git` pet-name overwrite.
  - Rotating the secret breaks the guarantee that replaying a formula returns the same partition.
- **engine-realist:** every facet resolution creates a fresh unconfined git caplet and worker.
- **pruner:** the security-model explanation is repeated in about six places, plus duplicate paragraphs in `DEPLOYMENT.md`, the design doc and the config comments.

Round 6's migrator and scribe blockers are resolved; both seats are now comment-only.

**Posted:**
- The review is a COMMENT, not a request-changes review, because GitHub refuses request-changes on the bot's own PR. Rounds 1–6 were posted the same way.
- The 29 comment-only and approve seats went up as two follow-up PR comments (#issuecomment-6140389158 and #issuecomment-6140389666) to stay under GitHub's size limit.

**Follow-ups:**
- The gauntlet had already posted a terminal "review-budget-reached" status after round 6, so this round 7 looks like a re-run. Whoever drives the gauntlet should check whether a fix stage is wanted now.
- Two seats could not do their checks: coverage-auditor found no c8 coverage report, and thesaurus could not fetch the live PR title and body. Both reported this as a comment rather than counting the check as clean.

No garden code changed and nothing was committed.
<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr180-gauntlet-panel-7.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 38 tokens (1042718 cached reads)
- Output: 6315 tokens
- Cost: $0.8460516
- Wall-clock: 1074s

<!-- garden-usage-end -->
