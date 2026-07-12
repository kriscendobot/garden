---
role: gardener
---

Run the gauntlet on `endojs/endo-but-for-bots` DRAFT PR #682
`design(endo-reminder): @endo/reminder message-scheduler plugin (supersedes
endoclaw-timer)` (base `llm`, head `design/endo-reminder`).

This is a **design-only** PR (every changed path is under `designs/`), so the
gardening state machine's design-panel variant applies: **panel (7-seat design
panel: critic, skeptic, decomplector, ergonomist, copyeditor, pedant, novice)
→ fix-loop while must-fix → un-draft**. The assayer and cleaner stages are
skipped (no source or test surface); `panel.sh` senses the design panel
automatically from the diff.

Context: this is the maintainer-requested follow-up to the fixer pass on the
concluded design review
(https://github.com/endojs/endo-but-for-bots/pull/682#pullrequestreview-4680373156,
agreed via
https://github.com/endojs/endo-but-for-bots/pull/682#issuecomment-4951968957).
The six agreed review conclusions are **already applied at branch HEAD**
(commit `design(endo-reminder): recover #165's operational richness, ungate
delivery`): named catch-up policies, jittered/persisted backoff parameters,
the coalesced-message annotation, the sketched CLI surface, the
persistence-scale note, and — the headline — decoupling the delivery baseline
from the SturdyRef gate (subscriber-capability delivery as the ungated Phase 2,
`send`+`storeValue` demoted to a gated Phase 4). Drive the panel from this
head; run the design panel, address any must-fix items with follow-up commits,
and un-draft when the panel-fixer loop terminates clean.
