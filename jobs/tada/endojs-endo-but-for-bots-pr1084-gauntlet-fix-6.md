CI is GREEN (5/5 checks, 0 failed). The fix stage is complete.

## Completion report

**Stage:** FIX round 6 — endojs/endo-but-for-bots PR #1084 (design: adaptive exo-stream pacing).

Read the panel-6 verdict (disposition **must-fix**; request-changes from **critic** and **ergonomist**). Applied all must-fix items as a single review-feedback follow-up commit (`6771868b4`) to the PR head `design/exo-stream-adaptive-pacing` on `endojs/endo-but-for-bots`.

**What changed** (`designs/exo-stream-adaptive-pacing.md`, +96/−59):

- **critic (request-changes):** The design claimed `tArrive` capture "falls out" of credit issuance via a naive `nodePromise.then(...)`. Verified against the tree that this is false — a syn credit only unblocks the producer's next pull (`reader-pump.js:74-76`), and `node.promise` is readable only after the current node resolves (`iterate-reader.js:110-117`). Rewrote the section to specify the actual mechanism at the data-structure level: a single-cursor **arrival walker**, an **arrival FIFO** (the concrete "local prefetch buffer", depth bounded by `outstanding ≤ floor(W) ≤ max`), consumption that dequeues rather than walks, and how `return()`/`throw()` teardown resumes the drain from the walker's released cursor (`iterate-reader.js:193-195`) so the two chain-walks never race the same `node.promise`. Updated the Cancellation bullet to match.
- **ergonomist (request-changes) a:** Renamed the interface ceiling field `maxCredit` → `max` so the descriptor key set (`{ max: 16 }`) and the field read back (`.max === 16`) share one name and one value — an exact round trip — with a note that the realized integer credit ceiling is `floor(max)` while the field reports the configured value verbatim. Propagated through all loop/limits/verification prose.
- **ergonomist (request-changes) b:** Widened `policy: 'codel' | 'occupancy'` to `string` so a third-party `CreditController` (the interface is advertised as user-implementable) has a truthful value to report.
- **copyeditor (should-fix):** subject-verb agreement ("streams … are instances of"), "on termination", two spelled-out trailing possessives, and the malformed `buffer`/`pacing` fragment.

Did **not** re-run the panel (driver re-posts panel-7). Left the comment-only findings (skeptic's call-site audit, decomplector's factory-name concern, novice's reordering) for the driver/next round — out of the must-fix scope.

**CI:** GREEN — 5/5 checks passed, 0 failed (rc 0). This is a `designs/`-only change; the docs-CI prettier check covers only `.github`/`packages` and the TypeDoc build reads package sources, so no new failure surface.

**Follow-ups:** none required for this stage.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1084-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 95 tokens (4831000 cached reads)
- Output: 32752 tokens
- Cost: $4.293312
- Wall-clock: 899s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
