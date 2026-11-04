---
handed-off: orchestrate-build-minion-town-ordered-gutter-20261104
deliverable-complete: false
---
I didn't build any of the gutter or context-menu work myself. I handed the whole job to a five-step chain of follow-up build jobs instead, and nothing has been built or deployed yet.

**Why:** the design lays out five increments, and each one has to be deployed and checked in production with the real daemon and Playwright. That doesn't fit in this run's budget of about $3.20. Doing one increment and leaving the rest unowned would be worse than an orderly handoff.

**What I found:**
- The design is `designs/ordered-gutter-context-menu.md` on draft PR kriscendobot/minion.town#247, which isn't merged yet. Its § 7 lists the five increments in order.
- Two other open drafts cover related parts: #179 (real clip names and icons in the gutter) and #201 (the New Clip zygote).

**What I posted:** `orchestrate-build-minion-town-ordered-gutter-20261104`. It runs one child job at a time and halts if one fails. Each child is a builder job at the `mentor` tier:
1. `build-minion-town-ordered-gutter-inc1-20261104`: an empty account gets no example clips, and `+` stays visible.
2. `…-inc2-20261104`: `+` creates exactly one New Clip named `new-clip`, and it survives a daemon restart.
3. `…-inc3-20261104`: the named `clips/` catalog, stable entry ids, rename, and moving the saved order from #190 to the new order file, with property tests.
4. `…-inc4-20261104`: the context menu with Open and Rename, opened by mouse, touch, pen and keyboard, with rendered-page tests.
5. `…-inc5-20261104`: Clone, Clone with alternate powers, Freeze, and Destroy with its cascade, plus crash-recovery tests and the full production acceptance run.

**What each child is told:**
- Read the design on #247.
- Stack on the previous increment's PR, and on #179 or #201 where the design calls for it, rather than duplicating them.
- Deploy through the normal deploy pipeline and verify in production with the real daemon and Playwright, using a throwaway test account.
- Never touch or reset the maintainer's production account data.
- If a blocking open question remains, build what isn't blocked and report the rest.

**Follow-up:** #247 is still a draft. Builders work from it as written, so the maintainer may want to merge or approve it.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-minion-town-ordered-gutter-context-menu-20261104.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 12 tokens (295590 cached reads)
- Output: 3120 tokens
- Cost: $0.502054
- Wall-clock: 99s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
