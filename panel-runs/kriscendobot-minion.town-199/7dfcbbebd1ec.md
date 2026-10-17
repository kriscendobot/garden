---
kind: panel-run
repo: kriscendobot/minion.town
pr: 199
panel_kind: code
provider: anthropic
base_ref: bda7739df6f432987b659d23c29f42e829d600fa
pr_body_hash: f23189403ac89ce1976c9540b1b5c76feb1e3ab2afe9a9706c6e9e7020aebd50
rounds: 1
disposition: must-fix
exit_code: 0
reviewed_head: 94c494337907e5f326ba75a961eed827c36651ff
must_fix_total: 20
appellate_ran: false
appellate_proposals: 0
epoch:
run_id: 7dfcbbebd1ec
recorded_by: endolin-garden-ece02cb4
---

# Panel run — kriscendobot/minion.town #199 (code)

Terminal disposition: **must-fix** after **1** round(s).

## Round 1 — head `94c49433`

seat verdicts (34): archivist=must-fix assessor=must-fix benchmarker=comment breaker=must-fix changeset-auditor=pass corner-prober=comment coverage-auditor=comment curator=comment decomplector=comment duality-auditor=comment engine-realist=comment fast-checker=comment gateway=comment integrator=must-fix locksmith=comment migrator=comment orthographer=pass packager=comment procurer=comment prover=must-fix pruner=must-fix purist=comment reexport-auditor=pass releaser=comment saboteur=must-fix scribe=comment spec-keeper=comment stylist=comment surfacer=comment thesaurus=pass transplanter=pass typist=comment warden=comment wire-watcher=must-fix
must-fix items (20):
- archivist: **must-fix**: The design doc that the new code cites does not exist in the tree. `designs/guest-coupons.md` is cited ...
- archivist: `src/config.ts:122`
- archivist: `src/coupons/ledger.ts:2`
- archivist: `src/coupons/issuer.ts:2`
- archivist: `src/coupons/dynamodb.ts:3`
- archivist: `src/http.ts:721`
- archivist: `src/web/guest-web-router.ts:48`
- archivist: `deploy/aws/scripts/deploy-coupon-store.sh:2`
- archivist: `deploy/aws/systemd/minion-mcp.service:94`
- archivist: **should-fix**: Operator-facing behavior is not documented in any README or design file. The diff touches no `*.md` f...
- archivist: **comment-only**: `src/coupons/ledger.ts:3-16` and `src/coupons/dynamodb.ts:16` agree with each other. Both say every...
- assessor: **should-fix: the sweep never marks a terminal coupon as removed.** `src/coupons/issuer.ts` (sweep, last branch) sele...
- assessor: **Failure scenario:** every 5-minute tick from `src/http.ts` calls `daemon.removeCoupon` for every expired, revoked, ...
- assessor: **Report noise:** `report.removed` re-lists the same serials each time, so the `coupon-sweep` output cannot show what...
- assessor: **Cost:** the work grows linearly with ledger history, on top of the full `ledger.list()` scan.
- assessor: **Fix:** stamp a `removedAt` field, or clear `couponId`. Keep the `ID#` index so a late same-nonce retry still resolves.
- assessor: [proposed-rule: reconcilers must record completion of each idempotent effect, so a periodic sweep's work is bounded b...
- assessor: **should-fix: `issue()` loses coupons when the pool runs out partway.** `src/coupons/issuer.ts`, `issue()`. It reserv...
- assessor: **Failure scenario:** `coupon-issue 50 dir` against a pool with room for 10 refuses, leaves 10 reserved coupons that ...
- assessor: **Contrast:** `fillRoundRobin` appends after each reserve, so the orphan window there is a single coupon.
