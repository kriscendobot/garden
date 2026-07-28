---
role: builder
handler-timeout: 7200
parent_design: designs/staged-gauntlet.md
---

# Build the staged gauntlet: deterministic per-PR driver + stage handlers

Implement the staged gauntlet specified in `designs/staged-gauntlet.md` (now on
`main2`). The design's motivation: the gauntlet (clean → panel → fix-loop →
un-draft) runs today as ONE claimed `role: gardener` job whose handler must span the
whole chain, including an unbounded number of panel rounds and unbounded CI waits —
which does not fit any handler budget (nine jobs poisoned on `deadline-overrun`
2026-07-28, one at a 14000s budget already against the `GARDEN_CLAIM_TTL` ceiling).
The enabling primitive — `panel.sh`'s `GARDEN_PANEL_SINGLE_ROUND=1` mode — and its
test (`scripts/jobs/test/panel-single-round-test.sh`) already landed with the design.
This is garden-infra work on `main2`: develop in your own worktree and **push
directly to `main2`, no PR** (the garden opens no PRs against itself).

Read `designs/staged-gauntlet.md` end to end first; it is the spec. Build:

1. **`scripts/jobs/post-gauntlet.sh`** + the **`jobs/gauntlet/<g>.md` record format**
   (a new category alongside `jobs/orch/`, outside the claim lifecycle — add
   `JOBS_GAUNTLET` to `common.sh` beside `JOBS_ORCH`, and ensure the fixture/board
   setup and any board-listing that enumerates non-claimed categories know about it).
   Frontmatter per the design (pr/repo/pr_number/build_job/kind/stage/iteration/
   max_iterations/current_child/state/created_by/created_at). Idempotent: a no-op if a
   record or `jobs/tada/<g>.md` already exists (mirror `post-orchestration.sh`).

2. **`scripts/jobs/gauntlet.sh`** — the deterministic, leader-only, no-`claude -p`
   driver, modeled on `scripts/jobs/orchestrate.sh`. Reuse its substrate:
   `child_state` (done/active/parked/failed from the board), `promote-plan.sh` /
   `post-job.sh` for stage promotion, `set_orch_state`-style CAS record updates,
   `finish_orch`-style completion (write `jobs/tada/<g>.md`, remove the record),
   `orch_notify`-style maintainer surfacing. Per tick, per active record: read
   `current_child`'s state; `active` → wait; `failed` → **halt** (state=halted +
   surface); `done` → parse the child's `tada/` report for the stage-result marker
   `<!-- gauntlet-stage-result: <stage>=<result> -->` and apply the design's
   transition table (clean→panel-1; panel-k pass→undraft/done(probe); panel-k
   must-fix→fix-k; fix-k→panel-(k+1) or halt at max_iterations; undraft→done). A
   `done` child with NO parseable marker is a **failure** (halt), never a guess —
   fail-closed like `panel.sh`'s disposition parse. Use a `GARDEN_GAUNTLET_CLONE`
   override for its per-service clone (mirror `GARDEN_ORCH_CLONE`).

3. **`scripts/systemd/garden-gauntlet.{service,timer}`** — leader-only via
   `ExecCondition=is-main-host.sh`, run through `self-heal-run.sh`, absolute
   `OnCalendar` schedule (mirror `garden-orchestrate` — relative timers starve).
   `install-units.sh` auto-discovers the pair; no source-list edit needed. Confirm
   `is-main-host` gating and that a follower condition-skips cleanly.

4. **The four stage handlers** as thin `role: gardener` job bodies (or small
   handler scripts the stage jobs invoke), each idempotent against **live PR state**
   and each emitting its stage-result marker in its completion report:
   - `clean`: coverage pass + dead-code + `ci-wait-merge.sh <repo> <N> --no-merge`;
     on rc=4 (still pending) report `still-pending` WITHOUT a terminal marker so the
     driver re-posts the stage; rc=3 (red) fails → halt. No-op if already clean+green.
   - `panel-<k>`: run `panel.sh` with `GARDEN_PANEL_SINGLE_ROUND=1`, post the
     aggregate as a `gh pr review` (the panel-verdict shape the next-stage-owed
     heuristic recognizes), emit `panel=pass`|`panel=must-fix`.
   - `fix-<k>`: apply the must-fix items from the latest panel verdict, push
     follow-ups via `safe-push-pr-head.sh`, watch CI; emit `fix=done`.
   - `undraft`: appellate (advisory) + `gh pr ready`; no-op if already ready; emit
     `undraft=done`. A `kind: probe` record never reaches this stage.

5. **Switch the producers to create a record, not a monolith:**
   - `scripts/jobs/auto-gauntlet-handoff.sh` — replace the `post-job.sh
     "$base-gauntlet"` monolith with `post-gauntlet.sh <g> <pr-url> --build-job
     <base> [--probe]`. Preserve every existing invariant: probe detection (stays
     `kind: probe`), the non-draft re-draft correction, the "failed post leaves the
     build unfinished for requeue" contract. Update
     `scripts/jobs/test/auto-gauntlet-handoff-test.sh` accordingly.
   - `scripts/jobs/comment-watcher.sh` (and `mention-watcher.sh`) `run the gauntlet`
     path — create a record instead of the `<slug>-pr<N>-gauntlet` monolith.

6. **Tests.** A hermetic `scripts/jobs/test/gauntlet-test.sh` modeled on
   `scripts/jobs/test/orchestrate-test.sh` (bare-repo fake journal, env scrub,
   `GARDEN_GAUNTLET_CLONE`, `complete_child`/`fail_child` fleet simulation, tick =
   run `gauntlet.sh` once). Cover: clean→panel→undraft happy path (no fixes);
   panel→fix→panel loop convergence; non-convergence halt at max_iterations; a failed
   stage halts + surfaces; probe never un-drafts; idempotent re-tick. Keep every new
   script `bash -n` clean and `shellcheck -S warning` clean.

## Definition of done

- All of the above on `main2` (direct push, no PR), every new/changed script `bash
  -n` and shellcheck clean, `gauntlet-test.sh` and the updated
  `auto-gauntlet-handoff-test.sh` green, and the existing
  `panel-single-round-test.sh` / `panel-parallel-fanout-test.sh` still green.
- Report explicitly which acceptance criteria you **ran and observed** vs which need
  a live deploy. NOTE: the design's "demonstrated on one real PR, each stage inside
  the default budget, chain reaches un-draft" criterion requires the
  `garden-gauntlet` unit to be **deployed to the garden root** (a drained
  `deploy-garden.sh` the liaison/maintainer runs) — that live demonstration and the
  **migration of the gauntlet-shaped poisoned jobs** (re-post `endo-sturdyref-…`
  #871, `finbot-pr5-panel`, `pr755`) as gauntlet records are a **post-deploy
  follow-up**, not part of this build. Surface that handoff in your completion report
  so the liaison can schedule the deploy + demo + migration.
- If you decompose this into ordered parts, orchestrate them (don't pile sub-jobs).
</content>

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 6
  worker_kind: gardener
  claimed_at: 2026-07-28T16:12:43Z
