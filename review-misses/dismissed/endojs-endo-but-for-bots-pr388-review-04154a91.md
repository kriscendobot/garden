---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr388-review-04154a91
verdict: not-a-miss
category: new-direction
pr: 388
review_at: 2026-08-16T06:00:08Z
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/388#discussion_r3791088077
identity: endojs/endo-but-for-bots#388:review:4945543700:retro
producing_role: builder
producing_job: endojs-endo-but-for-bots-pr388-review-04154a91
severity: minor
---

# Dismissal: endo-but-for-bots #388 review 4945543700 (retro)

kriskowal's inline comment on `packages/gateway/src/node-crypto-powers.js` asks,
in paraphrase, whether a typed array (`Uint8Array`) could be used in place of the
`ArrayBuffer`-shaped byte value at that call site. This retro judges whether the
garden **review process** (panel/gauntlet/seats/standing instructions) should have
anticipated it and concludes it could not have — this is maintainer taste and
architectural direction, not a review-catchable defect.

Grounds (drawn from #388's actual history, not the primary's report):

- **A genuine, defensible design fork the producer explicitly surfaced.** The PR
  body carries an "Architectural choice for maintainer confirmation" section stating
  that the builder deliberately chose immutable `ArrayBuffer` as the cross-realm byte
  shape because typed arrays cannot be frozen and so are non-passable through
  `@endo/marshal` / `@endo/patterns`, and because that is what `packages/ocapn`
  already uses for keys, signatures, and IDs. The builder asked the maintainer to
  confirm the choice or request the design text name `ArrayBuffer` explicitly. The
  ambiguity was elevated, not hidden — the review process working as intended.

- **The maintainer's preference contradicts a defensible existing precedent.** The
  `Uint8Array`-as-lingua-franca preference is a repo-owner taste call that overrides
  the `ocapn`/`@endo/bytes` byte-shape convention the producer reasonably followed.
  It is encoded in no juror seat brief, skill, or standing instruction; the codebase
  precedent pointed the *other* way. No garden review check could have anticipated a
  maintainer decision to override an in-tree precedent, and the producer had already
  flagged the fork for a maintainer verdict.

- **Not the `prefer-endo-primitives` family.** That cluster is about hand-rolling a
  primitive an `@endo/*` package already provides. This is a type-choice between two
  competing endo idioms (`ArrayBuffer` per ocapn vs `Uint8Array` per the maintainer's
  stated preference), not a reuse-vs-reimplement miss.

- **First stated at review time, not knowable at build time.** The maintainer's
  clearest statements of this preference (the 2026-06-02 review comments on the same
  PR: "prefer Uint8Array strictly", "favor Uint8Array at the interface throughout
  this module", "should not be necessary if we use Uint8Array as a lingua franca")
  are themselves the review of this PR — they postdate the ArrayBuffer choice. The
  2026-08-16 comment re-raises the same preference during a re-review of the (by then
  auto-closed) PR; no producer work happened between June and August, so this is the
  same review round re-surfacing, not a producer ignoring landed feedback.

- **No skipped-evaluator (avoidance) shape, and the directive was genuinely
  executed.** #388 is a draft, stacked phase-2 feature PR; no gauntlet/panel job for
  it appears in `journal/jobs/tada/` — but a panel, had it run, could not have
  enforced a maintainer taste that contradicts in-tree precedent, so there is no
  `process`/gaming miss. The primary loop genuinely resolved the directive: commit
  `c709a4d7` ("refactor(gateway): pass Uint8Array DER key without a Buffer view",
  authored 2026-08-16T06:07:06Z, verified present on the fork) drops the `Buffer`
  re-wrap and passes the assembled `Uint8Array` DER straight to
  `crypto.createPublicKey`/`createPrivateKey`, with an in-thread reply
  (`r3791101756`). This is not a false no-op.

Recorded as a durable dismissal so the same review is never re-litigated. No cluster
minted; no improvement dispatched. See comment_url for the verbatim comment.
