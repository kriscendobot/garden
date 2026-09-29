---
created: 2026-09-28
updated: 2026-09-28
author: gardener
---

# Garden systemd units

This is the complete operator inventory for the user units shipped in
`scripts/systemd/` and the worker units rendered by
`scripts/jobs/install-units.sh`. The facts below come from those unit files,
their `ExecStart` scripts, `scripts/jobs/common.sh`, and the installer's enable
policy. The units run under `systemd --user`, not the system manager.

## Summary

"Leader" means an `ExecCondition=scripts/jobs/is-main-host.sh` gate unless the
row says "in-loop". "Host" means every host. Template instance names use the
systemd `%i` value described in the detailed entry.

| Unit family | Cadence or lifetime | Scope | Purpose |
| --- | --- | --- | --- |
| `garden-worker@` -> `garden-{monk,cleric,...}@` | long-running, per numbered slot | host | Claim and execute jobs with one of nine worker kinds. |
| `garden-gardener-scaler` | 1 minute after the prior run | host | Reconcile local worker instances to the journal host record. |
| `garden-foreman` | every 5 minutes at `:04` | leader | Keep the active board at its target. |
| `garden-budget-refresh` | every 5 minutes at `:02` | leader | Release budget-held plans after quota refresh. |
| `garden-reputation-reducer` | every 5 minutes at `:02` | leader | Reduce worker outcomes into reputation projections. |
| `garden-triager@` | 30 seconds after boot, then 2 minutes | leader | Turn watched repository changes into jobs. |
| `garden-comment-watcher@` | 30 seconds after boot, then 90 seconds | leader | Interpret authorized PR and issue comments. |
| `garden-ci-watcher@` | 45 seconds after boot, then 90 seconds | leader | Post shepherd work for red CI. |
| `garden-dependabot-watcher@` | 90 seconds after boot, then 5 minutes | leader | Post botanist work for new Dependabot PRs. |
| `garden-approval-reconciler@` | 2 minutes after boot, then 15 minutes | leader | Recover missed approved-PR finalization work. |
| `garden-receipt-watcher@` | 90 seconds after boot, then 5 minutes | leader | Generate receipts for terminal garden-worked PRs. |
| `garden-repo-watcher` | 1 minute after the prior run | host | Reconcile all per-repository watcher instances. |
| `garden-mention-watcher` | 90 seconds after the prior run | leader | Watch trusted GitHub-wide bot mentions; manually armed. |
| `garden-issue-inbox` | 45 seconds after boot, then 2 minutes | leader | Route garden-repository issues into jobs or the maintainer inbox. |
| `garden-pages-watcher` | 50 seconds after boot, then 2 minutes | leader | Post a pages-shepherd when Garden Pages fails. |
| `garden-comment-latency-watch` | 6 minutes after boot, then 5 minutes | leader | Check watcher liveness and acknowledgment latency. |
| `garden-design-pr-gauntlet-audit` | hourly at `:37` | leader | Alert on open non-draft bot PRs lacking gauntlet coverage. |
| `garden-requirements-watch` | every 5 minutes at `:02` | leader by unit condition | Alert on capability-gated jobs that remain unclaimed. |
| `garden-orchestrate` | every 3 minutes at `:01` | leader | Advance declared multi-job orchestrations. |
| `garden-gauntlet` | every 3 minutes at `:02` | leader | Advance staged PR gauntlets. |
| `garden-follow-up` | every 10 minutes at `:08` | leader | Turn completion-report follow-ups into durable actions. |
| `garden-scheduler` | every 15 minutes at `:05` | leader | Dispatch recurring and one-shot scheduled jobs. |
| `garden-proxy` | 5 minutes after the prior run | leader | Resolve or park ordinary absent-maintainer questions. |
| `garden-unblock` | every 5 minutes at `:01` | host | Promote blocked plans whose dependency completed. |
| `garden-deadmail` | every 5 minutes at `:00` | leader | Promote messages whose intended live recipient disappeared. |
| `garden-deadline-nudge` | every minute | leader | Nudge claimed jobs near their handler deadline. |
| `garden-reaper` | every 10 minutes at `:03` | leader | Requeue stale claims and classify repeated failures. |
| `garden-mentor` | every 30 minutes at `:20` | leader | Mine automation logs for improvement work. |
| `garden-bulletin` | continuously restarting service | leader, in-loop | Keep the journal landing-page bulletin current. |
| `garden-mirror-closer` | every 5 minutes at `:03` | leader | Close a bot mirror PR after its upstream PR closes. |
| `garden-library-link-scan` | hourly at `:22` | host | Post scholar repairs for dangling library navigation. |
| `garden-library-source-drift-scan` | hourly at `:07` | leader | Post scholar refreshes for drifted ingested sources. |
| `garden-export-index` | daily at 04:23 host time | leader | Publish roadmap-branch export indexes. |
| `garden-regenerate-sections-index` | hourly at `:37`, up to 5-minute jitter | host | Deterministically rebuild the library sections index. |
| `garden-regenerate-topics-counts` | hourly at `:17` | host | Rebuild topic section counts. |
| `garden-ironhorse-fuzz` | 2 minutes after boot, then 5 minutes | leader, paused | Run the continuous IronHorse fuzz campaign. |
| `garden-upgrade-monitor` | every 5 minutes at `:02` | host | Detect an available `main2` upgrade. |
| `garden-self-deploy` | every 3 minutes at `:00` | host | Deploy a follower after the leader releases a roll. |
| `garden-rolling-deploy` | every 3 minutes at `:02` | leader | Conduct follower-first fleet upgrades. |
| `garden-watchman` | 2 minutes after the prior run | host; broadcast leader-only in-loop | Broadcast role and skill changes after deploy. |
| `garden-root-repo-guard` | every 30 minutes at `:22` | host | Check and repair deployed-root and inode invariants. |
| `garden-container-hardening` | daily at 06:17 and 18:17 host time | host | Probe the container's unprivileged posture. |
| `garden-minion-mcp-watchdog` | every 10 minutes at `:04` | host | Probe and reconnect the minion.town MCP connection; edge-latched alert. |
| `garden-journal-contention-watch` | 3 minutes after boot, then 5 minutes | host | Detect journal contention and remedy bloated clones. |
| `garden-journal-worktree-keeper` | every 30 minutes at `:15` | host | Keep the shared journal read worktree current and recover divergence. |
| `garden-clone-keeper` | every 30 minutes at `:00` | host | Fetch and fast-forward standing bare clones. |
| `garden-state-clone-keeper` | hourly at `:22` | host | Reclaim leaked state clones. |
| `garden-worktree-sweeper` | every 30 minutes at `:12` | host | Reclaim terminal and orphaned worktrees. |
| `garden-transcript-capture` | hourly at `:20` | host | Archive redacted session transcripts. |
| `garden-sysop` | every 20 seconds | host | Execute closed-vocabulary operations addressed to this host. |
| `garden-local-model-pull` | on demand | host | Run an attested Ollama model pull for sysop. |
| `garden-root-maintenance` | on demand | host | Run attested stale-lock and bounded Git maintenance for sysop. |
| `garden-ollama` | long-running when a local worker needs it | host | Serve the local OpenAI-compatible inference endpoint. |
| `garden-watcher@` | long-running per feed | host | Legacy activity-feed watcher template; current implementation is a stub. |

