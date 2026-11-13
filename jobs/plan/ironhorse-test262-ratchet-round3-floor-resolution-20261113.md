---
gate: awaiting-maintainer
maintainer_question: 'Re-pin the Ironhorse floor to a fresh llm measurement (A) or keep refresh-20260904 and repair the 882 losses (B)?'
asked_at: https://github.com/kriscendobot/garden/issues/51#issuecomment-6850754867
priority: high
posted_by: producer
posted_at: 2026-11-13T10:52:54Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
role: builder
handler-timeout: 14339

# Resolve the Ironhorse round-3 historical floor (successor, post-weave)

This job takes over all remaining work from `ironhorse-test262-ratchet-round3-floor-resolution-20260928`. Read that job's tada report and the original spec it quotes, including the peer annotations from `build-ironhorse-ratchet-autopilot` and `improve-ironhorse-test262-ratchet-gate`. Every acceptance item there still applies. The rest of this body records what has changed since. Do not waive, replace or relabel the historical floor unless the maintainer explicitly authorizes it.

Maintainer question: https://github.com/kriscendobot/garden/issues/51#issuecomment-6850754867 asks for A (re-pin to a fresh `llm` measurement, auditing all 882 paths through `ironhorse-test262-ratchet-gate.sh pin --from-report … --supersedes refresh-20260904`) or B (keep `refresh-20260904` and repair the genuine losses).
Standing directive (kriskowal, 2026-11-13): "Fix the base and continue. Keep the ratchet moving. Ratchet must go up. Nothing merges until the ratchet produces an improvement on the base, and the base may move. Weave at discretion, repair regressions."

State after `weave-ironhorse-pr1359-20261113` (see its tada report):
- PR: https://github.com/endojs/endo-but-for-bots/pull/1359 (draft). Base is live `llm` (rebased onto `48d6f3e08b`). Head is `feat/ironhorse-test262-ratchet-round3` at `5825b6c5667f254d890b0463f02340bfefa5181c`.
- `llm` already landed the same engine fix (`25d95061b4`). The PR now carries only `tests/intrinsic_numeric_constants.rs` plus the `baseline/refresh-20260928/` evidence. That evidence describes a superseded branch point. **The PR adds 0 coverage over its base**, so under the directive it needs a real engine improvement before it can merge.
- Current `llm`, whole corpus (pins `be13516f` / XS `23b4d6b0`, `--jobs 14 --oracle on`): covered 39,860, failure 1,064, unsupported 3,256, skipped 7,614, infrastructure 177, refused 5.
- 882 of the 30,233 floor paths are still lost: 443 resource-limit, 410 both-engine-abort positive tests, 19 TypeError where XS completes, 5 strict-acceptance, 3 script-eval declarations, 2 async (`Promise/prototype/finally/*-observable-then-calls-argument.js`, which now fail hard on `resolve.length`). There are 0 branch-point or round-3 losses and no new regressions.

Do this:
1. Take a fresh measurement on the current `llm` tip and on the PR head. Weave again if `llm` has moved. Use an ensure-project-worktree.sh checkout keyed by THIS base.
2. In both cases A and B, the ratchet must go up. Repair a cluster that gives a measurable improvement over the base. Cheap candidates come first: the 2 Promise-finally `length` cases and the 19 TypeError cases. Add an oracle-checked dual-run regression for each repaired cluster. Run the whole-corpus sweep and the pinned Rust gates (`cargo +1.88.0` fmt/clippy, release test).
3. If A is authorized: pin the floor with the gate, with full disposition audit, and commit it next to the evidence. If B: keep repairing losses, and commit a superseding floor only at zero loss.
4. Update the PR body. Post a before/after comment and a ranked-queue comment on https://github.com/kriscendobot/garden/issues/51. Tell `build-ironhorse-ratchet-autopilot` the enforced-floor path, and run `scripts/jobs/ironhorse-ratchet.sh resume` (or ask the liaison to). Leave the PR as a draft; the maintainer owns the gauntlet. Temporal and Intl are out of scope.
