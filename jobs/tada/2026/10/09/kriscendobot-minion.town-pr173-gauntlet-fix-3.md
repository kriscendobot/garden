Fix round 3 for kriscendobot/minion.town#173 is pushed, and CI is green: `ci-wait-merge.sh` returned rc 0 with 3 of 3 checks passing.

**The must-fix.** The panel-3 review had one must-fix item. Its point was that the design specified the whole rotation system as committed work: the saga, tombstones, the degraded mode, and the churn limits. Its own gate 5 might show that rotation is never needed. The reviewer asked to cut the design to units 1–3 and move rotation into a separate follow-up design.

**What changed** (commit `3b62b08`, pushed to `design/ocap-site-crawler-leak-rotation` with `safe-push-pr-head.sh`):
- **New file `designs/ocap-site-link-rotation-followup.md`.** It holds the old §4.3 (churn and abuse limits), §5 (rotation semantics) and §6 (the formula-identifier and #1433 interface, saga and degraded mode). Its header says it is deferred, not committed, and is written up as a real design only if gate 5 passes.
- **`designs/ocap-site-crawler-leak-rotation.md`:**
  - The title no longer mentions rotation.
  - The status block now says the committed scope is units 1–3 only.
  - §4.3, §5 and §6 are now short stubs that point to the follow-up, so section numbers and cross-references still line up.
  - The rotate tier in §4.1 now records an alert only.
  - Units 4 and 5 are removed from §9.
  - Open question 3 (how long a tombstone lasts) is marked as deferred along with rotation.
  - A new open question 4 asks whether the cheaper protections alone are enough (`noindex`, `no-store`, the `robots.txt` tripwire and owner alerts).

**Follow-ups:**
- **Leftover rotation text.** Rotation is only partly removed from the main design. §7.1 still lists the `rotate()` method and its error codes. §8 still has acceptance steps that call `rotate()`; §9 now says those steps move to the follow-up, but they are still in the text. The §4.1 state diagram still shows the Rotating states. The status note tells readers to treat this text as deferred. Panel 4 may still ask for it to be removed.
- **Should-fix items not done.** This round applied only the must-fix. These remain open and may come back in panel 4:
  - Which request actually reaches the rotate tier, given that compliant crawlers usually fetch only `robots.txt`.
  - Bounded, cached DNS lookups for crawler verification.
  - A size cap on the spool.
  - The degraded-rotation alert wording, which should say that powers already obtained are not revoked.
  - Checking that alerts are delivered before a rotation commits.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr173-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 18 tokens (491155 cached reads)
- Output: 5874 tokens
- Cost: $0.661391
- Wall-clock: 72s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
