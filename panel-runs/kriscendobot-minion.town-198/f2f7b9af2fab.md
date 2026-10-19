---
kind: panel-run
repo: kriscendobot/minion.town
pr: 198
panel_kind: code
provider: anthropic
base_ref: bda7739df6f432987b659d23c29f42e829d600fa
pr_body_hash: 750614cef562740f59b1d4fc331ee2f96ecacd3d680433adc67d6ec55d6d90ac
rounds: 1
disposition: must-fix
exit_code: 0
reviewed_head: a25ec72cbbd8ca14cb3e03007085ddf7c1d26552
must_fix_total: 20
appellate_ran: false
appellate_proposals: 0
epoch:
run_id: f2f7b9af2fab
recorded_by: oros-studio-garden-ce242c49
---

# Panel run — kriscendobot/minion.town #198 (code)

Terminal disposition: **must-fix** after **1** round(s).

## Round 1 — head `a25ec72c`

seat verdicts (34): archivist=must-fix assessor=pass benchmarker=pass breaker=comment changeset-auditor=pass corner-prober=comment coverage-auditor=comment curator=comment decomplector=comment duality-auditor=comment engine-realist=comment fast-checker=comment gateway=comment integrator=comment locksmith=must-fix migrator=comment orthographer=pass packager=comment procurer=must-fix prover=comment pruner=must-fix purist=must-fix reexport-auditor=pass releaser=comment saboteur=must-fix scribe=comment spec-keeper=must-fix stylist=comment surfacer=pass thesaurus=pass transplanter=comment typist=pass warden=pass wire-watcher=comment
must-fix items (20):
- archivist: **should-fix** `designs/closed-beta-waitlist.md:147`: the doc names "`@endo/http-confine`'s limiter" as an existing t...
- archivist: Rate limit (5/hour, /24 or /48 key, `Retry-After: 3600`): `src/waitlist/waitlist.ts:249,258-259`.
- archivist: Dedupe via conditional put (`attribute_not_exists(email)`): `src/waitlist/stores/dynamodb.ts:42`.
- archivist: Caddy `308` for `/index.html`, `/guest.html`, `/shell.html`: `deploy/aws/caddy/conf.d/minion-town.caddy:181-183`.
- archivist: Public `handle /` carries the full CSP with `frame-ancestors 'none'` and `X-Frame-Options: DENY`: same file, lines 16...
- archivist: Table name default and the PutItem-only grant with `ReturnValues` NONE: `src/waitlist/waitlist.ts:24`, `deploy/aws/sc...
- archivist: `list` / `remove` CLI and the oldest-first sort: `src/waitlist-cli.ts:31-44`, `src/waitlist/stores/dynamodb.ts:93`.
- archivist: Honeypot is off-screen (`deploy/aws/www/index.html:358-360`).
- archivist: The "tab and CR are refused by the email grammar" claim in the `csvField` JSDoc holds: `EMAIL_PATTERN` excludes `\s` ...
- archivist: Cross-doc anchors resolve: `invitation-only-guest-onboarding.md` § 7, `closed-beta-waitlist.md` § The one landing.
- locksmith: **comment-only: the waitlist writer facet is structural, as POLA asks.**
- locksmith: `src/waitlist/stores/dynamodb.ts` `makeDynamoWaitlistWriter` builds a frozen `{ add }` that never closes over `ScanCo...
- locksmith: `src/waitlist/waitlist.ts` `makeWaitlistWriter` binds `store.add` once and re-freezes it, so the router's `options.st...
- locksmith: `buildWaitlistWriter` (`src/http.ts:393`) hands the app only the writer.
- locksmith: The IAM split in `deploy/aws/scripts/deploy-waitlist-store.sh` (PutItem only) matches the code split.
- locksmith: This is the right shape. [rule: roles/jurors/locksmith/AGENT.md § runtime-flag attenuation]
- locksmith: **comment-only: the IAM grant is wider than the code facet, and the script's closing log line says less than its own ...
- locksmith: `deploy-waitlist-store.sh` grants `dynamodb:PutItem` with no condition-expression requirement. The app role can there...
- locksmith: The in-script comment admits this. The closing log line (`PutItem with ReturnValues NONE (no GetItem, …)`) reads as...
- locksmith: `ReturnValuesOnConditionCheckFailure` is also left as "if this condition key does not also govern". Verify it, or den...
