FIX round 1 for PR #695 (`design(sturdy-refs): agent provide/accept surface`) is complete.

**What I did.** Read the latest panel verdict (request-changes across critic, skeptic, decomplector, ergonomist, copyeditor, pedant, novice; orthographer approved-with-fix) and applied every must-fix plus the cheap should-fix/comment items in one revision of `designs/sturdy-refs-agent-surface.md`, pushed as a follow-up commit to the PR head, and confirmed CI green.

**What changed** (commit `947cbbe4bc` on `design/sturdy-refs-agent-surface`):
- **Two false load-bearing premises corrected** (verified against the worktree): `@endo/genie` was retired (commit `42bc7d5161`) — the design now targets **two** agents, Lal and Fae, not three; and Fae does **not** depend on `@endo/agent-tools` — the sharing story is rewritten around the layer both agents actually consume (`@endo/agent-tools` directly for Lal, via `@endo/agentry` for Fae).
- **critic must-fix:** enumerated the in-tree consumers of the methods Phase 2 removes (`locate`/`lookupById` in Lal's tools + Fae's subagent/credential paths) and made explicit that the attenuated facet is a *new* confinement level for a new class of worker — Lal/Fae keep the full `EndoGuest` and are not migrated; the confinement criterion is tested against a purpose-built confined worker.
- **ergonomist/novice must-fix:** stated `lookupBySturdyRef`'s return (an enlivened presence) at its introduction and scoped the initial accept surface to code-mode (no model-addressable handle for the returned presence).
- **copyeditor/novice must-fix:** removed the self-contradicting `## Status` section; the SturdyRefToken cost is now stated once, canonically, in Retention.
- **novice must-fix:** added a concrete same-turn worked example to the problem statement.
- **should-fix items:** recursive `storeValue` deny over the passable graph (+ nested negative tests); `enlivenSturdyRef` reuse caveated (process-local WeakMap; CapTP path isn't `@endo/ocapn`) with a daemon-held index required in Phase 3; stale-vs-unknown made implementable under the per-activation map (epoch counter + bounded handle-epoch record outlive each discarded map); render map keyed by object identity; pinned model-visible tool/param names + a third failure message; Summary corrected to "single-turn for model-presented handles."
- **comment/mechanical:** corrected drifted `path:line` citations, renamed the resolver arg to `secretResolver`, `analogue`→`analog`, `i.e.`→removed, normalized round→turn, linked competing-pair selection disposition, and reflowed prose to 80 cols.

Left a stray environment-introduced edit to `packages/floot/package.json` uncommitted (a warm-cache yarn step, not mine, not in the PR head).

**CI:** green — `ci-wait-merge.sh` returned rc 0 (27 checks, 0 failed; design-only change so most jobs skip, `lint`/`zizmor`/`changes` pass). Did not re-run the panel, per stage instructions.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr695-gauntlet-23a03130-pinned-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 78 tokens (4455490 cached reads)
- Output: 55407 tokens
- Cost: $5.110371
- Wall-clock: 1373s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
