---
gate: go-ahead
priority: normal
posted_by: liaison
posted_at: 2026-06-27T16:40:40Z
---

# PLAN: service host-roles — gardeners run everywhere, singletons run only on the "main" host

Map: **build** (garden infra) on the garden's own repo, branch main2. Go-ahead gated —
this changes service topology and can disable services if misconfigured; promote with
"go ahead on service-host-roles-singletons-on-main-host".

## Goal
- **Gardener services run on EVERY host.** Concurrent gardeners across hosts are safe —
  they race-claim jobs via the job board's git-push CAS, which dedups the work. More
  hosts = more gardener concurrency, no duplication.
- **Every OTHER service runs ONLY on the "main" host.** None of the singleton services
  handle concurrent duplicates: two foremen double-pump the milestone, two schedulers
  double-dispatch, two bulletins/deadmail/reaper/follow-up double-post/act, two watchmen
  double-broadcast. So they must run on exactly one host.
- **The "main" host is tracked as STATE in the journal.** Currently `endolinbot` (this
  host) — no other instances are running. Changing main is a journal edit (no automatic
  failover in this plan; see open questions).

## Design
1. **Journal main-host marker.** A journal-tracked value, e.g. `hosts/main-host`
   containing the logical hostname (`endolinbot` now). Single source of truth; read by
   the gate below.
2. **A reusable main-host predicate** (`is-main-host.sh`): reads `hosts/main-host` from a
   synced journal clone and compares to this host's `GARDEN_HOST` / `hostname -s`; exit 0
   if this host IS main, non-zero otherwise. Deterministic, no LLM.
3. **Gate the singleton services on it, dynamically.** Add a systemd drop-in /
   `ExecCondition=` (timer-fired oneshots) — the same mechanism as the foreman pause
   drop-in but keyed on `is-main-host.sh` — so a non-main host's singleton timers fire
   but the service skips (clean condition-failed, never marked failed). For the
   continuous singletons (bulletin, comment-watcher), ExecCondition is checked at start;
   a main-host change needs a restart, so add a small re-check (the watchman/deploy-sync
   already restart services on code change — extend that to restart-or-stop singletons
   when `hosts/main-host` changes).
4. **Gardeners (and the local-pool scaler) are NOT gated** — they run on every host.

## Service classification (the deliverable must enumerate this exactly)
- **Every-host:** `garden-gardener@*`, `garden-gardener-scaler` (each host scales its OWN
  local pool).
- **Main-host-only singletons:** `garden-foreman`, `garden-scheduler`, `garden-bulletin`,
  `garden-deadmail`, `garden-reaper`, `garden-follow-up`, `garden-proxy`, `garden-mentor`,
  `garden-mirror-closer`, `garden-comment-watcher@*`, `garden-mention-watcher`,
  `garden-library-source-drift-scan`.
- **OPEN QUESTION — per-host infra that manages LOCAL host state, NOT shared work:**
  `garden-deploy-sync`, `garden-clone-keeper`, `garden-journal-worktree-keeper`, and the
  ff-half of `garden-watchman` each maintain a host's OWN checkout/clones/worktrees, so a
  second host needs them locally to function — they are NOT main-only. But the watchman's
  BROADCAST-half (telling gardeners main2 advanced) IS duplicate-prone if every host
  broadcasts. Resolve before building: either (a) keep deploy-sync/clone-keeper/
  worktree-keeper per-host and split the watchman into a per-host ff part + a main-only
  broadcast part, or (b) for the single-host present, treat them as main-only and revisit
  when a 2nd host joins. Surface this to the maintainer; do not silently disable a host's
  ability to deploy.

## Initialize for the current reality
Set `hosts/main-host` = `endolinbot` (this host; the only instance). With one host,
behavior is unchanged today; the gate only bites when a second host joins.

## Open questions (for the maintainer)
- **Failover:** this plan tracks main-host as a manual journal value with NO automatic
  failover (if the main host dies, singletons stop until main is re-pointed by hand). A
  follow-on could add lease-based election (a heartbeat + takeover), but that is a
  harder, separate problem — confirm whether manual-main is acceptable for now.
- The per-host-infra classification above (deploy-sync / clone-keeper / worktree-keeper /
  watchman split) — confirm the intended split before a 2nd host exists.

## Tests
Extend run-test.sh: `is-main-host.sh` returns true on the journal-named main host and
false elsewhere (mock `hosts/main-host` + GARDEN_HOST); a gated singleton SKIPS cleanly
on a non-main host and RUNS on main; gardeners run regardless of main-host value.

Deliverable: a journal `hosts/main-host` marker (init `endolinbot`), an `is-main-host.sh`
predicate, singleton units gated on it (with the continuous-service restart-on-change
handling), gardeners ungated, and the per-host-infra classification resolved per the
maintainer's answer.
