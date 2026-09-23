Implemented and pushed milestone 1; opened draft PR https://github.com/endojs/endo-but-for-bots/pull/1303 against frozen base `llm-387ea66` (`387ea66146a0b64d9d94a858369b0d37b09c55db`).

Changes:
- Added six deterministic workloads—closure sites, facet cohorts, harden tree/repeat, mixed OCap, and mutable control—at three sizes.
- Added Endo usage inventory, documented parameters, deterministic generation, manifest, and digest `2d2ee4d59557b1320cd7f35e4cc76826b837d36d444edc7d5ec3ce28529a950b`.
- Added Ironhorse/XS result verification, parent/candidate same-host runner, phase timings, computron and allocation counters, schema validation, and fail-closed tests.
- Added baseline artifact `rust/engine/benches/results/ocap-initial.json`.

Baseline command:
`CARGO_INCREMENTAL=0 RUST_MIN_STACK=33554432 python3 rust/engine/benches/ocap/run.py --parent llm-387ea66 --candidate HEAD --output rust/engine/benches/results/ocap-initial.json`

Baseline provenance:
- Candidate: `82d3d26de05b02f2479f4d21344c2b92879bd8ca`
- XS: `23b4d6b0a65f35209d9118c4c13c6c9b3e68784d`
- Host: `endolin-garden2-5bcdff64`, AMD Ryzen AI MAX+ 395, Linux 7.0.0-30 x86_64
- Toolchain: rustc 1.91.1, cargo 1.91.1
- Seven retained samples after one warmup; all results, parent/candidate computrons, and allocations matched; zero validation failures.
- Representative candidate/parent ratio: `1.0597854335629027`; no optimization was included.

Verification passed:
- 18 benchmark-checker tests.
- Report validation.
- Rust release OCap integration test across all 18 fixtures on Ironhorse and XS.
- Rust formatting, diff checks, and six pre-push probes.

The broader package suite encountered an unrelated existing `expectation_shards` `/tmp` fixture failure. Full local verification also exposed host/repository issues: missing Moddable ESLint dependency, unavailable `zizmor`, daemon-start test failures, and documentation-generation OOM. PR CI is pending.

Commits:
`e7cf07649a9a7869695bf4711a4e9069d2527c61`
`f0714d7ed7a9682d9c5979aa4e593c5318fb618d`
`c2613748ab01fd5c3f02a136822db87957bc6140`
`90fc531d5a745af1fd877915124286fc53aad08f`
`a8c214a3f8451193d19b83503872db7d1384e8bb`
`2a62a8ed0e474007e0716a7e2c60a5383e30a7e8`
`5061abeb40c37278d516b4445347146ec770bf5a`
`82d3d26de05b02f2479f4d21344c2b92879bd8ca`
`72afbc5f9c9ae660ae3e18237015abbe6cc1baf3`
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-ocap-benchmark-corpus.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 3136s

<!-- garden-usage-end -->