`OnCalendar` expressions above are systemd calendar expressions. The unit files
do not set `Timezone=`, so the user manager's host timezone applies. Check
`timedatectl` before interpreting a calendar on an unfamiliar host.
`Persistent=true` means
a missed calendar activation is caught up after downtime. `OnUnitActiveSec`
measures from the last activation, so a long run lengthens the wall-clock gap.

## Controls common to every entry

Use the full service or timer name shown below in these commands:

```sh
systemctl --user status UNIT
systemctl --user cat UNIT
systemctl --user show UNIT -p ActiveState -p SubState -p Result -p ExecMainStatus
journalctl --user -u UNIT --since today
journalctl --user -u UNIT -f
```

For a timer, inspect both halves and its next activation:

```sh
systemctl --user status NAME.timer NAME.service
systemctl --user list-timers NAME.timer
journalctl --user -u NAME.timer -u NAME.service --since today
```

`systemctl --user disable --now UNIT` is **not a durable stop**. The scaler,
repo watcher, install reconciliation, or a deploy can re-arm intended units,
often within about 90 seconds. Mask every half that could be started:

```sh
systemctl --user mask --now NAME.timer NAME.service
# Template example: mask the concrete instance, not only the template.
systemctl --user mask --now garden-triager@OWNER-REPO.timer garden-triager@OWNER-REPO.service
```

A mask survives those reconcilers. Restore deliberately with `unmask`, then let
the owner re-arm it. A source-level policy pause is stronger where one exists:
`install-units.sh` actively stops and disables the IronHorse fuzz pair on every
reconcile. The mention watcher is omit-only, so the installer neither arms nor
force-disables a maintainer's manual choice.

Unless an entry says otherwise, a service is a timer-fired `Type=oneshot`
wrapped by `scripts/jobs/self-heal-run.sh`. That wrapper records host-local
diagnostics below `$GARDEN_STATE/self-heal/` and uses a dedicated journal clone
at `$GARDEN_STATE/self-heal/journal`. It can post self-heal work to `jobs/` and
maintainer notices to `msgs/`. The entry's "State/journal" line lists additional
state owned by the payload.

Drain and brake are different controls. A local fleet drain is
`$GARDEN_STATE/draining` (legacy `$GARDEN_STATE/NOPE` is also honored). "Skips
under drain" means the timer still activates but the payload exits or idles
without its normal action. The journal-backed foreman brake is only
`config/foreman-brake`; it stops the foreman and does not stop any other unit.
Thus every entry below continues under the foreman brake except the foreman.

## Worker pools and leveling

### Worker instances

Files and rendered units: `garden-worker@.service.in` is a render-only source,
not installed under that name. `install-units.sh` substitutes the worker kind
and renders `garden-monk@.service`, `garden-cleric@.service`,
`garden-hermit@.service`, `garden-mystic@.service`,
`garden-fireworker@.service`, `garden-openrouter@.service`,
`garden-openrouter-promo@.service`, `garden-opencode-anthropic@.service`, and
`garden-friar@.service`. `%i` is the numeric local slot, such as
`garden-cleric@3.service`.

- **Purpose/run:** a long-running `Type=exec`, `Restart=on-failure` instance runs
  `scripts/jobs/self-heal-run.sh` around `scripts/jobs/gardener.sh %i`, using the
  label `garden-KIND` and `--work-id %i`. It claims one job at a time and invokes
  the kind's registered handler. The kinds use Claude (`monk`), Codex (`cleric`, `hermit`,
  `fireworker`, `openrouter`, `openrouter-promo`), Kimi (`mystic`), OpenCode
  (`opencode-anthropic`), or Claude against Ollama Cloud (`friar`). It does not
  spawn another systemd worker. Job roles determine any agent work inside it.
- **Scope/controls:** every host. Drain lets an in-flight claim finish and blocks
  the next claim. The foreman brake does not stop workers. The separate
  correlated-outage fleet brake can delay claims. `KillMode=mixed` and a
  45-minute stop timeout preserve the headless completion window.
- **Knobs:** rendered `GARDEN_WORKER_KIND`; `GARDEN_CLAIM_TTL=14400`, handler
  timeout `2400` seconds, provider credentials/models, and the per-kind count in
  journal `hosts/$GARDEN`. The registry and defaults are in
  `scripts/jobs/common.sh`.
- **State/journal:** `$GARDEN_STATE/<kind-plural>/<id>/journal`, per-instance
  markers below the same namespace, job transitions in `jobs/{todo,doin,tada}`,
  `jobs/index`, inbox messages, progress/result entries, and usage/reputation
  events. The `hermit` lane is registered for old records but clamped to zero.
