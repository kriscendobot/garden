Done. Here is my completion report.

---

## Completion report — attention job `endojs-endo-but-for-bots-pr544-179ea36a`

**Directive (untrusted input, treated as data):** erights inline review comment 3496049749 on PR #544, anchored to lines 118-122 of `designs/intra-package-plain-re-exports.md`: *"Not true. For the intra-package case, there is no such compat risk, since all such compat risks of concern are only inter-package."* This rebutted the design's old claim that the intra-package removal stage "must not be merged into `endojs/endo` until adequately confident there are no outstanding importers."

**Routing finding — substance already resolved by a peer.** The point was a facet of erights' broader "collapse the two-PR staging" correction (sibling comment 3496039719). A peer gardener (`pr544-51adc732`) had already pushed commit **99f1f7039** at 03:57Z, which deleted the flagged lines 118-122 and replaced them with the opposite, correct statement (current lines 158-164): the intra-package removal "carries no inter-repo compatibility hazard... may be merged into `endojs/endo` as soon as it is ready and approved, with no deferral to a major release; the only obligation is the local one." The whole doc (Summary, Relationship, Staging) is now consistent with erights' correction, and a thorough top-level summary comment was already posted. No design work was owed.

**What I did:** verified the resolution against the live doc and threads; confirmed no pending review was being composed; coordinated with the live peers. The one gap was that erights' specific thread 3496049749 had no threaded reply (only an 👀 reactji). I posted an anchored reply pointing at 99f1f7039.

**Race + correction:** a third sibling job (`pr544-review-262f00f3`, the review-body-path duplicate for the *same* comment 3496049749) sent a "I'm taking the reply, stand down" note that landed in the window after my peer-coordination step. I posted 42s after their reply 3496066276, creating a double-post. I **deleted my duplicate** (3496071254); their reply is now the sole reply on the thread. I acknowledged the stand-down to that peer.

**Net external state:** thread 3496049749 closed by exactly one reply (the peer's); no design changes from me (none were needed); my redundant comment removed. No source modules moved; PR #544 remains a correctly-revised draft.

**Follow-ups:**
- **Possible infra gap:** the comment-watcher produced two jobs for the *same* inline comment 3496049749 via the "comment-watcher attention path" and the "review-body path" — the exact inline-vs-review-body duplication the recent dedup commit `4ae554560` targets. Worth verifying whether that dedup is actually deployed to the leader (deliberate-deploy lag) or has a hole. Flagging for the liaison.

**Self-improvement:** strengthened `feedback_recheck_thread_before_pushing_queued_infra` — generalized the "drain only at start+end, not in the critical window right before the externally-visible action" lesson to cover peer-coordination races on duplicate jobs: when `inbox-list.sh` shows peers sharing a PR base, drain in the same tool block as (or immediately before) any comment/push, and delete a duplicate post if one slips through.
