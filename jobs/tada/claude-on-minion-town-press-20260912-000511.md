All three tick deliverables are complete. Completion report follows.

---

**Press tick 2026-09-12 00:0x — Claude-on-minion.town arc (issue #89)**

**State verified.** Walked the three named build PRs and the six design PRs:
- **#1125 (guest-owned invitation primitive, the arc's only artifact-level blocker):** the re-review the arc was waiting on **landed** — kriskowal re-reviewed 2026-09-11T23:52Z with CHANGES_REQUESTED (head `63a30a78`), asking to keep the guest-visible pins directory but add (a) a pointer to the incarnation/reincarnation logic and (b) a formula-held pins set the guest/agent can't see or mutate. CI green. This is a real state change since the last press comment (2026-09-09, which said "awaiting re-review").
- #87 (item 2 build) and #1015 (item 4 build): both still open, draft, quiet — reconciliations remain blocked on their designs (#97 root-only amendment, etc.) merging, which haven't.
- Six design PRs (#96/#97/#98/#99, #1226/#1227/#1228): all still draft, in gauntlet. #1228 is now DIRTY (merge conflict) — left to its gauntlet, off the arc critical path.

**Issue updated.** Corrected item 7's evidence line and the first Known-blockers bullet to reflect the 2026-09-11 re-review and that the ball is now in our court (machine work), not a pending review. Architecture text and item specs untouched.

**Comment posted** ([#issuecomment-5642056152](https://github.com/kriscendobot/garden/issues/89#issuecomment-5642056152)): reported the state change and, honestly, **no maintainer review ask this tick** — the critical path is now the fixer plus the design gauntlets, not human review.

**Job posted.** `endojs-endo-but-for-bots-pr1125-fix-formula-held-pins-20260911` (fixer, mentor tier) to address both review asks on #1125, with an escape hatch: if ask (b) turns out to need a spec decision, the fixer escalates one question rather than guessing. No other jobs — #87/#1015 reconciliations stay blocked on unmerged designs, and `build-minion-town-invitation-onboarding` stays parked (blocked on #1125 merging).

**Stop condition:** not triggered — the next step is machine work (the fixer), not a maintainer decision. Board was clean of any duplicate #1125 fix job; inbox empty.

Follow-ups for the next tick: watch the #1125 fixer to a re-reviewable push; watch the six design PRs for un-draft (admits their floor builds); #1228's DIRTY state if its gauntlet stalls.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/claude-on-minion-town-press-20260912-000511.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 28 tokens (975108 cached reads)
- Output: 13094 tokens
- Cost: $1.5420780000000003
- Wall-clock: 218s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
