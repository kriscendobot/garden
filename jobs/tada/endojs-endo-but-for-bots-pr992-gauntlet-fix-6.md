CI is green (rc 0, 5/5 checks, 0 failed). The fix stage is complete.

## Completion report

**Job:** gauntlet FIX round 6 for endojs/endo-but-for-bots PR #992 (design-doc-only: `designs/http-adapter-pipeline.md` + `designs/README.md`).

**Re-derivation:** Fresh worktree after reaper requeue. No prior fix commit was on the PR head (still at `33d202fdf`, round-5). I read the latest panel verdict (round-6 must-fix, posted as a comment review) and recovered the truncated corner-prober/fast-checker seats from the panel transcript. The PR head is on the fork `kriscendobot/endo-but-for-bots`, so I checked it out from there.

**Must-fix items applied** (one commit `d6cb6e6cb`, pushed via `safe-push-pr-head.sh --mode advance`, `33d202fdf..d6cb6e6cb`):
- **assessor** — cost formula's `deadline` units: it's an absolute timestamp, so `effectiveDeadlineMs = min((deadline ?? (now + timeoutMs)) - now, timeoutMs)`; corrected the worked example and the § Open questions restatement.
- **typist** — `RequestShape.contentLength` typed `IntegerNonNegative` (was `FiniteNonNegative`), agreeing with § Numeric domain and its two other declarations.
- **saboteur** — enforce `maxRequestBytes` as the outbound ceiling on the *declared* `contentLength` branch (reject `contentLength > maxRequestBytes` at pre-flight), not only the omitted branch; added test.
- **breaker/assessor** — classified the internal `RateLimitError`/`CircuitOpenError` in § 4 as terminal/not-auto-retried, distinct from an origin HTTP-429 resend; added test.
- **curator/purist/spec-keeper** — `harden(MeterReservationInterface)` and renamed its tag to `'EndoMeterReservation'` to match the `Endo*` family.
- **wire-watcher** — spelled `settle`/`release` as mutually-exclusive first-wins terminal transitions to close the deadline-vs-late-completion double-count race; added test.
- **stylist** — `req` → `request` throughout sketches/prose (left the deliberate `--per-byte-req` bad-name example).
- **packager** — README milestone cell: seven controller verbs (was five), five concerns incl. fees (was four).
- **fast-checker/corner-prober** — added a property-based `costActual <= costMax` test to the Test plan.

Out-of-scope (stale cross-diff) changeset-auditor/surfacer findings about `packages/*` were correctly not applied — the true PR touches only the three design files.

**CI:** GREEN — 5/5 checks, 0 failed.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr992-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 2 host(s) (2 unmetered)
- Input: 118 tokens (6182369 cached reads)
- Output: 31694 tokens
- Cost: $5.081317500000001 (2 engagement(s) unpriced)
- Wall-clock: 1022s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
