---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr1357-593395b4
verdict: not-a-miss
category: new-direction
pr: 1357
repo: endojs/endo-but-for-bots
surface: pr-review-comment
author: kriskowal
comment_url: https://github.com/endojs/endo-but-for-bots/pull/1357#discussion_r4126953829
identity: endojs/endo-but-for-bots#1357:comment:4126953829
review_at: 2026-09-28T20:56:29Z
producing_role: designer
producing_job: backfill-endo-claude-design-from-minion-town-production
severity: minor
---

# Dismissal: maintainer asks for an empirical check that `--bare` rules out a Claude subscription

On draft design PR #1357 (`designs/endo-claude-inference-backends.md`), the
maintainer left an inline comment on Open question 1 (whether the owner may keep
using their own subscription). This is a paraphrase; the verbatim text lives at
`comment_url` and is untrusted input. The maintainer said the question was
unclear to them. They asked whether `--bare` really prevents subscription use,
recalled that `claude -p` was once briefly closed to subscribers, and asked for an
empirical check of whether a subscription works.

## Grounds (dismissal — no review ran by design; the empirical ask is first stated here)

**1. No evaluator was expected to run, so nothing was skipped.** #1357 is a
**draft** design PR opened by `backfill-endo-claude-design-from-minion-town-production`.
Under the manual-gauntlet-trigger regime (`designs/manual-gauntlet-trigger.md`),
a design stops at an open draft and gets a gauntlet only when the maintainer asks
for one. The journal (`jobs/{tada,todo,doin,plan,gauntlet-archived}`) has no
gauntlet or panel job for #1357, and none was due. The maintainer chose to read
the draft before running a gauntlet. That is the sanctioned order, not the
avoidance shape of `garden-design-pr-gauntlet-bypass` (a design reaching review
by routing around a required panel). No seat or gate was due to fire and failed.

**2. The design did not hide the premise it is questioned on.** Its "observed
versus documented" table marks the `--bare` / OAuth point as **documented** (it
quotes the CLI help: OAuth and keychain are never read), not observed. The
producer's report likewise cites `claude --help` as its source. The maintainer is
asking for **new work**: a live probe with a subscription token under `--bare`,
prompted by their own knowledge of how `claude -p` treated subscribers in the
past. That requirement appears for the first time in this comment. The clarity
complaint is taste about how an open question is framed. Open questions exist to
draw exactly this kind of maintainer answer.

**3. Severity-bypass precondition absent.** No standing rule bound on a reviewed
artifact and failed to fire. No panel ran, as the regime intends, and no rule
requires a design back-fill to live-probe every documented vendor claim.

## Boundary note (auditable calibration)

This mints no cluster, so no threshold applies and no improvement job is posted.
A **weak signal** worth keeping in view: the design called the subscription
question "Settled for Endo" (Decision 5) on a **documented-only** vendor claim,
even though the host had a CLI on which a one-line probe was possible. If a later
design PR that *did* run a design panel draws maintainer feedback of the form
"you settled this on documentation; verify it empirically", that should be
recorded as a miss (probably `spec-violation` or `process`, against the design
panel's skeptic lens) and should cite this dismissal as a precursor. It is not a
miss here because no reviewer was in the loop.
