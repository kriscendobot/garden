---
ts: 2026-05-20T03:41:05Z
kind: result
role: fixer
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
worktree: dispatches/fixer--3b27f7/project
---

Addressed kriskowal's `CHANGES_REQUESTED` "Unlikely." inline (comment
3271054176, file `packages/lal/primer/smallcaps.md`, line 7) on PR #290.

**Identified claim** (line 7 of the file at PR head `b813721ab`):

  "...so plain JSON values in your tool calls behave the way you
   expect."

This is the tail of the article's opening sentence introduced in
a0ee8b5e (deemphasize smallcaps primer article). Read in context with
the later "the harness handles regular strings ... without any prefix
from you" claim, the article over-promised transparent JSON behavior
that the harness only partially delivers: post-b813721a (scope decode
to per-tool `bigintArgs`), the harness deliberately does NOT touch
non-bigint fields — so the framing "the harness handles" them is
inverted; the truthful framing is "the harness does not decode them
at all."

**Disposition: replace.** Rewrote the article to state the inverse
contract directly:

  - SmallCaps surfaces in exactly one place: `messageNumber` BigInt
    arguments via `"+N"` / `"-N"`.
  - Every other field is bytes-for-bytes to the tool, including the
    `!`, `#`, `$`, `%`, `&`, `+`, `-` first-character cases.
  - The `@endo/marshal` SmallCaps grammar is documented for curiosity
    but explicitly NOT applied to tool arguments.

Dropped two related minimizations that read as the same "Unlikely."
claim from different angles: "You will rarely need to think about
SmallCaps directly" (false: every reply/dismiss/resolve/reject/adopt
needs `"+N"`) and "the harness handles regular strings ... without
any prefix from you" (true only because the harness no longer
processes them; better stated as "no decoding").

**Commit**: `6c17b25d3` (docs(lal): drop overstated SmallCaps
transparency claims (per kriskowal #290)).
**Push**: `git push origin HEAD:feat/lal-pi-harness` succeeded
(`b813721ab..6c17b25d3`).
**Inline reply**: id `3271080947` (POST'd via
`/pulls/290/comments/3271054176/replies`) cites the addressing SHA
and asks kriskowal to reopen if "Unlikely." was targeting a different
claim than line 7's "behave the way you expect."

**Pre-push gate**: ran `bash garden/skills/pre-push-gates/pre-push-gates.sh
--probes-only --summary`. The `sentence-per-line-md` probe initially
failed on three lines in the rewrite (first draft used wrap-only line
breaks; the project's `CLAUDE.md` § Markdown Style requires each
sentence start on a new line). Re-wrote so each sentence begins on
its own line; probe now passes. The remaining probe failures
(`filename-no-stutter`, `no-ascii-banners`, `no-inline-import-jsdoc`,
`security-md-hash-uniform`) are pre-existing repo-wide items that do
not touch `packages/lal/primer/smallcaps.md` and are out of this
dispatch's scope (diff-only scoping per the dispatch brief).

**Top-level summary comment**: not posted. The dispatch did not stage
a top-level-summary authorization (only the inline-reply authorization
implicit in a `CHANGES_REQUESTED`-driven fixer dispatch per
`roles/COMMON.md` § External-repo etiquette). The maintainer's review
body "Looking good." plus the single inline ask reads as a light
touch; the inline reply is sufficient.

**Re-request review**: not done. kriskowal's review state is
`CHANGES_REQUESTED` so a re-request would normally apply, but the
dispatch did not explicitly stage the `gh api .../requested_reviewers`
authorization and CI state was not verified by this dispatch. Defer
to the steward / liaison for the re-request after CI converges.

**Open questions**: one, recorded in the inline reply. "Unlikely." is
terse and the file at PR head has multiple candidate claims; I read
line 7's "behave the way you expect" as the primary target (the
literal line the comment anchors to, and the framing closest to the
two related over-promises). If kriskowal meant a different claim
(e.g., line 18-22's "without any prefix from you"), the rewrite still
addresses it because both framings landed in the same disposition.
The inline reply explicitly invites a reopen if my read was wrong.

Self-improvement: nothing this time. The `pr-review-thread-replies`
skill plus the `pre-push-gates` skill carried the entire dispatch
without surfacing a gap. Worth flagging that the `pre-push-gates`
probes scope to the staged diff first and fall back to
`origin/<base>...HEAD`, which on a PR branch surfaces every
pre-existing item in the PR; reading `gate failed` as "your diff
failed" is a false positive when the failing paths are not in the
staged diff. This is consistent with the skill's docs and not a gap.
