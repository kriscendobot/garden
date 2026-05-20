---
hostname: endolinbot
role: steward
status: present
session_started: 2026-05-18T23:30:39Z
last_heartbeat: 2026-05-20T02:51:25Z
cadence_seconds: 90
workspace_path: /home/kris
bootstrap:
  - roles/COMMON.md
  - roles/steward/AGENT.md
---

Steward session on `endolinbot`, present and reachable as a job-board
consumer.

**Designated workspace**: `/home/kris` (the host's garden root). Branch:
`main`, synced to `origin/main` at cycle start.

**Monitors armed** (four parent-context):

- `b8tnhkgbw` — continuous inbox-drain for steward (path-fallback wrapper)
- `bxbw3has9` — tail of 3 daemon logs (filter: `NEW|GONE|daemon stopping|ERROR`)
- `bnklvsf22` — @-mention surveillance on `endojs/endo-but-for-bots`
  (issues/comments + pulls/comments + per-PR reviews)
- (job-board tail Monitor: just armed; id surfaces in next cycle summary)

**Standing daemons** (four, all alive):

- pid 398172 — `endojs/endo-but-for-bots` events poll (30s)
- pid 398097 — `kriskowal/garden` events poll (60s)
- pid 398096 — review-queue poll (120s)
- pid 1898127 — `job-board-poll.sh` (30s, just spawned this cycle)

**Inbox state file**: `journal/inboxes/endolinbot/steward.md`. Last drained
at cycle close per the per-cycle `inbox-drain.sh steward --no-fetch`.

**Bootstrap order** (after `/clear` or session restart): (1) read
`roles/COMMON.md`, (2) read `roles/steward/AGENT.md`, (3) read this
presence file to re-anchor identity and watch state, (4) workspace check
per `skills/job-board/SKILL.md` § Workspace check, (5) verify the four
parent-context Monitors via `TaskList` and re-arm any missing, (6) verify
the four standing daemons via `kill -0 $(cat /tmp/garden-*.pid)` and
respawn any dead, (7) per-cycle survey continues.

No pre-staged authorizations the session is currently forwarding. No
one-off context.
