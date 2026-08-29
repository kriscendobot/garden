---
role: designer
handler-budget-role: review
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Design adaptive exo-stream pacing and buffer control

Design a follow-up to the fixed `buffer` option used by `@endo/exo-stream`
readers, including `ReadableBlob.lines()`. Consider a CoDel-inspired algorithm
that implicitly controls producer pace and buffer size while retaining an
explicit alpha parameter for the caller to select relative aggressiveness.

Specify the observable signals and control loop, where the policy belongs,
how it composes with CapTP flow control and cancellation, compatibility with
fixed-buffer callers, limits and failure behavior, and a verification plan.
Keep the current `ReadableBlob.lines(buffer = 0)` decision unchanged unless
this follow-up establishes a replacement suitable for the shared reader API.

Origin: https://github.com/endojs/endo-but-for-bots/pull/832#discussion_r3885564599
