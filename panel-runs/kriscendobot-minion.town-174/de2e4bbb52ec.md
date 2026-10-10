---
kind: panel-run
repo: kriscendobot/minion.town
pr: 174
panel_kind: code
base_ref: 39867df7874c01db702e4b1299f417523fdcaf24
rounds: 1
disposition: must-fix
exit_code: 0
reviewed_head: 8f88be43a1959fcd4d64d3e0c52c600404eff7ea
must_fix_total: 20
appellate_ran: false
appellate_proposals: 0
epoch:
run_id: de2e4bbb52ec
recorded_by: endolin-garden-ece02cb4
---

# Panel run — kriscendobot/minion.town #174 (code)

Terminal disposition: **must-fix** after **1** round(s).

## Round 1 — head `8f88be43`

seat verdicts (34): archivist=pass assessor=pass benchmarker=pass breaker=must-fix changeset-auditor=comment corner-prober=comment coverage-auditor=comment curator=comment decomplector=must-fix duality-auditor=comment engine-realist=comment fast-checker=comment gateway=comment integrator=comment locksmith=comment migrator=comment orthographer=pass packager=comment procurer=pass prover=comment pruner=pass purist=comment reexport-auditor=pass releaser=comment saboteur=comment scribe=comment spec-keeper=comment stylist=comment surfacer=must-fix thesaurus=pass transplanter=pass typist=must-fix warden=comment wire-watcher=must-fix
must-fix items (20):
- breaker: **should-fix: "Idempotent on `grantId`" fails across processes.** `src/endo/credit-ledger.ts` `apply` (the fold) neve...
- breaker: **should-fix: A failed `append` can poison the log mid-file.** `makeFsLedgerLog.append` writes `JSON.stringify(record...
- breaker: **should-fix: The "corrupt line is logged with its location" claim is false for lines that parse but are not records....
- breaker: **comment-only: Crash after the charge, before the refund.** If the process dies between the ledger append and a refu...
- breaker: **comment-only: Hold and refund sharing holds up.** I tried these interleavings and found no way to fall below one ch...
- breaker: A fails while B is joined.
- breaker: B joins during a refund (it waits on `refunding`).
- breaker: A's charge throws insufficient while B is joined.
- breaker: A refund rejection followed by a retry.
- breaker: **comment-only (capability slice): `AccountCharge` is correctly attenuated.** The facet is frozen and bound to one ac...
- decomplector: **Must-fix: the refund/hold mechanism has been patched for five rounds without anyone asking whether it is needed.** ...
- decomplector: The recurring keys are balance, charge, grant, post and `publish.ts`.
- decomplector: Rounds 1–5 each added hardening: refund across the whole publish, hold concurrent settlements, a refunding-hold sta...
- decomplector: The root cause is that the ledger braids three things into one primitive: charge, settlement identity, and rollback.
- decomplector: The `charge` and `refund` log records mutate a `settled` set (`credit-ledger.ts:70`, `settled.delete`). A refund ther...
- decomplector: This is a place-oriented construct inside an append-only log.
- decomplector: `publish.ts` has to supply a `PublishSettlement` with `confirm()` and `refund()` and sequence them across `intern`, `...
- decomplector: The simpler primitive is the one the design already names, in § "Charge first, refund on failure": reserve-then-comm...
- decomplector: A simpler option is to charge only after `evaluateRegister` and `writeDirectory` succeed. Charge idempotency on the c...
- decomplector: The design's stated objection is that charging after success lets unpaid content be stored. But the interim ledger's ...
