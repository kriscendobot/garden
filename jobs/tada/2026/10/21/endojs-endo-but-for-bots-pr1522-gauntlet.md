gauntlet-status: not-viable
viability-result: overtaken
repo: endojs/endo-but-for-bots
pr_number: 1522
# gauntlet endojs-endo-but-for-bots-pr1522-gauntlet - not viable

the premise was overtaken. Deciding question: does the live `llm` branch still lack `endor run <entry.js>`, so that this PR's XS-hosted compartment-mapper version (design Option B) is still the needed implementation? Option: close as superseded.

## Viability report

The PR is **overtaken**. It is still open and in draft, but its core feature already exists on the live `llm` branch through a different, maintainer-chosen design.

Deciding question: does the live `llm` branch still lack `endor run <entry.js>`, so that this PR's XS-hosted compartment-mapper version (design Option B) is still the needed implementation?
**Answer: no.**

Evidence:
- **Facts about the PR:** it is open, in draft, has no reviews, and was opened 2026-10-21 by job `build-endor-run-expanded-phase-4-entry-point-input-open-pr`. Its base is the frozen snapshot `endor-e0322c4`, taken from the `endor` branch tip `e0322c405` (2026-07-06). That branch is 1 commit ahead of `llm` and **4838 commits behind** it.
- **The feature has already landed:** `llm` already has entry-point input, in `rust/endo/src/{run_input.rs,entry_walk.rs,assemble.rs}` and in `ingest_entry_point` in `cas_archive.rs`. It came through PRs #799, #800, #803, #805, #812, #818 and #862, all merged into `llm` around 2026-07-21. #800 was "entry-point assembly and XS execution over CAS and registry table".
- **The design on `llm` records it:** the Status section of `designs/endor-run-expanded.md` says Phase 4 is implemented. It says the registry-cache resolver became the default for `endor run <entry.js>`, which is the shape the maintainer asked for on PR #282. The Node-style `node_modules` walk is kept behind `--node-modules`, and "the XS-hosted compartment-mapper bundle remains deferred".
- **Same phase, older PR:** #279 (Phase 4 entry-point input, based on `llm`) is also still open.

So this PR re-implements a phase that is already done, using an approach the design explicitly deferred, on a base thousands of commits stale. It cannot land without a full rework against `llm`.

**Part worth saving:** the nested-path tree-builder fix. On `llm`, `ingest_archive` in `cas_archive.rs` still splits ZIP paths only at the first `/`. So a file nested more than one level inside a compartment (`app-v1.0.0/lib/util.js`) is likely still stored under the flat key `lib/util.js`. I didn't run a test on `llm` to confirm the module fails to load there. If it does, `ArchiveTreeBuilder` and the `nested_module_loads_from_cas` and `nested_files_become_nested_trees` tests would make a small fix PR based on `llm`. I did not post that job; it's the maintainer's call.

Option: close as superseded

I spent no clean, panel, fix, CI-wait or un-draft budget, and made no edits or pushes.

<!-- gauntlet-stage-result: viability=overtaken -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1522-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 14 tokens (361197 cached reads)
- Output: 3446 tokens
- Cost: $0.5527114000000001
- Wall-clock: 49s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
