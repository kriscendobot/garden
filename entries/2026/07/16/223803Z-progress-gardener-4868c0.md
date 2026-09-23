---
kind: progress
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-07-16T22:38:04Z
---
# SturdyRef press tick (2026-07-16T22:35 dispatch, job endo-sturdyref-press-20260716-223502)

**Headline: HOLDING — 5th consecutive fully-gated tick. All gates re-verified
closed at 22:35–22:45Z. No push, no second nudge (the 20:07Z nudge is STILL
undelivered).**

## State verified this tick (gh, 22:35–22:45Z)

- **#737** (`build/sturdyref-pass-style-ocapn-single`): OPEN, DRAFT, head
  unchanged at `ce7341b47d`, updatedAt still 16:32Z. **Zero reviews.** Last
  comment on the PR remains our 16:32Z decision comment (prefix pick A/`q` vs
  B/`t` vs C/`w` + stack-collapse preference) — no reply, zero reactions.
  CI on that head: `gh pr checks 737` → 25 pass / 0 fail (tab-split count).
- **#695** (agent provide/accept design): OPEN, CHANGES_REQUESTED, head
  `f5df0a4c83`, updatedAt 2026-07-15T05:14Z — still awaiting re-review.
- **#697** (cross-peer bridge design): OPEN, CHANGES_REQUESTED, head
  `e4a0a614b8`, updatedAt 2026-07-15T05:43Z — still awaiting re-review.
- **#541/#698/#700/#511/#539**: all OPEN/DRAFT, heads untouched since 07-11;
  restack/fold-in still gated on the collapse answer.
- **Nudge 20260716T200737Z-72c74a is STILL in `inbox/maintainer/unread/`** —
  and that inbox now holds **48 unread messages**, so the liaison is not
  draining it. The ~24h second-nudge clock has not started (it runs from
  delivery, not send). This is now a delivery-channel problem, not a
  maintainer-attention problem; worth a liaison-session look.
- No live sturdyref peer (`inbox-list`: this job, finbot, liaison, xs2rust
  lanes, self-heal lanes). `jobs/doin/` holds only an xs2rust job. My job
  inbox: empty.
- Caveat: raw `gh api` REST calls returned an HTML error page this tick
  (rate-limit shaped); all state above came via GraphQL-backed `gh pr view`
  / `gh pr checks`, which worked. kriskowal-activity search was therefore NOT
  re-run this tick; inferred quiet from the unchanged PR surfaces.

## Why no push (unchanged since 17:38Z)

Marshal encode/decode arms need the prefix pick; #541/#698–#704 restack needs
the collapse answer; the agent provide/accept build needs the #695 re-review;
opportunistic commits on #737 would dilute its single-squashed-commit review
shape while the first review is pending.

## Confinement statement

No behavior changed this tick, so no confinement surface moved. Standing
invariants as last verified on the green `ce7341b47d` CI run: the swiss-num
secret is never a property on a SturdyRef instance (shape tests incl.
forged/decoy rejections in the green suite); the raw locator stays off-band in
the ocapn session manager's closely-held map. Token unlinkability
(no-identification) remains pending the #695-gated provide/accept build.

## Guidance for the next tick

Same gates: kriskowal's first review on #737, re-reviews on #695/#697, the
prefix pick, the collapse answer. **Do NOT send another nudge** until
20260716T200737Z-72c74a reaches `inbox/maintainer/read/`; start the ~24h
second-nudge clock from that delivery. If the maintainer inbox is still
undrained (48+ unread) next tick, consider that the nudge channel itself is
stalled and mention it to the liaison rather than re-nudging. On the prefix
pick: implement the marshal encode/decode arms +
`encodeSturdyRef`/`decodeSturdyRef` hooks on #737's branch (encode a
host-supplied ordinal, never the secret). On a collapse "yes": fold #541 +
#698–#704 into #737; on "no": restack them onto
`build/sturdyref-pass-style-ocapn-single`.
