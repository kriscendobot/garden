All work complete. Here is my report.

---

**Press tick 2026-09-22 ~16:2xZ — arc issue #89 (Claude on minion.town)**

**Material state change since last press (09:56Z):** The pin re-land [minion.town#110](https://github.com/kriscendobot/minion.town/pull/110) (Endo daemon pin `89481580`, `EndoGuest.accept`) was reviewed, **merged to `main` at 14:07Z — then reverted 49 min later by [#111](https://github.com/kriscendobot/minion.town/pull/111)** (14:56Z). Root cause is an upstream Endo defect: `89481580` makes `registry` a required `HostFormula` field but never shipped the on-start migration `designs/registry-capability.md` promises, so minion.town's pre-existing prod host formulas crash-loop the daemon and the post-merge deploy stalled. `main` is back on the stale `f66505034…`. (Matches the standing memory note on the 89481580 registry-pin revert.)

**What I did:**
1. **Verified all 7 checklist items** against live PR state — #87 merged, #98 merged, #104 merged (to frozen base only), #97 draft/MERGEABLE awaiting review, #96/#1226/#1227 CHANGES_REQUESTED, #1228 closed, #1310/#1305 merged, #1015 quiet draft. The one box-moving change was item 7's pin path (above).
2. **Updated the issue body** — the "as-of" note, item 7's tail, and two blocker entries now record the #110-merge→#111-revert and name the new sole upstream blocker: Endo [#1329](https://github.com/endojs/endo-but-for-bots/pull/1329) ("migrate persisted host formulas missing registry"). Architecture text and item specs left unchanged.
3. **Posted one press comment** ([issue #89 comment](https://github.com/kriscendobot/garden/issues/89#issuecomment-5780126161)) — honest recommendation: the CapTP eval half is now blocked upstream on #1329, which is draft with one red (likely-flake) CI leg and no review, so **no maintainer review is ready yet**; the next step is machine work (drive #1329 green), after which review+merge of #1329 to `llm` is the single gate reopening the whole pin → fallback fix → #81 → CapTP eval chain.
4. **Posted one job** — `shepherd-endo-pr1329-registry-migration` (drive #1329's CI green, don't un-draft/merge). Nothing on the board owned #1329; it is now claimed and running (`jobs/doin/`).

**Stop condition:** Not triggered. The next step is machine work (drive #1329 to green), not a maintainer decision — so no maintainer question posted. The contingent review ask (merge #1329 once green) is flagged in the comment, not pinged to the inbox.

**Follow-ups for the next tick:** watch #1329 → green + un-draft + merge to `llm`; then a minion.town re-pin to the new `llm` HEAD becomes fair game (which readies the parked `minion-town-guest-web-invite-accept-fallback-fix-20260922`, #81, and the CapTP eval build). No new job needed until #1329 lands.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/claude-on-minion-town-press-20260922-162051.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 54 tokens (1800023 cached reads)
- Output: 20850 tokens
- Cost: $2.1302554999999996
- Wall-clock: 355s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
