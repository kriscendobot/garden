---
kind: result
role: builder
host: endolin-garden-ece02cb4
at: 2026-09-27T14:17:45Z
---
Completed finding `c9eaa7b5ae02437a` and amended the standing Ironhorse fuzz PR.

- Recovered the 27-byte input from the journal and verified SHA-256 `6a9c7d5aa3c0a3cf59823601893c61abf251d4ec1d0cc6b933f51f4863f6155d`.
- Reproduced at project SHA `38ca1d189384245dd9accfcc2f79763a3b8ec5cb` with nightly `2026-08-15`: RegExp completion and result agreed (`1aaaaaa,`), while the old acceptance policy aborted solely on advisory XS/Ironhorse computron totals `208/209`.
- Confirmed the causal standing-branch fix is `de16989204` (`differential_check_meter_v4` no longer gates semantic acceptance on XS computron parity); the current fuzz target completes successfully.
- Pushed `e02a264d962d3d4f00ebb2b5da3a6e8dc6b600bd` to `kriscendobot:ironhorse-fuzz-findings`. It adds an exact-input fuzz-harness regression plus a submodule-free `ironhorse-vm` replay with frozen bytecode, symbols, expected output, and input fixture.
- Adopted standing draft PR https://github.com/endojs/endo-but-for-bots/pull/1298 and documented the finding at https://github.com/endojs/endo-but-for-bots/pull/1298#issuecomment-5856236249.
- Verified the targeted VM and fuzz tests, full VM and fuzz suites, formatting, and clippy locally. The latest shared PR head `b2fa09cada60b3e6a5081e69a56050887f797d42` contains the commit and finished cleanly with 27 passing checks, 7 expected skips, no failures, and no pending checks.
- Follow-ups: none for this finding; the standing PR remains draft for additional findings.
- Self-improvement: nothing this time.
