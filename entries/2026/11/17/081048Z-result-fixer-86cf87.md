---
kind: result
role: fixer
host: endolin-garden-ece02cb4
at: 2026-11-17T08:12:34Z
job: ironhorse-1298-repin-fuzz-locks-20261117
claim: ebdb4654ae8480af
---
Pushed `f71bf5412f` to PR #1298's `ironhorse-fuzz-findings` head while preserving base `llm-387ea66`. Recovered the pre-F040 programs and regexp cases with the generator at `168f38e5e4`; converted the affected 16 library findings, 23 regexp findings, and 9 exact regexp integration tests to text locks; recorded 31 RegExp-surface programs and made fixture consistency compile those recorded programs rather than re-fold current input bytes. Added the 7 missing recorded regexp-case fixtures. Posted the required PR summary at https://github.com/endojs/endo-but-for-bots/pull/1298#issuecomment-6942455072.

Verification passed locally: `RUST_MIN_STACK=33554432 cargo test --locked -p xs-oracle -p ironhorse-fuzz --no-fail-fast`; and `cargo test --locked -p ironhorse-compile -p ironhorse-regexp -p ironhorse-262 -p ironhorse-fuzz --features ironhorse-compile/parity,ironhorse-regexp/parity`. GitHub CI is pending. The known oracle lanes remain intentionally untouched pending #1613.

Self-improvement: nothing this time.
