from_host: endolin-garden-ece02cb4
from: gardener:reconcile-gardener-alias-retirement-gate-20260916
reply_to: reconcile-gardener-alias-retirement-gate-20260916
msg_key: msg-reconcile-gardener-alias-retirement-gate-20260916-70e30735a192
notice_count: 1
first_seen: 2026-09-16T05:58:26Z
last_seen: 2026-09-16T05:58:27Z
sent_at: 2026-09-16T05:58:27Z
---
Reconcile of the retirement-gate-1 failure for `retire-gardener-worker-kind-alias`.
I re-gathered evidence on this host (endolin-garden-ece02cb4, the current LEADER)
and checked the shared journal fleet-wide. NET: retirement is still correctly
blocked — but the real blocker is a THIRD host the original plan never accounted
for. I changed no code, journal state, or units, and did NOT requeue the cleanup.
Requeuing now would just re-fail gate 1 (it already exhausted its 5 requeue cycles).

Re-verified findings on THIS host (endolin-garden-ece02cb4):
- `.garden-state/gardeners/` holds 100 legacy `*.garden` identity markers + a
  `backend/{state,status}` probe-cache. Newest marker `1.garden` is
  2026-08-31T02:10:35Z (= container recreate; content is the current host name).
  (garden2 had 101 — different host, so a slightly different count is expected.)
- Legacy `garden-gardener@1.service`: loaded, INACTIVE, dead (only @1 is present
  here, not @1..4).
- Monk count: the host declares `monks: 3` and `garden-monk@1..3` are enabled +
  active. NO mismatch on this host. The "declares 4 / only 1..3 active" finding
  was garden2-specific and is now stale (the leveler has since moved garden2 to
  `monks: 2`).

Are the markers dead / read by anything? Partly:
- `<id>.garden` is a per-worker IDENTITY marker written by gardener.sh at every
  spawn to `$GARDEN_STATE/<state_ns>/<id>.garden`, read by the scaler's
  identity-drift guard. For the `monk` kind state_ns=monks, so live monks write
  `.garden-state/monks/*.garden` (confirmed fresh today). The `gardeners/*.garden`
  markers belong to the `gardener` kind (state_ns=gardeners).
- On endolin-garden hosts no `gardener`-kind worker runs, so those markers are
  dead residue LOCALLY. BUT they are NOT globally dead — see the blocker below.
- I therefore did NOT delete them. On a monk host they are harmless, and marker
  removal is the retirement cleanup's own gated responsibility (it plans to remove
  them on both endolin hosts as host-side cleanup), not a side effect of a reconcile.

Monk count reconciliation: nothing to reconcile here (3 == 3), and the declared
count is BUDGET-LEVELER-OWNED (live pool anthropic:endolin-garden-ece02cb4 spend
43.8M / cap 143M). I left it untouched, per your directive not to fight the leveler.

THE ACTUAL BLOCKER (new, not in the original plan): a third fleet host,
`oros-studio-garden-ce242c49` (live follower, active as of 2026-09-15), still
declares ONLY `gardeners: 2` with NO `monks:` key — it was never migrated to monk.
So the legacy `gardener` worker kind is STILL IN ACTIVE FLEET USE, which means:
- Gate 1 ("all fleet inventory reports zero legacy units and state markers")
  genuinely fails — oros writes/reads `gardeners/*.garden` live.
- Gate 3 ("all hosts have deployed the canonical release") is also in doubt: oros
  is currently FAILING to deploy latest main2 (deploy test-gate rejection
  2026-09-15, policy-refusal-quarantine-test rc=1).
Retiring the alias now would break oros-studio outright. The plan job's premise
("both fleet hosts have cut over") predates oros and is no longer true.

This is your call, so I stopped rather than guess:
  (a) migrate oros-studio to monk first (`migrate-host-to-monk.sh cutover` ON that
      host, followers-first per the design) and fix its deploy gate, THEN promote
      the retirement cleanup; or
  (b) decide oros stays gardener and the alias is NOT retired for now.
I left `jobs/plan/retire-gardener-worker-kind-alias` parked (HELD) and did not
promote/requeue it. Also the original prior-pass message
`inbox/maintainer/unread/20260901T205650Z-59a6f5` can be marked read — its two
asks (marker disposition + monk-count) are resolved above; the live blocker is oros.
