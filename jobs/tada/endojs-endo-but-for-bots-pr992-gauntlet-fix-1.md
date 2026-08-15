CI is GREEN on the PR head `6da5d70fc` (my fix commit) — all 5 checks pass. The fix stage is complete.

## Completion report

**Job:** Gauntlet FIX round 1 for endojs/endo-but-for-bots PR #992 (design: HTTP adapter pipeline).

**What I did:** Applied the design panel's round-1 must-fix items to the three design files on the PR head branch `design-http-adapter-pipeline` (fork `kriscendobot/endo-but-for-bots`), pushed as a review-feedback follow-up commit, and watched CI to green.

**Changes (commit `6da5d70fc`):**
- **Circuit-breaker ordering (critic, skeptic — load-bearing):** the stage-order table had the breaker strictly outermost, contradicting its per-attempt observation claims (under the compose-at-construction, far-ref-only model an outermost breaker sees only the whole retry loop's aggregate outcome). Reordered to `retry → breaker → rate → meter → transport` so the breaker is retry's `next`, invoked once per attempt — it both gates before any resource-spending stage and observes every attempt, and a mid-loop trip fast-rejects the next attempt. Updated the table, composer order, and the retry/breaker/rate prose to match.
- **429 as breaker evidence (skeptic):** excluded 429 from breaker evidence (it reflects request volume, not origin health, so counting it lets one greedy guest trip the shared per-origin breaker for co-guests); kept it retryable with the `Retry-After` floor and documented the deliberate retry-vs-breaker asymmetry.
- **RequestContext value-orientation (decomplector):** replaced "set by"/"increments" mutation language with fresh-hardened-record threading (`{ ...ctx, attempt: ctx.attempt + 1 }`).
- **Shape split + guards + idempotency (ergonomist):** split the shared context into `CallerContextShape` (deadline only) vs internal `StageContextShape`; explained why `request`/`reserve` return unguarded while `help`/`getBalance` guard their bare primitives; documented `release()` idempotency.
- **Typist/em-dash sweep (copyeditor, pedant):** removed all 56 em-dashes and every hard-to-type code point (arrows, middot, minus, `<=`, ellipsis) from the new doc plus the one added README line; dropped terminal periods on the Alt A/B/C/D headings. (Left the two title-case `##` headings — they are the repo template canon used by 115 designs.)
- **Reader mental-model gaps (novice):** noted "The five concerns" is not in pipeline order and that fees is not a stage; glossed minion.town at first mention; replaced the "step 1/step 3" ordinal back-reference with named steps.
- Added the two test-plan cases the panel flagged as omitted (concurrent-reservation serialization, `estimateCost`).

**Verification:** `typist-friendly-code-points.sh` passes; the main doc is free of all flagged glyphs; the README diff is minimal (only the one intended line). PR head `6da5d70fc251`, CI rollup all SUCCESS (browser-tests, build, lint, test, zizmor).

Per the gauntlet contract I did not re-run the panel — the driver re-posts panel-2.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr992-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 5 on 2 host(s) (3 unmetered)
- Input: 77 tokens (3969260 cached reads)
- Output: 43284 tokens
- Cost: $4.2359279999999995 (3 engagement(s) unpriced)
- Wall-clock: 798s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