- **Inspect/stop:** use the common commands with a concrete instance; also run
  `scripts/jobs/install-units.sh status`. Mask that concrete `.service` for a
  durable stop, or use `set-workers.sh KIND 0` for the intended pool-level stop.
  See [scaling.md](scaling.md), [health.md](health.md), and
  `designs/cleric-worker-bid-auction-reputation.md`.

### Gardener scaler

Files: `garden-gardener-scaler.timer`, `garden-gardener-scaler.service`.

- **Purpose/run/trigger:** every minute, run
  `scripts/jobs/gardener-scaler.sh` through the self-heal wrapper and reconcile
  every registered kind's numbered services to `hosts/$GARDEN`.
- **Scope/controls/spawns:** every host; continues under drain and the foreman
  brake. It starts and stops the nine rendered worker kinds above. The hermit
  count is clamped to zero, and Ollama is reconciled with it.
- **Knobs/state:** `GARDEN_SCALER_CLONE` defaults to
  `$GARDEN_STATE/gardener-scaler/journal`; the journal host record supplies count
  keys such as `monks:` and `clerics:`. It changes only local systemd state and
  reads journal `hosts/`.
- **Inspect/stop:** inspect both files with the common commands. Mask both to
  freeze automatic reconciliation, then stop/mask concrete workers as needed.
  See [scaling.md](scaling.md).

### Foreman

Files: `garden-foreman.timer`, `garden-foreman.service`.

- **Purpose/run/trigger:** at minutes `04,09,14,...`, run
  `scripts/jobs/foreman.sh`, which calls `handlers/foreman-claude.sh` when active
  work is below the target and posts the resulting jobs.
- **Scope/controls/spawns:** leader only. A drain or `config/foreman-brake` makes
  the tick inert. It posts whatever role/kind the foreman decision selects; it
  does not start worker processes directly.
- **Knobs/state:** the unit sets `GARDEN_FOREMAN_ACTIVE_TARGET=10`; script
  fallbacks include `GARDEN_FOREMAN_IDLE_SETTLE=240`, project
  `endo-but-for-bots`, and notice TTL 86400. State is
  `$GARDEN_STATE/foreman/journal` plus `$GARDEN_STATE/foreman`; journal reads the
  board and `config/foreman-brake`, then writes new `jobs/todo` records.
- **Inspect/stop:** common commands, plus `scripts/jobs/brake-foreman.sh status`.
  The supported durable policy stop is `brake-foreman.sh on`; mask both units to
  stop activations. See [scaling.md](scaling.md) and
  [cybernetics.md](cybernetics.md).

### Budget refresh and reputation reduction

Files: `garden-budget-refresh.timer`, `garden-budget-refresh.service`,
`garden-reputation-reducer.timer`, `garden-reputation-reducer.service`.

- **Budget refresh:** leader-only at `:02/5`; runs
  `scripts/jobs/budget-refresh.sh`, skips under drain, and promotes eligible
  `jobs/plan` entries whose `budget_hold` window has reset. Its key seam is
  `GARDEN_BUDGET_REFRESH_NOW`; its clone defaults to
  `$GARDEN_STATE/budget-refresh/journal`. It spawns no kind directly.
- **Reducer:** leader-only at `:02/5`; runs
  `scripts/jobs/reputation-reduce.sh`, continues under drain, and converts
  completed reputation events into arm projections. Key knobs are the rate card,
  event/pending batch sizes, and `GARDEN_REP_FLAT_PROVIDERS`; state is
  `$GARDEN_STATE/reducer/{journal,checkpoint}` and journal `reputation/` records.
- **Inspect/stop:** apply the common paired-unit commands and mask the relevant
  pair. The foreman brake does not stop either. See
  [cybernetics.md](cybernetics.md).

## Repository and GitHub watchers

All six per-repository templates use `%i=OWNER-REPO`, with the first hyphen
separating owner from repository. `repo-watcher.sh` arms `garden-triager@` from
`repos/`; it arms the other five from the stricter `comment-repos/` set.

### Per-repository template set

- **`garden-triager@.timer`, `garden-triager@.service`:** leader-only; 30-second
  boot delay, then two-minute activations with up to 30 seconds of jitter. Runs
  `scripts/jobs/triager.sh %i`. It fetches `worktrees/%i.git`, compares durable
  activity/failure cursors, and invokes the triager handler to post arbitrary
  role jobs. It skips under drain. Key knobs include fetch retries/timeouts,
  `GARDEN_TRIAGE_FAIL_THRESHOLD`, and tick deadline; state is
  `$GARDEN_STATE/triager/`, `$GARDEN_STATE/triager-pace/journal`, and journal
  activity/failcount cursors and `jobs/todo`.
- **`garden-comment-watcher@.timer`, `garden-comment-watcher@.service`:**
  leader-only; 30-second boot delay, then 90 seconds with up to 30 seconds of
  jitter. Runs `scripts/jobs/comment-watcher.sh %i`. It acknowledges trusted
  commands and reviews and posts the mapped role, including shepherd/conductor
  transitions. It skips under drain. Key knobs select the source, post, reactji,
  reply, and API cooldown; state is under
  `$GARDEN_STATE/comment-watcher/` (`heartbeat`, `selftest`, and `verify`) and the
  journal comment cursors, messages, and jobs.
- **`garden-ci-watcher@.timer`, `garden-ci-watcher@.service`:** leader-only;
  45-second boot delay, then 90 seconds with up to 30 seconds of jitter. Runs
  `scripts/jobs/ci-watcher.sh %i`, posts a `shepherd` for completed-red bot PR CI,
  and retires an unclaimed auto-shepherd if CI self-heals. It skips under drain.
  Key knobs are activity window, PR source, rollup and timeout seams; per-repo
  state is `$GARDEN_STATE/ci-watcher/{verify-%i,retire-%i}` plus the shared API
  cooldown, and journal `jobs/`.
