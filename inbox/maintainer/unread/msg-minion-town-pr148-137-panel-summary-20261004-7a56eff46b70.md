from_host: endolin-garden-ece02cb4
from: gardener:minion-town-pr148-137-panel-summary-20261004
reply_to: minion-town-pr148-137-panel-summary-20261004
msg_key: msg-minion-town-pr148-137-panel-summary-20261004-7a56eff46b70
notice_count: 1
first_seen: 2026-10-04T04:55:46Z
last_seen: 2026-10-04T04:55:50Z
sent_at: 2026-10-04T04:55:50Z
---
# minion.town kriscendobot/minion.town#137 → kriscendobot/minion.town#148: merge decision for the Claude CLI rollout

Merge order is kriscendobot/minion.town#137, then kriscendobot/minion.town#148. To unblock `minion-town-claude-cli-production-20261003`, which halted at the kriscendobot/minion.town#148 conduct child with the canary parked: (1) approve and merge kriscendobot/minion.town#137; (2) re-review kriscendobot/minion.town#148 to clear your CHANGES_REQUESTED, then un-draft and merge it; (3) before the canary enables production, record on kriscendobot/minion.town#149 that you accept the root-socket relay leftover. After that the orchestration needs a re-posted kriscendobot/minion.town#148 conduct, or the canary promoted.

## kriscendobot/minion.town#137 — fix(deploy): reap the endo-daemon port orphan (https://github.com/kriscendobot/minion.town/pull/137)
- Correction to the job's premise: kriscendobot/minion.town#137 never ran a gauntlet. It has **no panel coverage**; it did not reach its review budget. CI is green at `dbed712`, and it is 1 commit across 5 files. Main is 44 commits ahead, but none of them touch kriscendobot/minion.town#137's files, so it applies cleanly.
- From my own read of the diff (not a panel):
  - **follow-up-worthy:** the reaper kills *any* process listening on :8920 without checking its owner. Today only the daemon uses that port, but filtering to the `endo-daemon` uid is a one-line hardening.
  - **follow-up-worthy:** kriscendobot/minion.town#139 (`6a3555d`, on main) traced the 09-29 wedge to a stray daemon auto-started by the probe, and it already reaps strays at deploy time. kriscendobot/minion.town#137's "PID-1 orphan after cgroup teardown" diagnosis was never confirmed. What kriscendobot/minion.town#137 adds on top of kriscendobot/minion.town#139 is a reap before *every* start (`Restart=on-failure`, manual restarts) and stop→reap→start in place of a bare restart. That makes it cheap defense-in-depth rather than the root fix.
  - **taste:** the new ExecStartPre comment sits between the existing yarn comment and `ExecStart`, so that comment no longer sits next to the line it describes. The unrelated `minion-git-remote` `HOME=` change rides along in a fix PR.
  - kriscendobot/minion.town#130, open and not a draft, also edits step 4g. Whichever merges second needs a small rebase.
- **Bottom line: merge as is.** Low risk, and it removes a restart wedge that could hit the canary's pin-bump restart. The uid filter can be a follow-up.

## kriscendobot/minion.town#148 — feat(claude): confined inference via the Claude CLI backend (https://github.com/kriscendobot/minion.town/pull/148)
- **Panel coverage: stale.** Round 6 (8 request-changes / 9 comment-only / 15 approve; round 1 was 13/11/9) reviewed `dea0146`. The head is now `7c08ffa`, 5 commits later, and those commits were never reviewed. Two of them are substantive: `533aabb` puts children under per-caller child hosts (a capability-structure change) and `f36cae1` moves token files to tmpfs. CI is green at `7c08ffa`. The PR is 6 behind main and mergeable.
- **Your review:** a panel seat confirmed Botese is clean (thesaurus approved in round 6). The duplicated daemon code is gone: the local relay and `captp-client.ts` were removed, and kriscendobot/minion.town#148 now uses the daemon-exported `makeEndoClient` and `endo-mcp-stdio` over the daemon socket. Your one inline thread (`unknown` → `PromiseLike<unknown>`, `086797f`) has a reply but is still unresolved.
- Objections still open after round 6:
  - **must-fix (small):** saboteur found a has-then-make race in `ensureDirectory` (`claude-guest-bridge.ts:145`), and it is still at head. The daemon's `makeDirectory` overwrites, so two concurrent first creates can orphan a child binding. That under-counts quota, and `removeChild` then silently does nothing. Fix: memoize per path.
  - **must-fix (gate):** the 5 unreviewed commits since `dea0146` need one panel round or your own read before merge.
  - **follow-up-worthy (production gate, not merge):** locksmith's root-authority finding is only half closed. Children no longer have root as `@host`, but the `endo-mcp-stdio` relay still gets the root socket and narrows to the guest only by `ENDO_GUEST_FORMULA_ID`. Fully closing it needs an upstream guest-scoped bootstrap (kriscendobot/minion.town#149). Production stays off until you accept this or upstream lands.
  - **follow-up-worthy (deferred by the fixer):** make `activate` required (if a store omits it, the pending gate is skipped; this one is small and could go with the race fix); a process-wide spawn ceiling (today it is 2 × subjects); eviction for the `minted`/`fullIdentifiers` maps; merging the `ClaudeBridgeHost`/`DaemonHost` types; production env overrides that skip the pin gate; reconnect putting working agents into needs-auth during the probe; and type/README gaps in the vendored `@endo/claude` (deferred because the vendored copy is kept byte-identical to upstream).
  - **taste/noise:** the "probe must remain draft" pre-pass. It is structural, no fix loop can clear it, and it is why the gauntlet could never converge. Also the PR-body word count, scribe's missing-summary notes (summaries posted since), and the formatter churn (reverted).
- **Bottom line: merge after a named small fix.** Memoize `ensureDirectory` (and, ideally, make `activate` required), then either one panel round on the new head or your own review of `533aabb`…`7c08ffa`. It does not need a redesign. Production enablement still needs your kriscendobot/minion.town#149 acceptance.
