---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr475-review-2f4785d0
verdict: not-a-miss
category: new-direction
pr: 475
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/475#pullrequestreview-4998349698
identity: endojs/endo-but-for-bots#475:review:4998349698:retro
producing_role: builder
producing_job: endojs-endo-but-for-bots-pr475-review-2f4785d0
review_at: 2026-08-22T00:23:37Z
missed_by: none
severity: minor
grounds: >
  erights (repo owner and maintainer) left review 4998349698 (state COMMENTED,
  empty body) carrying a single inline comment (id 3834552639) on
  packages/immutable-arraybuffer/src/bytes.js at the thawedBytes @param: it
  observes that the local variable named "buffer" holds only Uint8Arrays and
  asks — paraphrased — whether renaming all such variables to "bytes" would work
  well or would stylistically/technically conflict with other uses of "bytes",
  and what the author would suggest if it did. I re-fetched the review and its
  inline comments read-only in this retro to ground the verdict in the world,
  not the primary report: the one inline comment above is the entire feedback,
  and the primary's deliverable is real and pushed — commit 1364f685c
  ("refactor(bytes): name Uint8Array values bytes (#475)") renamed both
  PR-added `buffer` parameters to `bytes` (thawedBytes in bytes.js and
  decodeBytestringLabel in ocapn/src/syrup/codec.js). So the single loop
  genuinely addressed the ask; this second loop only judges whether the review
  process should have anticipated the preference.
  It could not have, for three grounds. (1) The comment is an exploratory
  naming question, not an indictment: the maintainer is himself uncertain the
  rename is even correct — he asks whether it "would work well" or would
  "conflict" and asks the author "what do you suggest instead". A convention the
  panel demonstrably knew and violated does not arrive phrased as an open
  question the reviewer is still working out. (2) `buffer` naming a Uint8Array
  is a legitimate, common idiom, not a defect — Node's `Buffer` IS a Uint8Array
  subclass, so the name is defensible; there is nothing wrong to catch, only a
  taste refinement toward `bytes` for extra precision. (3) No standing rule
  bound: a repo-wide grep of every juror seat brief and skill for a
  "don't-name-a-typed-array-buffer" / name-by-type / bytes-vs-buffer convention
  returns nothing. The existing naming cluster `avoid-name-abbreviations`
  governs abbreviated identifiers (dir, Arg, subDir, Cmd); `buffer` is a full,
  unabbreviated word, so that gate and its stylist/ergonomist amendments do not
  reach this case, and no other seat encodes a type-precision naming rule. The
  stylist's generic "non-misleading name" lens does not bind a name that is a
  standard idiom. The preference for `bytes` over `buffer` on Uint8Array-typed
  locals is first stated in this comment; nobody could have anticipated it.
  Textbook new direction / taste. No cluster minted; no improvement dispatched.
  Recorded durably so the same review is never re-litigated.
---

# Dismissal: endo-but-for-bots #475 review 4998349698 (retro)

erights (repo owner and maintainer) left one inline comment on
packages/immutable-arraybuffer/src/bytes.js in review 4998349698: paraphrased,
the local variable named `buffer` here holds only Uint8Arrays, so would renaming
all such variables to `bytes` work well, or would it conflict stylistically or
technically with other uses of `bytes` — and if so, what would the author
suggest instead?

Not a garden review-process miss — new direction / taste. The comment is an
exploratory naming question, not a caught-should-have defect: the maintainer is
himself unsure the rename is right ("would it work well... or would that
conflict... what do you suggest instead?"), which is the signature of a
preference being formed in dialogue rather than a convention the panel knew and
let through. Naming a `Uint8Array` variable `buffer` is a legitimate idiom, not
a bug — Node's `Buffer` is itself a `Uint8Array` subclass — so there was nothing
for a panel seat, gate, or standing instruction to flag ahead of the maintainer;
the `bytes` rename is a precision refinement, not a fix.

Three grounds confirm no review surface could have anticipated it. (1) The
existing naming cluster `avoid-name-abbreviations` and its stylist/ergonomist
amendments target abbreviated identifiers (dir, Arg, subDir, Cmd); `buffer` is a
full, unabbreviated word, so that gate does not reach this case. (2) A repo-wide
grep of every juror seat brief and skill finds no `bytes`-vs-`buffer` /
name-by-type / don't-name-a-typed-array-`buffer` convention — no seat, gate, or
COMMON.md norm demanded it. (3) The stylist's generic "non-misleading name" lens
does not bind a name that is a standard idiom for byte arrays. The preference is
first stated in this comment.

Grounded in the world, not the primary report: the primary's fix is real and
pushed. Commit 1364f685c ("refactor(bytes): name Uint8Array values bytes (#475)")
renamed both PR-added `buffer` parameters to `bytes` (thawedBytes in bytes.js and
decodeBytestringLabel in ocapn/src/syrup/codec.js) — so the single-loop response
genuinely landed the maintainer's preference. Same class as prior maintainer
taste/new-direction dismissals. No cluster minted; no improvement dispatched.
See comment_url for the verbatim comment.
