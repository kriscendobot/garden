FIX round 1 complete. Applied the design panel's must-fix and should-fix items to PR #1157, pushed as a follow-up commit, and CI is green.

## What I did

**Substantive design edits** (`designs/npm-registry-indelible-guest-inventory.md`):
- **Endor parity (must-fix — critic, skeptic):** Rescoped Goal 4 and the parity section to the *tree contract*. The `@registry` inventory projection is Node-only now; the Endor projection is explicitly deferred to a future agent/guest model, since Endor has no agent/guest/formula/special-name substrate today. Added a matching non-goal.
- **Migration precedent (must-fix — skeptic, critic):** Stated Phase 2 is the daemon's *first* formula-rewriting upgrade, not a copy. The cited `HostFormula.registry` precedent was designed but shipped fail-fast; noted the design-only status in the Dependencies table.
- **Persistence lifecycle (decomplector, skeptic, novice):** Named **GC reachability** (not `thisDiesIfThatDies` cancellation) as the mechanism, so a shared root is never killed by one guest's cancellation.
- **Failure shape (ergonomist, novice):** Named the documented registry error family; construction fails closed.
- **Indelibility chokepoint (decomplector, skeptic):** Stated the single `assertPetNamePath` enforcement point, marked the call-site list illustrative, added a catalog test across every guest naming method, and added the shipped `leastAuthority`/`@none` alternative row.
- **Floor contract & strict attenuation (decomplector, ergonomist):** Specified `@registry` is always present/enumerable (`list()` may be empty; misses raise the tree error family), guest root is a strict attenuation with identical interfaces, and credentialed views occupy a different name.
- **Confidentiality (critic, ergonomist, skeptic):** Recorded withheld-vs-absent indistinguishability as a deliberate Design Decision.
- **help-text-data.js (ergonomist):** Added the discoverability surface to Phase 1.
- **Novice:** Added path-structure sentence, a worked `lookup` example, forward-reference to the guest-safe root.
- **Copyeditor/pedant line edits:** dangling modifiers, subject-verb agreement, pronoun/temporal fixes, jargon-before-use, `reincarnate` spelling, sentence-initial link recasts, title-case canonical headings, MVS/CAS abbreviation expansion, table-cell punctuation. Kept the file pure ASCII (removed `§`).

**Index (must-fix — pedant, novice):** Added the design to `designs/README.md` — recently-added note, summary table, mermaid dependency node + edges, description table, M3 size estimate, and the totals increment (195→196).

## Result
Commit `aaee0c451` pushed to `design/npm-registry-indelible-guest-inventory`. CI terminal: 5/5 checks, 0 failed → GREEN. Did not re-run the panel (driver re-posts panel-2).

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1157-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 80 tokens (3029049 cached reads)
- Output: 25099 tokens
- Cost: $3.0250775
- Wall-clock: 878s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
