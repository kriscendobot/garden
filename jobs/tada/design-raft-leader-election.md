The PR is clean — exactly two files (the new design + the index row), 455 additions, 0 deletions, base `main2`, head on the fork. Done.

---

## Completion report

**Job:** `design-raft-leader-election` — propose a design-only PR for RAFT leader election over journal2 at a half-hour cadence, adapting `kriskowal/cask`.

**Delivered:** PR **[kriskowal/garden#14](https://github.com/kriskowal/garden/pull/14)** — `design(raft-leader-election)`, base `main2`, head `kriscendobot:design/raft-leader-election`. Adds `designs/raft-leader-election.md` (Status: Proposed) plus its `designs/README.md` index row. Clean diff: 2 files, +455/-0, no source/behavior change.

**What the design covers (all five required items):**
1. **RAFT ↔ journal2 mapping** — I studied cask's actual `go/raft/` and found it's an *election-only* RAFT (term + RequestVote/Vote/Heartbeat + majority quorum, **no command-log replication**), which is exactly the garden's need. The doc expresses `currentTerm`/`votedFor`/leadership-grant-log as journal2 files under `raft/`, and the three RAFT messages as records serialized by the existing push-to-`origin/journal2` CAS. Explicit transport analogy table: cask's 1KB-block-CAS ↔ git-CAS; UDP heartbeats ↔ periodic `raft/heartbeat` bumps; RFC 6298 retransmission (cited from the scholar's library note) ↔ the garden's `backoff()` on a rejected push.
2. **Half-hour cadence, justified** — concrete tunables (tick 5 min, heartbeat 10 min, election timeout randomized [30,50] min, lease 20 min) preserving cask's ratios scaled ~6000×, justified by the singleton-only blast radius and journal-contention budget; worst-case failover ≈ one election timeout stated and defended.
3. **Safety (no two leaders)** — one-vote-per-term via the durable ledger, term monotonicity via CAS, and a **lease-aware `is_main_host`** with the inequality `L < Te_min − Tt` proving an old leader's singletons go quiet *strictly before* any new leader can start; lost-CAS-race = dropped-packet analogue with backoff. Also handles clock-skew safety via a monotone heartbeat `seq` observed against each host's own local clock.
4. **Membership** — explicit `raft/members/` voter roster (operator-admitted, cask's manual-trust-root model), dead-host removal to unwedge quorum, and an honest call-out that today's 2-host fleet is quorum 2/2 (no single-fault failover until a 3rd voter).
5. **Integration + migration** — keeps `hosts/main-host` + `is-main-host.sh` as the committed output (only a lease-freshness clause added), `set-main-host.sh` degrades to seed/break-glass, the tick runs as an **every-host** timer (called out explicitly), phased shadow→commit→fault-tolerant rollout with no flap.

**Process note (one self-correction):** the harness completion convention had me push the commit to `main2` first; on recognizing the job is a *design-only PR* governed by the design-only-PR workflow (and matching the existing open design PRs #6/#7: head `design/*` on the fork, base `main2`, commit not pre-landed), I lease-guard-reverted `main2` back to its prior tip (`f5c73a78e`, safe — only my single doc commit was on top, nobody had pushed after me) and redid it as the proper PR. No other branch state touched. Inbox drained clean throughout.

**Follow-ups (deferred in the doc, noted for the maintainer):** add a 3rd voter before relying on hands-off failover (the 2-of-2 quorum problem); joint-consensus membership change, RAFT pre-vote, and heartbeat/vote-record GC are listed as future refinements. Implementation is out of scope for this PR by design.
