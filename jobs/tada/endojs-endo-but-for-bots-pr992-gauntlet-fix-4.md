CI is green (rc 0). All panel round-4 must-fix items applied, pushed as a follow-up commit, and CI passed.

## Completion report

**Job:** Gauntlet FIX round 4 — endojs/endo-but-for-bots PR #992 (`design(http): HTTP client/controller as a metered pass-style adapter pipeline`).

**What I did:** Read the panel-4 verdict (5 of 7 seats request-changes) and applied every must-fix item to `designs/http-adapter-pipeline.md` and `designs/README.md` in one commit (`750ed9d26`), pushed to the fork PR head, and watched CI to green.

**Findings applied:**
- **critic** — `estimateCost` now documents that the probe reflects only the funds axis (a known limitation), not the breaker/rate admission gates; the `attachChargeAccount` table cell reworded to gate on controller-holder access (matching the "structural, not a provenance test" prose), not on inspecting the account ref.
- **skeptic / decomplector** — the guest-budgeting guidance reworked: `maxAttempts` is controller-only via `inspectPipeline()`, so full-call budget sizing belongs to the controller-holder (out-of-band), not the guest. Corrected the false "Phase 1 default is GET/HEAD" claim (verified `CONFINED_ALLOWED_METHODS` is the full seven-method set). Specified and added a test for the omitted-`contentLength` case as an enforced `maxRequestBytes` cap.
- **ergonomist** — `set-request-bytes` and `set-rate` CLI verbs now keep the Phase 1 positional argument shape (no silent breaking change; the aggregate window is an optional flag); renamed `setControllerMaxRequestBytes` → `setMaxRequestBytes`.
- **copyeditor** — fixed the "fee stage" vs "not a pipeline stage at all" contradiction (3 sites → "the meter stage (fee-side)"), the dangling "mining" participle + spliced quote, the missing comma after "Third (the low-impact one)", and swept the new README Totals `→` to `->`.
- **pedant** — swept `↔` → `<->` (README:1458) and `→` → `->` on the edited Totals line; fixed the "bill worst case" hyphenation.
- **novice** (comment-only, cheap win) — added the `measurementId` derivation note.

**Result:** CI GREEN (rollup 5/5, 0 failed, rc 0). Did not re-run the panel (driver re-posts panel-5).

**Follow-ups:** none blocking. Out-of-scope notes the panel logged (retry `costMax` over-reservation tuning; `cli-http-client.md` "Proposed" status-sweep drift) remain deferred to their respective ledgers, as the seats intended.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr992-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 115 tokens (4328229 cached reads)
- Output: 25135 tokens
- Cost: $3.6456704999999996
- Wall-clock: 819s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
