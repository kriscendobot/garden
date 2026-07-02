# Build the orchestration-job pattern: an orchestrator that sequences planned sub-jobs and watches them
Maintainer directive (kriskowal 2026-07-01): **for a multi-part job, always make an ORCHESTRATION JOB**
that moves the planned sub-jobs off `plan/` into `todo/` **in sequence (default) or parallel (as
instructed)**, and the orchestrator **watches the progress of the child jobs** so it is **less likely to
forget to follow up with the next job**.
Build the pattern:
1. **Orchestrator role + skill** (`roles/orchestrator/AGENT.md` + a skill): a gardener claims an
   orchestration job that names its **child sub-jobs** (parked in `plan/`) and an **ordering**
   (`serial` default | `parallel`). It drives them:
   - **serial:** promote child #1 (`promote-plan.sh`), **WATCH it reach `jobs/tada/`**, then promote #2,
     … — one at a time, in order.
   - **parallel:** promote all children at once, then watch them all to completion.
   It watches child completion via the job board (poll `jobs/tada/`), reports overall progress, and on a
   **child failure** surfaces/handles it (halt-serial vs continue, per the orchestration job's policy)
   rather than silently stalling.
2. **Mechanism / children identification:** define how the orchestrator knows its children — e.g. a
   `children:` list + `order: serial|parallel` in the orchestration job body, and/or an
   `orchestrated-by: <orchestrator-base>` field on the child `plan/` jobs. Reuse the plan/promote
   primitives. **Relate to the existing `blocked_on` + `unblock.sh` chain**, which already does
   DETERMINISTIC serial promotion (child B `blocked_on` A → promoted when A lands in tada): decide whether
   to build the orchestrator ON that deterministic substrate (preferred for reliability) and add the
   active watch + parallel + progress-report + failure-policy on top.
3. **Encode the behavior:** in **CLAUDE.md** (job-system section) + **roles/liaison/AGENT.md** (and the
   steward/orchestrator roles): when posting a **multi-part job**, decompose it into planned sub-jobs +
   one orchestration job (serial default). Make it the standing pattern.
Tests: serial promotion advances only after each child reaches tada; parallel promotes all; a child
failure triggers the policy, not a silent stall. Land on `main2` via an isolated worktree off origin/main2.

---
claim:
  host: endolinbot2
  gardener: 7
  claimed_at: 2026-07-02T00:00:21Z
