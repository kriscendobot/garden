<!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-06-28T17:31:12Z -->

# PLAN: multibot leader/follower — gardeners run everywhere, singletons run only on the "leader" host

Map: **build** (garden infra) on the garden's own repo, branch main2. Go-ahead gated —
this changes service topology and the host-identity knob and can disable services if
misconfigured; promote with "go ahead on service-host-roles-singletons-on-main-host".

> **Expanded 2026-06-28 to cover all eight points of issue kriskowal/garden#11
> ("Multibot").** The original plan (below) already covered the topology: gardeners on
> every host, singletons on one host, a journal-tracked marker, and condition-gating with
> restart-on-change. This expansion (a) reconciles the issue's **leader/follower**
> vocabulary with this plan's **main-host/singleton** vocabulary, (b) adds the **`GARDEN`
> host-identity env knob** (issue points 3, 6, 7), (c) adds the **liaison stand-up
> verification + stand-down/drain vocabulary** (issue points 1, 6, 8), and (d) answers
> the open questions using the issue's guidance. The build MUST comment its completion
> back on the issue — see the ISSUE NOTE at the bottom.

## Terminology (issue ↔ this plan)
The issue says **leader** / **follower**; this plan said **main host** / non-main host,
and **singleton service** for a service that must run on exactly one host. They are the
same thing — adopt the issue's words in operator-facing surfaces (CLAUDE.md, the liaison
role) and keep the predicate name stable in code:
- **leader host** = the one host whose `GARDEN` identity matches the journal marker; runs
  the singletons. (was "main host")
- **follower host** = any other host; runs only the gardener pool. (issue point 2)
- **singleton service** = a service that must run on exactly one (the leader) host.

## Goal
- **Gardener services run on EVERY host** (leader and follower alike). Concurrent
  gardeners across hosts are safe — they race-claim jobs via the job board's git-push
  CAS, which dedups the work. More hosts = more gardener concurrency, no duplication.
  (issue point 2: a follower container runs **only** the gardener systemd processes.)
- **Every singleton service runs ONLY on the leader host.** None of the singletons handle
  concurrent duplicates: two foremen double-pump the milestone, two schedulers
  double-dispatch, two bulletins/deadmail/reaper/follow-up double-post/act, two watchmen
  double-broadcast, **two liaison maintainer-inbox monitors double-answer** (issue
  point 1). So they must run on exactly one host.
- **The leader host is tracked as STATE in the journal** (issue point 4). Currently
  `endolinbot` — no other instances are running. Changing the leader is a journal edit
  (manual; no automatic failover — see Open questions, now answered).

## Design
1. **Journal leader marker.** A journal-tracked value `hosts/main-host` containing the
   leader's logical `GARDEN` identity (`endolinbot` now). Single source of truth; read by
   the predicate below. (issue point 4. Keep the path name `hosts/main-host` for code
   stability; it holds the leader identity.)
