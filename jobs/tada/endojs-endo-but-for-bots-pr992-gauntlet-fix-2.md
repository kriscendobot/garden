CI is GREEN (rc 0). All panel round-2 must-fix items applied, pushed, and CI passing.

## Completion report

**Job:** FIX round 2 of the endojs/endo-but-for-bots PR #992 gauntlet (design-only PR: the HTTP adapter pipeline design doc).

**What I did:** Read the panel-2 request-changes verdict (5 seats: critic, skeptic, decomplector, ergonomist, novice request-changes; copyeditor, pedant comment-only) and applied every finding to `designs/http-adapter-pipeline.md` (+`designs/README.md`), then pushed as a follow-up commit to the PR head and watched CI green.

**Findings addressed:**
- **critic** — split the client boundary (`HttpClientInterface`/`CallerContextShape`) from the internal `HttpStageInterface`/`StageContextShape`, sketched the pre-flight seam synthesizing `{ origin, attempt: 0 }` so the `CallerContextShape` guard is actually applied; added `estimateCost` to the stage interface as a probe forwarded down to the meter.
- **skeptic** — added `contentLength` to `RequestShape` and used it in both cost formulas (the `ReadableBlob` body has no synchronous length); added a test-plan bullet for the "cannot supply attempt/reservation" boundary claim; named the origin-before-method reordering as a third change.
- **decomplector** — dropped the `reservation` far-ref from the shared `StageContext` (lives in the meter's closure); derived `operationId` per attempt as `requestId:attempt` to reconcile idempotency vs per-attempt billing.
- **novice** — named a non-refundable `perRequest` admission fee committed at reserve so `release()` and the aborted-response charge no longer contradict; reconciled the four-knob vs six-step count; glossed "exo facet" before it's load-bearing.
- **ergonomist** — spelled out `--per-byte-request`/`--per-byte-response`/`--per-request`; mapped `inspect` vs `inspectPipeline` onto the `--pipeline` flag; tied `setMeterPrice` to the ledger authority.
- **copyeditor/pedant** — fixed "fees are not"; colon-form on the five concern headings; added the design to the README dependency graph, M3 milestone table, and size/duration estimate.

**Changed:** `designs/http-adapter-pipeline.md` (+203/−67 combined with README), pushed `6da5d70fc → 5a55a90138c` on `origin/design-http-adapter-pipeline`.

**CI:** GREEN — 5/5 checks, 0 failed (rc 0).

**Follow-ups:** none; per the stage contract I stopped without re-running the panel (the driver re-posts panel-3).

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr992-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s) (1 unmetered)
- Input: 87 tokens (5014126 cached reads)
- Output: 39609 tokens
- Cost: $4.799327000000001 (1 engagement(s) unpriced)
- Wall-clock: 985s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
