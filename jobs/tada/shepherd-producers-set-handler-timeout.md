Landed on `origin/main2` at `6135d93046`. Job complete.

---

## Completion report

**What I did:** Taught both shepherd producers to stamp a CI-sized `handler-timeout:` header on the `<slug>-pr<N>-shepherd` jobs they mint, so a shepherd that blocks on CI now **completes** instead of deterministically overrunning (rc=124) the default 2400s handler budget.

**Changed (SHA `6135d93046` on `main2`):**
- `scripts/jobs/common.sh` — new shared constant `GARDEN_SHEPHERD_HANDLER_TIMEOUT`, default **7200s (2h)**. Both producers read it from here, so they never drift and an idempotent cross-producer re-post cannot flap the header (the one code path the spec asked for).
- `scripts/jobs/ci-watcher.sh` — auto-shepherd-on-red path emits `handler-timeout: $GARDEN_SHEPHERD_HANDLER_TIMEOUT`.
- `scripts/jobs/comment-watcher.sh` — manual `shepherd #N` path emits the same header (guarded `[ "$verb" = shepherd ]` inside the shared `write_job_body` generic branch, so only shepherd jobs get it — rebase/retcon/refresh/gauntlet are unaffected).
- `roles/shepherd/AGENT.md` — operating note documenting the header, the value, and why.

**Value chosen — 7200s (2h) — justification:** A shepherd waits on CI; `endojs/endo-but-for-bots` CI runs land on the order of 20–40min, so 2h covers a full CI wait plus ~2–3 fix→CI cycles. It stays comfortably under the claim-budget max (`GARDEN_CLAIM_TTL − GARDEN_HANDLER_KILL_AFTER − 1 ≈ 14339s / ~3.98h` at shipped defaults), so the gardener honors it verbatim rather than clamping+escalating.

**Verified:**
- `bash -n` clean on all three scripts; `shellcheck -S warning` introduces **no new warnings** (the 2 `GARDEN_TAG` SC2034 lines are pre-existing on baseline — confirmed 3 SC2034 before and after).
- Both producers emit the identical line `handler-timeout: 7200` in a minted shepherd body.
- Reproduced the gardener parse (`gardener.sh:360-366`) against a minted body: logs `honoring in place of default 2400s` at `handler_budget=7200` (the honor path, **not** the clamp path).

**Boundary noted:** A shepherd genuinely needing >~3.98h of CI-driving (longer than one claim) cannot be helped by a bigger header — it would clamp+escalate. Out of scope; the fix targets the common minutes-to-a-couple-hours case.

**Sibling gaps flagged for a possible maintainer follow-on (not fixed here):**
1. **Gauntlet-embedded shepherd stage** — the gauntlet runs a CI-wait shepherd *stage* (`scripts/jobs/gardening/ci-wait-merge.sh`) inside the enclosing **gauntlet job**, which rides that job's budget, not this header. The `gauntlet` verb goes through the same generic `write_job_body` branch and now gets **no** header, so a gauntlet blocking on CI likely overruns the default 2400s the same way. Non-trivial (needs its own sizing decision, and the gauntlet does more than wait) — flagged as a sibling follow-on rather than fixed here.
2. **Docker-image builds** and other long-running producers have the same no-auto-classifier gap (no producer stamps `handler-timeout:` for them). Out of scope for "teach the shepherd."

Takes effect on this host at the next deliberate deploy.
