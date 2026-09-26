Round-4 panel review posted (COMMENTED, 6703 chars) with the `<!-- garden-panel-round: 4 disposition=must-fix -->` marker, matching the format of the prior three rounds.

## Completion report

Re-ran the round-4 PANEL stage of `build-ocapn-nonce-locator-endo-mechanism-gauntlet` against endojs/endo-but-for-bots PR #1124 as a clean start.

**Re-derived state:** PR #1124 (draft, head `f72ab327e`, base `llm`) had panel rounds 1–3 already posted (last at 09:00Z); no round-4 review existed. Set up an isolated project worktree of the PR head, base ref `1d91f0d9d`.

**What I did:**
- Ran `panel.sh` in single-round mode (29 seats). Exit 0, disposition **must-fix**.
- Verdicts: 6 request-changes (archivist, curator, releaser, scribe, stylist, wire-watcher), 10 comment-only, 13 approve — a marked improvement over round 3's 23 request-changes. The round-3 blocking set (pipelining wedge, unpinned severance/abort wiring, throwing-`abortSession` oracle, changeset overstatement, type widening) is resolved and confirmed by the seats that raised it.
- Wrote a faithful digest and posted it to the PR. `--request-changes` was rejected (self-authored PR), so posted as a COMMENTED review carrying the `disposition=must-fix` marker — the same shape as rounds 1–3.

**Remaining blocking items (for the fix stage, not this stage):** (1) `SessionLocatorContext` docstring/README recommend keying on `getPeerPublicKeyForSessionId`, which is unreachable from the `makeLocatorForSession` extension point (archivist + curator, must-fix); (2) bare `const ref` identifier in the endpoint test (stylist). Plus should-fixes: changeset audience/`endo-bootstrap` dead-name, stray `EndoMountControl` export, two untested docstring guarantees, and the gauntlet fix-stage-prompt root cause.

Stage owed: another fix round. This stage posts the verdict and stops.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-ocapn-nonce-locator-endo-mechanism-gauntlet-panel-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 2 host(s)
- Input: 188 tokens (5382357 cached reads)
- Output: 31828 tokens
- Cost: $4.5432595
- Wall-clock: 1313s
- Model(s): claude-opus-4-8 ×3

<!-- garden-usage-end -->
