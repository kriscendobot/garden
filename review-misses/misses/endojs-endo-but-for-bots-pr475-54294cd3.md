---
kind: review-miss
primary_job: endojs-endo-but-for-bots-pr475-54294cd3
verdict: miss
category: test-gap
pr: 475
cluster: cross-platform-test-coverage
review_at: 2026-08-18T20:06:46Z
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/475#issuecomment-5333434953
identity: endojs/endo-but-for-bots#475:comment:5333434953
producing_role: builder
missed_by: engine-realist
severity: minor
---

On PR #475 (narrow byteArray to a plain frozen Uint8Array), several unit tests
in `@endo/immutable-arraybuffer` and `@endo/bytes` (and, latently,
`packages/pass-style/test/byteArray.test.js`) unconditionally constructed the
shim's emulated ArrayBuffer wrapper and asserted emulated-only shapes —
`ArrayBuffer.isView(view) === false`, `view[i] === undefined`, the
`[object ImmutableArrayBuffer]` buffer tag, OrdinarySet own-property shadowing.
These pass today only because Node lacks native immutable ArrayBuffer *and*
these packages' `test:xs` is an `exit 0` stub. The maintainer pointed out that
current XS already ships native immutable ArrayBuffer (Stage 3 detect-then-skip:
when `sliceToImmutable` exists the shim steps aside and `new Uint8Array(iab)` is
a genuine view), so the "no engine ships native, therefore always shimmed"
assumption baked into these assertions is obsolete and the tests are latent
false-greens that flip to failures the moment any engine ships native support or
`test:xs` runs under `xst`. A peer job (`...-verify-shimmed-claim-20260819`)
later gated the assertions behind a native-detection predicate (commit
`0984dd89b`) and filed a follow-up for the pass-style tests.

grounds: This is a miss, not new direction. The engine-realist seat brief
(`roles/jurors/engine-realist/AGENT.md`) is chartered exactly for this: its
"V8 vs XS reality" axis asks whether a test "covers both engines or documents
why one engine is out of scope," and its secondary regression-evidence surface
owns the "this assertion passes on V8 but is engine-defined" slice. Emulated-only
assertions that hold only because the runner lacks native support are engine-
specific by construction; a standing seat brief that already existed did not
bind. The stage-3 detect-then-skip design means "native could ship" was always a
planned-for reality, not a surprise requirement first stated in the comment.
Joins `cross-platform-test-coverage` (PR #836): same family — XS-vs-V8 behavioral
divergence the panel did not require tests to exercise; #836 was "no test:xs
variant at all," #475 is "tests exist but encode a shimmed-only engine
assumption unvalidated under native/XS." Severity minor: test-only, latent, no
shipped runtime defect (the runtime source branches on `ArrayBuffer.isView` and
is native-safe), and caught pre-merge.
