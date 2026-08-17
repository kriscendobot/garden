Pushed to main2 (`29712dfa20..284b26fe2a`). The remote-moved notice is the documented `kriskowal→kriscendobot` redirect. Job complete.

---

## Completion report: `self-improve-job-basename-isodate`

**Grounding incident:** while hand-posting the 11-child `endojs-endo-but-for-bots-gateway-phase-restack-chain` orchestration (2026-08-17), a fresh child `endojs-endo-but-for-bots-pr395-weave` silently collided with an unrelated, already-**completed** job of the same base (an earlier PR #395 restack against a since-superseded base). `post-plan.sh` correctly no-op'd, but the intended child was never parked — caught only by reading the loop's log line by line.

**Fresh-start check:** no prior attempt had committed anything to main2 (the requeue lost its session/tree); I re-derived from history and did the work clean.

### What changed (commit `284b26fe2a` on main2)

1. **Convention documented once, canonically** — `skills/job-board/SKILL.md` gained a new **§ Basename shape**: bare deterministic base for a **stable one-shot** ask (`design-X`/`build-X`/a specific fix — date-suffixing would break intended idempotency); an ISO-date `-YYYYMMDD` (or identity) suffix for a **recurring verb against the same target** (`weave`/`shepherd`/`conduct`/restack/`retcon`). Cross-linked from **CLAUDE.md § How work reaches workers** and **skills/orchestration/SKILL.md** (child-parking step, where the incident occurred). Role files (weaver/shepherd/conductor) use "base" only for git refs — no duplicated basename guidance to reconcile.

2. **Audit of the deterministic minters — finding: no code change needed, each already carries a disambiguator** (named per acceptance):
   - `scheduler.sh:392` — date-stamps every tick `${prefix}-YYYYMMDD-HHMMSS` ✓
   - `pages-watcher.sh:262` — keys on commit SHA `garden-pages-<sha>-shepherd` ✓
   - `comment-watcher.sh:1841-1859` (rebase/retcon/refresh/shepherd/gauntlet/pinbase/finalize/review) — bare `(PR,verb)` base **but** passes a **directive identity** (comment/review id); `base_live` counts only todo/doin, identity index is the re-see guard (the #671 fix, commit `1d6cdc5a14`) — a fresh directive is never tada-swallowed ✓
   - `ci-watcher.sh:385` auto-shepherd + `approval-reconciler.sh` conductor — deliberately **share** the bare `(PR,verb)` base with the manual path so concurrent producers collapse to one; **date-suffixing these would break that cross-producer dedup and double-post** — correctly left alone.
   
   The real gap is the **hand-posted** recurring job (orchestration child, liaison verb job) carrying neither date nor identity — which the convention now governs.

3. **Visibility fix (item 3, landed — clean & small)** — `post-job.sh` and `post-plan.sh` now split the routine plan/todo/doin no-op from a **loud `WARN`** when a post collides with a **completed tada/** job, so a scripted posting loop can no longer let the swallow pass unnoticed.

### Tests
Added `directive-identity-dedup-test` cases **8f1/8f2** (tada collision stays a no-op **and** now surfaces the WARN). Full green: dedup **22/22**, comment-watcher **320/320**, orchestrate **49/49**, annotate-plan **45/45**, promote-plan-doom **32/32**. Both edited scripts pass `bash -n`; the only shellcheck notes are pre-existing `GARDEN_TAG` false positives.

**Follow-ups:** none required. Deliberately did **not** blanket-mutate the minters (one incident, per self-improvement § Threshold: document a pitfall, don't add a broad rule).
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/self-improve-job-basename-isodate.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 4 on 2 host(s) (3 unmetered)
- Input: 63 tokens (2766317 cached reads)
- Output: 25291 tokens
- Cost: $2.9005525 (3 engagement(s) unpriced)
- Wall-clock: 457s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
