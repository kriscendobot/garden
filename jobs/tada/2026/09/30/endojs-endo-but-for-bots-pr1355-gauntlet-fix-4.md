**Gauntlet fix round 4: endojs/endo-but-for-bots#1355**

I fixed both must-fix items from the round-4 panel, pushed the fix to the PR head, and CI came back green.

**What changed**
- New commit `ff0e38fc14` on `design/hardened-url-shim-status-reconciliation`, pushed with `safe-push-pr-head.sh` as a fast-forward from `a4511c64fe`. The commit message is "docs(designs): address hardened URL shim panel round 4".
- **Ergonomist (must-fix):** the design body now uses the option name that actually shipped, `urlBlobTaming` with `'retain'` as the default. It replaces the old `urlBlobMethods` / `'keepOnInitialGlobal'` everywhere they appeared, including the `lockdown({ urlBlobTaming: 'remove' })` code sample, the permits-table note, the pipeline step, test-plan items 1 and 4, the phases and the migration section. Line 36 of the Status section still gives the old spelling on purpose, because that is where the rename is recorded. The sentence "The rest of this document keeps the originally proposed names" now says the body keeps the `%URL%` name but uses the shipped option spelling, so the samples work if copied as written.
- **Pedant (must-fix):** I removed the extra "; and" from the Status bullet list. I also changed the inline "Resolved in the Status section…" note under Cross-compartment `instanceof` to the same `*Resolved:* … (see [Status](#status))` form the Open questions section uses, so all resolution markers now match.

**CI:** `ci-wait-merge.sh --no-merge` exited with rc 0 after about 22 minutes: 28 checks, none failed (reported as "CI GREEN").

**Follow-ups:** these should-fix and comment-only items from the panel were left undone, since this round covered only the must-fix items:
- **Skeptic:** add a Known Gaps entry for the XS smoke test (test-plan item 9).
- **Novice:** say where the Status section's forward references (Phase 3, Open question 2) are defined.
- **Decomplector:** add a sentence noting that `'remove'` restores `constructor === URL`.
- **Ergonomist:** give a recommendation on the action-named `*Taming` option.

The driver will re-post panel-5.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1355-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 26 tokens (756641 cached reads)
- Output: 4689 tokens
- Cost: $0.7154202000000001
- Wall-clock: 1468s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
