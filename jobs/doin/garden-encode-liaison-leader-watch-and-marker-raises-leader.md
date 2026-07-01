# Encode: every liaison watches the leader marker; changing it RAISES the new leader
Maintainer directive (kriskowal, 2026-07-01): make leadership transfer a standing, self-raising contract.
Encode in **CLAUDE.md** (the leader/follower + stand-up sections) AND **roles/liaison/AGENT.md**
(§ Stand up / stand down):
1. **Every liaison, on every host, runs a STANDING MONITOR watching the journal leader marker** (the
   journal-root `leader` file that `set-main-host.sh` writes and `is-main-host.sh` reads). It is the
   follower's half of the leader/follower contract — a follower liaison must have this watch armed.
2. **When the marker names the liaison's OWN host** (its `GARDEN` identity), that liaison **stands up
   as leader** per the CLAUDE.md stand-up procedure: arm the maintainer-inbox Monitor + the
   deploy-on-upgrade Monitor; the leader-only singletons auto-start (is-main-host → exit 0). If the host
   is to run gardeners, lift any drain.
3. **Changing the designated leader (`set-main-host.sh <host>`) has the effect of RAISING the new
   leader** — because the new leader's standing watch observes the marker change and stands itself up.
   Document this explicitly so whoever runs `set-main-host` understands designating a leader = raising it.
4. **Handoff contract:** the outgoing leader **drains** (`drain-fleet.sh on`) and **stands down** its
   leader Monitors, then the marker is re-pointed (`set-main-host.sh <new>`), which raises the new leader
   via its watch. (This is the manual-designation-with-standing-watch mechanism; relate it to
   `designs/…raft-leader-election` — the future automatic-election evolution — but this watch-raises-leader
   contract is what's live now.)
Keep the marker note: the authoritative marker is the `leader` file; `hosts/main-host` is stale legacy
cruft the predicate no longer reads. Land on `main2` via an isolated worktree off origin/main2; keep the
edits short and consistent with the existing multibot/deliberate-deploy prose.

---
claim:
  host: endolinbot2
  gardener: 1
  claimed_at: 2026-07-01T22:43:53Z
