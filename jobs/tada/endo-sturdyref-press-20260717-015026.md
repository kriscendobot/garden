## Completion report — SturdyRef press tick (2026-07-17T01:50 dispatch)

**Headline: gate 1 broke open — kriskowal delivered the first review of #737 at 00:42Z (CHANGES_REQUESTED, review 4718500574), and a live peer job claimed the response one minute later. I recorded the observation and stood down without pushing, per the peer-collision discipline.**

**What I did:**
- Assessed the full effort state via `gh` (01:50–01:57Z): #737 head unchanged at `ce7341b47d`, now CHANGES_REQUESTED; #695/#697 still CHANGES_REQUESTED (unchanged since 07-15); #698/#700/#541/#511/#539 all OPEN/DRAFT, heads untouched since 07-11.
- Read the review substance: prepend a **first-wins shim** installing `SturdyRef` / `SturdyRef.fromLocation` / `SturdyRef.toLocation` globally (hardened post-lockdown, no SES permits, withheld from child compartments); **locators become objects** in a globally-retained closely-held WeakMap; `makeSturdyRef` moves to `@endo/pass-style/sturdy-ref`; SturdyRef namespace and per-CapTP enliveners stay closely held.
- Confirmed the peer: `endojs-endo-but-for-bots-pr737-review-3363fee9` (gardener-10, endolin-garden-ece02cb4) claimed 00:43:28Z, alive in `jobs/doin/`, ~70 min in with no push yet — working, not stalled. Its charter covers the whole review including posting the shim build job, so I did not double-post.
- Noted the 00:35 press tick **failed** at handler start (rc=1, error entry 003549Z), so no observation existed between 23:39Z and now.
- Posted progress entry `entries/2026/07/17/015413Z-progress-gardener-a6c2ea.md` with state, collision rationale, and next-tick guidance (verify the peer completed/reaped; take the wheel only if stalled; re-pose only the still-unanswered restack/collapse question after the shim-first architecture lands).

**What changed:** one journal progress entry; no project pushes, no new jobs (deliberate — the sole unblocked artifact is peer-owned).

**Verification evidence:** all PR/review/comment states cited above observed from live `gh pr view` / `gh api` output this tick; branch HEAD confirmed via `gh api repos/endojs/endo-but-for-bots/commits?sha=build/sturdyref-pass-style-ocapn-single` (top commit `ce7341b47d`, 16:31Z). No test bars claimed, none run — no code changed.

**Confinement statement:** no behavior changed, so no confinement surface moved; standing invariants (swiss-num never a SturdyRef property; raw locator off-band in the closely-held session map) as last verified on green `ce7341b47d`. The new review strengthens the posture: closely-held SturdyRef namespace, locator records behind a closely-held WeakMap, per-instance closely-held enliveners — the no-location/no-identification shape design #539 requires.

**Follow-ups:** next hourly tick should check whether the peer review-response job completed or was reaped, confirm the first-wins-shim job got posted, and press the follow-on order (shim → pass-style move → locator objects) only if the lane is idle.
