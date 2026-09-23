CI is GREEN (rc 0, all 5 checks passed). The fix stage is complete.

## Completion report — gauntlet FIX round 3, endojs/endo-but-for-bots PR #1098

**Panel round-3 disposition:** must-fix (three seats requested changes: critic, skeptic, novice; plus should-fix items from decomplector, copyeditor, pedant, and comment-only from ergonomist). The PR is a prose-only revision of `designs/endo-claude.md`. I applied all actionable items in one follow-up commit (`149fa929d`) and pushed to the PR head via `safe-push-pr-head.sh` (advance mode, `70a7659d1 → 149fa929d`).

**Changes made:**
- **§ *Operational ceiling* rewritten** (renamed to *Argv length is an operational ceiling* per ergonomist; all cross-refs updated):
  - **critic** — the argv-length refusal now fires **once at `makeGuestInference`** (grant time), framed as a static property of the pinned catalog, alongside the DD8 grant-time throws, instead of a per-call spawn-time check that would churn a credential-pool slot on every doomed `infer`.
  - **skeptic-1** — `--allowedTools` is now rendered as **multi-token variadic argv** (each tool name its own token), relocating the governing limit from the ~128 KB per-argument `MAX_ARG_STRLEN` to the MB-scale whole-command `ARG_MAX`; the refusal is demoted to a grant-time backstop a realistic catalog never hits.
  - **decomplector-1** — `--mcp-config` file-path is now stated **unconditionally** (was "for a large facet, prefer…"), in both the section and the flags table row.
  - **decomplector-2** — added a "considered and rejected" note on routing the allow-list through the `--settings` file (DD5 keeps it minimal).
  - **copyeditor-2** — removed the tautological "refusal is a…refusal" density.
  - Also updated the DD8 grant-time-throw list and the property-test checklist item to match (grant-time throw over `ARG_MAX`).
- **skeptic-2** — hedged the "metering-invisible / never appears in any metered purse" claim against the still-open quota-accounting open question (now cites § *Open questions*).
- **novice-1** — fixed the DD7 residual cross-reference ("two bullets above" → named by its bolded phrase, *Attenuate the pooled subscription credential*).
- **novice-2** — glossed the rejected "provider-spend ring / multi-provider router" alternative (spend-attenuation tiers and model-id-prefix router now defined inline).
- **copyeditor-1** — "are not tidiness" → "are not mere tidiness".
- **copyeditor-3** — "a hit limit" → "a limit hit".
- **pedant** — unified "Fresh process per call" hyphenation (body now matches the open-form heading).

**CI:** GREEN — all 5 checks pass (`build`, `lint`, `test`, `browser-tests`, `zizmor`); `ci-wait-merge.sh` returned rc 0. Did not re-run the panel (the driver re-posts panel-4). PR remains draft as expected.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1098-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 108 tokens (3880235 cached reads)
- Output: 26531 tokens
- Cost: $3.4674655000000003
- Wall-clock: 1678s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
