CI is GREEN (rc 0). The fix stage is complete.

## Completion report

**Job:** Gauntlet FIX stage, round 6 — endojs/endo-but-for-bots PR #1157 (design doc: `designs/npm-registry-indelible-guest-inventory.md`).

**What I did:** Read the round-6 design panel verdict (disposition: must-fix) and applied every juror's request-changes finding, plus one cheap comment-only fix, as a single review-feedback follow-up commit to the PR head:

- **critic** — Dependencies row for `npm-registry-as-directory-tree` now names a *concrete default aggregate-exposure bound* as an explicit **Phase-3 close gate**; added a Dependencies placeholder row owning root-rotation / re-seating follow-up tooling.
- **skeptic** — Named what keeps the *shared default* root alive at zero guests: the daemon preformulates it as a formula-graph root in its own right (the `leastAuthority`/`@none` precedent), independent of any guest edge, so identity never drifts and Migration step 1 can always "locate" it. This also moots the skeptic's comment-only test-catalog note.
- **ergonomist** — Formally defined the **root-seating hook** at first use; added an operator-visible surface for migration-quarantined guests (migration-summary log entry + inspection-visible quarantine marker) with a matching test-catalog assertion.
- **pedant** — `tree contract` italicized only at its true first use (Summary), roman thereafter; capitalized "Phases 1-2" in the Dependencies row.
- **novice** — Glossed `thisDiesIfThatDies` at its first (code-comment) use; glossed `GuestFormula` and the special-name overlay in the Summary; consolidated the cancellation-wiring callback's home in Placement and name with a clean back-reference from Persistence.
- **copyeditor** — Disambiguated the adjacent section-title cross-references.

I avoided introducing em-dashes (the doc deliberately uses none, praised by the pedant) — checked and confirmed zero `—` in the final file.

**Result:** Pushed `4041fd590a → 484eb9e93f` to the PR head. CI watched to terminal: **GREEN** (5/5 checks, 0 failed, rc 0).

**Follow-ups:** None for this stage. Panel-7 will be re-posted by the gauntlet driver; I did not re-run the panel per stage discipline.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1157-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 78 tokens (2771905 cached reads)
- Output: 22269 tokens
- Cost: $2.7354665
- Wall-clock: 833s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