- **`garden-dependabot-watcher@.timer`,
  `garden-dependabot-watcher@.service`:** leader-only; 90-second boot delay,
  then five minutes with up to 90 seconds of jitter. Runs
  `scripts/jobs/dependabot-watcher.sh %i` and posts `botanist` jobs after
  compatibility checks. It skips under drain. Key knobs select PR/compatibility
  sources and maximum checks; state is
  `$GARDEN_STATE/dependabot-watcher/verify` and journal jobs/index records.
- **`garden-approval-reconciler@.timer`,
  `garden-approval-reconciler@.service`:** leader-only; two-minute boot delay,
  then 15 minutes with up to five minutes of jitter. Runs
  `scripts/jobs/approval-reconciler.sh %i` and posts `conductor` or `shepherd`
  when a current trusted approval was missed. It skips under drain. Key knobs
  include activity window and approval/mergeable/source handlers; state is
  `$GARDEN_STATE/approval-reconciler/verify` and journal jobs/index records.
- **`garden-receipt-watcher@.timer`, `garden-receipt-watcher@.service`:**
  leader-only; 90-second boot delay, then five minutes with up to one minute of
  jitter. Runs `scripts/jobs/receipt-watcher.sh %i`, normally calls
  `pr-receipt.sh` directly, and posts a `receipt` recovery job only on structural
  failure. It skips under drain. Defaults include a two-day seed window,
  180-second source timeout, and 300-second generation timeout; state is the
  per-repo `$GARDEN_STATE/receipt-watcher/journal-%i` clone and journal receipt
  cursors/archive/comments.

Each service is a bounded oneshot and uses `KillMode=mixed`. Inspect a concrete
timer and service together. To stop one repository durably, mask both concrete
instances; to stop all instances, remove the corresponding journal watch-set
entry through the supported watch configuration and mask any instance that must
remain off despite reconciliation. The foreman brake affects none of them.
See [leader-follower.md](leader-follower.md), [health.md](health.md), and
`designs/auto-provision-fork-watchers.md`.

### Repository watcher reconciler

Files: `garden-repo-watcher.timer`, `garden-repo-watcher.service`.

- **Purpose/run/trigger:** one minute after each activation,
  `scripts/jobs/repo-watcher.sh` syncs journal `repos/` and `comment-repos/`,
  self-installs a missing template, and enables/disables the six concrete timer
  families above. It also auto-provisions eligible own-fork watches.
- **Scope/controls/spawns:** every host and continues under drain, which means
  follower hosts also reconcile timers whose service-side leader condition will
  skip. It starts timer instances, not workers. Foreman brake has no effect.
- **Knobs/state:** arm retries 3 with two-second delay;
  `$GARDEN_STATE/repo-watcher/journal` and
  `fork-provisioner-offline` hold its clone/latch. It writes watch-set membership
  through the provisioner and local user-manager state.
- **Inspect/stop:** mask both reconciler units and every concrete watcher instance
  that must stay off. Disabling an instance alone is repaired on the next
  one-minute tick. See [leader-follower.md](leader-follower.md).

### Global and garden-repository watchers

- **`garden-mention-watcher.timer`, `garden-mention-watcher.service`:**
  leader-only, every 90 seconds after the prior activation; runs
  `scripts/jobs/mention-watcher.sh`. It sender-trust-gates GitHub-wide mentions,
  acknowledges them, and posts mapped jobs/plans. It skips under drain. State is
  `$GARDEN_STATE/mention-watcher/{heartbeat/github-wide,verify}` plus journal
  cursors/jobs. This pair is excluded from automatic enablement for monitoring
  safety and must be maintainer-armed. Mask both for a durable stop.
- **`garden-issue-inbox.timer`, `garden-issue-inbox.service`:** leader-only,
  45 seconds after boot then every two minutes; runs
  `scripts/jobs/issue-inbox-watcher.sh`. It posts work or messages the maintainer
  for explicitly addressed garden issues. It skips under drain. Key defaults are
  `GARDEN_EXPLICIT_ADDRESS_REQUIRED=1`, 480-second tick budget, and 90-second
  stage timeout. State is under `$GARDEN_STATE/issue-inbox/` (`verify` and
  `notified-nonmaintainers`) and its heartbeat, plus journal jobs/messages.
- **`garden-pages-watcher.timer`, `garden-pages-watcher.service`:** leader-only,
  50 seconds after boot then every two minutes; runs
  `scripts/jobs/pages-watcher.sh` and posts a `pages-shepherd` for a failed
  `pages-build-deployment` workflow. It skips under drain. Defaults include a
  120-second source timeout; state is `$GARDEN_STATE/pages-watcher/verify` and
  journal jobs.
- **`garden-comment-latency-watch.timer`,
  `garden-comment-latency-watch.service`:** leader-only, six minutes after boot
  then every five minutes; runs `scripts/jobs/comment-latency-watch.sh`. During a
  drain it still measures and reports a coalesced "muted by drain" notice rather
  than declaring watchers dead. Defaults include six-hour lookback, 20-minute
  stuck threshold, and storm maximum 5. State is
  `$GARDEN_STATE/comment-latency-watch` and maintainer watchdog messages.
- **`garden-design-pr-gauntlet-audit.timer`,
  `garden-design-pr-gauntlet-audit.service`:** leader-only, hourly at `:37`;
  runs `scripts/jobs/design-pr-gauntlet-coverage-audit.sh`. It skips under drain,
  never stages a gauntlet, and emits only deduplicated alerts. State is
  `$GARDEN_STATE/design-pr-gauntlet-audit/journal` and
  `$GARDEN_STATE/pr-gauntlet-readiness`; it reads PR/gauntlet journal records.
- **`garden-requirements-watch.timer`, `garden-requirements-watch.service`:**
  leader-only by `ExecCondition`, every five minutes at `:02`; runs
  `scripts/jobs/requirements-watch.sh`. It continues under drain and alerts once
  after the default 900-second dwell. State is
  `$GARDEN_STATE/requirements-watch/{journal,*first,*noticed}` and journal
  `jobs/todo`.

