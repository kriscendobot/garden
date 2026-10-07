I fixed the gate in `scripts/jobs/check-issue-refs.sh` so a panel item label such as `prover #3` is no longer rejected as a GitHub reference. The change is pushed to `main2` as `b528103e3d8`. I ran the old and new SUBTEST 29 assertions directly against the checker and they pass, but I did not run the full `scripts/jobs/test/run-test.sh` suite.

**The cause:** In the failed fix job's message (`endojs-endo-but-for-bots-pr1398-gauntlet-fix-3`), the text "prover #3" has a space before the `#`. The checker therefore flagged `#3` on its own as a bare `#N` reference. The job described this as an `owner#N` match, but it was actually the bare-`#N` rule.

**The fix:**
- The checker builds the list of jury seat names from the folders under `roles/jurors/`. `GARDEN_JUROR_SEATS_DIR` can point it elsewhere.
- A `#N` is exempt when a seat name comes right before it, either directly (`typist#2`) or after spaces (`prover #3`). This also works inside parentheses (`(prover #3)`) and ignores case (`Corner-Prober #12`).
- Everything else is still rejected: a bare `#N` (even next to a seat label, as in `prover #3 … see #5`), `acme#4`, an ordinary word before the number (`fixer #6`), and `GH-N`.
- The rejection message now says seat labels are exempt.

**Test and docs:**
- I added four regression checks to SUBTEST 29 in `scripts/jobs/test/run-test.sh`: seat labels in all three forms pass, a hyphenated seat name in mixed case passes, a bare `#N` next to a seat label is still rejected, and `owner#N` plus an ordinary word before the number are still rejected.
- `skills/message-bus/SKILL.md` now lists the seat-label exemption.

**Follow-up:** No follow-ups. One limit: only the folder names under `roles/jurors/` count, so a panel label using some other name would still be rejected.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-panel-item-reference-gate.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 22 tokens (568805 cached reads)
- Output: 5866 tokens
- Cost: $0.6366090000000001
- Wall-clock: 207s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
