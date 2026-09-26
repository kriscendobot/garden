Authored `skills/self-healing-wrapper/SKILL.md` and landed it on `origin/main2` (commit `1e0d49d3`).

## What I did

- Built in an isolated worktree off `origin/main2` (per the garden-infra-jobs norm — the shared `/home/kris` tree is concurrently mutated), committed an explicit pathspec, and pushed `HEAD:main2`. The first push was rejected by a concurrent gardener; I rebased on the new tip and pushed clean. Verified the file exists on `origin/main2` and removed the worktree.

## What the skill says

A reusable three-part playbook for an outer wrapper that, on failure:

1. **Captures the failure output** by SHA (`git hash-object -w` into the service's journal clone), with both capture sources — an EXIT/ERR trap keeping the `-x` transcript, and diverted tracing (`BASH_XTRACEFD` → `$GARDEN_TRACE_LOG`). Stresses *hash, don't inline* to keep prompt token cost bounded.
2. **Hands the SHA to a task-specific `claude -p` responder** via a four-slot brief, with the known-SHA short-circuit and best-effort/never-crash disciplines. Emphasizes a *role specific to the self-healing task* over the central mentor's one-generic-prompt approach.
3. **Proposes/posts a fix** via one of three routes (committed gardener inbox, per-service self-improvement log, or a posted job), and codifies the local-clone-vs-cross-host capture nuance the audit flagged.

Cites all three exemplars the job named: `scripts/driver/driver.sh` (EXIT trap + `capture_and_self_improve`, the full shape — with the caveat it's on the retired posture), the v1 `report-error.sh` (capture+escalate half, journal→journal2 retarget caveat), and the gardening state machine's diverted tracing (`garden-pr.sh`/`panel.sh` — the trace-only half). Also frames the wrapper against `Restart=` and the central mentor as three distinct layers.

## Follow-ups (already tracked as sibling jobs)

- The cross-links to `prompt-on-failure-capture` and `gardener-inbox-error-reporting` are written as **forward links** marked "v1-only / port pending" — those skills are not yet in the v2 tree (`self-heal-port-capture-skills`). Once they land, the "once ported" qualifiers in the skill can be dropped. `v1/skills/...` references match the convention the audit doc already uses.
- I did **not** touch `CLAUDE.md`'s skill inventory or `skills/README.md` (the README "Defined:" list is curated to a few core skills, not exhaustive), to avoid a shared-file conflict with concurrent gardeners. If the maintainer wants the inventory line added, that's a small separate edit.