These units spawn only the job kinds named above, not systemd worker instances.
The foreman brake does not affect them. Inspect and mask each pair using the
common commands. See `CLAUDE.md` under "Monitoring safety constraint" and
[health.md](health.md).

## Board workflow, recovery, and health

### Orchestration, gauntlet, follow-up, and schedules

- **`garden-orchestrate.timer`, `garden-orchestrate.service`:** leader-only at
  `:01/3`; runs `scripts/jobs/orchestrate.sh`. It skips under drain and promotes
  the next declared child job, serial or parallel, while tracking completion.
  Defaults include 2400-second handler timeout, stall multiplier 1, and two stall
  requeues. State is `$GARDEN_STATE/orch/journal` and journal
  `orchestrations/`, `jobs/plan`, `jobs/todo`, and messages.
- **`garden-gauntlet.timer`, `garden-gauntlet.service`:** leader-only at `:02/3`;
  runs `scripts/jobs/gauntlet.sh`. It skips under drain and advances clean,
  panel, fix-loop, and un-draft stages by posting/promoting their role jobs.
  Defaults include 10800-second panel timeout, 3600-second CI deadline, and
  Anthropic panel provider. State is `$GARDEN_STATE/gauntlet/journal` and journal
  gauntlet records plus job lanes.
- **`garden-follow-up.timer`, `garden-follow-up.service`:** leader-only at
  `:08/10`; runs `scripts/jobs/follow-up.sh`. It skips under drain, converts
  structured `follow-up:` report fields into jobs, schedules, or maintainer
  messages, and invokes `handlers/follow-up-claude.sh` when interpretation is
  needed. Defaults are five retries and six-hour transient window. State is
  `$GARDEN_STATE/follow-up/{journal,seen,fail-count,transient}` and journal
  `jobs/tada`, jobs, schedules, and messages.
- **`garden-scheduler.timer`, `garden-scheduler.service`:** leader-only at
  `:05/15`; runs `scripts/jobs/scheduler.sh`. It skips under drain and posts due
  recurring/one-shot schedule jobs; it also runs budget-level and worker
  de-rotation controllers. Defaults include 14400-second claim TTL and
  120-second preflight timeout. State is
  `$GARDEN_STATE/scheduler/{journal,preflight-missing}` and journal `schedules/`,
  job lanes, budget, and host records.
- **`garden-proxy.timer`, `garden-proxy.service`:** leader-only five minutes
  after the prior activation; runs `scripts/jobs/proxy.sh`. It skips under drain,
  waits the default 900-second grace, invokes `handlers/proxy-claude.sh`, and
  answers ordinary gating questions or parks blocked work. State is
  `$GARDEN_STATE/proxy/{journal,seen}` and journal inboxes, messages, and
  `jobs/plan`.
- **`garden-unblock.timer`, `garden-unblock.service`:** every host at `:01/5`;
  runs `scripts/jobs/unblock.sh`. It skips under drain and promotes
  `gate: blocked` plans after a named job or PR completes, or changes the gate to
  `blocked-failed`. State is `$GARDEN_STATE/unblock/journal`; it reads/writes
  `jobs/{plan,todo,tada}` and may notify the maintainer.

These units create/promote job records that any eligible worker kind may claim;
they do not start a kind directly. Foreman brake has no effect. Inspect and mask
the named pair. See `designs/gardening-state-machine.md`,
`designs/manual-gauntlet-trigger.md`, [schedules.md](schedules.md), and
[plan-queue.md](plan-queue.md).

### Deadmail, deadlines, and reaping

- **`garden-deadmail.timer`, `garden-deadmail.service`:** leader-only at
  `:00/5`; runs `scripts/jobs/deadmail.sh`, skips under drain, and promotes
  undeliverable directed messages into jobs. State is
  `$GARDEN_STATE/deadmail/{journal,verify}` plus journal messages/deadmail/jobs.
- **`garden-deadline-nudge.timer`, `garden-deadline-nudge.service`:**
  leader-only every minute; directly runs `scripts/jobs/deadline-nudge.sh`
  without the self-heal wrapper. It continues under drain and sends an in-process
  continuation nudge as a claim approaches one quarter of the remaining window,
  bounded at 900 seconds. Defaults include interval 60, fraction 4, and five
  push attempts. State is `$GARDEN_STATE/deadline-nudge/journal`; it amends
  claimed-job state/messages rather than spawning a worker.
- **`garden-reaper.timer`, `garden-reaper.service`:** leader-only at `:03/10`;
  directly runs `scripts/jobs/reaper.sh`. It continues under drain, requeues
  expired `jobs/doin` claims, handles explicit reap requests, and moves repeated
  nonproductive work toward doom or gauntlet handoff. Defaults include 14400
  second claim TTL, eight age-expired claims per tick, and 600-second plain-retry
  backoff. State is under `$GARDEN_STATE/reaper/` (`journal`, `doom-spool`, and
  `gauntlet-handoff-spool`) and journal job/progress/doom records.

Foreman brake has no effect. Inspect and mask the pair. See
[health.md](health.md) and `designs/gardening-state-machine.md`.

### Mentor and bulletin

- **`garden-mentor.timer`, `garden-mentor.service`:** leader-only at `:20/30`;
  runs `scripts/jobs/mentor.sh`, skips under drain, reads new systemd log
  evidence, and invokes `handlers/mentor-claude.sh` to post automation-improvement
  work. Defaults are three semantic rejections and outage backoff cap 32. State
  is under `$GARDEN_STATE/mentor/` (`journal`, `journalctl-since`, `seen`,
  `semantic-rejections`, and `transient-outage`) plus journal jobs/messages.
- **`garden-bulletin.service`:** standalone `Type=exec`, `Restart=always` service
  running `scripts/jobs/bulletin.sh` through self-heal with no handler timeout.
  There is no timer. Every host may enable it, but its loop rechecks leadership
  and only the leader publishes; it idles on a follower or under drain. It invokes
  a journalist handler only when the deterministic dashboard changed. Key knobs
  include idle sleep, parked cache TTL, and fetch-backoff cap. State is
  `$GARDEN_STATE/bulletin/{journal,cursor,parked.md,parked.stamp}`; it writes the
  journal `README.md`, `plan/README.md`, and commits to `journal2`.

