---
kind: result
role: prosecutor
host: endolin-garden2-5bcdff64
at: 2026-08-22T06:39:46Z
---
---
kind: result
role: prosecutor
repo: endojs/endo-but-for-bots
project: endo
refs:
  - endojs/endo-but-for-bots#475:review:4998347995:retro
---

review-retrospective (second loop) on endojs/endo-but-for-bots PR #475, review
4998347995 (erights, empty body; substance in one inline comment): a parameter
named `buffer` bound only to a `Uint8Array` is confusing — the name is a remnant
of when it held an `ArrayBuffer` — with a request to sweep every `buffer`-named
variable whose value type does not contain "Buffer."

Verdict: **miss**, category `naming`, missed_by `stylist`. Grounds: the flagged
function carries `@param {Uint8Array} buffer` in its own JSDoc, so the
name-vs-type contradiction is visible in the diff without maintainer-only
knowledge; the stylist seat's brief already forbids "a name that lies about what
the value is" (primary surface) and calls out the JSDoc-name-vs-type
disagreement (secondary surface), yet the 2026-08-19 gauntlet's naming lens let it
through. Distinct from `avoid-name-abbreviations` (`buffer` is a misleading full
word, not an abbreviation) and from `stale-identifier-reference-sweep` (that is
docs/comment prose drift; this is a live source identifier contradicting its own
type annotation).

Recorded to review-misses/misses/endojs-endo-but-for-bots-pr475-review-5b54f00b.md,
minting cluster `name-contradicts-value-type` (count=1, prs={475}, status=open,
recurrence=0). **Threshold: hold, no dispatch** — a single miss on a single PR,
severity minor; below the K≥3-across-≥2-PRs floor, and minor severity makes it
ineligible for the single-major standing-rule bypass even though the stylist rule
existed and did not bind. No improvement job.

Grounded against the world, not the primary report: the primary (review-5b54f00b)
closed as a declared handoff (deliverable-complete: false) to
`endojs-endo-but-for-bots-pr475-c55fb1c4`. Confirmed that successor exists and
genuinely completed — it re-swept every non-`.js` file at PR head, found zero
further occurrences, and posted a substantive answer to erights
(issuecomment-5378301984). The two PR-diff parameters were renamed `buffer`→`bytes`
in commit 1364f685c with all checks green. So the first loop's resolution is real,
not a false no-op. Self-improvement: nothing this time.
