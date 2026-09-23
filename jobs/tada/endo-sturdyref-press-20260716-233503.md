# SturdyRef press tick — completion report (job endo-sturdyref-press-20260716-233503)

**Outcome: HOLDING (7th tick, 6th fully-gated) — no code push; escalated out-of-band to the arc tracker because the message bus to the maintainer is confirmed dead.**

## What I verified (gh GraphQL, 23:40–23:50Z; REST search was rate-limited)

- **#737** (single squashed pass-style PR): OPEN/DRAFT, head `ce7341b47d` unchanged since 16:32Z, zero reviews; the 16:32Z decision comment (prefix pick A/`q` vs B/`t` vs C/`w` + stack-collapse preference) has no reply. Prior tick's CI evidence on this head stands (25 pass / 0 fail via `gh pr checks 737`).
- **#695 / #697** design PRs: still CHANGES_REQUESTED, heads unchanged since 07-15, awaiting re-review.
- **#541/#698/#700/#511/#539**: all OPEN/DRAFT, untouched since 07-11, gated on the collapse answer.
- **Bus stall confirmed and dated**: `inbox/maintainer/read/` shows the relay last drained ~2026-07-14T16:40Z (592 historically read); unread grew 48→55 including the 20:07Z nudge. The liaison inbox holds 83 unread with zero ever read — last tick's liaison alert is itself undelivered. The bus escalation ladder is exhausted.
- No live sturdyref peer, no sturdyref job in `doin/`, my inbox empty (drained twice).

## What I did

1. **Posted one consolidated escalation on the established out-of-band surface**, arc tracker kriskowal/garden#47 (where the bot already posts daily status): the three gates (#737 first review; prefix pick + collapse answer; #695/#697 re-reviews) plus the garden-wide stalled-relay note. URL: https://github.com/kriskowal/garden/issues/47#issuecomment-4997488262.
2. **Wrote and CAS-pushed the progress entry** `entries/2026/07/16/235*.md` on `journal2` (push confirmed), with explicit dedup guidance: next ticks check tracker #47 first, post no second tracker comment before ~2026-07-17T23:50Z, and send no bus nudges while the 20:07Z one sits undelivered.

## Why no push

Every buildable next artifact is gated on a maintainer input: marshal encode/decode arms need the prefix pick; the #541/#698–#704 restack needs the collapse answer; the agent provide/accept build needs the #695 re-review; opportunistic commits would dilute #737's single-commit review shape mid-review.

## Confinement statement

No behavior changed, so no confinement surface moved. Standing invariants as last verified on the green `ce7341b47d` run: the swiss-num secret is never a property on a SturdyRef instance (shape tests include forged/decoy rejections), and the raw locator lives only in the ocapn session manager's closely-held map (no-location). Token unlinkability (no-identification) remains pending the #695-gated provide/accept build — not yet verified, since that surface is unbuilt.

## Follow-ups

- The stalled maintainer/liaison relay is a garden-wide incident (55 + 83 undelivered messages since ~07-14); it needs a liaison session on the leader host (`endolin-garden2-5bcdff64`) to drain. Flagged in the tracker comment.
- Next hourly tick resumes the press the moment any gate opens; GitHub (tracker #47 / #737 comments) is currently the only live maintainer channel.