The foreman brake affects neither. Inspect the mentor pair normally. Inspect or
mask the bulletin service alone. See [health.md](health.md),
`designs/job-board.md`, and the journal `DESIGN.md`.

## PR lifecycle and library producers

- **`garden-mirror-closer.timer`, `garden-mirror-closer.service`:** leader-only
  at `:03/5`; runs `scripts/jobs/mirror-closer.sh`, skips under drain, and closes
  a bot mirror PR once its recorded upstream PR is closed. Handler knobs select
  PR-state and close implementations. State is `$GARDEN_STATE/mirror-closer` and
  journal roadmap/mirror records. It spawns no worker.
- **`garden-library-link-scan.timer`, `garden-library-link-scan.service`:** every
  host at `:22`; runs `scripts/jobs/library-link-scan.sh --actuate`, continues
  under drain, and posts one content-addressed `scholar-fix-dangling-nav-links-*`
  job when navigation links dangle. State is
  `$GARDEN_STATE/library-link-check/journal`; it reads journal `library/` and
  writes `jobs/` through `post-job.sh`.
- **`garden-library-source-drift-scan.timer`,
  `garden-library-source-drift-scan.service`:** leader-only at `:07`; runs
  `scripts/jobs/library-source-drift-scan.sh`, continues under drain, and posts a
  `scholar-refresh-SLUG` job for each new pinned-source drift. State is
  `$GARDEN_STATE/library-source-drift-scan/journal`; it reads journal library
  indexes and local bare clones, then writes jobs/index records.
- **`garden-export-index.timer`, `garden-export-index.service`:** leader-only at
  04:23; runs `scripts/jobs/export-index/publish-export-index.sh`, continues
  under drain, and lands deterministic `library/exports/*.tsv` plus its README.
  `config/export-index-roadmaps` selects inputs, defaulting to
  `endojs/endo-but-for-bots@llm`; it uses the shared journal read worktree and
  `land-journal-edit.sh`, with no dedicated `$GARDEN_STATE` path.
- **`garden-regenerate-sections-index.timer`,
  `garden-regenerate-sections-index.service`:** every host at `:37` with up to
  300 seconds jitter; runs `scripts/jobs/regenerate-sections-index.sh`, continues
  under drain, and CAS-lands `library/sections/README.md`. State is
  `$GARDEN_STATE/regenerate-sections-index/journal` plus temporary regeneration
  state.
- **`garden-regenerate-topics-counts.timer`,
  `garden-regenerate-topics-counts.service`:** every host at `:17`; runs
  `scripts/jobs/regenerate-topics-counts.sh --land`, continues under drain, and
  CAS-lands the `library/topics/README.md` section counts. State is
  `$GARDEN_STATE/regenerate-topics-counts/journal` plus temporary regeneration
  state.

Only the two scans spawn jobs, and both spawn scholar work. Foreman brake affects
none. Inspect and mask the matching pair. Related context is
`skills/library-lookup/SKILL.md`, `designs/export-index-build-vs-buy.md`, and
`roles/scholar/AGENT.md`.

### IronHorse fuzz campaign

Files: `garden-ironhorse-fuzz.timer`, `garden-ironhorse-fuzz.service`.

- **Purpose/run/trigger:** two minutes after boot and five minutes after the prior
  activation, run `scripts/jobs/ironhorse-fuzz.sh` with an hour start timeout. It
  maintains an off-critical-path fuzz campaign, repair jobs, and one standing PR.
- **Scope/controls/spawns:** leader only and skips under drain. It posts IronHorse
  repair jobs. Foreman brake does not affect it.
- **Knobs/state:** corpus/cluster/high-water/low-water/doom thresholds and branch
  names are configurable. State and its journal clone are under
  `$GARDEN_STATE/ironhorse-fuzz`; journal job and campaign records are touched.
- **Inspect/stop:** this pair is listed in `PAUSED_UNITS`; every install reconcile
  stops and disables it. Do not unpause merely by unmasking. Follow the explicit
  re-arming checklist in [ironhorse-fuzz.md](ironhorse-fuzz.md). The service's
  unusual `WantedBy=timers.target` is not used by the normal installer because a
  sibling timer exists.

## Deploy and evolution

- **`garden-upgrade-monitor.timer`, `garden-upgrade-monitor.service`:** every
  host at `:02/5`; directly runs `scripts/jobs/upgrade-monitor.sh`, continues
  under drain, and compares deployed HEAD with `origin/main2`. It writes the
  upgrade-ready marker under `$GARDEN_STATE/deploy` and blind-sensor counters in
  `$GARDEN_STATE/upgrade-monitor`; default alert threshold is 12 skipped reads.
  It writes no journal board record except watchdog notices.
- **`garden-self-deploy.timer`, `garden-self-deploy.service`:** every host at
  `:00/3`; runs `scripts/jobs/self-deploy.sh`. It respects an operator drain,
  handles roll-owned drain provenance specially, and deploys only after a leader
  release or safe leaderless gate. State is under
  `$GARDEN_STATE/self-deploy/` (including `journal`) and `$GARDEN_STATE/deploy`;
  journal deploy roll/release/health records are
  read and written. It spawns no worker kind, but `deploy-garden.sh` reinstalls
  and restarts units.
- **`garden-rolling-deploy.timer`, `garden-rolling-deploy.service`:** leader-only
  at `:02/3`; runs `scripts/jobs/rolling-deploy.sh`, skips while the leader itself
  is drained, and releases followers as canaries before the leader. Default stuck
  canary threshold is 1200 seconds; retry/backoff/probe deadlines are knobs.
  State is `$GARDEN_STATE/rolling-deploy/{journal,...}` and producer clone state;
  journal deploy release, fleet health, and deployed-sha records are touched.
