Roster and lifecycle audit for completion-press tick 20261013-080506 (issue #89). This was evidence-only: I made no board, schedule, inbox, journal or git-push changes, and sent no messages.

**Source**
- Fresh `origin/journal2` = `58d8b62dedb2bb40847f0cf131b37bce246163e1` (commit time 2026-10-13T15:44:48Z), fetched at 15:45:06Z with `GARDEN_FETCH_MAX_AGE_OVERRIDE=0 git fetch origin journal2` from this job's worktree.
- I built the roster with the deterministic wrapper, which applies all three parent-spec selector rules. I did not rebuild it by hand. Two runs:
  - **Tick window** (W1: 01:50:07Z → 08:05:06Z): `scripts/jobs/claude-on-minion-town-completion-report.sh --since 2026-10-13T01:50:07Z --until 2026-10-13T08:05:06Z --repo $PWD --ref 58d8b62d…`. The start is the dispatch of the preceding tick, `claude-on-minion-town-completion-press-20261013-015007`. The script compared against prior ref `1f526ec74e9c`.
  - **Since the tick, to now** (W2: 08:05:06Z → 15:45:06Z): same command with those dates. Prior ref was `af319386604a`.
- I added these by hand: `git show`/`git log` on `jobs/{todo,doin,plan,orch,gauntlet,tada}`, `work/<base>`, `fleet/health/<host>`, `hosts/<host>`, `inbox/maintainer/unread/*`, and `schedules/claude-on-minion-town-{completion-,}press.md`. The completion-press schedule's `last_dispatched` is already 14:05:06Z, so tick 140506 has also run.

**Counts (from the script)**
| | W1 | W2 |
|---|---|---|
| Roster | 625 | 611 |
| tada | 606 | 594 |
| plan | 11 | 8 |
| todo | 3 | 4 |
| doin | 3 | 3 |
| orch | 1 | 1 |
| gauntlet | 1 | 1 |
| Claims | 9 | 20 |
| Completions | 6 | 15 |
| New dooms | 0 | 2 |
| Stalled claims | 0 | 2 |
| `absent_prior_roster` | 0 | 0 |

No completion in either window has `orchestration_failed: true`. No roster job vanished.

**Every job not in tada, at HEAD**
- **orch:**
  - `claude-on-minion-town-completion-press-20261013-080506-split`: serial, halt policy, running.
- **doin:**
  - `…-080506-roster-audit`: this job (endolin monk-1, claimed 15:44:23Z).
  - `claude-on-minion-town-press-20261013-102024`: oros monk-4, claimed 12:21:32Z.
  - `claude-on-minion-town-press-carry-20261013`: oros monk-6, claimed 14:15:49Z.
- **plan:**
  - `…-080506-integrity-audit` and `…-080506-publish`: orchestrated children, waiting their turn.
  - `claude-on-minion-town-press-20261010-133536`: doomed and carried over from earlier (`requeue-exhausted`, `doomed_on: endolin-garden-ece02cb4`, 2026-10-11T09:03:12Z, `requeue_cycles: 2`).
  - `claude-on-minion-town-press-unblocks-20261013`
  - `evaluate-reauth-escalation-default-after-oauth-relay-20260927`
  - `minion-town-claude-cli-production-canary-after-connection-20261004`
  - `minion-town-claude-kriscendobot-canary-after-connect-20261006`
  - `minion-town-public-browser-caddy-gate-smoke-after-mfa-20261006`
- **gauntlet:**
  - `kriscendobot-minion.town-pr167-gauntlet-20261013`: an active control record, so this is a location, not a disappearance.
- **todo:**
  - `kriscendobot-minion.town-pr167-gauntlet-20261013-clean`: retried at 13:26:13Z; `handler-timeout: 7200`.
  - `minion-town-arc-press-20261013-090507`, `-120507` and `-152006`.

**Completions**
- **W1:**
  - `claude-on-minion-town-completion-press-20261013-015007` (02:14:39Z)
  - `kriscendobot-minion.town-pr183-gauntlet-panel-3` (03:57Z)
  - `minion-town-arc-press-20261013-030506` (04:01Z)
  - `…pr183-gauntlet-fix-3` (05:22Z)
  - `…pr183-gauntlet-panel-4` (05:42Z)
  - `…pr183-gauntlet-fix-4` (06:57Z)
- **W2:**
  - `…pr183-gauntlet-panel-5` (08:23Z)
  - `claude-on-minion-town-press-20261013-042006` (09:13Z)
  - `revise-minion-town-pr167-root-canary-answers` (10:19Z)
  - `…pr167-gauntlet-20261013-viability` (10:51Z)
  - `…pr183-gauntlet-fix-5` (10:58Z)
  - `claude-on-minion-town-press-20261013-072006` (11:07Z)
  - `claude-on-minion-town-press-audit-20261013` (11:41Z)
  - `claude-on-minion-town-completion-press-20261013-080506` (12:47:19Z; this tick, completed by splitting into the orchestration above)
  - `minion-town-arc-press-20261013-060506` (14:01Z)
  - `claude-on-minion-town-press-20261013-072006-split` (14:57Z)
  - `…pr183-gauntlet-panel-6` (15:04Z)
  - `claude-on-minion-town-completion-press-20261013-140506` (15:07Z)
  - `claude-on-minion-town-press-20261013-133505` (15:10Z)
  - `…pr183-gauntlet-fix-6` (15:27Z)
  - `kriscendobot-minion.town-pr183-gauntlet` (15:29Z; the whole PR 183 gauntlet finished)

**Repeated claim/requeue cycles in W2**
- **`…completion-press-20261013-080506`:** claimed 08:56:15Z and overran its handler deadline (hint at 12:41:02Z from oros). It was reaped at 12:43:32Z, re-claimed at 12:44:02Z by endolin cleric-1, and completed at 12:47:19Z by splitting. That is 2 claims.
- **`revise-minion-town-pr167-root-canary-answers`:** claimed at 09:10:01Z and again at 09:53:47Z, then completed.
- **`…pr183-gauntlet-panel-6`:** oros monk-6 claimed it at 12:10:52Z. Oros flagged a "transient handler kill" at 12:51:42Z and it was doomed `requeue-exhausted` (`doomed_on: endolin-garden-ece02cb4`) at 12:53:30Z. The gauntlet retried the stage at 12:56Z; endolin claimed it at 15:01Z and it completed at 15:04Z. The doom is resolved.
- **`…pr167-gauntlet-20261013-clean`:** oros monk-3 claimed it at 12:15:36Z. Oros flagged a "transient handler kill" at 13:17:28Z and it was doomed `requeue-exhausted` (`doomed_on: endolin-garden-ece02cb4`) at 13:23:31Z. The gauntlet retried it at 13:26:13Z and it has sat unclaimed in todo since (about 2h19m). The todo file at HEAD carries no `doom_*` fields.
- **`…pr181-gauntlet-fix-6`:** oros monk-1 claimed it at 12:30:47Z; endolin re-claimed it at 15:27:53Z and finished at 15:44:13Z. The script did not include it in the roster.

**Dooms**
- Only two are current (carried, not new):
  - `claude-on-minion-town-press-20261010-133536` (above).
  - `kriscendobot-minion.town-pr181-gauntlet-fix-5`: `requeue-exhausted`, `doomed_on: endolin-garden-ece02cb4`, 01:33:09Z, `requeue_cycles: 1`.
- The two new dooms in W2 (panel-6 and pr167-clean, above) are both `requeue-exhausted`.
- **No `policy-refusal` doom exists anywhere in the roster.** That string only appears as wording in the press-spec bodies of every completion-press job, which is spec text, not a doom signature.

**Board anomaly**
- `kriscendobot-minion.town-pr181-gauntlet-fix-5` exists twice: in `jobs/plan/` (doomed at 01:33:09Z) and in `jobs/tada/2026/10/13/`. The original oros claimant (gardener-2) completed it at 01:45:30Z, 12 minutes after the reaper doomed it, and the plan copy was never removed.
- It looks like a reap/complete race. The publisher should flag it; I did not touch it.

**Stalled claims (handler budget 2400s; the script reports `requeue_cycles: 0` for both)**
- **`claude-on-minion-town-press-20261013-102024`** (oros monk-4): 12214s old, 9814s overdue, about 5× budget. Deadline checkpoint and nudge messages are sitting unread in its inbox.
- **`claude-on-minion-town-press-carry-20261013`** (oros monk-6): 5357s old, 2957s overdue. The `…-072006-split` orchestration already raised `orchestration-child-timeout` to the maintainer at 14:57Z (`handler-timeout`, halt policy). Yet `…-072006-split` shows as tada at 14:57:17Z. **Unknown:** whether the halt closed the orchestration while its child still runs.
- Neither is on a second or later requeue cycle. The only jobs that reached cycle 2 recovered (080506) or are carried (133536).

**Claimable arc work while workers sit idle: likely yes, but not proven**
- **Waiting in todo:** `pr167-gauntlet-20261013-clean` since 13:26Z, and `minion-town-arc-press-20261013-090507` since 09:05Z (6h40m) plus `-120507`.
- **Endolin:** 1 monk and 1 cleric; its monk has been continuously busy.
- **endolin-garden2:** 1 monk, 1 cleric; health last written 2026-10-09; no claims seen in W2.
- **Oros:** declares 8 monks, but HEAD shows only four of its claims: monk-4, monk-6, monk-3 (`pr184-gauntlet-panel-5`, since 13:31Z) and monk-7 (`oros-health-checkup-20261013-102024`, since 11:56Z, the long job blocking oros's deploy).
  - Oros's last claim was 14:27:48Z, about 77 minutes before HEAD.
  - Oros is impaired. A 10:36Z maintainer message says its sysop bridge is unreachable. Its deploy is deferred (it runs `bdc2943c`; target is `8fd22da4`), and two `oros-health-checkup` jobs sit in todo.
  - So idle oros monk slots are probable, but the cause is host impairment, not lack of work. I cannot prove from journal state alone whether the slots are idle or wedged.

**Ambiguities for the publisher**
1. The `minion-town-arc-press-*` jobs are the issue-58 supervisor press. They enter the roster through rule 3 because their bodies contain the issue-89 URL.
2. PR 181's gauntlet jobs drift in and out of the roster: fix-5 is listed in W1, but fix-6 never is.
3. The two windows give different roster sizes (625 vs 611) because each compares against a different prior ref.
4. Oros worker state is inferred from claim records only; there is no per-worker heartbeat on journal2.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/claude-on-minion-town-completion-press-20261013-080506-roster-audit.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 40 tokens (1382555 cached reads)
- Output: 13502 tokens
- Cost: $1.2096550000000001
- Wall-clock: 204s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
