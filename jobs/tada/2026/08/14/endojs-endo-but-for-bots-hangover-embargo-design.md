The work is complete. Draft PR #989 is open against `llm` with the design as its only diff (plus the README summary row), the mermaid diagram validates, and my inbox is empty.

## Completion report

**Job:** designer follow-up from the approving review of PR #124 (slot-machine wire protocol), addressing the "hangover inconsistency" kriskowal flagged.

**What I did**
- Studied the actual delivery/emission paths on `llm`: the XS reactive pump (`rust/endo/xsnap/src/lib.rs` `run_supervised` crank loop), the XS send seam (`bus-xs-core.js` `sendEnvelope` -> `sendRawFrame`), the Node worker's crank-free dispatch loop (`connection.js` `makeMessageCapTP`), the supervisor routing (`supervisor.rs`), and the existing `quiesce`/`fxMachineHasPendingJobs` primitive. Cross-referenced the prior `daemon-xs-worker-metering.md` design (which already defines the crank and explicitly *rejected* a rollback-embargo via admission control) and the Ken/crank-buffering prior art in the garden library.
- Authored `designs/worker-quiescence-embargo.md`: defines the inconsistency precisely (mid-crank inbound folding on XS + no crank boundary on Node -> divergent outbound byte streams and intermediate state across supervisors), specifies the embargo (one envelope per crank, buffer outbound worker-side, flush atomically in emission order at quiescence), enumerates affected components, states the byte-for-byte parity invariant and a reproduction+regression test strategy, and carefully distinguishes this release-at-quiescence embargo from the metering rollback-embargo (they compose). Central open risk called out: strict one-envelope-per-crank vs. supervisor-mediated synchronous-call round-trips (`pending_syncs`), with a proposed within-crank response-admission carve-out; a probe is recommended over a direct build.
- Added the summary-table row to `designs/README.md`.
- Validated the mermaid sequence diagram parses (parse-only checker: `mm-1.mmd OK sequence`); fixed an initial PARSE-FAIL caused by a semicolon in `Note over` text.

**What changed**
- New design `designs/worker-quiescence-embargo.md` and a README row, on branch `design/worker-quiescence-embargo`.
- Draft PR: https://github.com/endojs/endo-but-for-bots/pull/989 (base `llm`, diff is the two design files only). Verified `isDraft: true`, `state: OPEN`.

**Design slug / PR:** `worker-quiescence-embargo` / PR #989. Left **draft** per the designer role; the design-panel gauntlet is staged automatically by the completion machinery. I did not un-draft it or hand-post a gauntlet job. PR #124 was not touched.

**Follow-ups (named in the design, not yet posted):** a probe attempting strict one-envelope-per-crank on the XS pump to surface where sync round-trips deadlock, before a build. To be filed after design review.

**Self-improvement:** small reusable gotcha for `skills/mermaid-validation` — a semicolon inside `Note over` text breaks the sequence-diagram grammar (the parse-only checker catches it); worth a one-line note in that skill's Notes. Minor, so surfacing it here rather than as a role edit.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-hangover-embargo-design.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 78 tokens (4041564 cached reads)
- Output: 32220 tokens
- Cost: $3.99845
- Wall-clock: 512s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