- **`garden-watchman.timer`, `garden-watchman.service`:** every host two minutes
  after its prior activation; runs `scripts/jobs/watchman.sh`. It skips under
  drain. Per-host fetch/legacy maintenance runs everywhere, while only the leader
  broadcasts reread messages and invokes `handlers/watchman-claude.sh`.
  `GARDEN_AGGRESSIVE_CHECKOUT=0` by default. State is
  `$GARDEN_STATE/watchman/seen-main2`; it writes broadcast messages and may post a
  wedge-resolution job only if the legacy aggressive mode is explicitly enabled.

Foreman brake affects none. Inspect and mask the matching pair. See
[deploy.md](deploy.md) and [leader-follower.md](leader-follower.md).

## Per-host maintenance and security

- **`garden-root-repo-guard.timer`, `garden-root-repo-guard.service`:** every
  host at `:22/30`; runs `scripts/jobs/root-repo-guard.sh` with a 30-minute unit
  timeout. It continues checking during drain. It verifies canonical origin,
  deployed ancestry, object-store health, inode headroom, and stalled deploys,
  repairing classified drift or alerting. State is
  `$GARDEN_STATE/root-repo-guard` and `$GARDEN_STATE/deploy/dirty-tree-backups`;
  notices go to the journal maintainer inbox. Key knobs set fetch bounds and
  leader/follower stall thresholds.
- **`garden-minion-mcp-watchdog.timer`, `garden-minion-mcp-watchdog.service`:**
  every host at `:04/10`; runs `scripts/jobs/minion-mcp-watchdog.sh` (no LLM)
  with a 10-minute unit timeout. It honors the `config/minion-mcp` gate and
  otherwise probes token acquisition plus MCP `initialize`/`tools/list` through
  the worker stdio bridge. On failure it forces a fresh token and re-probes, then
  posts one edge-latched `watchdog-notice.sh` notice
  (`minion-mcp-connection-<GARDEN>`) and a recovery close-out. State and the
  heartbeat are in `$GARDEN_STATE/minion-mcp`. See
  [minion-town-mcp.md](minion-town-mcp.md).
- **`garden-container-hardening.timer`,
  `garden-container-hardening.service`:** every host at 06:17 and 18:17; runs
  `scripts/check-container-hardening.sh` and treats the documented pending-image
  exits as expected through the wrapper. It continues under drain. The principal
  marker is `$GARDEN_STATE/container-hardening/hardened-verified`; strict mode,
  maintainer login/allowlist, and seven-day pending renotify interval are knobs.
- **`garden-journal-contention-watch.timer`,
  `garden-journal-contention-watch.service`:** every host three minutes after
  boot then every five minutes; runs `scripts/jobs/journal-contention-watch.sh`
  and continues under drain. It samples clone-lock contention, drift, packs and
  size, then remedies replaceable clones or alerts. State is entirely under
  `$GARDEN_STATE/journal-contention-watch`; defaults include 256-sample window,
  4 GiB clone limit, and six-hour remedy interval.
- **`garden-journal-worktree-keeper.timer`,
  `garden-journal-worktree-keeper.service`:** every host at `:15/30`; runs
  `scripts/jobs/journal-worktree-keeper.sh`, continues under drain, and
  fast-forwards a clean `journal/` or losslessly backs up and heals divergence
  after checking for active writers. State and backups are under
  `$GARDEN_STATE/journal-worktree-keeper`; defaults include three-second settle,
  self-heal enabled, and two-hour freshness threshold.
- **`garden-clone-keeper.timer`, `garden-clone-keeper.service`:** every host at
  `:00/30`; runs `scripts/jobs/clone-keeper.sh` and continues under drain. It
  fetches and fast-forwards the configured standing bare clones under
  `worktrees/`; `GARDEN_TRACKED_CLONES` and fetch timeout/reap age are knobs. It
  owns no journal write path and no dedicated `$GARDEN_STATE` path.
- **`garden-state-clone-keeper.timer`,
  `garden-state-clone-keeper.service`:** every host at `:22`; runs
  `scripts/jobs/state-clone-keeper.sh` and continues under drain. It reclaims
  idle per-identity clones under `$GARDEN_STATE` after proving no active owner.
  Defaults are six-hour idle, 200 normal candidates, kinds `inbox`, `monitors`,
  `clerics`, and `monks`, and a five-percent inode floor. Its read clone is
  `$GARDEN_STATE/state-clone-keeper/journal`.
- **`garden-worktree-sweeper.timer`, `garden-worktree-sweeper.service`:** every
  host at `:12/30`; runs `scripts/jobs/worktree-sweeper.sh` with a 30-minute unit
  timeout and continues under drain. It removes completed, doomed, and orphaned
  local checkouts after terminality checks. Defaults are 100 removals and a
  1500-second soft deadline. State is
  `$GARDEN_STATE/worktree-sweeper/journal`; it reads terminal journal jobs and
  changes local `$GARDEN_SCRATCH`/root worktrees.
- **`garden-transcript-capture.timer`,
  `garden-transcript-capture.service`:** every host hourly at `:20`; runs
  `scripts/jobs/transcript-capture.sh` and continues under drain. It reconciles
  Claude cleanup retention, redacts/compresses the completion spool and idle
  sessions, then pushes per-host paths to `transcripts2` when configured. Defaults
  include 720-second tick budget, batch 32, and six-hour idle age. State is
  `$GARDEN_STATE/transcripts/{journal,clone,captured.tsv,spool}`; it reads journal
  transcript configuration and writes the separate transcript branch.

None spawns workers, and the foreman brake affects none. Inspect and mask the
relevant pair. See [health.md](health.md), [deploy.md](deploy.md),
[harden-container.md](harden-container.md), and [transcripts.md](transcripts.md).

## Host operations and local inference

### Sysop

Files: `garden-sysop.timer`, `garden-sysop.service`.

- **Purpose/run/trigger:** every 20 seconds, run `scripts/jobs/sysop.sh` and
  execute the closed vocabulary addressed to journal `msgs/host/$GARDEN`:
  `set-workers`, `drain`, `reset-failed`, `restore`, `unit`, `deploy`,
  `local-model`, and `maintain`.
