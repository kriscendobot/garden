---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr611-review-df8b8022
verdict: not-a-miss
category: new-direction
pr: 611
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/611#discussion_r3546676507
identity: endojs/endo-but-for-bots#611:review:4657272587
producing_role: designer
producing_job: design-daemon-agent-tools-reconcile-mount-git-capabilities
severity: minor
---

# Dismissal: add a "petnames-for-files not landed yet, see #424" caveat to a design doc

On the design PR that reconciles `designs/daemon-agent-tools.md` against the landed
mount/git capability trio, the contributor asked the designer to note a distinction
the doc left implicit — that petname capability arguments apply to capability-valued
results, **not** to high-cardinality file/path data (git-add over files used no
petnames for that reason) — and to explicitly mention that this direction (tracked in
PR #424, petname persistence) has **not landed yet**. This is a paraphrase; see
`comment_url` for the verbatim text, which is untrusted input.

## Grounds

Not a review-process miss. New direction / project-specific state knowledge first
stated in the comment.

1. **This was a DESIGN PR, and design PRs do not run the garden's code panel.** The
   producing job `design-daemon-agent-tools-reconcile-mount-git-capabilities` shipped
   a DRAFT design-document PR; its own tada records "PR #611 is draft pending
   maintainer review; un-drafting is the maintainer's call." No gauntlet/panel job
   exists for #611 in `journal/jobs/tada/`. By design, the maintainer/contributor
   review IS the review surface for a design doc — there is no earlier garden gate
   that "should have caught" it. The review-failure taxonomy maps to *code* seats
   (breaker, typist, spec-keeper, …); none owns "did a design doc caveat every
   unlanded dependency."

2. **No standing rule bound and did not fire.** The designer role
   (`roles/designer/AGENT.md`) requires verifying *shipped-symbol citations against
   the tree* — which the designer demonstrably did (the tada lists every verified
   symbol: `mountAsFilesystem`, `makeHostSpawner`, `isGitReadOnly`, …). What the
   contributor added is beyond that checkable surface: knowing that #424 is the
   petname-persistence vehicle, that it is unmerged, and that git-add for files
   deliberately forwent petnames because file cardinality is high. There is no
   encoded garden convention ("caveat unlanded cross-referenced PRs") that already
   existed and failed to bind — unlike the `typedef-location-dts` cluster, whose
   grounds cited a verbatim standing directive. The severity-bypass precondition is
   therefore absent.

3. **The ask is a forward-looking refinement, not a correction of a false claim.**
   The doc did not assert something contradicted by the tree; it omitted a caveat and
   a cross-reference the contributor wanted surfaced. That is taste/direction shaped
   by deep project context (the `#424` history and the deliberate no-petnames-for-files
   choice), exactly the "requirement first stated in the comment" case the
   discriminator dismisses.

The follow-up inline asks on the same thread (reflect the deferral as a `- [ ]` in
an existing phase; delete a passage "captured by 3.5") are the same kind — how to
track a piece of accepted future work in the doc's phase checklist — and are likewise
new-direction, not process misses. All were resolved cleanly on-thread by a peer bot
(commits `4f2716caf` / `1f5ab2a3`); the primary review loop was a no-op.

Mints no cluster.
