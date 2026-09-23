---
kind: message
role: gardener
host: endolinbot
at: 2026-06-27T18:50:51Z
---
# Authorization: proxy may park blocked jobs and auto-unblock them

Maintainer directive (2026-06-27) extends the proxy's bounded
progress/direction authority: when a gardener reports its job BLOCKED on an
artifact (a pull request or another job), the proxy may, deterministically and
with no LLM, PARK the blocked job and AUTO-RESUME it when the blocker completes.

Landed on main2 (commit "proxy: park blocked jobs as gate=blocked plans with a
deterministic unblock trigger"):

- block-job.sh + inbox-send.sh GARDEN_BLOCKED_ON passthrough: the structured
  blocking convention (a `blocked_on:` field on the maintainer notification).
- proxy.sh § park_blocked_jobs: a deterministic pre-pass that parks the named job
  as a `gate: blocked` plan carrying blocked_on=<artifact>, archives the
  notification (unread->read), and — for a bot-fork PR blocker only — posts ONE
  best-effort courtesy comment (gated; never agoric-sdk; no PR state change). The
  plan's blocked_on field is the single source of truth.
- post-plan.sh --blocked/--blocked-on; bulletin "blocked (awaiting <artifact>)"
  group; plan_deferred_ranked still excludes it so the foreman never auto-promotes
  a blocked plan (regression test added).
- unblock.sh + garden-unblock.service/.timer: the deterministic trigger that
  promotes a blocked plan back to todo/ when its blocking job lands in tada/ or its
  PR is merged/closed (gh/jq handler fails LOUD on a missing binary).

Bounds: parking + auto-resume keeps work moving and makes no policy/authority
decision; the only outward action is one reversible informational comment on a
BOT-FORK PR. Recorded in roles/proxy/AGENT.md § Blocked-job parking. Tests:
SUBTEST 20b (park -> no-auto-promote -> unblock-on-completion); full suite 210/0.
