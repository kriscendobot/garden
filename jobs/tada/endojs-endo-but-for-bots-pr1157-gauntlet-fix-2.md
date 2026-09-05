CI is green (rc 0). The fix is pushed and verified.

## Completion report

**Job:** gauntlet FIX round 2 for endojs/endo-but-for-bots PR #1157 (`docs: design indelible registry in every guest inventory`).

**What I did:** Read the latest (round-2) design panel verdict — disposition **must-fix**, aggregating per-seat reviews (critic, ergonomist, copyeditor, pedant request-changes; skeptic, decomplector, novice comment-only). Applied the panel's must-fix items to `designs/npm-registry-indelible-guest-inventory.md` in one pass:

- **critic (request-changes):** Corrected the `thisDiesIfThatDies` rationale. The prior text claimed omitting the wiring prevents "a shared root being cancelled by a guest's cancellation," which mis-stated the primitive's direction. Rewrote it: `thisDiesIfThatDies` cancels *this* context when its dependency dies, so wiring the guest slot would cascade a shared root's death into every dependent guest — never the reverse.
- **ergonomist (request-changes):** Noted the deliberate divergence from the cancellation-wired sibling `HostFormula.registry`, explaining why the host's cascade semantics are wrong for a many-guests-share-one-root slot. Also converged the drifting "remove/rename/rebind/replace/copy over/shadow" verb lists (Summary + Goal 2) onto one set.
- **copyeditor (request-changes):** Reworded the reachability sentence that inverted the cancellation relationship ("rather than tied to the guest's cancellation"); made Design decision 6 imperative ("Treat a withheld package as…") to match its siblings.
- **pedant (request-changes):** Normalized the two title-case headings (`## What is the Problem Being Solved?`, `## Design Decisions`) to sentence case with no terminal punctuation, matching the document majority; updated the in-body cross-reference.
- **skeptic (should-fix, cheap+valuable):** Conceded the special-name chokepoint enforces only *name indelibility*; the guest-safe-view property is a formulation-policy + test guarantee. Named where per-caller resource accounting is owned (the directory-tree design), and added a mid-pass migration crash-recovery test to the catalog.

Kept my additions ASCII/em-dash-free to match the doc's existing style (avoiding a fresh pedant/copyeditor finding). Skipped decomplector's `registry`→`publicRegistry` field rename (comment-only, and in direct tension with the design's host/guest interface-symmetry goal) and novice's larger reorganization suggestions (comment-only restructuring that would risk new findings).

**What changed:** one commit `9fa67bca1` on head `design/npm-registry-indelible-guest-inventory` (+41/−12), pushed via `safe-push-pr-head.sh` (advance mode, clean fast-forward `aaee0c451..9fa67bca1`).

**CI:** `ci-wait-merge.sh … --no-merge` → **GREEN** (5/5 checks, 0 failed), rc 0. Did not re-run the panel; the driver re-posts panel-3.

**Follow-ups:** none blocking. The design remains a DRAFT PR and is declared **Blocking** on the Not-Started `npm-registry-as-directory-tree` design (a scheduling fact, stated in the doc's Dependencies table, not a defect).

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1157-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 62 tokens (2128417 cached reads)
- Output: 14826 tokens
- Cost: $2.1974665000000004
- Wall-clock: 727s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
