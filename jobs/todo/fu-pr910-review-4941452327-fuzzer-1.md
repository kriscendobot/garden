---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
In endojs/endo-but-for-bots, on PR https://github.com/endojs/endo-but-for-bots/pull/910, apply the `streamWindowBase64` clamp identified by the fuzzer review of PR-head `4fa0a45f3` and add the missing `range(MAX_SAFE).streamBase64()` regression test covering a producer with no `streamBytes`. Push the fix as a follow-up commit on the PR branch and confirm CI.
