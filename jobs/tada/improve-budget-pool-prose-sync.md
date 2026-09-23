Both deliverables are complete and verified.

## Completion report — `improve-budget-pool-prose-sync`

**Investigation.** `set-budget-pool.sh` already reconciles obsolete host calibration prose on promotion — the `dropping_header`/`target_header` awk block was added 4 days ago in `7d43394850` ("fix(budget): synchronize promotion header comments"). The live journal2 `config/budget-pools` was stale only because both pools were last promoted on 2026‑09‑04/05, *before* that logic landed; no promotion has fired since, so the superseded 595M/385M prose persisted for ~5 days beside the authoritative 143M/64M rows. I verified the current awk cleanly handles the real journal shape (both pools, including the same host carried in two blocks with an interleaved unrelated NOTE) — no code fix to the setter was needed.

**What changed.**
1. **Regression fixture (main2, pushed — `7ec4e057a9`).** Added a case to `scripts/jobs/test/quota-calibration-test.sh` capturing the real legacy header shape the existing single-block fixture never exercised: a colon-less general intro, alignment padding before the colon (`host  :`), the *same host* carried across two superseded blocks, and an unrelated indent-matched `NOTE` block interleaved between them. It asserts promotion strips every superseded block for the promoted host while preserving the intro, the interleaved NOTE, and the columns legend. Verified it **fails** when the prose-removal awk is neutered (genuine guard) and passes with it — suite now 7/7.
2. **Live journal reconciled (journal2, pushed via the setter).** Re-promoted both pools with their exact current authoritative values (identical ceiling/provenance/date, so admission is unchanged) to mechanically strip the stale prose. The header now carries only the general intro, the bases-differ NOTE, and the columns legend; all 595M/385M/149M mentions are gone; rows remain 143M/64M.

**Follow-up (optional).** The mechanical strip also removed the ece02cb4 block's forward caveat that the weekly cap is not the only limit in play (session-scoped 5‑hour window has no column) — retained in git history per the setter's design, but not duplicated in surviving prose. If the maintainer wants that structural caveat kept as living text, it should be relocated into the general intro or the NOTE block (non-host-keyed regions the setter preserves); I left it out to keep this reconciliation purely mechanical.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-budget-pool-prose-sync.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 58 tokens (1635144 cached reads)
- Output: 24401 tokens
- Cost: $2.11054
- Wall-clock: 394s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
