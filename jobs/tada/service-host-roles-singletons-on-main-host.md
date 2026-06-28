Inbox empty. The work is complete. Here is my completion report.

---

## Completion report: `service-host-roles-singletons-on-main-host`

Shipped the multibot leader/follower topology (issue kriskowal/garden#11) to `main2` in commit `edc78369b`. **Gardeners run on every host; singleton services run only on the leader host** named by the journal marker `hosts/main-host`.

### What I did

**Core mechanism (`scripts/jobs/common.sh`)**
- Added the **`GARDEN` host-identity knob**: `: "${GARDEN:=$(hostname -s)}"; : "${GARDEN_HOST:=$GARDEN}"`. `GARDEN_HOST` stays the internal name every script already uses, so this is one assignment, not a rename. An operator exports `GARDEN=endolinbot2` to spawn a parallel pool from a worktree without touching the Dockerfile.
- Added `main_host` / `is_main_host` helpers: read the journal marker into a dedicated clone, TTL-cache it (30s) to avoid hammering the journal per ExecCondition, fall back to the stale cache on a journal outage, and fail **open** (leader) when wholly undeterminable so single-host behavior is unchanged.

**New scripts** — `is-main-host.sh` (the predicate as a systemd `ExecCondition`, exit 0=leader/1=follower) and `set-main-host.sh` (CAS-writes `hosts/main-host`; manual leader, no failover).

**Gating** — `ExecCondition=is-main-host.sh` on 13 timer-fired singleton services (foreman, scheduler, deadmail, reaper, follow-up, proxy, mentor, mirror-closer, comment-watcher@, mention-watcher, **triager@**, **issue-inbox**, library-source-drift-scan). A follower's timer fires but skips cleanly; each firing re-evaluates so promotion/demotion needs no restart. The **bulletin** (continuous) and the **watchman reread broadcast** gate `is_main_host` in-process (watchman's ff/maintenance half stays every-host). Gardeners + local-infra stay ungated.

**Docs** — liaison stand-up/stand-down vocabulary + leader-only Monitor; CLAUDE.md "Leader and follower hosts" section + `GARDEN` in bring-up step 1; `designs/multibot-leader-follower.md`.

**Marker init** — wrote `hosts/main-host=endolinbot` to journal2; verified the live predicate classifies `endolinbot`→leader, `endolinbot2`→follower.

**Tests** — `test/main-host-test.sh` (39 assertions, all pass) + `run-test.sh` SUBTEST 28 (passes). Full suite: 239 passed, 2 failed — the 2 are the **pre-existing** `issue-source-gh` PATH-shadow flake (that handler sources common.sh, which prepends the fleet `gh` wrapper ahead of the test's stub; unrelated to my change, triggered only by running inside the live garden root).

**Issue comment** — posted to issue #11 mapping all eight points to what shipped (#issuecomment-4826919751).

### Decisions / follow-ups
- **Extended gating to `triager@` and `issue-inbox`** beyond the plan's enumerated list, by the same producer-double-post logic as the listed comment/mention watchers. Flagged on issue #11 for the maintainer to confirm or reverse; `unblock` and `repo-watcher` left every-host.
- **No automatic failover** (manual leader per issue point 4); lease-based election is a noted harder follow-on.
- The marker only "bites" once a second host joins — today, single-host `endolinbot` behavior is unchanged.

Worktree torn down; no leftover state.
