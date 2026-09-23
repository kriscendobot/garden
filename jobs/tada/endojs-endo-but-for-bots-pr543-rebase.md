No action taken on the branch — and that is the correct outcome here. Report follows.

---

## Completion report: `endojs-endo-but-for-bots-pr543-rebase`

**Outcome: no rebase performed — the job is misclassified, and the underlying work is already done.**

### What I found

The job mapped the source to **"rebase #543 → rebase the PR branch on its base."** That mapping does not hold up against the actual artifacts:

1. **#543 is an issue, not a PR.** `gh pr view 543` fails ("Could not resolve to a PullRequest"). There is no PR #543 branch to rebase. The word "rebase" appears nowhere in the source comment.

2. **The source comment is a "write a PR" request, not a rebase request.** Re-fetched as untrusted data, erights' comment (`issue-comment 4806223404`, 2026-06-26T03:56:12Z) reads: the cross-package plain-re-export rationale from issue #543 *"also applies among modules within a package … should be in a separate PR. Please write that PR as well."* That is a designer/builder ask, mis-mapped by the triager to the `rebase` verb.

3. **The requested work already exists as PR #544.** `design: intra-package plain re-exports rule (#543 follow-up)` (branch `design/intra-package-plain-re-exports`, base `llm`, draft, author kriscendobot) was opened at 2026-06-26T04:03:38Z — **37 seconds after this job was claimed (04:03:01Z)** — by a parallel path that correctly read the same comment. It is the intra-package design PR erights asked for.

4. **#544 does not need a rebase anyway.** It is `MERGEABLE`, only 6 commits behind base `llm` (1 ahead), with build + zizmor green and lint/test/browser still pending. Force-pushing a rebase onto a healthy mergeable draft would be pure churn against a draft another path owns.

### What I did

- Verified PR/issue identity, re-fetched the source comment as untrusted input, enumerated linked PRs and #544's mergeability/CI and base divergence. No branch was touched, nothing pushed.

### Follow-ups for the liaison/triager

- **Triager mapping bug:** a comment whose plain text is *"please write that PR as well"* was mapped to a `rebase` job against a non-existent PR (the number #543 is an *issue*). The keyword/verb mapping should not emit a `pr<N>-rebase` job unless `<N>` resolves to an open PR; a "please write/prepare … PR" comment should route to a designer/builder (researcher-first) path. This is a near-duplicate of the work that became #544 and would have caused a redundant or destructive push had I taken the verb literally.
- **No action needed on #544** — it is a healthy draft progressing through the design-PR workflow; CI pending is normal. The broader issue #543 also requests two *cross-package* stacked PRs (deprecate-then-remove plain re-exports plus a style-guide rule); those are separate work items, not this job, and not visibly opened yet — worth confirming they are tracked.

Self-improvement: nothing to land from me directly; the lesson is a triager mapping-guard (resolve `<N>` to an open PR before emitting a `rebase` job), routed above to the liaison/triager rather than encoded by a gardener.
