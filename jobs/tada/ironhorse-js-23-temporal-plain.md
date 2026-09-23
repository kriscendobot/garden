---
orchestration-failed: true
---
Implemented and pushed Temporal plain ISO-family support to the shared draft PR.

- Added branded, immutable `PlainDate`, `PlainTime`, `PlainDateTime`, `PlainYearMonth`, `PlainMonthDay`, and ISO `Calendar` records.
- Implemented constructors, parsing/formatting, field access, `from`/`with`, comparison/equality, arithmetic/difference, and plain-family conversions.
- Added three focused XS-differential Rust regression groups.
- Official pinned slice: 2,626 cases; 0 failures/infrastructure before and after. Host-only `oracle-host-missing-temporal` increased 1,379 → 1,568, while descriptor-related unsupported cases fell 272 → 32. The pinned corpus contains no `Temporal/Calendar` tests.
- Remaining 1,058 skips are shared prerequisites, chiefly Unicode-regexp `u`/`v` support (969), descriptor reflection (32), native `apply` (26), and parse/decode gaps (19). Thus the complete-slice gate remains unmet.
- Verification passed:
  - `cargo test -p ironhorse-262 --test temporal_plain`
  - `cargo test --workspace --release`
  - Official five-family XS differential run: 2,626 total, 0 failed
  - Exact-meter corpus: 1,712/1,712 covered, 0 failed/skipped
- Pins unchanged: test262 `be13516fb6441b950ba8a3df97eb34062c186972`; XS `23b4d6b0a65f35209d9118c4c13c6c9b3e68784d`.
- Head: `99e607aa39abe8e5fee7abdafc1068b799dad476`
- PR: https://github.com/endojs/endo-but-for-bots/pull/970 — open and draft.
- Completion comment: https://github.com/endojs/endo-but-for-bots/pull/970#issuecomment-5297560859
- Self-improvement: nothing this time.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-js-23-temporal-plain.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 807s

<!-- garden-usage-end -->
