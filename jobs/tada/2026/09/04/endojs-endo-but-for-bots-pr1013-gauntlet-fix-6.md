The PR head is `9dc920ea43` and the passing CI run's `head_sha` matches it exactly. CI is GREEN. The fix stage is complete.

## Completion report

**Gauntlet FIX round 6 — endojs/endo-but-for-bots PR #1013** (`designs/relative-routing.md`, a design PR).

Applied the round-6 panel's must-fix items once, in a single follow-up commit `9dc920ea43` on `design/relative-routing`, pushed via `safe-push-pr-head.sh` (advance mode, `67e76353ea → 9dc920ea43`). CI then went fully green.

Must-fix items addressed (verified each claim against the shipped code first):
- **critic** — Settled which layer carries the scope on the ocapn-noise substrate. Its `ConnectionHint` is the outer `ocapn+noise+tcp://…?loc=…` URI (the flat record is nested inside `loc=`, unpacked only in `connect()` after selection, so `selectRoutes` never sees it). Rewrote § 3 to make the `#scope=` fragment on that URI the single encoding surface and note a nested-`loc=` key would be invisible; added a nested-hint test row; fixed the contradicting Dependencies-table row.
- **skeptic** — Stated that the "one `ConnectionHint` per boundary" producer workaround is unavailable on ocapn-noise (`aggregatedHints`/`buildLocationFor` emit one aggregated location per daemon), so the mixed-scope forfeit fully applies there. Corrected the transition-rule retirement condition to producer *annotation* with `scope=` (omission, which `isPublishableDirectAddress` performs, would drop the cheap same-host route cases 1/4 want) and gave producer-side annotation a home in Phased Implementation step 3. Fixed the audience-blind mischaracterization of `isPublishableDirectAddress` in § 3 and § Security.
- **decomplector** — Split the immutable `ScopeSnapshot` value that `selectRoutes` consumes from the live `LocalScope` identity that emits successive snapshots; re-rank on change is re-running `selectRoutes` over the next snapshot. Threaded through § 2 types, § 4 signature/pseudocode/prose, the test plan, and the Open Questions async-discovery note.
- **pedant** — Rewrote all remaining prose em-dashes (the fenced-code one is exempt) and the § 1 comma splice.

Also bumped the stale `Updated` date to 2026-09-04 in both the design and its `designs/README.md` row.

CI (head `9dc920ea43`): build, lint, test, browser-tests, zizmor — all pass.

Notes: the CI watch was reaped/requeued three times mid-wait (long CI + a transient gh rate-limit window); confirmed the terminal green state directly by `gh pr checks` and matched the passing run's `head_sha` to the pushed head. Did not re-run the panel (the driver posts panel-7). Should-fix/comment-only items from round 6 were left for the next panel round per the "must-fix only" instruction.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1013-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 4 on 1 host(s)
- Input: 156 tokens (8424197 cached reads)
- Output: 45789 tokens
- Cost: $10.669853750000001
- Wall-clock: 1973s
- Model(s): claude-opus-4-8 ×4

<!-- garden-usage-end -->
