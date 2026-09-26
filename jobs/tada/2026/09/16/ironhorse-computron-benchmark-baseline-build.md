---
handed-off: ironhorse-computron-benchmark-baseline-build-exec
deliverable-complete: false
---
The successor is durably on `origin/journal2`, the audit is preserved in both the successor body and the maintainer message, and the maintainer has been messaged. The handoff is real and verifiable. No garden `main2` code changes were needed — this job's deliverable is the audit plus the surfaced decisions.

## Completion report

**Job:** `ironhorse-computron-benchmark-baseline-build` (builder) — execute the plan from sibling design `ironhorse-computron-benchmark-baseline-design` (design PR endojs/endo-but-for-bots#1283) to re-express PR #1282's removed range-constraining computron tests as benchmark-established baselines.

**What I did**
- Read the landed plan (`designs/ironhorse-computron-benchmark-baseline.md`, fetched from draft PR #1283 branch) and the design's tada report. Confirmed the design is an **unreviewed draft PR** (no comments, no reviews) with a `## Open questions` section the designer explicitly flagged as *gating build implementation specifics*.
- Set up an isolated project worktree of `endojs/endo-but-for-bots` on `llm`.
- **Completed the plan's step 1 — the audit**: for every test PR #1282 removed or relaxed, determined whether the load's computron range is still constrained. Verified against the `chore/ironhorse-demolish-xs-computron-parity-myth` head state and the 53-entry golden corpus (`ironhorse-vm/tests/fixtures/computrons.tsv`). Result — **loads left with no surviving own-cost constraint (the gap the regime must fill):** async-generator `await` metering (`await_in_try.rs`), suspend-in-try metering (`suspend_in_try_metering.rs`), promise-combinator meter (`promise_combinator_capability_result_parity.rs`), and regexp match-meter (`parity.rs`+fuzz, partially retained via `work_limits.rs` and the `finding_*` overflow pins). Kept-constrained: `error_messages_calls.rs` `==14`, the ~15 interp frozen pins, `ironhorse_meter_bounds.rs`, `ironhorse-meter-5-raw-N` raw pins, the golden corpus, `--repeat`.

**Why I did not build the full regime now (steps 2–8)** — two independent, real blockers:
1. **Premature/gated:** the design is unreviewed and its 6 open questions define the *substance* of the committed artifact — the seed roster (which loads to baseline) and the tolerance bands (the gate values). Committing measured, provenance-tracked baselines against unconfirmed parameters, as a PR competing with the still-open design PR, inverts the intended design→review→build flow and risks throwaway churn.
2. **Infeasible to spec here:** the "benchmark-established" heart (gate 3, steps 4 & 8) requires wall-clock median measurement on a **controlled host**; the garden's linuxkit container cannot produce representative medians the committed `computron-baseline.json` provenance demands.

**What changed / evidence**
- Sent the maintainer (via liaison) a message delivered to `inbox/maintainer` (`msg-ironhorse-computron-benchmark-baseline-build-88d207a2b27d`): the audit + all 6 open questions with the design's recommended defaults, requesting confirm/adjust or a "build on defaults" go-ahead.
- Durably parked successor build job **`ironhorse-computron-benchmark-baseline-build-exec`** on the plan queue (verified on `origin/journal2` at `jobs/plan/ironhorse-computron-benchmark-baseline-build-exec.md`), owning steps 2–8, carrying the full audit and a two-part GATE (maintainer answers + #1283 review / go-ahead) plus the controlled-host note. Ready for the liaison to promote once the maintainer answers.
- No garden `main2` code changes; no PR opened (a hollow implementation PR would be noise and would collide with the still-open design PR).

**Follow-ups / who owns what**
- **Maintainer:** answer the 6 open questions on the message (or approve building on the design's defaults) and review/approve design PR #1283.
- **Liaison:** on the maintainer's reply, promote `ironhorse-computron-benchmark-baseline-build-exec`.
- **Successor job:** executes steps 2–8 (record format, harness with gates 1–2 + `--write-baseline`, nightly gate 3, roster seeding + measurement on a controlled host, CI wiring, #1282 reconciliation/rebase, evidence), opening the PR via `ensure-pr.sh` against `llm`.

The core deliverable (the executed regime + PR) is intentionally unfinished pending maintainer decisions and a benchmark-capable host; step 1 is delivered and all remaining work is durably owned by the named successor.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-computron-benchmark-baseline-build.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 66 tokens (2203037 cached reads)
- Output: 35957 tokens
- Cost: $2.8569835
- Wall-clock: 700s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
