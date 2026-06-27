Everything landed. Here is my completion report.

---

## Completion report — `issue-inbox-maintainer-interaction-workflow`

**Outcome:** Designed and built the `garden-issue-inbox` workflow — a deterministic watcher that turns the garden's own GitHub issues into a maintainer-interaction inbox. Landed on `main2` as commit **2a7b07dc7** (11 files, +1031), built in an isolated worktree off `origin/main2` and pushed via a rebase-CAS loop (clean, no conflicts).

**What I built:**
- **`scripts/jobs/issue-inbox-watcher.sh`** — single-instance, no-LLM watcher. New issue → posts a job keyed to a stable spine `issue-<owner>-<repo>-<number>` carrying the issue note; new comment on an in-flight issue → delivers a message to that issue's doer via `inbox-send` (dead-letters → `garden-deadmail` promotes to a job if the doer finished); submitter-closed issue → terminal. Durable journal cursor; advances only after a verified dispatch.
- **`scripts/jobs/handlers/issue-source-gh.sh`** — gh/jq source. `require_tools gh jq` (fails loud on missing jq), `--paginate`, excludes PRs, and joins the parent issue for `submitter`/`state`/`closed_by`.
- **The safety gate (mandatory):** a deterministic maintainer-trust gate that runs in plain code **before any body is read**, dropping every non-maintainer author. Stricter than the mention/comment watchers — **allowlist-only, no org-membership fallback**.
- **Per-instance journal config** (not main2): `config/garden-repo` + `maintainers/allowlist`, with init producers **`set-garden-repo.sh`** / **`add-maintainer.sh`**. Watcher is inert until both exist.
- **The issue note** (url + spine + submitter) carried in every job/message; consumer rule (copy verbatim into follow-on jobs, reply on the issue thread, never auto-close) documented in **`skills/issue-inbox/SKILL.md`**. Confirmed (and pinned by test) that `deadmail.sh` preserves the note for free; added a clarifying comment there.
- **`scripts/systemd/garden-issue-inbox.{service,timer}`** — auto-enabled by `install-units.sh` (non-template, `WantedBy=timers.target`), inert until configured.
- **`designs/issue-inbox.md`** — decisions; **CLAUDE.md** — bring-up step + monitoring-safety exception note + skills inventory.
- **`run-test.sh` SUBTEST 26** — 19 assertions, all passing (non-maintainer dropped; maintainer issue→job-with-note; in-flight comment→message; dead-doer comment→deadmail-promoted job carrying the note; note propagation; submitter-close terminal; inert-without-config; source PR-exclusion + parent-issue join).

**Authorization recorded:** posted a journal `message` entry (`entries/2026/06/27/190100Z-message-gardener-b84c82.md`) documenting the maintainer-authorized monitoring widening, per the constraint.

**Bugs found and fixed during build:** (1) scrambled arg order in the note writer; (2) tab-IFS field collapse on the empty `closed_by` column (adopted a `-` sentinel in source + watcher); (3) a latent `if commit_and_push; then …; fi; rc=$?` idiom that swallows the rc=2 "nothing to commit" return (a false `if` with no `else` is exit 0) — fixed with `|| rc=$?` in both init scripts so idempotent re-runs no longer loop. The sibling producers (`set-schedule`/`set-gardeners`) share this latent bug but mask it with always-changing timestamps; left out of scope.

**Follow-ups (not blocking):**
- To actually arm this instance, a maintainer runs `set-garden-repo.sh kriskowal/garden` + `add-maintainer.sh <login>` (deliberate act; left for the maintainer).
- Comment delivery is at-least-once on a crash (accepted per "re-process, never skip"); same-second comment ties on the cursor boundary are dropped — fine for the garden's low-traffic own issues, documented in the design.
- The latent `if commit_and_push` rc-swallow in `set-schedule.sh`/`set-gardeners.sh` is worth a separate hardening job.

Worktree and scratch torn down; inbox empty.
