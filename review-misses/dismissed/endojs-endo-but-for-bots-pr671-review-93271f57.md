---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr671-review-93271f57
verdict: not-a-miss
category: new-direction
pr: 671
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/671#discussion_r3583159122
identity: endojs/endo-but-for-bots#671:review:4699156507:retro
producing_role: builder
severity: trivial
grounds: >
  kriskowal left a five-word inline comment on packages/daemon/src/daemon-go.js
  asking that a `promisify(zlib.gunzip)` call be hoisted up-front rather than
  re-wrapped inside the per-call `gunzip` closure that assembles the registry
  node powers. This retro judges whether the garden REVIEW PROCESS should have
  anticipated it and concludes it could not have. The ask is a code-hygiene /
  micro-idiom preference — compute the promisified wrapper once at module scope
  instead of on every invocation — on daemon module-SETUP code (registry-powers
  assembly), not a hot vat-crank path. No seat brief, skill, pre-push gate, or
  standing instruction in the garden mandates hoisting `promisify` wrappers, or
  any general "hoist invariant computation out of a per-call closure" rule
  (verified by grepping roles/jurors, skills, roles/COMMON.md, context/, and the
  pre-push-gates/local-verify skills for promisify/hoist/up-front/module-scope/
  per-call — no match). The closest lens, the engine-realist seat's
  allocation-budget check, is explicitly scoped to vat-crank allocation hotspots
  (its worked example is a WeakMap allocated per crank in a delimited-lifetime
  membrane); a rarely-invoked gunzip-wrapper allocation on a registry tarball
  path would rank comment-only there at most, not a demonstrable convention the
  panel failed to enforce. This is maintainer taste first stated in the comment,
  unanticipatable by any review surface — new direction, not a review-process
  miss. The primary loop already resolved it cleanly: a peer landed commit
  5442f32a8 promisifying zlib.gunzip once at module scope before the registry
  powers are assembled, and the primary job (pr671-review-93271f57) confirmed
  the fix via the deterministic preflight (exit 2, peer-resolved). Same
  cheap-dismissal class as the other trivial-preference retros. Recorded as a
  durable dismissal so this comment is never re-litigated. No cluster minted; no
  improvement dispatched.
---

# Dismissal: endo-but-for-bots #671 discussion r3583159122 (retro)

kriskowal asked, in a five-word inline comment on `daemon-go.js`, that a
`promisify(zlib.gunzip)` call be hoisted up-front instead of re-wrapped inside a
per-call `gunzip` closure in the registry node-powers assembly.

Not a garden review-process miss. The ask is a code-hygiene / micro-idiom
preference (compute the promisified wrapper once at module scope rather than per
invocation) on daemon module-setup code, not a hot path. No seat brief, skill,
gate, or standing instruction codifies "hoist promisify up-front" or any
general hoist-invariant-out-of-closure rule; the nearest lens (engine-realist's
allocation budget) is scoped to vat-crank allocation hotspots and would treat a
rare gunzip-wrapper allocation as comment-only at most. It is maintainer taste
first stated in the comment — unanticipatable, new direction. The primary loop
already landed the fix cleanly (peer commit 5442f32a8; primary job confirmed
via preflight exit 2). No cluster; no improvement. See comment_url for the
verbatim comment.
