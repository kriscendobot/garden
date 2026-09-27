PR #511 failed round 1 of the gauntlet panel: the verdict is **must-fix**, and it's posted on the PR as a comment review rather than a request-changes review.

**What I did**
- Checked out the PR head (`endojs/endo-but-for-bots`, branch `design/sturdy-refs-via-finalization-registry` at `648a10e75a`) in an isolated project worktree.
- Ran `panel.sh` in single-round mode against the PR's real merge base (`eb64412d76`). It exited 0 and returned `must-fix`.
- Seat votes: critic, skeptic, decomplector, ergonomist, copyeditor and pedant requested changes; novice left comments only; thesaurus approved.

**Main problems the panel found**
- **The retention mechanism can't work as written.** The design has a daemon-side `FinalizationRegistry` firing when the worker collects a ref. A registry only sees garbage collection in its own heap, and the worker runs in a separate process. The design needs a registry on the worker side that sends an explicit "dropped" message to the daemon, which is how captp's `finalize.js` works.
- **Refs can be released too early.** `holdsViaSturdyRef` is a single on/off edge with no count. If the same target crosses into a worker twice and one copy is collected, the edge is removed while the worker still holds the other copy.
- **It contradicts itself on how a SturdyRef crosses.** It calls a SturdyRef copied data in some places and a new captp slot kind (a tracked reference) in others.
- **Validity check (should-fix).** `confirmCanBeValid` would look up a WeakMap outside the object instead of checking only the object's own shape, unlike every other pass-style check.
- **Missing tests (should-fix).** No tests are named for the marshal round-trip or for rejecting local-only refs at the daemon boundary.
- **Likely typo.** `getStudyRefLocator` is probably meant to be `getSturdyRefLocator`.

**Posting the verdict**
- GitHub refused a request-changes review because the bot account authored this PR ("Can not request changes on your own pull request").
- I posted the full panel output as a comment review instead: https://github.com/endojs/endo-but-for-bots/pull/511#pullrequestreview-5328447771. A header line in it states the verdict is must-fix, and it carries the `garden-job` marker.

No garden code changed, nothing was committed, and the PR is still a draft.

**Follow-up:** the step that decides which gauntlet stage runs next may only recognize request-changes reviews as panel verdicts. On bot-authored PRs like this one, a must-fix verdict can only be a comment review, so that step may misread it; it's worth checking.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr511-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 8 on 2 host(s)
- Input: 28 tokens (946713 cached reads)
- Output: 4412 tokens
- Cost: $0.8196546
- Wall-clock: 310s
- Model(s): claude-opus-4-8 ×7, claude-opus-5-5 ×1

<!-- garden-usage-end -->
