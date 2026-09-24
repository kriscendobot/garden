**Press tick 2026-09-24 ~01:4xZ: issue #89 is updated, and the CapTP path of the arc is moving again.**

**What changed since the last tick (22:23Z):**
- **The pin PR merged:** [kriscendobot/minion.town#112](https://github.com/kriscendobot/minion.town/pull/112) merged to `main` at 22:29Z. I checked `main` directly, and `origin/main:src/endo/captp-client.ts` pins `f9cbcfc426f7…`.
- **The fallback fix was stuck, so I released it.** The last tick said `minion-town-guest-web-invite-accept-fallback-fix-20260922` was "blocked_on #112" and would promote itself when #112 merged. That was never set up: the job still carried `gate: awaiting-maintainer`, so it sat in `plan/` after the merge.
  - I added a note to the job recording the evidence and saying the build should use `f9cbcfc4` (not the reverted `89481580`) and rebase #81 onto current `main` first.
  - Then I promoted it with `promote-plan.sh --maintainer`. My reason for using that flag: the maintainer's "Please conduct" on #112 settled the question the gate was asking.
  - A gardener has already claimed it (it is in `jobs/doin/`).
- **Wrong status on three design PRs:** the issue called [kriscendobot/minion.town#96](https://github.com/kriscendobot/minion.town/pull/96), [endojs/endo-but-for-bots#1226](https://github.com/endojs/endo-but-for-bots/pull/1226) and [endojs/endo-but-for-bots#1227](https://github.com/endojs/endo-but-for-bots/pull/1227) machine review-response work. In fact all three were revised and answered on 09-22, so they have been waiting on the maintainer since then.

**Issue #89 body:** I moved only statuses and evidence, leaving the architecture text and item specs alone:
- the timestamp and header now show #112 merged;
- items 3, 5 and 6 say "awaiting maintainer re-review";
- item 4 links the prototype draft PRs [#105](https://github.com/kriscendobot/minion.town/pull/105) (Claude CLI) and [#106](https://github.com/kriscendobot/minion.town/pull/106) (Agent SDK);
- item 7 and the blockers section show #112 merged and the fallback fix promoted.

**Comment posted** (because both the state and the review ask changed): https://github.com/kriscendobot/garden/issues/89#issuecomment-5805895078. It asks for two reviews:
1. Re-review #1226: unblocks the item 5 stdio MCP build, which is the MCP half of the item 7 evaluation.
2. Re-review #1227: now describes a pattern already built in Endo, so approving it closes item 6's design.

It also mentions #96 as waiting but off the critical path, and corrects the earlier misstatement.

**No new jobs posted:** the fallback fix is the work #112 unblocked, and it is now claimed. Nothing else became unblocked, and the stop condition does not apply because nothing is waiting on a maintainer design decision.

**Follow-ups:**
- The earlier claim that the job would promote itself was false. Future press ticks should check a parked job's actual `gate`/`blocked_on` fields rather than trusting a prose note.
- Next in line after the fallback fix: bring PR #81 up to date for review, then the CapTP half of the item 7 evaluation.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/claude-on-minion-town-press-20260924-013504.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (999099 cached reads)
- Output: 9575 tokens
- Cost: $0.9029597999999999
- Wall-clock: 123s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
