---
kind: panel-run
repo: kriscendobot/endo-but-for-bots
pr: 1343
panel_kind: code
base_ref: 5feadaeac04fa74409929bc457441c17c2b0dac4
rounds: 1
disposition: must-fix
exit_code: 0
reviewed_head: d2cf543e450e755e626cb490d920b31dbd32a674
must_fix_total: 20
appellate_ran: false
appellate_proposals: 0
epoch:
run_id: b5a269bf8bfe
recorded_by: endolin-garden2-5bcdff64
---

# Panel run — kriscendobot/endo-but-for-bots #1343 (code)

Terminal disposition: **must-fix** after **1** round(s).

## Round 1 — head `d2cf543e`

seat verdicts (34): archivist=pass assessor=comment benchmarker=pass breaker=must-fix changeset-auditor=comment corner-prober=comment coverage-auditor=pass curator=comment decomplector=comment duality-auditor=comment engine-realist=comment fast-checker=comment gateway=comment integrator=must-fix locksmith=must-fix migrator=must-fix orthographer=pass packager=must-fix procurer=pass prover=comment pruner=must-fix purist=comment reexport-auditor=pass releaser=comment saboteur=comment scribe=comment spec-keeper=must-fix stylist=comment surfacer=comment thesaurus=pass transplanter=pass typist=comment warden=pass wire-watcher=must-fix
must-fix items (20):
- breaker: **must-fix**: special-endowment formula IDs aren't pinned between resolution and guest formulation.
- breaker: *Invariant claimed:* `resolveSpecialEndowment` (`packages/daemon/src/host.js`) and `MakeGuestOptions.endowments` (`ty...
- breaker: *Attack:* `provideGuest('g', { endowments: { '@main': ['w'] } })` resolves `w` to an ID with `identify()`, outside `w...
- breaker: *Fix:* `pinTransient` each special ID inside `formulateGuestDependencies` and add it to `pinned`, or re-identify unde...
- breaker: [proposed-rule: every formula ID a new formula references must be pinned in its `formulate*Dependencies` until the fo...
- breaker: **should-fix**: a retained policy record can permanently hold dangling special IDs.
- breaker: *Invariant claimed:* "Changing or widening a retained policy fails closed", and special names can't be repaired.
- breaker: *Attack:* on the fresh-record path, `run` (`provision/index.js`) writes `specialNames` IDs into the record (plain str...
- breaker: *Result:* every reconnect replays the stale ID (`freshRecord = false`, so there is no re-resolve). The immutability c...
- breaker: *Fix:* either pin the record's special IDs, or re-resolve when no guest exists yet.
- breaker: [rule: packages/daemon/AGENTS.md]
- breaker: **comment-only**: the claim that the guest "evaluates in it by default" isn't backed by the code.
- breaker: `resolveSpecialEndowment` justifies the worker check by saying the guest evaluates in `@main` by default.
- breaker: But `guest.js` `prepareWorkerFormulation(undefined)` returns `undefined`, and `formulateEval` then calls `provideWork...
- breaker: So replacing `@main` affects only callers that pass `'@main'` explicitly. Either route the default through `specialSt...
- breaker: [proposed-rule: a doc comment that justifies a guard must name the code path that enforces the behavior it describes]
- breaker: **comment-only**: two copies of the reserved-names list drift apart.
- breaker: `daemonReservedSpecialNames` (`host.js`) is hand-kept to match the `specialNames` literal in `guest.js`.
- breaker: The `guest.js` backstop uses `hasOwnProperty`, so when `mailHubId === undefined` it accepts `@mail` from a formula or...
- breaker: *Fix:* export one shared constant.
