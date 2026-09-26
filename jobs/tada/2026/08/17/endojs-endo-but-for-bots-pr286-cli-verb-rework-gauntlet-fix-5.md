## Fix stage round 5 — complete

Applied the panel round-5 verdict to PR #1014 (`endo http mk`), pushed as review-feedback follow-up commits, and CI is fully green.

**Must-fix (item 1, integrator) — PR body "Out of scope" bullet corrected.** The bullet claimed *"CI here is pinned to Node 24 where the slot is not tripped"*, contradicting this PR's own round-4 design-doc correction. Rewrote it to match the design doc's actual rationale: the `harden(Headers)`/#286 crash path is unreached because **no test in this PR dials out through the confined client** (tests mint a client but never issue a request), so it's safe regardless of Node version — CI matrixes *both* Node 22.x and 24.18.0 (no Node-24-only pin). Updated via `gh pr edit --body-file`.

**Should-fix + non-blocking (purist / assessor / spec-keeper) — code cleanups in `packages/cli/src/http-mk-policy.js`:**
- Dropped the dead `parsed.pathname !== ''` disjunct (unreachable for http:/https: special schemes; the WHATWG serializer always yields at least `/`).
- Added WHATWG origin/host-serializer spec anchors to the normalizer doc.
- **Attempted** `harden(HTTP_ORIGIN_SCHEMES/HTTP_POLICY_MODES)` per the purist item — this reddened all four test legs with `harden is not defined`, because `http-mk-command.test.js` imports this pure helper directly in plain Node without SES lockdown (the module is deliberately factored to be unit-testable without a daemon). Reverted with a code comment explaining why these local-only, never-CapTP-crossed constants intentionally differ from the daemon's always-under-SES hardened twin. This was a genuine decline, not a miss — the purist explicitly marked it should-fix and noted "no live side-channel/passability break follows."

**Commits pushed to `feat/cli-http-mk-on-policy-client`:** `219c440573` (cleanups + attempted harden) → `afb9c2fd95` (harden revert + explanatory comment). Head now `afb9c2fd9530c6c75e8058473040004735604d3b`.

**CI:** 26/26 checks SUCCESS, 0 pending, 0 failed.

Follow-ups (all non-blocking, left for the driver's next panel to weigh): `@ts-check` pragma on `commands/http-mk.js` (skipped to avoid introducing a typecheck failure; dir is legacy-exempt), c8 coverage report, and an IPv4-literal property-test arbitrary.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr286-cli-verb-rework-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 10 on 2 host(s) (7 unmetered)
- Input: 76 tokens (2752588 cached reads)
- Output: 21507 tokens
- Cost: $3.311221999999999 (7 engagement(s) unpriced)
- Wall-clock: 1154s
- Model(s): claude-opus-4-8 ×3

<!-- garden-usage-end -->
