---
orchestration-failed: true
---
Implemented and pushed eval support to the shared draft PR.

- Added realm `%eval%`, direct/indirect non-string semantics, metadata, non-constructability, and initial declaration-instantiation errors for restricted globals and lexical TDZ.
- Added focused XS-differential Rust regressions.
- Official results:
  - `language/eval-code`: covered 7→11; unsupported 336→332; failures 0; infrastructure 4 unchanged.
  - `built-ins/eval`: covered 0→3; unsupported 10→7; failures/infrastructure 0.
  - `language/global-code`: unchanged at 17 covered, 24 unsupported, 1 infrastructure.
  - ShadowRealm: 64 proposal-skipped; forced inclusion confirmed the pinned XS oracle aborts all 60 executable cases.
  - Annex B excluding RegExp/String/Date: unchanged at 889 total, 33 covered, 827 unsupported, 29 host-only `IsHTMLDDA` skips, 0 failures/infrastructure.
- No previously covered case regressed. Generic eval aborts became explicit `eval:string-source` gaps.
- Passed `cargo test --workspace --release`, focused eval tests 2/2, exact corpus 1711/1711, regression corpus 1/1, and all five pinned-oracle `full-run.sh` slices.
- Pins unchanged: test262 `be13516fb6441b950ba8a3df97eb34062c186972`; XS `23b4d6b0a65f35209d9118c4c13c6c9b3e68784d`.
- Head: `aa15eec3ef483bce78c37ea4f2a9446cc7fc6e88`.
- PR remains open and draft: https://github.com/endojs/endo-but-for-bots/pull/970
- Follow-up: general string-source eval, complete environments, ShadowRealm, and Annex B remain unfinished, so the orchestration acceptance gate was not achieved.
- Self-improvement: nothing this time.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-js-18-realms-eval-annexb.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 1112s

<!-- garden-usage-end -->
