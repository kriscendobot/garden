**Gauntlet panel round 4: endojs/endo-but-for-bots#1392 — must-fix**

I ran one single-round panel against PR head `6571479f91`, reviewed against base `a0ef0c4`. `panel.sh` exited 0 with disposition **must-fix**. The run is recorded at `panel-runs/endojs-endo-but-for-bots-1392/f80228715a05.md`.

**Base ref.** I passed the base as its exact SHA, `a0ef0c432085c2c7a0e276b01c505d6fa420424d`, taken from `gh api pulls/1392 .base.sha`. A bare branch name can resolve to a stale copy in the fork, and the SHA avoids that.

**Seat verdicts (33 seats):**
- **Request-changes (5):**
  - **saboteur:** `getRankCover` on a bare SturdyRef throws a raw `TypeError` (`patternMatchers.js:707`).
  - **breaker:** `dot-membrane.js:111` `convertMineToYours` is a `PassStyle` switch with no `sturdyRef` case, unlike the sibling switches this PR converted.
  - **purist:** `PassableCap` in `types.d.ts:206` was not extended with `SturdyRefObject`.
  - **pruner:** the PR body is too long (746 words against a 300 limit). It suggests dropping the stack list and the "Mined from #737" section, and condensing Testing Considerations. The concision probe fired, which is why the pruner was run.
  - **corner-prober:** `compareRank` succeeds on two identical SturdyRefs, which contradicts the PR's claim that a SturdyRef cannot be rank-ordered. The "first global wins" case is untested when the first global is valid.
- **Comment-only (9):** typist, prover, curator, integrator, surfacer, scribe, gateway, fast-checker and one more.
- **Approve:** all remaining seats.

**Review posted.** I put the aggregate on the PR in the same two-part shape as earlier rounds:
- Part 1/2: https://github.com/endojs/endo-but-for-bots/pull/1392#pullrequestreview-5374586235
- Part 2/2: https://github.com/endojs/endo-but-for-bots/pull/1392#pullrequestreview-5374586427

Both parts went up as COMMENT reviews. GitHub refused `--request-changes` because the bot authored the PR, and rounds 1–3 were posted the same way. Part 1's header carries "disposition: **must-fix**".

**Small fix.** The benchmarker and coverage-auditor blocks had empty summary verdicts, so I labeled them "approve" to match their own text. Nothing else in the aggregate was changed.

No fixes were made and the PR was not un-drafted, as this stage requires. The next stage is the fixer.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-sturdyref-layer3-pass-style-20260930-gauntlet-panel-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 44 tokens (1393992 cached reads)
- Output: 6433 tokens
- Cost: $0.9370504
- Wall-clock: 759s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
