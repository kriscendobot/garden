SturdyRef press tick complete — a holding tick with one substantive act: the overdue maintainer escalation is now sent.

**What I found (all re-verified live via `gh pr view` this tick):**
- The effort is frozen at CI-green-but-unreviewed: endojs/endo-but-for-bots#871 (agent provide/accept surface, bar 2) is an OPEN draft at head `c3fa894c9` with statusCheckRollup 21/21 SUCCESS, zero reviews, zero comments — the panel has never run. The bridge-cut stack (#698 `c19fdd96c`, #700 `e0122dfd7`, #541 `fd60a74b0`) is unchanged since 2026-07-25.
- The sole blocker is maintainer-only: `endo-sturdyref-agent-surface-build-gauntlet` remains parked in `jobs/plan/` with `gate: go-ahead` (amended `handler-timeout: 14000` intact). The go-ahead request of 2026-07-26T23:42Z was still **unread at ~31.6h**, and the planned 24h once-escalation never fired because this job's two prior ticks crashed on ps23 (rc=1 at 00:49Z and 04:54Z).

**What I did:**
- Sent the consolidated once-escalation to the maintainer (`inbox/maintainer/unread/20260728T071714Z-2cdc32`), asking for exactly one act: "go ahead on endo-sturdyref-agent-surface-build-gauntlet".
- Coordinated with the concurrent peer press tick `endo-sturdyref-press-20260728-065010` (live on ps23) via its inbox (`20260728T071752Z-337397`) so it does not double-send.
- Recorded the tick in the journal (`entries/2026/07/28/071818Z-progress-gardener-0e9e0e.md`) with a "do NOT re-escalate" marker for future ticks and next-tick guidance (watch the gauntlet if promoted; hold otherwise, re-surface only at ~72h total silence).

**Confinement property statement:** no project code was pushed, so the invariants stand as last exercised on the green heads — no-location (passStyleOf-opaque sturdyref; enliven mediated by the closely-held OCapN network capability, design #539), no-identification (unlinkable per-guest mints), opaque-and-unforgeable; #871 carries the agent-surface guard/escrow regression tests inside the cited 21/21 rollup. Not re-verified by local execution this tick because nothing changed; bars rest on the CI evidence cited above.

**Follow-ups:** the next hourly tick should watch the gauntlet job if the maintainer promotes it; the recurring ps23 rc=1 press-tick failures (captured outputs `a8dae905…`/`172c1dee…`, unreadable from this host) may deserve a look by a ps23-side worker if they recur.
