# Completion report: scholar-ingest-yavashark-ironhorse-20261030

**Done:** Sharktheone/yavashark is in the library as a repo-overview source with four sections, written with an Iron Horse lens. The foreign-content classifier was not run.

**Verdict:** yavashark's Test262 runner ideas are worth taking, but its engine design doesn't fit Iron Horse.

## What I did
- **Grounding:** I read Iron Horse's current state first (`rust/engine/` ARCHITECTURE and README acceptance status, the test262-convergence and intrinsic-fault-in designs, the `ironhorse-262` scripts, the crate list) at endojs/endo-but-for-bots `origin/llm` `48d6f3e0`. That was the newest `llm` ref in the local clone; the plain `llm` branch there is stale.
- **Reading yavashark:** I cloned main @ `2e159150` (2026-11-11, MIT) into a scratch dir and read it as untrusted data. I checked the crate layout, the GC, values, strings, realm and intrinsics, built-ins and their dependencies, the Test262 runner (Go and Rust), and the early-error validator.
- **Classifier gate:** not run. The content came from a git clone, not a web fetch, and this host has no `TYPESAFE_API_KEY`. I proceeded under your 2026-11-12 bypass directive (commit `c2a2b3c899a`), but I couldn't find the bypass marker file under either state directory I checked. The source page records this as a `content_caveat`. I saw no instruction-like text.
- **Idempotency check:** no earlier `yavashark--*` source existed, so this is a fresh ingest.

## What changed (all landed on `journal2` through the lander)
- **New source page:** `library/sources/yavashark--overview.md` has an abstract, plus the two required headings ("Graftable with light translation" and "Architectural differences worth considering") as summaries that link to the sections.
- **Four new sections** in `library/sections/`:
  - `yavashark--overview--architecture-and-crate-map`
  - `yavashark--overview--test262-runner`
  - `yavashark--overview--graftable-for-ironhorse`: nine ranked candidates, each with the yavashark file, what Iron Horse lacks, effort, and license.
  - `yavashark--overview--architectural-differences-vs-ironhorse`: nine axes.
- **Topic rows:** four added to `topics/engine-implementation.md`, two to `topics/testing.md`.
- **Index:** a new row in `sources/README.md` under sibling implementations. Two shared files changed under me while landing; I re-read the latest version and reapplied my rows, without forcing.
- **Checks:** `library-link-check` passed. The sections index was regenerated and landed; topic counts were already current.
- **Reporting:** result entry `entries/2026/11/12/211310Z-result-scholar-902070.md`, and a short digest sent to the maintainer inbox.

## Findings
- **Worth taking (low effort):**
  - measured per-test CPU, wall time and memory, used to sort tests into fast/medium/slow/risky tiers;
  - deterministic hash-based N% sampling for quick PR runs;
  - pinning risky tests to their own CPUs.

  Iron Horse's sweep batches tests by count and has none of these. They target the flaky drifts the library records for high-parallelism sweeps.
- **Useful as references:**
  - `Intl.Locale`, built on the same ICU4X 2.2 that Iron Horse already pins;
  - `temporal_rs` as a possible test-only cross-check for Iron Horse's Temporal, which has no XS oracle. This one is speculative.
- **Little to take:** yavashark's other four Intl constructors look like empty shells.
- **Not a fit:** its SWC parser, reference-counted heap (cycle collection is off by default), host clock and time-zone coupling, and lack of any metering conflict with Iron Horse's goals.
- **Two speculative design ideas:**
  - building intrinsics lazily, relevant to the proposed `ironhorse-intrinsic-fault-in` design;
  - storing ASCII strings compactly as UTF-8, relevant to Iron Horse's memory target.
- **Unverified:**
  - the README's "~81% of test262" claim (the results live in a separate repo I didn't fetch);
  - the licenses of `temporal_rs` and `regress`.

## Follow-ups
- No follow-on ingest job posted. The skipped parts (the `experiments/` prototypes, the bytecode VM's async internals, the macro object model, and the yavashark-data results repo) are listed on the source page as not decision-relevant for now.
- A possible Iron Horse test-infra job to adopt the cost tiers, sampling, and CPU pinning would be your call.

Self-improvement: the scholar brief assumes web fetches go through the classifier, but says nothing about a repo cloned from outside the watched set. Here that meant the gate didn't apply, and the provenance had to be noted by hand. A one-line rule in `roles/scholar/AGENT.md` for unwatched-repo clones would settle it.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/scholar-ingest-yavashark-ironhorse-20261030.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 132 tokens (8757739 cached reads)
- Output: 38874 tokens
- Cost: $3.9230918000000004
- Wall-clock: 818s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
