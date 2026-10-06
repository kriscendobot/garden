## Completion report: skill-caplet-validation-20261006

I wrote `skills/caplet-validation/SKILL.md` and pushed it straight to `main2` as commit `a512bff2671`. I also added `caplet-validation` to the skill list in `CLAUDE.md`. The rebase hit a conflict on that one inventory line; I took upstream's version and added the entry again.

**Is there a real caplet to validate against?** Yes, so the skill names real ones rather than a made-up example. It has not been run against any of them yet.
- minion.town `main` (`be0edb8`) has two in `src/endo/gateway/`:
  - `site-registry-caplet.ts` is unconfined: it is loaded with `makeUnconfined`.
  - `site-register-caplet.ts` is a register-only facet given to each guest. Its owner is fixed by the `CLIP_OWNER` setting where it is granted, and it throws if that setting is missing.
- endo-but-for-bots has more, such as `@endo/fetch` and `9p-server/mount-caplet.js`.
- No test-harness tool exists yet. The skill says so, and says to reuse `tools/cold-agent-eval/run.sh` from minion.town PR #147 once it lands.

**What the skill covers.** It follows the skill format from `CLAUDE.md`: purpose, status, inputs, state, procedure, output shape, notes.
- **Step 0: confined or unconfined.** For an unconfined caplet, validation can only check the capability it hands back, not the module itself. The verdict must say "scope: returned facet only".
- **Step 1: declared vs. granted.** The skill compares three lists: what the caplet declares it needs, what it is actually granted (read from the live daemon, not just the source), and what its returned object exposes. Any power granted beyond what was declared fails, even if the caplet never uses it.
- **Step 2: code review.** This reuses the existing locksmith, warden, breaker and saboteur jury seats rather than restating their rules.
- **Step 3: does it work?** This is PR #147 § 6 made general:
  - The client holds only the caplet. It is either a small scripted client or a bare `claude -p` with the PR's preflight check.
  - Each task uses a fresh random value and sets up its own starting state.
  - A separate verifier checks results from outside the client's reach.
  - Runs before and after a change, 5 runs each, pass at 4 of 5. Infrastructure failures are discarded and rerun.
  - A first adoption has only one set of runs, and the verdict says there was no baseline.
- **Step 4: confinement.** The skill adds escape probes: tasks the caplet must refuse. It records evidence from three places: the client's transcript, the caplet's errors, and before/after state seen by the verifier. A table sorts each attempt:
  - A specific, fail-closed refusal is positive evidence that the boundary held, not something to ignore.
  - An attempt that succeeds is an escape.
  - A silent result or a generic crash is ambiguous.
  - A probe the client never attempted counts as a gap in coverage, not a pass.
- **Output.** The verdict is approve / request-changes / needs-human, using panel-review's finding format and dispositions, with an ordered rubric. needs-human is the only new term.

**Checks.** The skill has no em dashes, and the cliché and British-spelling greps found nothing. My inbox was empty.

**Follow-ups:**
- Revise the skill after its first real run. The best first targets are the two minion.town gateway caplets.
- Re-read PR #147 § 6 if that PR changes or closes.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/skill-caplet-validation-20261006.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 44 tokens (1619966 cached reads)
- Output: 15008 tokens
- Cost: $1.2777852000000003
- Wall-clock: 194s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
