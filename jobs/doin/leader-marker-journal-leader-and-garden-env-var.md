# Simplify leader election: marker = journal/leader, host env var = GARDEN (then drain + upgrade)

Map: **build** (garden infra) on branch main2. Isolated worktree off origin/main2;
explicit-pathspec commits; push HEAD:main2 via git-rebase CAS. HIGH PRIORITY — the current
scheme has the whole leader-only singleton fleet DORMANT on the live host (see below).

Maintainer directive (kriskowal 2026-06-29): **"The leader marker should be simple
`journal/leader` now and the environment variable should simply be `GARDEN`. We may need to
drain and upgrade."**

## Why now (the bug this fixes)
The current predicate `is_main_host()` (common.sh) compares the journal marker `hosts/main-host`
("endolinbot") against the host's `GARDEN_HOST`. The marker's heartbeat (`hosts/endolinbot`) is 5
days stale while `hosts/endolinbot2` is fresh (the running services identify as a different name
than the marker), so on the live host `is_main_host` returns FALSE and **every leader-only
singleton is condition-skipped**: foreman, proxy, issue-inbox, comment-watcher, deadmail, reaper,
follow-up, scheduler, triager, mention-watcher, mentor, mirror-closer, library-source-drift-scan
(13 services, all `ExecCondition=is-main-host.sh`). That is why a maintainer review on
kriskowal/garden #5 was never picked up. The endolinbot/endolinbot2 split + the
`hosts/main-host`/`GARDEN_HOST`/`GARDEN_MAIN_HOST_*` complexity is exactly what the simplification
removes.

## Required change
1. **Leader marker → `journal/leader`** (a single file at the JOURNAL ROOT named `leader`,
   containing the leader host's name). Replace `GARDEN_MAIN_HOST_MARKER_PATH=hosts/main-host`
   with `leader`. Migrate the value (set `journal/leader` to the LIVE host) and remove the
   `hosts/main-host` marker. (Keep `hosts/<host>` heartbeats if the scaler still needs them, but
   the LEADER is `journal/leader`, decoupled from heartbeat file names.)
2. **Host-identity env var → `GARDEN`** (default `hostname -s`). Replace `GARDEN_HOST` everywhere
   with `GARDEN`. Collapse the `GARDEN_MAIN_HOST_*` family (CLONE/CACHE/TTL/MARKER_PATH/DEFAULT)
   to the minimum the new simple scheme needs (a `journal/leader` read + cache is fine; drop the
   redundant override vars or fold into one).
3. **`is_main_host()` becomes:** read `journal/leader`; this host is leader iff
   `leader == $GARDEN` (empty leader ⇒ default-leader, as today). Update `main_host()`/`is_main_host`
   accordingly.
4. **Update every consumer:** common.sh, `is-main-host.sh`, all 13 unit `ExecCondition`/`Environment`
   lines, the heartbeat/scaler writer, `set-gardeners.sh`, `install-units.sh`, and the CLAUDE.md
   bring-up section (which currently documents `GARDEN_HOST`/`hostname -s` uniqueness — restate as
   `GARDEN`). Grep the whole tree for `GARDEN_HOST`, `GARDEN_MAIN_HOST`, `hosts/main-host`,
   `main-host` and convert each.
5. **Cutover:** set `journal/leader` to the host that should lead (the live one with the fresh
   heartbeat) so that, post-deploy, the singletons promote within the marker TTL.

## Then: drain + upgrade (deploy)
This is code on every leader-gated unit, so a restart is required. After it lands on main2:
**drain the fleet, merge main2 into the root checkout, restart all services** (the deliberate-deploy
path) — and set `journal/leader` to the live host. The liaison will run the drain+upgrade once this
lands; the job's deliverable is the code + a clear cutover note (what `journal/leader` should be set
to and the exact restart sequence), NOT the live deploy itself.

## Tests
Assert `is_main_host` true iff `journal/leader == $GARDEN`; empty marker ⇒ leader; a follower
(`$GARDEN != journal/leader`) skips; no remaining references to `GARDEN_HOST`/`hosts/main-host`/the
old `GARDEN_MAIN_HOST_*` names (a grep-gate).

## Deliverable
The leader mechanism simplified to `journal/leader` + `GARDEN`, all 13 services and scripts/docs
converted, a grep-gate proving no old names remain, and a cutover note for the drain+upgrade.

---
claim:
  host: endolinbot2
  gardener: 26
  claimed_at: 2026-06-29T04:54:42Z
