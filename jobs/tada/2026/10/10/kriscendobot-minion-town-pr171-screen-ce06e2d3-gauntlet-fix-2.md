I applied round 2's must-fix items for kriscendobot/minion.town#171 and pushed them, and CI is green on the new head `acd28fc`.

The latest verdict for this gauntlet (round 2, head `0d30097`) had three seats asking for changes: archivist, integrator and pruner.

**What changed**
- **archivist:** `DEPLOYMENT.md` now lists the protected directories as full paths (`/opt/minion-town/bin`, `/opt/minion-town/share`, `/opt/minion-town/share/minion-town`), matching the observer code. This is commit `acd28fc` ("docs(probe): spell out the protected directories as absolute paths"), pushed with `safe-push-pr-head.sh` (`0d30097..acd28fc`, no rewind).
- **integrator, missing ledger and false "ready" claim:** I rewrote the PR body with a "Status: draft, not the deliverable" section and a `## Phase and evidence ledger` block. The ledger marks the code phase satisfied and lists provisioning, the `prod-probe` environment, the role ARN check, the merge after #166, the first live run and acceptance as not done. It sets `Disposition: orchestrated-slice` and `Successor: minion-town-arc-press-20261010-062006`, the standing minion.town arc supervisor job that carries this PR. I also converted the PR back to draft (`gh pr ready --undo`).
- **integrator, unreconciled stack:** the body now names #166 as a blocking predecessor (still draft, head moved to `86ea2d7`, must be woven onto before merge). It also states #167's state (draft design) and drops the head-branch `blob/` links, which would go stale after merge.
- **pruner:** I removed the "Least privilege" pointer section. The "Probe Trust Names" list and the `src/harness.test.ts` comments the pruner cited don't exist on this PR, so there was nothing to cut there.

**CI:** `ci-wait-merge.sh` failed every tick with "gh pr view … failed". This is the known gap on this host: the bot token can't read PR check statuses. The script then ran into the background time limit and was stopped, so it never returned a result code. Instead I read the Actions runs API for `acd28fc`: the only workflow, "test (typecheck + vitest)", completed with success. That is the same set of runs as the previous head.

**Follow-ups**
- **The ledger doesn't stop the un-draft.** `phase-evidence-gate.sh` only acts when a `designs/*.md` file is referenced or changed, and this PR has none, so it returns `clear`. The gauntlet's final un-draft stage will mark the PR ready again unless someone holds it. The arc supervisor, or whoever else, needs to keep it draft until #166 lands and the first live run passes.
- **Inbox not read:** the journal clone timed out, so I couldn't check my inbox this run.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr171-screen-ce06e2d3-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 64 tokens (2306918 cached reads)
- Output: 11565 tokens
- Cost: $1.3576996000000001
- Wall-clock: 1291s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
