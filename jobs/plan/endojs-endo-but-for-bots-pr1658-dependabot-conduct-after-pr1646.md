---
gate: blocked
blocked_on: https://github.com/endojs/endo-but-for-bots/pull/1646
priority: normal
posted_by: botanist
posted_at: 2026-11-08T22:32:06Z
---

---
role: botanist
tier: mentor
fallback-tier: minion
dispatch: automatic
handler-timeout: 7200
---
# Conduct endojs/endo-but-for-bots PR #1658 (preact 10.29.8 -> 11.1.1) after the Node pin lands

Successor to endojs-endo-but-for-bots-pr1658-dependabot-ci-resume. Promoted by unblock.sh when https://github.com/endojs/endo-but-for-bots/pull/1646 merges or closes.

Verdict is MERGE-NOW. Diligence is already complete: maturity floor passed 2026-11-07T05:01:22Z, only preact moves, there are no advisories, and the source read and provenance are clean. Head is 45e7064d4f5 (Dependabot plus the garden's preact-container isValidElement migration). Do NOT redo diligence unless the head or lockfile moved; if Dependabot rebased, re-check the moved set.

The only blocker was CI `test-xs`: hardened262 `sesNode/module passed -> failed test/intrinsics/ThrowTypeError/intrinsic-metadata.js`. That failure is PRE-EXISTING on base llm (push run 41370492445, job 125718398161, at 48d6f3e08b, identical delta). Its cause is `.node-version: lts/*` resolving to Node 26. #1646 pins Node 24.

1. Confirm #1646 MERGED and test-xs is green on llm (or `.node-version` no longer resolves to 26). If #1646 closed without a fix, stop and message the maintainer. Never merge on red, and never accept the conformance-baseline flip.
2. Confirm #1658 is still open and still authored by dependabot[bot].
3. Get CI on a head that includes the pin: comment `@dependabot rebase` (or let ci-wait-merge.sh rebase), then shepherd. The sandbox-drivers bwrap cleanup and @endo/cli exit-leak failures are known flakes, so rerun them.
4. From an isolated project checkout (ensure-project-worktree.sh), run `scripts/jobs/gardening/ci-wait-merge.sh endojs/endo-but-for-bots 1658 --dependabot-auto-merge`.
5. Post the terminal verdict comment, write a terminal Dependabotany ledger row (project: endo-but-for-bots, `# Dependabotany` heading) via journal-entry.sh, and report the merge SHA.
