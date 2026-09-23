---
ts: 2026-05-17T20:17:51Z
kind: result
role: judge
project: endo
repo: endojs/endo-but-for-bots
worktree: dispatches/judge--3bd7a0/project
prs:
  - repo: endojs/endo-but-for-bots
    pr: 238
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/238#pullrequestreview-PRR_kwDORRE4FM8AAAABAKwJyA
---

# Result: PR #238 second-round panel verdict, un-draft

## Summary

- PR: endojs/endo-but-for-bots#238 (`feat/rps-demo` -> `llm`,
  `feat(rps-demo): Endo daemon plugin demonstration as a distributed
  game (from endojs/playground#14)`).
- Head reviewed: `8c2d08105` (the fixer's address-pass for kriskowal
  CHANGES_REQUESTED + dckc COMMENTED).
- Panel kind: code-panel (12 seats; source-touching PR, 13 files
  including the new `packages/rps-demo/` package and a yarn.lock
  workspace-metadata diff).
- Panel execution: in-band-fallback (no `Agent` / `Task` tool in
  the harness; each seat written one at a time against
  `garden/roles/<seat>/AGENT.md`).
- Round: second panel round (the first round preceded the fixer's
  address-pass; this round verifies the address-pass landed cleanly
  and surfaces any new in-scope concern the fix introduced).
- Verdict: net-clean (no in-scope must-fix, no should-fix).
- Must-fix in scope: 0.
- Should-fix in this PR: 0.
- Out-of-scope / follow-up: 4 (hover-quality named `Attacker`
  interface, SECURITY.md applicability for a teaching demo,
  "device thingy" terminology gap, `keyMirror` idiom adjacency).
- Formal review: posted as `--comment` (self-PR; `kriscendobot`
  is both author and reviewer, so `--approve` and
  `--request-changes` are blocked by GitHub). Body carries the
  explicit "Must-fix before merge: None" heading.
- `@copilot` re-requested as additional reviewer alongside the
  panel.
- Un-draft: `gh pr ready 238` ran; PR is now ready for review.

## CI at terminal

- 3/25 SUCCESS, 0 FAILED, 22 QUEUED/IN_PROGRESS at review-submit
  time (the long cross-Node test matrix and the SES-internal jobs
  are still warming up). The three green at submit are `CI
  (docs-only) lint`, `Test project mutual dependency versions
  build`, and `check-action-pins`. No FAILED check observed; the
  panel's verdict carries the "if anything converges to failure,
  surface as new in-scope must-fix" caution forward to the
  follow-up watcher.

## Address-pass verification

All eleven inline threads on the prior round of reviews carry
kriscendobot replies citing addressing SHAs (or rationale for the
two question-shaped threads). The seven follow-up commits each
address exactly one thread, each is the minimal change, and the
feat commit was re-attributed to Dan Connolly per kriskowal's
explicit ask:

- `8a060c8fa` `feat(rps-demo): ...` (re-attributed to Dan Connolly
  <dckc@madmode.com>; bot remains committer).
- `559c61647` `chore: Update yarn.lock` (separate-commit
  discipline per CLAUDE.md § Pre-PR checklist).
- `5682be8eb` rename `*Shape` to `*I` on the two interface guards,
  keeping `ChoiceShape` and `GameResultShape` as patterns.
- `b85033af4` derive `Choice` from `(typeof choices)[number]` so
  the three names appear once.
- `7371a8e01` replace nested `Readonly<Record>` with
  `/** @type {const} */`.
- `cb08e7ba1` use `@import` for type re-exports in `index.js` to
  preserve docstrings at hover.
- `47ddb842e` add `game` / `games` to `package.json` keywords.
- `660d4855f` rewrite the README's three-throws claim as a
  synchronized-reveal description.
- `8c2d08105` replace the ASCII capability sketch with a Mermaid
  flowchart.

The two question-shaped threads (dckc on "device thingy"
terminology and dckc on the SECURITY.md fit) received substantive
rationale replies and ride in the panel's *Out of scope /
follow-up* section.

