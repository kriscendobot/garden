---
gate: awaiting-maintainer
maintainer_question: 'Reconcile the historical floor with current verdict/resource policy, or restore all 901 genuinely under unchanged pins and policy?'
asked_at: https://github.com/kriscendobot/garden/issues/51#issuecomment-5877917421
priority: high
posted_by: builder
posted_at: 2026-09-28T20:30:23Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
role: builder
handler-timeout: 14339

# Complete the round-3 Ironhorse historical-floor ratchet

This is the named successor to ironhorse-test262-ratchet-round3-20260928 and owns ALL remaining work required to complete that round. It is parked awaiting the maintainer's answer at https://github.com/kriscendobot/garden/issues/51#issuecomment-5877917421. Do not silently waive, replace, or relabel the historical floor.

Existing draft: https://github.com/endojs/endo-but-for-bots/pull/1359
Repo: endojs/endo-but-for-bots
Head: feat/ironhorse-test262-ratchet-round3 at f6a8388bf1c5bf7863262433320e730dcbb46037
Frozen base: llm-47f6965 (47f6965d882b9c1c3eaaa836dd8d75971a924bb4)

Use ensure-project-worktree.sh with THIS successor's unique job base and the existing head branch. Do not open a second PR; use ensure-pr.sh --find-only/adopt the existing branch if identity rediscovery is necessary. Coordinate with build-ironhorse-ratchet-autopilot before any branch mutation so its review work and yours do not race. Leave the PR draft; the maintainer owns the gauntlet trigger.

Already delivered:
- 9df05366b3 fixes the shared installation attributes of Math/Number numeric constants and both TypedArray BYTES_PER_ELEMENT owners.
- Five dual-run tests (52 source programs) fail before the fix and pass afterward.
- Whole-corpus covered 36,599 -> 36,673; failures 2,822 -> 2,748; exactly 74 records change from failure to covered; zero losses against branch point.
- Required release Rust gate passes: 3,304 passed, 43 ignored. Rust 1.88.0 fmt and all-target Clippy pass.
- Baseline/measurement evidence committed under rust/engine/ironhorse-262/baseline/refresh-20260928/: before-report.json and report.json (full original sweeps), before-covered.txt and covered.txt (byte-sorted), baseline.json (summary plus digests), gained.txt, restored-historical.txt, historical-losses.json, README.md (queue, evidence, reproduction).
- Original corpus pin be13516fb6441b950ba8a3df97eb34062c186972 and XS 23b4d6b0a65f35209d9118c4c13c6c9b3e68784d are unchanged. No runner policy or resource ceiling changed.

Remaining acceptance gap:
The enforced refresh-20260904 floor has 30,233 paths. Current llm already lost 906 before our change. Five Object.create/defineProperties cases are repaired; 901 remain (443 ironhorse-aborted-limit; 397 shared-positive-test-failure; 61 other outcomes). The current classifier rejects historical false-positive coverage where positive tests abort on both engines. Thus refresh-20260928 is explicitly a candidate measurement, NOT a superseding floor (supersedes:null in baseline.json).

After the maintainer answers:
1. Apply the explicitly authorized reconciliation if given, preserving an audit of every historical disposition. Otherwise repair all losses genuinely under the enforced pins/policy; do not pad covered.txt or relax verdict classification. The committed historical-losses.json owns the exact remaining set.
2. Preserve the union of the 30,233 historical floor and 36,599 branch-point covered paths unless the maintainer explicitly changes it. Also preserve all 74 gains already delivered. Fix any new regressions first.
3. Add oracle-checked dual-run regressions for each further repaired cluster. Repeat the final whole-corpus sweep and required Rust gates after source changes. Commit a genuinely superseding floor only when the authorized zero-loss criterion is satisfied.
4. Update the existing draft PR body and post a follow-up before/after/ranked-queue comment on https://github.com/kriscendobot/garden/issues/51. Report exact remaining failures honestly; Temporal/Intl work remains outside scope. No local hardened262 baseline update.
5. Communicate the reconciled enforced-floor path and successful gate evidence to the autopilot owner. Only then report the original round complete.

Diagnostic notes:
- Resource demotions need actual diagnosis, not dismissal as contention. The assembled generated RegExp ASCII.js case returns HeapExhausted with 1,210 slots / 241,986,612 chunk bytes, and doubling only the chunk ceiling to 512 MiB does not change that. The matcher independently caps states at 65,536 and payload at 64 MiB. This single observation does not classify all 443 paths.
- The old wrong-throw skip families now count as failures. Host-visible Halt no longer has Resume/Yield; catch propagation uses Step::Unwound, so round-2 protocol advice is historical.
- XS test262 clone at the pin works from tc39/test262; use a job-private scratch TMPDIR, because /tmp is noexec.
- Full sweeps used --jobs 14 --oracle on and RUST_MIN_STACK=67108864. No ironhorse-hang case occurred in the recorded sweeps.
- Default/newer Clippy flags an unrelated pre-existing manual-is-multiple-of warning. The CI-pinned cargo +1.88.0 clippy command passes; use the pinned toolchain instead of rewriting unrelated source.
