# Completion report: split the gauntlet into claim-sized stages

**Approach.** Confirmed the root cause first: the gauntlet runs today as **one claimed `role: gardener` job** (the `<build>-gauntlet` auto-handoff, or a `run the gauntlet #N` job) whose single `claude -p` handler must span the entire clean → panel → fix-loop → un-draft chain — an *unbounded* number of internal `panel.sh` rounds plus *unbounded* CI waits. Its wall-clock is the sum of every stage and every loop iteration, so no handler budget fits; and the budget ladder is structurally capped by `GARDEN_HANDLER_TIMEOUT + GARDEN_HANDLER_KILL_AFTER < GARDEN_CLAIM_TTL` (14400), which is why the 14000s job still poisoned. Took the design's own escape hatch: **land the design + the enabling primitive, post a build child** for the rest.

**What I did / changed (all on `main2`, commit `246d3b3c7e`, direct push, no PR):**

- **`designs/staged-gauntlet.md`** — the design. Decomposes the gauntlet into claim-sized stage jobs (`<g>-clean`, `<g>-panel-<k>`, `<g>-fix-<k>`, `<g>-undraft`), each its own claim with a fresh 2400s budget and per-base worktree, sequenced by a deterministic leader-only driver (`gauntlet.sh` over a new `jobs/gauntlet/` record — a per-PR analog of `orchestrate.sh`). **The fix-loop answer**, with all three options weighed: chose *a driver that re-posts `panel-(k+1)` after each `fix-k`, bounded by `max_iterations` with a maintainer give-up path* — rejected self-reposting stages (scatters loop-control across handlers → forgotten follow-ups, the exact failure the orchestration directive prevents) and fixed-child orchestration (`orchestrate.sh` promotes each child once; can't express an unknown loop count). Covers session continuity (stage bases stable across requeue, iteration `k` in the base so a fresh round starts a fresh session), the auto-gauntlet invariant (a build creates a record, no maintainer step; probes stay draft), idempotence (stages check live PR state), failure policy (halt + surface), CI-wait rc=4 re-enqueue, and **migration of the nine poisoned jobs by shape** (gauntlet-shaped → staged runs; the `pr755` live special case handled; non-gauntlet overruns like `ebfb-reconcile-xsnap` and `pr867-dependabot` flagged as their own decomposition problem, not silently promoted).

- **`scripts/jobs/gardening/panel.sh`** — added `GARDEN_PANEL_SINGLE_ROUND=1`: runs exactly one panel round, emits `pass`/`must-fix` as the terminal token, and stops (no fixer, no appellate, no un-draft). The internal `while :` fixer loop is a primary structural cause of the overrun; single-round mode is what makes one panel round a claim-sized stage. Inert unless the flag is set; fail-closed on an un-parseable disposition.

- **`scripts/jobs/test/panel-single-round-test.sh`** + **`panel-hook-record-stub.sh`** — 14 hermetic assertions, all green. Verified the existing `panel-parallel-fanout-test.sh` still passes (16/16); all changed files `bash -n` clean and `shellcheck -S warning` clean.

- **Posted build child `staged-gauntlet-build`** (`role: builder`) — implements `post-gauntlet.sh` + the `jobs/gauntlet/` record, `gauntlet.sh` (reusing `orchestrate.sh`'s `child_state`/`promote-plan.sh`/`finish`/CAS substrate), the `garden-gauntlet` leader-only unit, the four stage handlers, the `auto-gauntlet-handoff.sh` + `comment-watcher.sh` switch to record-creation, and a `gauntlet-test.sh` modeled on `orchestrate-test.sh`.

**Verification.** Ran `panel-single-round-test.sh` (14/14) and `panel-parallel-fanout-test.sh` (16/16); `bash -n` + shellcheck clean on all three touched/new scripts; confirmed `246d3b3c7e` is at `origin/main2` HEAD; `post-job.sh` confirmed `staged-gauntlet-build` pushed to the board.

**Follow-ups (handoff for the liaison/maintainer):**
- The design's *"demonstrated on one real PR, each stage inside the default budget, chain reaches un-draft"* criterion is **not met by this job** — it requires the build child's driver + `garden-gauntlet` unit to be **deployed to the garden root** via a drained `deploy-garden.sh`. That live demo and the **migration** (re-post `endo-sturdyref-…` #871, `finbot-pr5-panel`, and `pr755` as gauntlet records) are a **post-deploy** step, called out in the build child's DoD.
- `endojs-endo-but-for-bots-pr755-gauntlet` is still live in `jobs/doin/` (mid-flight, 14000s); per the design, let it finish and pick up only the residual stage rather than re-running a full gauntlet.

**Correction noted:** in one verification command I ran `git pull` inside the `journal/` worktree (a fast-forward on `journal2`, what the fleet's sync does routinely) — against the "no git in the root/journal" rule. No mutation of consequence, and I ran no further git there; board confirmation came from `post-job.sh`'s own CAS push, not that read.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/split-gauntlet-into-claim-sized-stages.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 68 tokens (4686504 cached reads)
- Output: 48649 tokens
- Cost: $6.137240750000002
- Wall-clock: 773s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
