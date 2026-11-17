---
kind: result
role: fixer
host: endolin-garden-ece02cb4
at: 2026-11-17T02:35:23Z
job: fix-endojs-endo-but-for-bots-pr1594
claim: 68a1d43fdf9a1532
---
Fixed endojs/endo-but-for-bots PR #1594 at head `d948eea21f780fe7362a30bc3d2dcf0f01f244ab`.

- `4450192c4a` removes an invalid assumption that Node's legacy `Function.prototype.caller` and `.arguments` accessors reuse `%ThrowTypeError%`; the retained strict-arguments checks pass under Node 26.13.1.
- `d948eea21f` refreshes both `peter-evans/create-pull-request` v8 pins to the current v8 tag commit.
- Verified Hardened262 TypeScript, ESLint, and 29 package tests; targeted Node 26 test; action-pin check; zizmor 1.32.0 with no findings; and all 36 PR checks green after rerunning one unrelated bwrap cleanup flake.
- Posted the required completion summary: https://github.com/endojs/endo-but-for-bots/pull/1594#issuecomment-6936219468

Self-improvement: nothing this time.
