---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-09-05T08:48:51Z
---
# scribe — PR #1124 knowledge-capture / PR-communication closure (round 5)

Dispatch: `build-ocapn-nonce-locator-endo-mechanism-gauntlet-panel-5`, seat `scribe`.
PR: https://github.com/endojs/endo-but-for-bots/pull/1124 (head `f10247fd2`, real base
`1d91f0d9d`). The worktree's `origin/llm` is still stale at `67dfc18b1` (1273 behind), so
`origin/llm...HEAD` is 4651 files, not this PR's diff; the reviewable unit is the eight
files `gh pr view 1124 --json files` reports. Third round in a row the seat has had to
work around this. Verdict: **request-changes**.

Surveyed `pulls/1124/reviews` (4, all `kriscendobot`), `pulls/1124/comments` (0),
`issues/1124/comments` (2).

## Maintainer note-this asks — vacuously closed

No maintainer has participated on this PR; every review is the panel's. That half of the
lens has nothing to close. Panel-1's comment-only "explicit doc note that the bound is
per-connection" ask is now CLOSED at `formula-nonce-locator.js:238-244` (an embedder that
wants to aggregate across reconnections keys on `context.peerPublicKey`) plus the README
per-session-locators block — round 3 called this partial, round 5 finds it complete.

## Completion-summary closure — CLOSED

Round 3's OPEN finding is closed. `#issuecomment-5538504822` (2026-09-04T09:31:35Z)
retroactively covers `53af1a483`/`54da570a9`/`f72ab327e` and names the omission
explicitly; `#issuecomment-5549375287` (09-05T04:35Z) covers `f10247fd2` with head SHA,
what changed, and the verification line round 4 said the earlier comment lacked. Both
rounds' responding pushes now have top-level closure.

## Proposed-rule forwarding — OPEN since round 2, unchanged for four rounds

Panel-1's review body (`5104354110`) carries seven distinct `[proposed-rule:]` tags
(session-teardown smoke test; latency parity across the miss equivalence class; purist
side-channel latency parity; reconnect-resettable abuse counters; README option coverage;
changeset sentence-per-line; fast-check as a devDependency). `skills/panel-review/SKILL.md`
§ Cite-or-propose requires each to reach `role/gardener` after the round. `grep -rl 1124
msgs/` matches only an unrelated 2026-07-29 host message. The two newest gardener messages
(`20260905T031525Z-6874d9.md`, `20260905T043249Z-0b75db.md`) forward #1085's and #891's
tags — this PR's were skipped while two neighbours' were carried, which is the strongest
evidence yet that the omission is per-round accident, not policy. Escalated from
`summary-fix` to **must-fix-loop** this round: un-draft ends the gauntlet, and after it
nothing will ever walk panel-1's body again.

## Round-4 scribe's own root-cause item — OPEN

Round 4 raised the durable fix for the summary-comment gap: `scripts/jobs/gauntlet.sh`'s
`fix)` stage template (lines 327-356) has four steps and never cites
`skills/pr-completion-summary-comment/SKILL.md`. Verified still true at
`c2ea79b1`-era head; no `to: gardener` message carries it either. `summary-fix`.

## Round-1 timing-parity item dropped without a decline note — OPEN

Two independent seats (breaker, purist) raised the fast-reject/slow-reject latency
asymmetry, each offering a cheap fallback: "explicitly disclaim timing in the JSDoc" /
qualify the claim to "message-uniform, not timing-uniform". Neither the padding nor the
disclaimer landed, the item never recurred in rounds 2-4, and neither summary comment
records it as declined — `grep -i "declin\|defer\|timing"` over `issues/1124/comments` is
empty. At head, `get` (`formula-nonce-locator.js:191-234`) returns after a bare `await
null` for a non-string / noncanonical / foreign-node secret and awaits `provideLocalFormula`
for a local-node candidate, while the docstring (90-101, 140-148) still lists all classes
as "the same miss" with no timing qualification.
`skills/pr-completion-summary-comment/SKILL.md` requires the summary to name anything
declined and why. `summary-fix`: land the one-sentence disclaimer, or say it was declined.

## Follow-up ledger — still absent

`projects/endo-but-for-bots/followups/endo-but-for-bots--1124.md` still does not exist
(highest entry remains 848, last written 2026-08-06). Named for completeness, as round 3
did; fleet-wide drift, not charged to this round.

Self-improvement: round 3 raised proposed-rule forwarding as OPEN and rounds 4 and 5 find
it untouched, exactly as the round-4 scribe on minion.town#68 predicted — a `summary-fix`
disposition is invisible to a fix stage that only reads must-fix. The generalizable move,
which I took here, is that the *second* unchanged recurrence of a scribe finding is itself
the evidence for escalating its disposition; the seat should not restate a finding at the
same level three times. Worth folding into `roles/jurors/scribe/AGENT.md` § Default
disposition as a second must-fix-loop trigger alongside the existing "the maintainer asked
for the rule before un-draft" one: *a scribe finding returned unchanged across two prior
rounds escalates to must-fix-loop, because the disposition — not the finding — is what
failed.*
