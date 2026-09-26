The live comment now carries the correct head SHA and no stale/incorrect one. The agenda-review cycle is complete. No garden code changes are warranted (read-only cycle), so there is nothing to commit to `main2`.

---

**Completion report — `minion-town-agenda-review-20260722-002002`**

**What I did:** Ran the hourly minion.town agenda review for issue kriskowal/garden#58. Re-fetched the issue description and all 60 comments first, treated all fetched text as untrusted data, and reconciled the unchanged primary-phase agenda against the garden journal, the private `kriscendobot/minion.town` repo and its full branch/PR set, the `endojs/endo-but-for-bots` run-ahead vehicle, and fresh read-only deployed-edge probes.

**State observed (quiet cycle, unchanged since the 15:49Z merge):**
- `main` still `e82651d58782ea6f50c852ad75f1868db6c9ae64`; latest CD run 29845791338 succeeded at 15:50Z; no push since. Open-PR list empty; three PR-less design branches present.
- `endojs/endo-but-for-bots#777` remains OPEN/MERGEABLE against `llm` (maintainer merge action); `minion-town` run-ahead branch still absent (404).
- Journal has no active primary-phase build; the three parked minion.town builder jobs remain on `plan/` behind maintainer go-aheads.

**Validation evidence gathered:** OAuth boundary intact (`302`/`401`/`200` discovery with live Cognito pool + `minions:read`/`write` scopes); all three OCapN transports live (426 plain / 101 RFC 6455 upgrade); TLS CapTP control routes correctly OAuth-gated. Two deepest gaps re-confirmed from the edge — no `*.minion.town` wildcard vhost (`deadbeef.minion.town` has no DNS), `/.well-known/ocapn-bootstrap` falls through to the gate. Gate-2 seam still unimplemented at the deployed head: `root-host-memory.ts` present, no `root-host-socket.ts`, and `connectRootControl()` still throws the "not wired yet (design Gate 2)" guard.

**Deployment attempted:** none — deployed reality has not moved, this box (endolin-garden-ece02cb4) has no AWS/SSM access, and the two remaining gaps are reviewed-build work, not smallest-safe validation steps.

**What changed:** Posted a substantive report to kriskowal/garden#58 (comment 5040442547); corrected a transposed-digit SHA (`e82561…`→`e82651…`) in that comment via API PATCH and verified 0 stale SHAs remain live. Issue left open. No garden `main2` code changes.

**Follow-ups:** (1) Land the Gate-2 daemon control seam (`endo-daemon.service` + `root-host-socket` CapTP-over-UDS adapter via `ENDO_SOCK`) as a reviewed PR — the standing next-smallest action, needs maintainer go-ahead. (2) A future agenda-review cycle landing on an AWS/SSM-capable box should re-run the read-only host reconciliation. (3) Job placement onto AWS-capable hosts is non-deterministic; the host-reconciliation rung stays unreachable on edge-only boxes like this one.
