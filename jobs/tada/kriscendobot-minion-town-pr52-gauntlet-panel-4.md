The panel round 4 completed and its verdict is posted. Here's my report.

---

**Panel round 4 — kriscendobot/minion.town PR #52 — complete.**

**Disposition: must-fix** (panel.sh exited rc=0; a clean decision, not a stage failure).

What I did:
- Resolved the PR head (`kriscendobot:feat/daemon-sites-exo`, base `main`) and ran the single-round code panel against an isolated project worktree of the head.
- **Recovered from repeated infrastructure teardown.** The claiming session was reaped 4 times (and the press was paused ~1 day mid-run per issue #58). The panel is a long (~28-seat) fan-out that ran as a child of the claude session, so each reaper teardown killed the whole process tree, leaving a 0-byte result. I relaunched it under a **transient `systemd --user` unit** (`panel-pr52-r4.service`) so it ran in its own cgroup, independent of the session, and survived subsequent teardowns.
- **Rode out a transient model outage.** An early run hit widespread empty-verdict responses (5 seats exhausting 3/3 attempts with empty stdout/stderr — the transient-overload signature). I relaunched with `GARDEN_PANEL_SEAT_ATTEMPTS=6`, `GARDEN_PANEL_SEAT_BACKOFF=10`, `GARDEN_PANEL_CONCURRENCY=5` (lower burst load). That run completed cleanly: **all 28 seats `ok`**, 632-line aggregate.
- Posted the aggregate as a `gh pr review --comment` (COMMENTED state — the bot is the PR author, so APPROVE/REQUEST_CHANGES are disallowed; this matches the round-1/2/3 shape the next-stage heuristic reads), header `## Panel verdict — round 4: **must-fix**`.

Headline findings (all cite the pinned daemon, not the PR's prose): two **must-fix** daemon-facet bugs from the assessor — `daemon-site-registry.ts` endows the mail *Handle* facet instead of the directory agent (`provideHost(storeName)` with no `agentName`), so every exo store call and the guest `evaluate`/`lookup('@self')` path throw; plus stylist/typist must-fix items (freshly-abbreviated identifier; declared-supertype-plus-recovery-predicate casts). Several should-fix items: orphan registration on partial write, an over-broad "cannot occur" safety claim that survives the flag flip, and O(all-sites) serial CapTP round-trips in `list(owner)`.

Follow-ups: none for this stage — it stops here by design. The gauntlet driver should advance to a **fix** stage on this must-fix verdict. Cleaned up the transient systemd unit.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr52-gauntlet-panel-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 6 on 1 host(s)
- Input: 110 tokens (5190228 cached reads)
- Output: 31666 tokens
- Cost: $6.469698
- Wall-clock: 1377s
- Model(s): claude-opus-4-8 ×6

<!-- garden-usage-end -->
