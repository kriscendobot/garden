## Completion report: endojs/endo-but-for-bots#249, addressing review 5095793109

I've handled every item in the CHANGES_REQUESTED review. CI is green on all 35 checks for the new head `6c62eee08d`, and I've asked @kriskowal to review again.

**Merge base:** I created the frozen branch `llm-7d2eb30` from the current `llm` tip, rebased the PR onto it, and moved the PR's base there (it was `llm-bbb1bd9`). The pinned-base check passes. During the rebase I resolved one conflict in the `designs/README.md` summary table and dropped the empty CI-nudge commit `76d43d5c719e`.

**Two new commits:**
- `89e3752c0d` expands `designs/ses-top-level-await.md`:
  - **Shim:** a per-file map of the changes in `module-source` and `ses`. The analyzer now also flags a module-scope `for await`.
  - **Compartment-mapper:** a new `pre-mjs-async-json` archive language, which is what makes old loaders refuse these bundles. Script-format bundles reject top-level await. CommonJS `require` refuses async modules the way Node does (`ERR_REQUIRE_ASYNC_MODULE`). This section also corrects an earlier claim: all three script bundle formats share one synchronous runtime, so none of them can support top-level await.
  - **IronHorse:** describes where the engine is today, then specifies async module evaluation that follows the spec exactly, the prerequisites, how the engine's own `Compartment` adopts the same contract, metering, snapshot fields, and acceptance. 197 test262 top-level-await cases are currently recorded as skips.
  - **Hardened test262 cases:** about 25 new hardened262 cases with paths and headers, plus a helper for driving asynchrony deterministically. They run on SES-on-Node, SES-on-XS, XS, IronHorse and SES-on-IronHorse, and land first as failing baselines.
  - **`importNow` / `import`:** adopted the direction from your inline comment. `importNow` now returns after the first turn of initialization, and `import` waits for the completed exports. The old `TypeError` guard remains only as an opt-in, `importNow(specifier, { requireSync: true })`.
  - **Virtual module sources:** designed with your `import({ bindings, needsImport, needsImportMeta, isAsync, initialize })` shape, accepted directly by `import` and `importNow`.
  - **Naming:** ECMA-262 calls the field `[[HasTLA]]`. proposal-compartments asks "Do we also need to reflect `isAsync`?" without deciding. XS has no flag and infers asynchrony from the function. The design adopts `isAsync` and renames `__moduleIsAsync__` to `__isAsync__`.
  - Also new: Dependencies, Phased implementation, and refreshed open questions.
- `6c62eee08d` updates the design's entries in `designs/README.md`:
  - current totals: Proposed goes from 25 to 26, records from 244 to 245;
  - the estimate goes up to XL;
  - the unscheduled section no longer names the retired M0–M6 milestone range.

**On the PR:**
- Rewrote the PR body to match the expanded design.
- Replied on both inline threads (`r4237520166`, `r4237520245`).
- Posted a top-level summary (`issuecomment-6097494398`).

The deterministic pre-push probes passed.

**Still open for you (recorded in the design):**
- How a module passed to `import(source)` without a specifier should resolve relative imports. For now they're treated as full specifiers.
- Converging with XS's `execute`-based virtual sources. The XS baseline will record those cases as failing until then.
- Whether script bundles should ever get an async runtime.

**Follow-up:** the shim currently sets up hoisted functions inside the module body rather than at link time, which differs from the spec. The design records this and the affected hardened case avoids depending on it. I didn't post a separate job for the fix.

## Panel-head freshness

Disposition: **review required**. The last completed panel reviewed `4424f3a9`; this job presented `6c62eee08dcc587c3e90bddc660c82b0c10635eb`. The old panel verdict does not cover the current head. No gauntlet was staged; the maintainer review docket received a deduplicated re-review action.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr249-address-review-20261007.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 134 tokens (9733178 cached reads)
- Output: 64423 tokens
- Cost: $6.010646800000002
- Wall-clock: 2813s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
