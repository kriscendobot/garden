I've retired `claude-endolin2` and the host `endolin-garden2-5bcdff64` from the live budget registries, and the accountant and foreman no longer count them. The journal change landed as `c3e4bf7e5e5` on journal2 and the code change as `8e62adabbbc` on main2. The live config still has the 610M slate; the accountant re-derives it at the 10-17 reset.

**What referenced the retired pool or host (before the change)**
- **Live config:**
  - `config/budget-pools`: the 168M pool row.
  - `config/subscription-mapping`: the monk and gardener rows, plus the `codex-endolin` cleric row for the retired host.
  - `config/worker-leveling`: a `host endolin-garden2-5bcdff64 0 0` row.
  - `worker-derotate/endolin-garden2-5bcdff64`: an offline marker from 10-10.
  - `hosts/endolin-garden2-5bcdff64`: monks 1, clerics 1.
  - `budget/live/claude-endolin2/…` and `budget/live/codex-endolin/endolin-garden2-5bcdff64`: live snapshots, last written 10-10.
- **Tracked defaults:** `scripts/jobs/subscription-mapping.tsv`, `budget-pools-placeholder.tsv`, and the `set-budget-pool.sh` case list.
- **Docs:** `roles/accountant/AGENT.md`, which listed four living subscriptions.
- **Not live config:** reset events, decisions, checkpoints, `fleet/{health,deployed}`, `subscriptions/endolin-garden2-5bcdff64.md`, receipts, entries and panel runs. The leader marker names `endolin-garden-ece02cb4`, and no schedules or claimable jobs are pinned to the host.

**Fail-closed check:** I removed the pool row and all its mapping rows together, so no host is mapped to a missing pool. `codex-endolin` keeps its `endolin-garden-ece02cb4` cleric row. Both living hosts still resolve their subscriptions, and the leveling envelope still fits (ceiling 10, physical capacity 12, 2 hosts).

**What changed**
- **New remover, `scripts/jobs/retire-subscription.sh`, with a test.** No remover existed, so I added one. In one CAS commit it:
  - drops the pool, its mapping rows, and the retired host's mapping, leveling, derotate marker and live-snapshot rows;
  - archives the host to `hosts/.archived-<host>`, the convention rolling-deploy already uses;
  - writes tombstones to a new `config/retired-budget-sources` file.
  
  It refuses an unauthorized request, an orphaned mapping, a living host or shared pool left with no mapping, or a broken leveling envelope. It has a `--dry-run` mode.
- **Tombstones are enforced.** `set-budget-pool.sh` and `set-worker-leveling.sh` now refuse a tombstoned id, so neither can re-add the account or host.
- **Applied live:** run with `--authorized-by kriskowal`, citing the 10-15 muster. History was not touched.
- **Tracked seeds:** endolin2 rows removed. `subscription-budget-model-test.sh` now uses a fixture-only subscription for its pacing coverage.
- **Docs:**
  - `context/operations/cybernetics.md`: a "Retired budget sources" note with the date and reason, saying not to treat the host's silence as an outage.
  - `roles/accountant/AGENT.md`: the living set is now three subscriptions.
  - `context/operations/minion-town-mcp.md`: corrected a stale "endolin-garden2 only" scope line; the config already says `hosts: *`.

**Capacity math against the new registry**
- Living Claude caps are 271M + 180M = 451M.
- The 610M slate came from 90% of (619M Claude + the 60.7M Codex fit) = 611.7M.
- Re-derived the same way: 90% of (451M + 60.7M) = **about 460.5M**, about 150M less. I did not set this; the accountant does at the 10-17 reset.
- `accountant-statement.sh` runs clean against the new registry and lists only `claude-endolin1`, `claude-oros` and `codex-endolin`; it doesn't mention endolin2.
- The re-slice nudge's inputs:
  - `budget_fleet_status` went from `unknown` before the change to `ok` after. The stale peer snapshot from the dead host was what made it `unknown`, which may be the "hiccup".
  - The fleet rate model now covers 3 subscriptions instead of 4; its lower bound is 80.7M tokens/day, down from 102.1M.
- The foreman mandate dry run (`set-apportionment.sh --carry-forward --dry-run`) runs clean but still carries the 610M total until the accountant re-slices.

**Tests**
- **Pass:** retire-subscription (6/6), subscription-budget-model, set-budget-pool-physical-cap, set-worker-leveling-pool-host, proportional-worker-leveling, subscription-used-percent, foreman-provider-order, foreman-decision-log, rolling-deploy, claim-aging-priority, panel-claim-eligibility, token-backoff-ramp.
- **Fail, but also failing without my changes:** live-budget-admission (same 4 failures), worker-derotate (same 1), budget-live-percent-label (same), handler-budget (same 8). accountant-arc-apportionment's one failure ("agent invoked while all held") also appears without my changes, which had 3 more failures.
- **Intermittent:** foreman-brake failed 2 of 3 runs on my branch, passed once, and also failed without my changes with a different message.
- I pushed main2 before checking the handler-budget and percent-label results; I compared them afterwards, as above.

**References to endolin2 I left in place, and why**
- Designs, `docs/reports`, incident comments in `common.sh`, `gardener.sh`, `self-deploy.sh` and `state-clone-keeper.sh`, and the `context/` pages for fireworks, openshell, local-inference, repo-transfer and identity: these record past events.
- Test fixtures that use the host name as an arbitrary id.
- In the journal, these are history and stay: reset events, decisions, `fleet/{health,deployed}` and `subscriptions/…md`.
- These need the accountant or the maintainer, not this job:
  - **Slate:** `config/apportionment` and `config/foreman-mandate` notes still mention endolin2 and the 610M total; the accountant rewrites them at 10-17.
  - **Schedule:** `schedules/reset-credit-watch.md` uses "burn claude-endolin2" as an example phrase.
  - **Inbox notices:** two maintainer inbox notices say the host is offline (`rolling-deploy-host-offline-endolin-garden2-5bcdff64`) and can be dismissed during muster. Archiving the host removes it from the rolling-deploy follower set, so the notice should stop growing.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/retire-claude-endolin2-pool-20261015.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 112 tokens (6622908 cached reads)
- Output: 39175 tokens
- Cost: $3.3053455999999994
- Wall-clock: 2015s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
