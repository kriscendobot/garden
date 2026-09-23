---
ts: 2026-05-23T00:46:38Z
kind: result
role: solicitor
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
refs:
  - entries/2026/05/23/004400Z-dispatch-general-contractor-7d6218.md
  - entries/2026/05/23/004538Z-message-solicitor-e65afa.md
---

# Solicitor result: PR #343 (`design/gateway-package`)

Round: post-fixer, after the fixer's seven OQ-resolution commits (`6fe0f04` through `ba4c812`) addressing the maintainer's 2026-05-22 `CHANGES_REQUESTED` review on seven Open Questions in `designs/gateway-package.md`. This is the first solicitor round on this PR (the prior fixer dispatches addressed maintainer inline comments directly without an intervening panel pass).

## Panel kind and execution

- **Panel kind:** design-panel (per `skills/panel-hints/panel-hints.sh --base llm-b1c3f4d`; all three changed files under `designs/`).
- **Panel execution:** in-band-fallback (the `Agent` tool was not in scope at this dispatch; the solicitor wrote each of the seven seat blocks in turn, one at a time, then aggregated).

Panel-hints output (verbatim):

```
Panel-kind: design-panel
Design panel (7): critic, skeptic, decomplector, ergonomist, copyeditor, pedant, novice
  designs/README.md
  designs/endo-gateway.md
  designs/gateway-package.md
Recommended total: 7 of 7 design-panel seats.
```

## Verdict

**Terminating round.** No `must-fix-loop` items; the panel net-passes the OQ-resolution work.

Disposition counts:

- `must-fix-loop`: 0
- `summary-fix`: 4
- `follow-up`: 0
- `acknowledge`: 4
- `drop`: 0

The four summary-fix items are bundled into one job (no panel re-run); the four acknowledge items are recorded in the formal review body for the audit trail.

## Findings (summary)

Summary-fix items (in the posted job):

1. Orphaned `setVirtualHostAllocationPolicy` and `AllocationPolicy` type after OQ3's resolution (critic).
2. OQ5 has two contradictory paragraphs ("still underspecified" sentence sits above the resolved Git-as-CAS framing) (critic + copyeditor agreed).
3. Feature 2 should name the alias-vs-identifier distinction at the `bind('chat', ...)` example (ergonomist; proposed-rule).
4. OQ7 should name what downstream readers must adjust between the resolution and the phase-1 mechanics (novice; proposed-rule).

Acknowledge items (in the formal review body only):

- OQ1 ERTP framing vs Feature 1's `ResourceLedger` shape: deferral is fine, reconciliation is the later design's job (decomplector).
- Feature 2 remote-client `Host`-header trust model: downstream of OQ4's deferral; consistent with gateway-bearer-token-auth (skeptic).
- Feature 6 `ResourceLedger`-with-ed25519-account joining clause: implicit but inferable; nice-to-have (critic; proposed-rule in Notes).
- Slash-disambiguation in "daemon/gateway-assigned weblet identifier" at line 254: copyedit nit (copyeditor).

## Post-loop actions taken

1. **Formal review submitted.** `gh pr review 343 -R endojs/endo-but-for-bots --comment --body-file /tmp/panel-343.md` at 2026-05-23T00:43:48Z. Body 11644 bytes. `--comment` selected because four `summary-fix` dispositions present, zero `must-fix-loop`.
2. **Summary-fix job posted.** `jobs/open/20260523T004457Z--234bf0--summary-fix-343.md` (commit `4da9d5ec` on `journal`). Eligible roles: steward, general-contractor. Four bundled items inlined.
3. **Followup ledger:** no follow-up dispositions; no ledger append.
4. **Gardener message written.** `entries/2026/05/23/004538Z-message-solicitor-e65afa.md` inlining the three `[proposed-rule]` tags from this round (one critic Notes proposal, one ergonomist proposal, one novice proposal).
5. **PR un-drafted.** `gh pr ready 343 -R endojs/endo-but-for-bots` succeeded; PR's `isDraft` is now false. The PR's `reviewDecision` remains `CHANGES_REQUESTED` from the maintainer's 2026-05-22 review (not dismissed by the solicitor's comment-only verdict, which is correct: the panel signals "no must-fix in our lens" but does not override the maintainer's open review).

## Note on `reviewDecision`

The maintainer's pre-fix `CHANGES_REQUESTED` survives the un-draft because the maintainer has not re-reviewed since the fixer addressed the seven OQs. The fixer's threaded replies on each inline comment cite the addressing SHAs; the next-stage owed is "maintainer re-review on the post-fix state", which is an external action (not a garden-side dispatch). The orchestrator may surface this on the bulletin if it wants the maintainer's attention, or leave it for the maintainer's next active session.

## Self-improvement

The `post-job.sh` script under `skills/job-board/` resolves `GARDEN_ROOT` from its own location (`SCRIPT_DIR/../..`), which expects `garden/journal/` to be a child directory of `garden/`. In the dispatch-root triple shape the journal is a **sibling** of garden, not a child, so the script fails with "garden/journal missing" when invoked from a dispatched subagent. The workaround in this dispatch was to write the job file directly to `<dispatch-root>/journal/jobs/open/` and commit+push manually. The skill or script should accept a `JRN` env override (or detect the dispatch-root triple shape) so subagent dispatches can use the canonical script rather than reimplementing its frontmatter assembly. Self-improvement: nothing actionable from this dispatch beyond the noted `post-job.sh` rough edge; flagging here so a future gardener or steward can lift it into a proper proposed-rule message.
