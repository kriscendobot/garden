Review posted (as a COMMENTED review — request-changes is blocked on our own PR — with the must-fix verdict in the header). The stage is complete: exactly one panel round, verdict posted, no fix/un-draft loop.

## Completion report

**Job:** Gauntlet PANEL stage, round 1, for endojs/endo-but-for-bots PR #1071 (`design(ocapn): one hint per transport protocol` — a design-doc change to `designs/ocapn-network-transport-separation.md`, 1 file, +89/−44).

**What I did:**
1. Resolved the PR head (endojs owner, branch `design/ocapn-single-hint-per-transport`, base `llm`) and created an isolated project worktree keyed to this job base.
2. Ran the panel in single-round mode (`GARDEN_PANEL_SINGLE_ROUND=1`) against the head with base ref `origin/llm`. Seven seats fired (critic, skeptic, decomplector, ergonomist, copyeditor, pedant, novice).
3. **Disposition: must-fix** — unanimous request-changes across all seven seats.
4. Posted the aggregated verdict (`$GARDEN_PANEL_RUNDIR/round-1.md`, prefixed with a must-fix header) as a `gh pr review` on the PR. `--request-changes` is rejected by GitHub on our own PR (the bot authored it), so it posted as a **COMMENTED** review whose body leads with "round 1 verdict: **must-fix**".

**Substance of the verdict (recurring must-fix themes):**
- The composite key `${scheme}+${codecName}` conflates *framing* vs *codec* (`+cbor` names framing for TCP netstring, message-codec for WS), regressing against the registered `tcp+netstring+json+captp0` vocabulary.
- § Target Model claims `tcp+cbor` and `tcp+syrup` can coexist, but § Target API pins one `codecName` per network — a capability the API cannot instantiate.
- Narrowing the hint value to a bare `host:port` authority silently drops the WebSocket path and over-constrains transport-defined/opaque payloads (mock adapter publishes a designator, not an authority).
- Locator examples are unencoded, contradicting the `encodeURIComponent` rule of the cited `daemon-locator-reference.md`.
- § Test Plan still says "duplicate-scheme rejection" (stale vocabulary) and adds no round-trip/IPv6/authority-rejection cases.
- Style: newly introduced em-dashes and `e.g.` in prose violate `em-dash-style` / `no-latin-shorthand`.

**Changed artifacts:** none in the repo (review-only stage). One PR review comment posted by `kriscendobot` at 2026-08-30T06:50:43Z.

**Follow-ups:** Next gauntlet stage (fix-loop) owns addressing the must-fix findings; I did not fix, un-draft, or loop, per single-round mode.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1071-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 25 tokens (593533 cached reads)
- Output: 5109 tokens
- Cost: $0.8637455
- Wall-clock: 495s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
