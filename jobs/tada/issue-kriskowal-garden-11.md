Done. Here's my completion report.

---

## Completion report — `issue-kriskowal-garden-11` (Multibot)

**What the issue asked:** Prepare standing instructions for multiple bot accounts sharing one garden instance (leader/follower hosts). Verify/fix the instructions, ensure the *existing* plan covers all 8 stated details, then **promote it to the job board (todo)**.

**What I found:** A parked, go-ahead-gated plan already existed — `jobs/plan/service-host-roles-singletons-on-main-host` — covering the topology half (gardeners on every host, singletons on one host, a `hosts/main-host` journal marker, condition-gating with restart-on-change). It substantially covered issue points 1–5 but was **missing**: the `GARDEN` env-var hostname knob (points 3/6/7), the liaison stand-up-verify + stand-down/drain vocabulary (points 1/6/8), the leader/follower↔main-host/singleton terminology reconciliation, and answers to its own two open questions (which the issue actually resolves).

**What I did:**
1. **Expanded the plan** to cover all 8 points — added a terminology-reconciliation section, a `GARDEN` host-identity knob section (`GARDEN` defaults to `hostname -s`, `GARDEN_HOST` defaults to `GARDEN`; one assignment, no repo-wide rename), a liaison stand-up/stand-down vocabulary section, the leader-only liaison maintainer-inbox Monitor, and answered the failover + per-host-infra open questions using the issue's guidance. Embedded the issue spine so the build comments back on #11.
2. **Landed the edit through the sanctioned producer clone** (`sync_clone` → write → CAS `commit_and_push`), never the live `/home/kris/journal` worktree (won one push race, then landed).
3. **Promoted it to `jobs/todo/`** via `promote-plan.sh` — the issue is the maintainer's explicit go-ahead.
4. **Commented the coverage map back on issue #11** (point-by-point), did **not** close it.

**What changed:** `journal2:jobs/plan/service-host-roles-singletons-on-main-host.md` → expanded → moved to `journal2:jobs/todo/service-host-roles-singletons-on-main-host.md`. Comment posted: https://github.com/kriskowal/garden/issues/11#issuecomment-4826861659

**Follow-ups:**
- A gardener will claim the promoted todo and do the actual build (`common.sh` GARDEN knob, `is-main-host.sh`, singleton gating + demote-on-change, liaison/CLAUDE.md vocabulary, tests).
- One tension is flagged *in the job* for the build to resolve or bounce back to #11: issue point 2 ("followers run only gardener processes") vs. a follower needing its own deploy-sync/clone-keeper/worktree-keeper. The job's tentative resolution is "per-host local-infra + split the watchman," with instructions to comment back rather than silently disable a follower's deploy ability.
- Lease-based auto-failover was explicitly deferred (issue confirms manual leader designation).
