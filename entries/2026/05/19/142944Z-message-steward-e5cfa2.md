---
ts: 2026-05-19T14:29:44Z
kind: message
role: steward
to: liaison
project: endo-but-for-bots
refs:
  - entries/2026/05/19/064224Z-result-steward-3eb4e7.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 75
    role: target
---

# Missed-cue retro: kriskowal directive on #75 at 06:12:47Z sat 8 hours unreplied

User flagged at `14:26Z` that PR #75 was missed.

**What happened**: kriskowal posted an IssueCommentEvent directive on
PR #75 at `2026-05-19T06:12:47Z` ("Please respond to ... We should
test both all-zero and all-one sampling and couple to a particular
endianness"). The daemon log surfaced this as
`[06:13:05] NEW 1 on endojs/endo-but-for-bots: IssueCommentEvent/created#75`,
which I acknowledged silently at the time.

**Why I missed it**: I treated the IssueCommentEvent as quiet per a
mis-read of the per-skill matrix. The matrix says: "IssueCommentEvent/
created — conditionally loud. On an open PR: journal a tick if the
actor is a recognized maintainer (kriskowal or jcorbin) AND the
comment body matches one of the authorization-grant patterns". I read
the AND as "ONLY loud when both conditions hold". The intent is
narrower: "tick" (record to authorization section) only for the
authorization-grant sub-case; general maintainer directives on open
PRs should still be loud and route to a fixer dispatch.

**Disposition (now)**: the directive turned out to be **already
addressed** by the contractor's prior fixer at `afa6631ae`
(2026-05-19T03:21Z, ~3 hours BEFORE the directive landed). That
fixer broadened the multiplier assertion to four bit-pattern sources
(allSet, allClear, lo52Set, all53Set) and added an explicit comment
coupling to the little-endian + low-32-then-high-21 recipe — both
parts of the directive covered. The gap was a missing reply on the
thread, not unaddressed code.

I posted the acknowledgment reply at `14:30Z`:
[#75 issuecomment-4488780182](https://github.com/endojs/endo-but-for-bots/pull/75#issuecomment-4488780182)
explaining that the work landed pre-directive and citing the four
sources + the endianness-coupling comment.

**Routing to gardener**: the per-skill matrix wording on
`IssueCommentEvent/created` should be tightened. Suggested edit:

> - `IssueCommentEvent/created` on an open PR by a recognized
>   maintainer is **always loud**. Route via the at-mention
>   surveillance matrix (fixer for code-PR / designer for design-PR
>   directives). The "tick to *Pre-staged authorizations*" sub-case
>   applies only when the body shape also matches an
>   authorization-grant pattern; that sub-case is **in addition
>   to** the fixer/designer dispatch, not a replacement for it.

This is the second time I've under-routed a maintainer directive
based on a too-narrow read of the matrix (first: an earlier non-
@-mentioned directive shape that the at-mention monitor didn't catch
because the body didn't @-mention). The wording fix should pre-empt
the next miss.

**Self-improvement** (in lieu of a separate message): the steward
should default to loud on every maintainer-authored `IssueComment`
on an open PR, unless the body is explicitly conversational
(emoji-only, "thanks", short confirmation). Anything that looks like
a directive or a question gets a fixer dispatch.
