---
kind: review-miss
primary_job: endojs-endo-but-for-bots-pr877-review-e5dd1111
verdict: miss
category: docs-drift
pr: 877
cluster: docs-claim-contradicts-code-semantics
review_at: 2026-08-16T20:15:40Z
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/877#pullrequestreview-4947220215
identity: endojs/endo-but-for-bots#877:review:4947220215
producing_role: builder
producing_job: endojs-endo-but-for-bots-pr877 (feat/endor-npm-dual-build-execution)
missed_by: scribe
severity: minor
---

The maintainer's review ("Nits only", CHANGES_REQUESTED) flagged two nits, both
on `packages/daemon/src/archive-text-endowments-xs.js`.

**Filed miss (docs-drift).** A header comment justified the file's in-place
forgiving-base64 reimplementation by asserting that `@endo/base64` *deliberately
does not provide* the atob/btoa layer. That is a definite, in-repo-verifiable
technical claim, and it is false: `@endo/base64` ships `atob.js`, `btoa.js`, an
`index.js` export, and an `@endo/base64/shim.js`. The reimplementation itself is
legitimate (it adds the WHATWG *forgiving* semantics — whitespace tolerance,
optional padding, `InvalidCharacterError` — that the strict RFC-4648 `@endo`
flavor omits), so the fix was a comment-accuracy correction, not a behavior
change. Review reads comment prose for clarity but does not cross-verify a
definite claim about a sibling in-repo package against that package's actual
exports, so the false claim reached the maintainer. This is the identical shape
to the cluster's founding member (#475: a README brand-check claim contradicted
by `@endo/pass-style` `byteArray.js` in the same monorepo).

**Second, related nit (noted, not separately filed — the store keys one record
per primary).** The alias `E` was chosen for `globalThis.__archiveEndowments`,
colliding with Endo's well-known eventual-send `E`; the maintainer asked for a
descriptive name and the fix renamed it to `endowments`. This is a naming nit of
the `avoid-name-abbreviations` family, but a single-character identifier slips
the landed `spell-out-identifiers` gate, which targets multi-character
truncations (`dir`, `subDir`, `Arg`). Recorded here as grounds; the docs-drift
false-claim is filed as the dominant verdict because it is the less-covered
review gap and the *second* base64/`@endo` return-trip on this same PR (cf. the
earlier #877 `prefer-endo-primitives` miss `review-1eec395e`).

**Grounds for a miss (not new-direction):** the base64 claim is a checkable
technical assertion contradicting authoritative code living in the same
monorepo, catchable by a docs/spec cross-verification lens — not taste, scope,
or a requirement first stated in the comment. Both nits map to known review
lenses (a docs cross-verify seat; the naming seat/gate), so the review process,
not just a fresh maintainer opinion, is what failed to anticipate them.