2. **The host-identity knob is `GARDEN`** (issue points 3, 6, 7). Today `common.sh` derives
   `GARDEN_HOST` from `hostname -s`. Introduce **`GARDEN`** as the canonical knob and make
   `GARDEN_HOST` default to it: `: "${GARDEN:=$(hostname -s)}"` then
   `: "${GARDEN_HOST:=$GARDEN}"` (keep `GARDEN_HOST` as the internal name every script
   already uses, so the change is one assignment, not a repo-wide rename). This lets an
   operator **check out a worktree and spawn a parallel gardener pool without touching the
   Dockerfile** — they just export `GARDEN=endolinbot2` (issue point 7). The kernel
   hostname stays fixed at container creation; `GARDEN` is the lighter, per-invocation
   override (issue point 6's `GARDEN=endolinbot2` example).
3. **A reusable leader predicate** (`is-main-host.sh`): reads `hosts/main-host` from a
   synced journal clone and compares to this host's `GARDEN` (via `GARDEN_HOST`); exit 0
   if this host IS the leader, non-zero otherwise. Deterministic, no LLM. This is the
   "am I leader or follower?" check every mode-aware service consults.
4. **Gate the singleton services on it, dynamically — the follower/leader two-mode
   behavior (issue point 5).** Add a systemd drop-in / `ExecCondition=` (timer-fired
   oneshots) keyed on `is-main-host.sh`, the same mechanism as the foreman pause drop-in —
   so a **follower's** singleton timers fire but the service skips cleanly
   (condition-failed, never marked failed): that IS "follower mode — watch the journal and
   wait until promoted." For the continuous singletons (bulletin, comment-watcher,
   maintainer-inbox monitor), `ExecCondition` is checked at start; promotion/demotion on a
   marker change needs a restart, so add a small re-check that **demotes a running
   singleton to follower when `hosts/main-host` no longer matches this host's `GARDEN`**
   (issue point 5: "in leader mode they also follow the journal and demote themselves to
   follower if their hostname no longer matches"). The watchman/deploy path already
   restarts services on code change — extend it to restart-or-stop singletons when
   `hosts/main-host` changes.
5. **Gardeners (and the local-pool scaler) are NOT gated** — they run on every host.

## Liaison stand-up / stand-down vocabulary (issue points 1, 6, 8)
The build also lands the operator-facing surface in `roles/liaison/AGENT.md` and the
top-level `CLAUDE.md` § Job system:
- **Stand-up aliases** — "**start**", "**resume**", "**stand up**" the garden's services.
  On any of these the liaison MUST **verify the hostname/`GARDEN` identity is unique**
  across running instances before bringing units up (the existing bring-up step-1
  uniqueness check, now reinforced and tied to `GARDEN`), and SHOULD offer the
  `GARDEN=endolinbot2` env override when the name collides or is a default (issue point 6).
  Only the **leader** runs the liaison maintainer-inbox Monitor — a follower stand-up
  brings up the gardener pool only (issue point 1).
- **Stand-down aliases** — the liaison recognizes "**stand down**", "**drain**", "**stop
  the garden**", "**halt the garden**", "**shut down the garden**" as the dual of
  standing up (issue point 8). These map to the existing graceful path
  (`scripts/jobs/drain-fleet.sh on` to drain the local pool; stopping/disabling the units
  to fully halt). Encode the alias set so any of the phrasings is honored.

## Service classification (the deliverable must enumerate this exactly)
- **Every-host (leader + follower):** `garden-gardener@*`, `garden-gardener-scaler` (each
  host scales its OWN local pool).
- **Leader-host-only singletons:** `garden-foreman`, `garden-scheduler`, `garden-bulletin`,
  `garden-deadmail`, `garden-reaper`, `garden-follow-up`, `garden-proxy`, `garden-mentor`,
  `garden-mirror-closer`, `garden-comment-watcher@*`, `garden-mention-watcher`,
  `garden-library-source-drift-scan`, and the **liaison maintainer-inbox Monitor** (issue
  point 1 — only one liaison watches its inbox, on the leader).
- **Per-host infra that manages LOCAL host state (RESOLVED below):**
  `garden-deploy-sync`/upgrade-monitor, `garden-clone-keeper`,
  `garden-journal-worktree-keeper`, and the ff-half of `garden-watchman`.

## Open questions — now ANSWERED by issue #11
- **Failover:** issue point 4 says the leader is "designated by a file in the journal,"
  changed manually — so **manual leader, NO automatic failover** is the accepted model for
  this build (if the leader dies, singletons stop until `hosts/main-host` is re-pointed by
  hand). Lease-based election stays a separate, harder follow-on.
- **Per-host infra vs. "followers run only gardener processes" (issue point 2):** there is
  a real tension — a follower still needs to maintain its OWN checkout/clones/worktrees to
  function, yet issue point 2 says a follower runs "only the gardener's systemd
  processes." **Resolution for the build:** classify deploy-sync/upgrade-monitor,
  clone-keeper, and worktree-keeper as **local-infra (every-host)** — they are not shared
  work and do not duplicate across hosts; they are part of what makes a host able to run
  gardeners at all, so they fall under the spirit of point 2 (a follower's non-gardener
  units do no *shared* work). **Split the watchman** into a per-host ff/maintenance part
  (every-host) and a leader-only broadcast part (telling gardeners main2 advanced), since
  every-host broadcast IS duplicate-prone. **If the build judges this reading wrong, it
  comments the question back on issue #11 rather than silently disabling a follower's
  ability to deploy.**

## Initialize for the current reality
Set `hosts/main-host` = `endolinbot` (this host; the only instance, its `GARDEN`
identity). With one host, behavior is unchanged today; the gate only bites when a second
host joins.

## Tests
Extend `run-test.sh`: `is-main-host.sh` returns true on the journal-named leader and false
elsewhere (mock `hosts/main-host` + `GARDEN`/`GARDEN_HOST`); a gated singleton SKIPS
cleanly on a follower and RUNS on the leader; gardeners run regardless of marker value;
`GARDEN` overrides `hostname -s` and `GARDEN_HOST` defaults to it; the liaison
stand-up/stand-down alias sets resolve to the verify+bring-up and drain/halt paths.

Deliverable: the `GARDEN` host-identity knob in `common.sh`; a journal `hosts/main-host`
marker (init `endolinbot`); an `is-main-host.sh` predicate; singleton units gated on it
with the leader↔follower restart/demote-on-change handling; gardeners ungated; the
liaison stand-up-verify + stand-down/drain vocabulary landed in `roles/liaison/AGENT.md`
and `CLAUDE.md`; the per-host-infra classification resolved as above. A **completion
comment posted back on issue #11**, mapping each of the eight points to what shipped.

----- ISSUE NOTE (copy this block VERBATIM into any follow-on job) -----
issue_spine: issue-kriskowal-garden-11
issue_url: https://github.com/kriskowal/garden/issues/11
submitter: kriskowal
----- END ISSUE NOTE -----
