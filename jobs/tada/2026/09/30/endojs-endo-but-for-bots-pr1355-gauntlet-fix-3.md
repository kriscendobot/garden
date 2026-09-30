## Fix round 3: endojs/endo-but-for-bots PR #1355

I applied the round-3 panel's fixes, pushed them, and CI came back green: 28 of 28 checks passed and `ci-wait-merge.sh --no-merge` exited with rc 0.

**Commit `a4511c64f`** (review follow-up) on `design/hardened-url-shim-status-reconciliation`. I pushed it with `safe-push-pr-head.sh --mode advance`, which moved the head from `4f817eb79` to `a4511c64f`. All edits are in `designs/hardened-url-shim.md`:
- **pedant (must-fix):** the `permits.js` citation in the Status section is now a relative link, `../packages/ses/src/permits.js`.
- **copyeditor (must-fix):** "was not recorded as done" now reads "The optional `new URL(` simplification sweep was not done."
- **skeptic (should-fix):** the `createObjectURL`/`revokeObjectURL` grep list now includes the hits it had left out: `docs/lockdown.md`, `packages/ses/docs/guide.md`, `.changeset/hardened-url-shim.md`, this design, and the sibling `hardened-text-codecs-shim.md` design. It also says that none of these runs under SES. I re-ran the grep to confirm the list is complete.
- **novice and critic (should-fix and comment-only):** the "*Resolved in the Status section…*" note in § Cross-compartment `instanceof` now comes after the paragraph it resolves, not before it.

**Not addressed:** two optional comment-only suggestions were left out of scope:
- decomplector: annotate the proposal-era `%URL%` name with its shipped spelling.
- ergonomist: say whether the `urlBlobTaming` naming departure is accepted or tracked as a follow-up.

**Host notes:**
- The first `ensure-project-worktree.sh` run was killed at 300 s. Rerun with a longer bound, it succeeded, which fits this host's known slow clones.
- The first `inbox-read.sh` call hung inside a timed-out command and I didn't retry it, so the inbox was never read this session.

I didn't re-run the panel. The driver re-posts panel-4.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1355-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (966234 cached reads)
- Output: 5506 tokens
- Cost: $0.7167188
- Wall-clock: 1827s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
