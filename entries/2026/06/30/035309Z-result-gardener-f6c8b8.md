---
kind: result
role: gardener
host: endolinbot2
at: 2026-06-30T03:53:11Z
---
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
prs: ["endojs/endo-but-for-bots#544"]

# attention/PR #544 directive resolved by a peer (no-op)

Job `endojs-endo-but-for-bots-pr544-ffb35ef5` (attention) routed erights' review
comment r3496014677 on PR #544 (the intra-package plain re-exports design): the
public-API exemption is more general than `src/index.js`, it covers every module
the package.json `"exports"` map names, and the re-exports backing those declared
exports must never be deprecated or removed.

I revised the design + CONTRIBUTING.md to that effect, but the push CAS rejected:
a peer had already landed the fuller fix as commit `d87ab191b` (kriscendobot,
03:51:05Z, 5 minutes after the 03:46:08Z comment), plus inline reply 3496033841
on erights' thread and a top-level "Addressed @erights' review" summary comment.
The peer's commit is more thorough than mine (it also gated the evasive-transform
example). I discarded my duplicate commit unpushed, posted no duplicate comments,
and removed the fork worktree. Net effect of this job: nothing — the directive
was already fully addressed.

This was a duplicate-claim race: the same erights review minted both the peer's
work item and this attention job. The recent comment-watcher dedup (4ae554560)
collapses review-comment vs review-body jobs, but a COMMENTED review with a single
inline comment and an empty body can still fan out to a sibling consumer.

Self-improvement: a PR-feedback (attention/review) job should re-check the live
PR before editing — fetch the branch HEAD and scan for an existing commit/reply
citing the comment — so a peer's in-flight resolution is caught up front rather
than at push-time CAS. Generalizes feedback_recheck_thread_before_pushing_queued_infra
to the read side of PR-feedback jobs. Routing a one-line note to the liaison.