- **Scope/controls/spawns:** every host. It deliberately continues under drain so
  the host can receive `drain off`; foreman brake has no effect. `set-workers`
  indirectly starts registered worker kinds, while `local-model` and `maintain`
  start the two on-demand units below.
- **Knobs/state:** heartbeat default 600 seconds; destructive operations require
  `authorized_by` on the maintainers allowlist. State is
  `$GARDEN_STATE/sysop/{journal,local-model,root-maintenance}` and
  `$GARDEN_STATE/seen/sysop-$GARDEN`; journal input is `msgs/host/$GARDEN`, output
  is `sysop-log/$GARDEN/` plus acknowledgments.
- **Inspect/stop:** common paired commands. Masking the pair is durable but removes
  remote recovery of a drained unattended host. See
  [host-operations.md](host-operations.md) and `designs/sysop.md`.

### On-demand sysop helpers

- **`garden-local-model-pull.service`:** no timer and no `[Install]`; sysop starts
  it explicitly for an attested `local-model` op. It directly runs
  `scripts/jobs/pull-local-model.sh` with infinite start timeout and mixed kill.
  Every host; continues under drain/brake. `GARDEN_SYSOP_OLLAMA_BIN=ollama` and
  requested-model state are key inputs. It writes
  `$GARDEN_STATE/sysop/local-model`, invokes no worker, and touches no journal
  path directly. Inspect/mask this service alone. See
  `designs/sysop-local-model.md`.
- **`garden-root-maintenance.service`:** no timer and no `[Install]`; sysop starts
  it explicitly for an attested `maintain` op. It directly runs
  `scripts/jobs/root-maintenance.sh`, with 1200-second start timeout, to classify
  and possibly break a confirmed-stale `gc.pid` before bounded Git maintenance.
  Every host; continues under drain/brake. State is
  `$GARDEN_STATE/sysop/root-maintenance`; guard and interval knobs are shared with
  root-repo-guard. It invokes no worker and touches no journal path directly.
  Inspect/mask this service alone. See `designs/sysop.md`.

### Ollama endpoint

File: `garden-ollama.service`.

- **Purpose/run/trigger:** long-running `Type=exec`, `Restart=always`; runs
  `scripts/jobs/ollama-serve.sh`. The installer does not put it in the standing
  enable set. `scale hermit N>0` would arm it and zero hermits disarms it.
- **Scope/controls/spawns:** every host; continues under drain and foreman brake.
  It serves workers but does not spawn them.
- **Knobs/state:** `GARDEN_LOCAL_OLLAMA_URL` selects the endpoint,
  `GARDEN_OLLAMA_BIN` the executable, and restart backoff the script loop. Ollama
  owns its model store; the unit owns no garden journal or `$GARDEN_STATE` path.
- **Inspect/stop:** inspect/mask the service alone. The hermit lane is retired and
  clamped to zero, so this service should normally be inactive. See
  [local-inference-amd/README.md](local-inference-amd/README.md).

## Legacy feed watcher

File: `garden-watcher@.service`.

- **Purpose/run/trigger:** `%i` is a feed slug. A long-running `Type=simple`,
  `Restart=on-failure` instance runs `%h/scripts/jobs/self-heal-run.sh` around
  `%h/scripts/watcher/%i/watcher.sh`, labeled `garden-watcher@%i`. It has no
  timer and is enabled per feed by
  the legacy daemon configuration, not `install-units.sh`'s standing set.
- **Scope/controls/spawns:** every host, with no leader or drain check in the unit.
  Behavior is feed-script-specific; it does not start worker units. Foreman brake
  has no effect.
- **Knobs/state:** `SELF_HEAL_HANDLER_TIMEOUT=0`. The contract calls for feed
  cursor/event state and journal events/jobs, but the only shipped feed,
  `endo-but-for-bots`, is a phase-one stub that exits without reading or writing
  them.
- **Inspect/stop:** use a concrete feed name and mask that `.service`. See
  `scripts/systemd/README.md` and `skills/activity-feed-watcher/SKILL.md`.

## Anomalies and intentionally inert surfaces

- `garden-watcher@.service` points through `%h/scripts/...`, unlike the rendered
  `@GARDEN_ROOT@` units. The only shipped feed implementation is explicitly a
  phase-one stub and exits cleanly, so this is not a functioning standing feed
  watcher. The v2 triager/comment/CI templates are the active surveillance path.
- `garden-library-link-scan`, `garden-regenerate-sections-index`,
  `garden-regenerate-topics-counts`, and `garden-unblock` have no leader
  condition and therefore run on every host even
  though they mutate or actuate shared journal state. Their scripts use
  deterministic identities or CAS landers, but no source comment claims the
  executions are leader-only. This page records the shipped behavior rather than
  inferring intent.
- `garden-bulletin.service` and `garden-watchman.service` have no
  `ExecCondition`, but their scripts perform in-loop leadership checks. The
  bulletin needs that shape to promote/demote without restart; watchman splits
  per-host maintenance from its leader-only broadcast.
- `garden-ironhorse-fuzz.service` declares `WantedBy=timers.target` as well as
  having a sibling timer. The installer skips direct enablement of any service
  with a sibling timer and actively disables this paused pair.
- `garden-mention-watcher` ships but is intentionally omitted from automatic
  enablement. `garden-local-model-pull` and `garden-root-maintenance` ship without
  install targets because sysop starts them on demand. `garden-ollama` is
  count-gated and the only local worker lane is currently clamped to zero.
- `seed-api-key-handoff.sh` lives in `scripts/systemd/` but is an image/build-time
  helper, not a systemd unit. `scripts/jobs/install-units.sh` does not render or
  enable it.

The source-level inventory is protected by
`scripts/jobs/test/systemd-unit-doc-completeness-test.sh`. Adding a source unit
or a worker kind without naming its resulting unit on this page fails that test.
