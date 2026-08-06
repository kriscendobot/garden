---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
handler-timeout: 7200

# Drive endojs/endo-but-for-bots PR #652 to merge-ready

**Directive:** kriskowal, 2026-08-06: "Please cue up
https://github.com/endojs/endo-but-for-bots/pull/652 for merge."

PR: https://github.com/endojs/endo-but-for-bots/pull/652
Title: feat(cli): expose mount deniedSegments via --deny/--no-deny (#127)
Head at time of posting: `b8948b8df`  Base: `llm`  (re-fetch live state before acting)

Role: shepherd. Do **NOT** run git in `$GARDEN_ROOT`; use your per-job worktree.

## State at posting

- `state=OPEN`, `isDraft=false`, `mergeable=MERGEABLE` against live `llm`.
- CI on the current head: **23 success, 2 FAILURE**.
  - `lint` — https://github.com/endojs/endo-but-for-bots/actions/runs/30519888250/job/90797709661
  - `sandbox-drivers` — https://github.com/endojs/endo-but-for-bots/actions/runs/30519888250/job/90797709658
  - Both started 2026-07-30T06:32Z and are on the **current** head — they are not stale
    runs from an earlier push. They have simply sat red for a week.
- `reviewDecision` is **empty** — there is no maintainer review on this PR at all.

## History — read before assuming this is a fresh PR

A conductor job (`endojs-endo-but-for-bots-pr652-conduct`, completed 2026-07-30 00:26)
stalled with `orchestration-failed: true` and this reason:

> needs weave: stale frozen base — PR is stacked on a pre-merge draft of #650 that
> conflicts with llm; rebase onto llm required, which invalidates the current
> maintainer approval.

That weave **appears to have happened** — the base now reads `llm` and GitHub reports
MERGEABLE. Confirm that yourself against the live PR; if the retarget did not in fact
land, the weave is the first task and the CI work follows it.

## Task

1. Re-fetch live PR state. Confirm base/mergeability rather than trusting the above.
2. Diagnose and fix the two red checks per
   [ci-failure-classification-loop](skills/ci-failure-classification-loop/SKILL.md).
   Treat each as a defect to close, not to wait out — per the standing rule that a
   lint/test CI failure is a defect in our automation.
3. Push fixes as follow-up commits on the PR branch (fork `kriscendobot`), watch CI to
   terminal via the usual `pr-ci-watch` path, and iterate until green.

## Definition of done — read this carefully

Drive CI to **green** and stop there. Report the result.

**Do NOT merge, and do NOT post a conductor job.** The merge is gated on a maintainer
APPROVED review on the *then-current* head, and #652 has no review at all. The bot is not
a maintainer and must not attempt to satisfy that gate. Once CI is green, say so in the
`tada/` report and alert the maintainer via `message-user.sh` that #652 is green and
awaiting their review on head `<sha>`; the conduct is posted after they approve.

If CI cannot be driven green, report the classification and what blocks it rather than
grinding to the deadline.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-08-06T06:38:33Z