## Self-PR fallback

Self-authored PR; `--request-changes` and `--approve` blocked by
GitHub on a self-review. The judge submitted `--comment` with the
panel body carrying the "Must-fix before merge: None" heading.
The orchestrator's dispatch matrix keys on the heading; the
verdict is unambiguously net-clean. Note: `reviewDecision` on the
PR remains `CHANGES_REQUESTED` (the stale value from kriskowal's
prior `CHANGES_REQUESTED` review), which is expected on a self-PR
because the self-comment does not flip the decision; only
kriskowal's re-review or a dismissal would. The bot-side chain
is complete from the load-bearing signals (panel body heading +
un-draft).

## Out-of-scope items raised

1. **Hover-quality named `Attacker` interface.** Promoting the
   `ReturnType<typeof makeAttacker>` inferred return type of
   `make` to a named exported `Attacker` interface would improve
   the hover surface for consumers using this package as a
   teaching artifact. Sized as a follow-up PR.
2. **SECURITY.md applicability** for a teaching demo (dckc
   thread). The reviewer raised that the file has no meaningful
   threat model on a demo package; the fixer's reply offers two
   paths (keep with in-line note, or drop and adjust
   `scripts/check-security-md.sh`). Sized as a project-wide
   follow-up rather than a blocker.
3. **"Device thingy" terminology gap** (dckc thread). The
   reviewer asked whether there is a term for an unconfined
   plugin that integrates network or storage. The fixer's reply
   clarifies this package is a guest module (confined, runs under
   SES, holds no powers), not the unconfined-plugin shape; the
   broader terminology question is for a separate venue.
4. **`keyMirror` idiom adjacency.** The fixer chose
   `(typeof choices)[number]` over `keyMirror` because `choices`
   is iterated as an array; both idioms are valid in the project.
   Surfacing so a future builder reaches for the idiom that fits
   their usage.

These ride in the panel body's *Out of scope / follow-up* section.
The orchestrator may surface them as separate issues or follow-up
PRs as the queue warrants.

## Authority and identity

Bot identity (`endolinbot` per the host's git config) on the bot
host. The dispatch carried per-action authorization for
`gh pr edit --add-reviewer @copilot`, the formal
`gh pr review --comment`, and `gh pr ready 238`. All three ran.
No inline-thread replies were issued by the judge (the fixer's
prior address-pass had already replied on every inline thread).

## Next stage owed

The PR is out of draft and waiting on kriskowal's re-review of
the address-pass. The bot-side chain is complete for this loop.
If kriskowal re-requests changes after re-review, the
orchestrator dispatches a fresh fixer; if kriskowal approves,
the conductor merges. If a CI job (still mostly queued at submit
time) converges to a hard failure, the orchestrator dispatches a
shepherd against it.

## Self-improvement

The in-band-fallback procedure ran cleanly on the twelve-seat
code panel for the second time today (the prior was the #261 SES
test-split panel at `194338Z-result-judge-ad9f99.md`). The
self-PR `--approve`-blocked note that prior result called out as
a one-sentence amendment to `skills/panel-review/SKILL.md`
§ Pitfalls would have saved a re-derivation here; it is still
worth landing. Beyond that, one observation specific to this
round: when a panel is a **post-address-pass** second round
(not an initial round on a fresh head), the panel body's
opening paragraph benefits from naming the prior round and
the threads-now-addressed before the per-seat findings, so a
maintainer skimming the review sees the audit trail first. The
current body does this; codifying it as guidance in
`skills/panel-review/SKILL.md` § Aggregation would help a
future judge reach for the shape. Routing to liaison as a
message rather than landing under bot identity in this
dispatch.

Self-improvement: skills/panel-review/SKILL.md § Aggregation
should note that a second-round (post-address-pass) panel body
opens with a brief address-pass audit (which threads were
addressed by which SHA) before the per-seat blocks, so the
maintainer's review trail is visible above the per-seat detail.
Routed to liaison as a companion message entry.
