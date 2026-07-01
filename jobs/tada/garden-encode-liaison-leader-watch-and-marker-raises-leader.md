Empty inbox. Work is complete and pushed.

## Completion report

**Job:** `garden-encode-liaison-leader-watch-and-marker-raises-leader` — encode the standing "watch-raises-leader" leadership-transfer contract.

**What I did:** Edited two files in this worktree and landed one commit (`ac5cf6273`) on `main2` (pushed first try, no rebase needed).

**`CLAUDE.md`** (§ Bringing up local systemd services, § Leader and follower hosts, § Deliberate deploy):
- Added a new bring-up **step 5** — *every host's* liaison runs a standing Monitor watching the journal `leader` marker; renumbered the old steps 5→6, 6→7, 7→8 and fixed the "bring-up step 7 → step 8" cross-reference in the deploy section.
- In § Leader and follower hosts, expanded "How the gate works" to name `leader` as the **authoritative marker** and `hosts/main-host` as stale legacy cruft the predicate no longer reads; added a **"Every liaison watches the marker; changing it RAISES the new leader"** bullet; reworked "Designating the leader" to state that `set-main-host.sh` raises the new leader via its standing watch and to point at the multibot design's lease-based/automatic-failover follow-on; added a **"Handoff contract"** bullet (outgoing leader drains + stands down its Monitors, then the marker is re-pointed).

**`roles/liaison/AGENT.md`** (§ Stand up / stand down):
- Added the marker note (authoritative `leader`, legacy `hosts/main-host`) to the intro.
- Added a standing **"Watch the leader marker on every host"** bullet: on the marker naming this host's own `GARDEN`, the liaison stands itself up as leader (arm maintainer-inbox + deploy-on-upgrade Monitors; singletons auto-start; lift any drain).
- Rewrote the "designate the leader" bullet ("designating a leader *is* raising it") and added a **"hand off leadership"** bullet describing the drain-then-stand-down-then-re-point sequence, relating both to the automatic-election future evolution.

**Notes / follow-ups:** The job's referenced `designs/…raft-leader-election` doesn't exist under that name; the live artifact is `designs/multibot-leader-follower.md` § Designating the leader, which frames the future automatic-failover as "lease-based election," so I linked there and called it the "lease-based / automatic-election" evolution rather than inventing a raft filename. No code/script changes were required — the mechanism (marker file, `is-main-host.sh`, `set-main-host.sh`, `ExecCondition=` gating) already exists; this job only encodes the standing-watch contract in the two prose surfaces as specified.
