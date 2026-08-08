---
gate: orchestrated
orchestrated_by: ironhorse-test262-report-and-gap-plan
priority: high
roadmap: ironhorse-language-completion
role: builder
posted_by: gardener
posted_at: 2026-08-08T03:43:59Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Build authoritative full-test262 automation for Ironhorse

Work in `endojs/endo-but-for-bots` from current `llm`, using an isolated checkout created with:
`/home/kris/garden/scripts/jobs/ensure-project-worktree.sh ironhorse-full-test262-automation endojs/endo-but-for-bots llm`.

Implement the maintainer's request from https://github.com/kriscendobot/garden/issues/51#issuecomment-5224315524. Start by auditing the merged PR https://github.com/endojs/endo-but-for-bots/pull/600 and the existing draft https://github.com/endojs/endo-but-for-bots/pull/946; reuse and extend PR 946's expectation/ratchet machinery where sound instead of duplicating it. Keep the bespoke bit-exact metering cases separate from upstream test262: they are complementary coverage, not duplicate conformance cases.

Deliver automation that runs the complete current authoritative TC39 test262 corpus against Ironhorse and emits both machine-readable results and a self-contained static HTML report. Requirements:

- Pin and record the exact authoritative upstream test262 revision used. Audit discovery so the run covers the entire official `test/**` tree, all applicable strict/non-strict/module variants, frontmatter includes, negative phases, async cases, and feature metadata; do not silently hide unsupported language features behind a curated-subtree filter.
- Check Proxy explicitly with targeted official cases and report the observed result rather than assuming it is absent.
- Make the full run bounded and resumable: isolate or batch the C-XS oracle so its known process-RSS retention cannot OOM a whole-tree run, preserve per-case results across interruption, and support deterministic aggregation/parallelism.
- Emit stable JSON plus accessible static HTML with run provenance (test262 SHA, endo/Ironhorse SHA, command/config, timestamps), totals by observed outcome, breakdowns by feature and path, named failures/skips/unsupported cases, and direct case identifiers sufficient to turn gaps into jobs. Distinguish Ironhorse execution failures from harness/oracle/infrastructure failures.
- Add a documented one-command entry point and suitable repeatable automation (including an explicitly invokable CI/workflow path if repository conventions support it). Do not make the ordinary PR matrix run the multi-hour full sweep unless explicitly dispatched.
- Add focused tests for discovery completeness, aggregation/report generation, interrupted-run resume, and HTML generation. Run proportionate Rust/JS lint and tests plus a small real oracle-backed slice.

Push the result to the existing PR 946 head if it remains the coherent vehicle, otherwise open a replacement PR against `llm` and explain why. Drive it through the normal builder gauntlet to ready-for-review when it is genuinely reviewable. Post the required PR completion summary with exact SHAs and executed verification. Do not claim the full corpus was run in this child; publishing the full run is the next orchestration child.

----- ISSUE NOTE (copy this block VERBATIM into every follow-on job) -----
issue_spine: issue-kriscendobot-garden-51
issue_url: https://github.com/kriscendobot/garden/issues/51#issuecomment-5224315524
submitter: kriscendobot
----- END ISSUE NOTE -----
