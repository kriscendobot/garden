---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Repo: https://github.com/kriscendobot/minion.town (fork worktree `kriscendobot-minion.town`). Design landed on `main` at `c6b864c` via PR #56: `designs/invitation-only-guest-onboarding.md` ("capability-first guest invitations"). Role: builder.

FIRST ACTION — CHECK THE GATE, DO NOT BUILD BLIND. The design states twice that the minion.town build is blocked until Endo exposes guest-native invitation methods on `EndoGuest` (`guest.invite(guestName)`, `guest.accept(invitationLocator, hostName)` — names provisional while the daemon tool rename settles) with a retained same-daemon round-trip test. The `llm` surface today exposes `invite`/`accept` only on `EndoHost`. That prerequisite is owned by job `endo-guest-invite-accept-design`, which is currently in `jobs/doin/` (design stage — its build has not even been posted). Verify against `endojs/endo-but-for-bots` @ `llm` whether the guest-native methods and their retained test have actually landed.

If they have NOT landed: do not implement, do not emulate guest authority by calling the host method on a guest's behalf (the design forbids exactly this, and forbids any app-mediated or host-authority fallback). Re-park this job with `scripts/jobs/post-plan.sh --blocked --blocked-on <the Endo build job base> build-minion-town-invitation-onboarding <body>`, note in the body which Endo job you are waiting on, and finish. That is a successful outcome for this job.

If they HAVE landed: implement the design's § 3 extend/accept flow, § 2 fragment-envelope routes (`GET /` un-gated, `#v=1&invitation=…`, `#v=1&guest=…`, capabilities presented only over the `wss://minion.town/.well-known/ocapn-cbor-np` CapTP session — never in an HTTP path, query, cookie, form post, log, or `Referer`), § 4 local-storage + `history.replaceState` credential carry, and the § 7 shell states. Treat the § 9 build gates as the acceptance criteria and produce executable evidence for each one you claim. Do not flip the production admission gate and do not touch `ACCOUNT_AUTOPROVISION` until the § 6 migration of existing OAuth-derived guests reports no unexplained admitted rows; the "Superseded by" note on `designs/account-creation-open-signup.md` belongs to that same flip. OAuth work (§ 5 recovery bonds) is optional and off the critical path — scope it out if it grows the change, and say so.

Coordinate rather than duplicate: `design-siwe-pivot-to-invitation-onboarding` (todo) is re-evaluating SIWE against this same pivot, and `minion-town-oauth-guest-facet-default` is in flight. Standard draft PR + auto-gauntlet.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-09-02T01:10:01Z
