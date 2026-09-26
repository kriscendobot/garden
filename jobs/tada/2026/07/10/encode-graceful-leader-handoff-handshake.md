Inbox empty. Work complete.

## Completion report

Documented the incoming-initiated, confirmed leader-handoff handshake per the maintainer directive (kriskowal, 2026-07-10). Committed and pushed to `main2` as `7df1f01d1`.

**Files touched:**
- `context/operations/leader-follower.md` — replaced the old leader-initiated "clean handoff contract" with three subsections: (1) *the marker-gating reconciliation* making explicit that systemd singletons are `ExecCondition=`-gated and flip atomically when the marker moves, so only the two liaison Monitors (maintainer-inbox + deploy-on-upgrade) need manual stand-down; (2) *the incoming-initiated, confirmed 5-step handshake* as the primary form, with the no-two-Monitors invariant; (3) *the dead-leader fallback* reducing to manual designation with the "manual, no automatic failover" statement kept.
- `roles/liaison/AGENT.md` § Stand up / stand down — expanded the "hand off leadership" bullet to also recognize **"assume leadership"** vocabulary, name the 5-step handshake, carry the one-line invariant, and point to the context page (contract lives in one place, not duplicated).

**Notes:**
- Followed em-dash-style (my authored prose is em-dash-free) and no-latin-shorthand ("for example" instead of `e.g.`). The 6 pre-existing em-dashes in unedited sections were left per fix-on-encounter scope.
- Mid-job correction: my initial Read/Edit calls accidentally targeted the deployed garden root (`/home/kris/garden2`) instead of this job's worktree. I verified the deployed root was at an *older* deployed sha (688e617) whose versions of my two edited regions were byte-identical to origin/main2, captured my edits as a patch, reverted only the two files in the deployed root (leaving its pre-existing `garden` change untouched), and re-applied the patch cleanly to the worktree before committing. No stray changes were left in the deployed root and nothing was pushed from there.

**Follow-ups:** none.
