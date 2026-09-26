CI is GREEN (rc 0). The fix stage is complete.

## Completion report

**Job:** Gauntlet FIX round 5 for endojs/endo-but-for-bots PR #1158 (`design(exo-db): define portable passable databases`, a design-doc PR on fork head `kriscendobot:design/exo-db`).

**What I did:** Read the round-5 panel verdict (disposition must-fix) and applied its findings once to `designs/exo-db.md` (+ one line in `designs/README.md`), then pushed as a follow-up commit and watched CI to green.

**Findings addressed:**
- **skeptic must-fix** — folded the logical-table ordinal into the reference-retention ledger and pending-mutation intent key (now `(database formula, table ordinal, row key[, retained formula])`) throughout the retention section, protocol steps 1–5, decision 8, and the implementation plan, so two tables of one database formula that key distinct rows by the same bytes reconcile independently. Added a cross-table colliding-key crash test to the verification plan.
- **critic (request-changes) #1** — scoped goal #4 to *existence-conditioned* writes, added a non-goal, and documented the no-compare-and-swap lost-update tradeoff with a deferred `ConditionFailedError`.
- **critic (request-changes) #2** — walked `delete` through the five-step protocol (empty add-set, full remove-set, absent-row reconciliation as the empty limit) and added a delete-specific crash test.
- **skeptic #2 / decomplector #1** — narrowed the mutation queue from per-database-formula to per-`(formula, table, key)`, restoring cross-table/cross-key write concurrency and naming the coarser lock as the rejected alternative.
- **ergonomist #1/#2** — named `TableExistsError`/`TableMissingError`; added `table.keyOf(row)` sugar to both table interfaces.
- **decomplector #2** — split the read-time shape-check's concern (out-of-band corruption defense).
- **copyeditor/pedant/novice polish** — fixed the comma splice ("So that…"), mid-line sentences (exo-db + README), the comma-inside-quote, and glossed Smallcaps / ReferenceIdentity / IronHorse (with a citation) at first use.

I also removed all 17 em-dashes I had introduced, since the doc deliberately contains none.

**Result:** Commit `ba78af62d` pushed to `origin/design/exo-db` via `safe-push-pr-head.sh` (advanced `0fed284fd → ba78af62d`, no peer rewind). CI wait returned **rc 0 — GREEN** (5/5 checks, 0 failed). Stopped without re-running the panel, per stage instructions.

**Follow-ups:** none required from this stage; the driver re-posts panel-6.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1158-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 116 tokens (5764992 cached reads)
- Output: 36965 tokens
- Cost: $5.101803999999999
- Wall-clock: 1008s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
