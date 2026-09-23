---
kind: progress
role: gardener
host: endolin-garden-ece02cb4
at: 2026-07-16T23:52:00Z
---
# SturdyRef press tick (2026-07-16T23:35 dispatch, job endo-sturdyref-press-20260716-233503)

**Headline: HOLDING (7th tick, 6th fully-gated) — no push; ESCALATED
out-of-band: consolidated gate summary posted to tracker
kriskowal/garden#47 (comment 4997488262, 23:50Z) because the message-bus
relay is confirmed stalled.**

## State verified this tick (gh, 23:40–23:50Z)

- **#737**: OPEN, DRAFT, head unchanged `ce7341b47d`, updatedAt still
  16:32Z, reviewDecision empty (zero reviews). Last comment remains our
  16:32Z decision comment (prefix pick A/`q` vs B/`t` vs C/`w` +
  stack-collapse preference) — no reply.
- **#695 / #697**: OPEN, CHANGES_REQUESTED, heads `f5df0a4c83` /
  `e4a0a614b8`, unchanged since 07-15 — still awaiting re-review.
- **#541/#698/#700/#511/#539**: all OPEN/DRAFT, heads untouched since
  07-11; restack/fold-in still gated on the collapse answer.
- **Bus relay stall CONFIRMED and dated**: `inbox/maintainer/read/` shows
  592 historically-drained messages with the last drain ~2026-07-14T16:40Z;
  `unread/` now 55 (was 48 last tick), still holding nudge
  `20260716T200737Z-72c74a`. The liaison inbox holds 83 unread with ZERO
  ever read. The 22:38Z liaison alert from the previous tick is among the
  unread. Conclusion: relay down ~2.3 days, bus escalation ladder exhausted.
- No live sturdyref peer (`inbox-list`); `jobs/doin/` has no sturdyref job;
  my job inbox empty. Caveat: REST `gh api search` again returned an HTML
  rate-limit page; all state above via GraphQL `gh pr view`/`gh issue view`.

## Action taken: out-of-band escalation (the one new artifact)

Posted a single consolidated comment on arc tracker **kriskowal/garden#47**
(the established bot→maintainer surface, fed daily by arc-status-daily):
the three gates (#737 first review; prefix pick + collapse answer;
#695/#697 re-reviews) plus the stalled-relay note (garden-wide impact).
URL: https://github.com/kriskowal/garden/issues/47#issuecomment-4997488262
Rationale: prior guidance said mention the stall to the liaison instead of
re-nudging — done last tick — but the liaison inbox is provably never
drained, so the next rung had to be out-of-band on an authorized surface.

## Why no push (unchanged since 17:38Z)

Marshal encode/decode arms need the prefix pick; #541/#698–#704 restack
needs the collapse answer; agent provide/accept build needs the #695
re-review; opportunistic commits would dilute #737's single-squashed-commit
review shape while the first review is pending.

## Confinement statement

No behavior changed this tick, so no confinement surface moved. Standing
invariants as last verified on the green `ce7341b47d` CI run: the swiss-num
secret is never a property on a SturdyRef instance (shape tests incl.
forged/decoy rejections); the raw locator stays off-band in the ocapn
session manager's closely-held map. Token unlinkability (no-identification)
remains pending the #695-gated provide/accept build.

## Guidance for the next tick

- Same gates. Check tracker #47 for a maintainer reply FIRST — GitHub is
  currently the only live channel.
- **Do NOT post another tracker comment**: comment 4997488262 (23:50Z
  2026-07-16) is the standing escalation; treat it as the delivered nudge
  and run the ~24h second-nudge clock from it (next escalation not before
  ~2026-07-17T23:50Z, and only if still fully gated).
- Do NOT re-send bus nudges while `20260716T200737Z-72c74a` sits in
  `inbox/maintainer/unread/`.
- On the prefix pick: implement the marshal encode/decode arms +
  `encodeSturdyRef`/`decodeSturdyRef` hooks on #737's branch (encode a
  host-supplied ordinal, never the secret). On a collapse "yes": fold #541
  + #698–#704 into #737; on "no": restack them onto
  `build/sturdyref-pass-style-ocapn-single`.
