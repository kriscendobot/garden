Landed on `main2` at `0dcae31c8e`.

## What I did

Added `scripts/jobs/annotate-plan.sh`: the sanctioned CAS-append for a job already parked in `jobs/plan/`. `post-plan.sh` is idempotent-only by design (a re-post of the same basename no-ops so a re-running producer can never fork a parked item), which left no primitive for "this parked job just learned something new" — hence the hand-rolled sync/edit/commit/push loops. This is that loop once, following the `post-plan.sh`/`promote-plan.sh` conventions exactly (shared producer clone, `sync_clone` → write → `commit_and_push`, retry-with-backoff on a lost race, no LLM).

Behavior:
- **Append** under a `<!-- garden-annotation: key=... by=... at=... -->` marker. A key already present is a **no-op success**, so a requeued producer never double-appends; the default key content-addresses the note + field change, so an identical re-annotation collapses for free. `--key` gives a stable external identity (a comment id) or a deliberate re-append.
- **Field updates in place** for `priority`/`roadmap`/`role` (inserted if absent). Every other frontmatter key passes through untouched — importantly the `model:` / `handler-timeout:` / `requires:` execution pins a blind rewrite would eat.
- **Gate fields deliberately not settable** (`gate:`, `blocked_on:`, `orchestrated_by:`): re-gating is a different act owned by `promote-plan.sh` / `block-job.sh` / `post-orchestration.sh`.
- **Plan-only and loud**: a base that has left `plan/` exits **3** rather than writing into a claimed job; `--if-parked` downgrades that to a quiet exit 0 for a producer racing the foreman.
- Carries `post-plan.sh`'s producer-body-hang guard, so an inline body *string* passed where a body *file* is expected fails fast instead of blocking on stdin while holding the producer lock.

## What changed

- `scripts/jobs/annotate-plan.sh` (new, executable)
- `scripts/jobs/test/annotate-plan-test.sh` (new) — hermetic throwaway bare `journal2`, no network; **45 assertions, all passing**: append/frontmatter integrity, dedup (default and explicit key), in-place field update with no duplicate keys and execution pins preserved, lifecycle refusal + `--if-parked`, the fail-fast guards, and that an annotated job still promotes to a clean todo body.
- `skills/job-board/SKILL.md` — an **Annotate** entry in § Plan category between Park and Promote, with the dedup/field/gate/lifecycle properties.
- `designs/job-board.md` — matching §2.5 paragraph and the primitives list.
- `roles/liaison/AGENT.md` — plan-queue vocabulary bullet ("also note Y on X" / "bump X to urgent"), so the liaison reaches for it instead of a no-op re-post.

New prose follows the house style rules (no em dashes, no typist-hostile code points); I swept the arrows/ellipsis in the liaison plan-queue list I was editing, per fix-on-encounter, but did not sweep the rest of those files.

## Follow-ups

- **Host hazard, unrelated to this job:** the shared garden root repo has a stale failed-gc marker — `/home/kris/garden2/.git/gc.log` (mtime 2026-07-28 23:52Z) reading `fatal: unable to read 9ad05cc3563a7ba4b8f3a0b3e7941090e4d427d6` / `failed to run repack`, mirrored into this worktree's `gc.log`. That object is unreadable (`git cat-file -t` fails). Per CLAUDE.md this permanently disables git's automatic cleanup until cleared, and every journal sync pays for the growing packs. It is `garden-root-repo-guard`'s territory; I did not touch the shared object store from inside a job. Worth confirming the guard's last tick actually repaired or alerted, since a genuinely missing object may exceed what it repairs losslessly.
- Adoption is opt-in: existing producers that want it (the PR-comment triager, which is the path that generated the hand-rolled append) still call `post-plan.sh` and silently no-op on a re-post. Wiring `annotate-plan.sh --key <comment-id>` into the comment-driven triage path would close that loop; I left it out as beyond this job's scope.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fu-endojs-endo-but-for-bots-pr124-feedback-triage-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 127 tokens (6799630 cached reads)
- Output: 40589 tokens
- Cost: $5.7052
- Wall-clock: 610s

<!-- garden-usage-end -->
