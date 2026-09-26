The job is complete. Here's my report.

---

**Job: issue-kriscendobot-garden-97 — test plan for `oros-ckm-data-readiness`**

**What I did**
- Analyzed `kriscendobot/oros-ckm-data-readiness` @ `ckm-poc-build`: read the `scoring/` engine (5-stage deterministic pipeline, 13 checks, `conditions/*.config.json` modules), the `src/` React demo, migrations, and the existing test suite.
- **Key finding:** all 79 existing tests are `*.gate.test.*` files in `src/`, and every one asserts against checked-in fixture JSON — the **ground-breaking code (`scoring/`) has zero tests**, and the gate tests would stay green even if engine logic regressed (fixtures are static snapshots).
- **Wrote and actually ran one working test** (`scoring/lib/aggregator.test.js`, 5 cases) driving the pure aggregation logic through an in-memory fake pg client — **no database, no fixtures**. Verified: full suite goes 79 → **84 passing**; confirmed the test *bites* by perturbing the expected exact-0.8 score and watching it fail.
- Produced a **telescoping plan**: Tier 1 = detailed plan for `aggregator.js` (with the delivered verified test) + `pathway_evaluator.js` + one representative check; Tier 2 = medium detail for the rest of `scoring/lib`, the 13-check family, `index.js` helpers, and config-module schema validation; Tier 3 = sketch for the already-gated UI, a fixture-provenance guard, and a single Postgres end-to-end smoke test.
- Answered the P.S.: file here to route work to the fleet (only `kriscendobot`-owned repos are watched, for prompt-injection safety); cross-post to `Oros-AI/...` to reach the upstream team, but expect no automated response there.

**What changed**
- Posted the plan as a comment: https://github.com/kriscendobot/garden/issues/97#issuecomment-5705478005
- No garden-repo (main2) changes — this job's deliverable is the issue comment. The delivered test lives verbatim in the comment (drop-in at `scoring/lib/aggregator.test.js`).
- Cleaned up the temporary analysis clones.

**Follow-ups / notes**
- Did not close the issue (submitter closes when satisfied, per issue-inbox contract).
- Hit a transient GitHub secondary rate limit on first post; succeeded via the REST endpoint.
- Recommended (in the plan) exporting the aggregator's private pure helpers to make deeper unit tests trivial — a low-risk refactor to sequence after the seam tests land.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/issue-kriscendobot-garden-97.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 54 tokens (1921324 cached reads)
- Output: 22997 tokens
- Cost: $2.43742
- Wall-clock: 336s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
