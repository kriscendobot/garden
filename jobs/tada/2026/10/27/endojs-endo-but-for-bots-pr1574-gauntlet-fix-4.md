# Gauntlet fix round 4: endojs/endo-but-for-bots#1574

I applied the panel-4 must-fix items, and most of the should-fix and comment-only items, as one follow-up commit. CI came back green: 30 of 30 checks passed, `ci-wait-merge.sh` exited 0.

The job body had no pre-pass block, so I worked from the latest panel verdict, review 5663154189 ("Must-fix before merge"). The fix is commit `f84ca3d2d1` on `design/api-key-agent-workbench`. I pushed it with `safe-push-pr-head.sh`, which fast-forwarded the branch from `033a55f51b`. Only `designs/api-key-agent-workbench.md` changed (+57/−42).

**Must-fix items (all four done):**
- **skeptic 1:** The design now says #1543 is an unmerged design whose phases are all unbuilt. It names its one change to the parent: it fixes how the broker serializes admissions, which the parent leaves unspecified. If the parent's phase 2 lands with a different broker, W3 becomes a rewrite and the design must be revised before W3 starts.
- **ergonomist 1:** `recordedLimits` is now optional and appears only with `getStatus({ verbose: true })`, described as the base that `resize` merges into.
- **ergonomist 2:** § Refusals now has one rule. A method throws when the request itself can't be honored, and returns normally, reporting the state, when the request is valid but the delegation's state blocks it. It lists the cases: `askSubagent` is the only tool that returns a tag; `resize` below usage succeeds; `pause`, `resume` and `resize` on a revoked child throw `agent-deleted`; `spawn` with a used name returns the existing child or throws `spawn-name-in-use`.
- **copyeditor 1:** The deferred queue is now named as the child agent's queue, as the parent design keeps one per agent.

**Should-fix and comment-only items applied:**
- **critic:**
  - The parent reserve is now described as best-effort, with the owner's control as the path that doesn't depend on budget.
  - Upstream aborts happen only after the cancelling queue entry commits, and the design says what happens when an abort fails.
  - Added the expected queue load and a benchmark trigger for adding a running total.
  - `resize` is bounded by the immediate parent's recorded limits, whoever calls it.
  - Status now says leaving Proposed requires an answer to open question 3.
- **skeptic:**
  - The design proposes a new lease per provider, refused with `broker-not-exclusive`, so a second broker for the same provider fails, with matching W3 tests.
  - The worst-case bound after a pause is restated to cover a concurrent `resize` and a period reset, with a W4 test.
  - Forwarding a sibling's `AgentInference` is named, along with who bears the loss.
  - Added a W4 test asserting the adapter's ask-timeout limits.
- **ergonomist:** The design now covers:
  - using `set` and `remove` with the same name (refused with `endowment-conflict`) and how a minted bundle is removed;
  - a one-sentence statement of the pause bound for `help()`;
  - that the `control` returned by `spawn` and the one bound at `subagent-controls/<name>` are the same object.
- **copyeditor:** Fixed a subject-verb agreement error, the "claims are tests" sentence, the unclear table reference, and several ambiguous antecedents.
- **pruner:**
  - Cut the `glorp` commit history, the stale Fae documentation paragraph, the restatement of the revoke cascade, and the long rationale in Design Decisions 4–6.
  - Trimmed the PR body to about 150 words with `gh pr edit`.

**Not applied:**
- **ergonomist 3 and 7:** the naming families and the unit convention in `ChildLimits`.
- **pruner 4:** I kept the ownership map. The critic counted it in the design's favour.
- **critic 6 / skeptic 7:** surfacing expired deferrals in `getStatus()`. Both were comment-only, and adding fields would cut against ergonomist 1.

**Follow-ups:** none from this stage; the driver posts panel-5. The design now proposes a lease per provider in the broker. Panel-5 should review it, because it adds a mechanism that neither #1543 nor any earlier panel round has seen.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1574-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 26 tokens (1044310 cached reads)
- Output: 13449 tokens
- Cost: $1.1962579999999998
- Wall-clock: 779s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
