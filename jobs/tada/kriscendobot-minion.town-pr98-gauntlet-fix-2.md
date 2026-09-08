Applied the round-2 panel's must-fix items to `designs/claude-on-minion-town-evaluation.md` on PR #98 (design-only doc), pushed as a follow-up commit, and CI went green.

**What I did**

Consolidated the latest panel verdict (round 2, disposition **must-fix**) and applied its explicit must-fix items plus a few cheap, multi-juror consistency fixes:

- **skeptic (must-fix) — zero-turn Flow A shortcut:** §1 now credits a challenge call only when the oracle correlates it with an active Claude inference lease for that child formula id, and states the parent holds no accessor to the child's own `EndoGuest` handle. Added a matching §6 defense row.
- **skeptic (must-fix) — unexecutable pre-serve 404:** removed the pre-serve 404 precondition from §3 and its §6 cheat-table clause; anti-cache now rests on the fresh formula-id origin plus oracle-only random bytes.
- **copyeditor (must-fix) — content-address contradiction:** reconciled the URL template (`https://<formula-id>.<clip-domain>/`) and the §6 "fresh formula-id origin" language; the only remaining "content-address" mention is the deliberate "earlier scheme was dropped" note.
- **copyeditor (must-fix) — §2 wrong actor:** the single CapTP message reaches the parent, which asks the child; the driver never addresses the child directly.
- **critic (must-fix) — unreachable local×clip gate cells:** defined the local clip observation (loopback origin pin via `validate-clip-url --target local`, byte fidelity, TLS not asserted locally) so all sixteen cells are reachable; updated §8's local row.
- **critic (must-fix) — plaintext body in harness dir:** dropped `expected-proof.txt`; the diagnostic clip check now grades by the oracle's digest only.
- **Cheap should-fix cleanups:** bound Flow A/Flow B labels at first use; `hand-off`→`handoff` (repo corpus); phrasal-adjective hyphenation; inverted-predication fix.

Restored `package-lock.json` (mutated by the warm-cache install) and committed only the design file. Pushed via `safe-push-pr-head.sh` (0216e08 → 349f684).

**Result:** `GARDEN_CI_DEADLINE_SECS=3600 ci-wait-merge.sh … --no-merge` returned rc 0 — CI GREEN.

**Follow-ups (not applied, out of must-fix scope):** several structural should-fix items remain for the driver's re-posted panel to judge — e.g. ergonomist's tagged-union error contract and single-key `endowments` bag, decomplector's oracle event-log/time-ordering point, and various pedant CMOS table-capitalization and section-parallelism notes.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr98-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 66 tokens (2296131 cached reads)
- Output: 21189 tokens
- Cost: $2.4735455
- Wall-clock: 367s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
