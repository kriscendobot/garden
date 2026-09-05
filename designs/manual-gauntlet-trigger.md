# Manual gauntlet trigger

| Created | 2026-09-05 |
| Author  | gardener (job `design-manual-gauntlet-trigger`) |
| Status  | Proposed |

## Decision

Completing a build or design stops at an open draft PR. It does not create a
`jobs/gauntlet/` record, run a panel, or make the PR ready for review. The
existing explicit phrase **`run the gauntlet #N`** is the only ordinary trigger:
the liaison or comment watcher calls `post-gauntlet.sh` directly with the stable
`<owner>-<repo>-pr<N>-gauntlet` base, and the existing staged driver performs
clean → panel → fix-loop → un-draft.

This separates two decisions that the automatic completion edge currently
conflates:

1. a worker has produced a reviewable artifact; and
2. the maintainer wants to spend a full gauntlet on that artifact now.

Build and design reports must therefore describe the draft as waiting for an
explicit gauntlet request. They must not post that request themselves. Probes
already stop in this state and do not change.

## Replacement guardrail

Removing the stager must not restore the earlier path from worker output to the
maintainer's mergeable queue with no review. The replacement invariant is
weaker than “every PR has a gauntlet,” but remains mechanical:

> A garden-authored build or design PR may complete without a gauntlet only
> while it is draft. Moving it into the mergeable queue requires a separate,
> maintainer-visible act.

Enforce this at the same two independent observation times as today:

- At job completion, a deterministic sensor inspects a bot-authored open PR
  newly named by the completion report. Draft passes without consulting
  gauntlet records. Non-draft fails completion unless a staged or completed
  gauntlet covers that PR. This catches the “opened ready by mistake” incident
  class without purchasing a gauntlet. To avoid the #671/#867 false-artifact
  regressions, a PR already cited by the job body is a reference rather than a
  newly produced artifact, and the sensor never changes PR state.
- The periodic audit becomes a readiness audit. It finds bot-authored open,
  non-draft build/design PRs with no active or completed gauntlet and sends a
  deduplicated maintainer alert. It never stages a record and never re-drafts a
  live PR. This catches drift and manual transitions without repeating the
  destructive force-draft behavior that disrupted active review.

Draft state is the hard boundary: ordinary GitHub merging is unavailable while
it holds. A successful explicit gauntlet remains the normal automatic owner of
`gh pr ready`. A maintainer can also make the state transition directly in
GitHub; that is an explicit act and the readiness audit reports, rather than
undoes, it.

This does not preserve the old property that panel review is non-optional. That
property is incompatible with a genuinely manual gauntlet: a maintainer can
choose not to spend it. What remains non-optional is that an agent cannot
silently put its fresh PR into the mergeable queue merely by completing its
producer job.

## Trigger and lifecycle

The direct record-posting path already exists and needs no intermediate gardener
job:

```text
build/design completes → open DRAFT PR → no further work
maintainer: run the gauntlet #N → post-gauntlet.sh → staged gauntlet → READY
```

The comment watcher already recognizes the exact imperative and records the
gauntlet before acknowledging the comment. The liaison should use the same
primitive for a chat directive. Repeated directives retain today's idempotence:
an active or completed record with the deterministic base is a no-op. A future
re-run after new commits is a separate concern because today's completed-record
idempotence already prevents it; this change does not quietly redefine that
behavior.

## Required implementation changes

- `roles/builder/AGENT.md` and `roles/designer/AGENT.md`: keep the unconditional
  draft rule, remove automatic-handoff promises, and state that only the
  maintainer requests a gauntlet. The designer's “review surface, never bare
  branch” rule remains; review-surface creation and panel execution are now
  distinct.
- `CLAUDE.md`, `README.md`, and `roles/liaison/AGENT.md`: change the vocabulary
  entries so `build`, `design`, and `probe` all stop draft by default, while
  `run the gauntlet` is the explicit promotion path. Remove the “standing
  auto-gauntlet” framing.
- `scripts/jobs/gardener.sh`: remove the call to
  `auto-gauntlet-handoff.sh`. Replace the design-gauntlet sensor call with the
  draft-at-completion sensor.
- `scripts/jobs/auto-gauntlet-handoff.sh`: retire it; do not leave a compatibility
  wrapper that can look like a supported automatic edge. Its tests become
  negative tests proving producer completion creates no record and makes no
  GitHub mutation.
- `scripts/jobs/assert-design-pr-gauntlet.sh`: replace/rename it as a general
  producer-PR draft sensor. Its positive condition is an open, non-draft,
  bot-authored artifact without gauntlet coverage—not a draft design lacking
  coverage. Preserve fail-open behavior for inconclusive network reads so GitHub
  outages do not wedge completion.
- `scripts/jobs/design-pr-gauntlet-coverage-audit.sh` and its systemd unit:
  replace/rename them as the non-mutating readiness audit. Alert deduplication
  should key on `<repo>#<number>:<headRefOid>` so a changed head can surface a
  new warning while an unchanged PR does not spam the maintainer.
- `skills/pr-creation-flow/SKILL.md`: make “run the gauntlet” the sole normal
  entry point, document the parked-draft state, and remove the role-independent
  auto-stager/sensor invariant.
- `scripts/jobs/comment-watcher.sh`: retain its existing direct
  `post-gauntlet.sh` path and add regression coverage establishing that its
  acknowledgment still implies a durable record.

Tests should cover builder and designer completion with no record; probes staying
draft; completion refusal for an accidentally ready artifact; completion success
for a draft artifact; active/completed gauntlet exemptions; job-body citation and
non-bot-author false positives; audit alert deduplication; and the explicit
comment/chat trigger creating exactly one record.

## Cost and scope alternative

The narrower alternative is to keep automatic gauntlets for the garden's own
repository and require them explicitly only for project forks. It targets the
observed concentration: at `origin/journal2` on 2026-09-05 there were 203
completed files named as gauntlets, of which 113 were for
`endojs/endo-but-for-bots`, 16 for `kriscendobot/minion.town`, and three for the
now-archived `kriscendobot/agoric-sdk`; only one was named for
`kriscendobot/garden`. The count is filename-based and measures runs, not tokens,
but it locates the volume.

Do not choose that alternative. Garden designs with open questions are already
exempt from automatic panels, and ordinary garden work lands directly on
`main2`, so a garden-only automatic policy saves little safety and introduces a
repo-dependent exception into a simple maintainer directive. A universal manual
default is easier to explain and test, while the draft sensor protects every
repository equally.

## Migration

Deploy the documentation and mechanics atomically. If the prose lands first,
workers will promise a manual stop while the completion hook still spends a
gauntlet; if the hook lands first, old role text will falsely tell maintainers no
request is needed. Existing `jobs/gauntlet/` records continue to completion—the
change stops new implicit records and does not cancel paid-for work already in
flight. Existing draft PRs remain untouched. The first readiness-audit tick may
report old uncovered ready PRs but must not mutate them.

## Open questions

- Should an explicit **`merge #N`** directive be a second sanctioned way out of
  draft without a gauntlet? Recommendation: yes, but only when the conductor has
  a current maintainer approval and green CI; it should call `gh pr ready`
  immediately before the merge rather than leave a reviewable non-draft window.
  If no, the conductor should fail closed on every draft and require `run the
  gauntlet #N` first.
- Should the readiness audit merely alert, as proposed, or re-draft an uncovered
  ready PR? Recommendation: alert only. Re-drafting is a stronger invariant but
  mutates a PR that may already be under human review, repeating the #671/#867
  incident shape.
