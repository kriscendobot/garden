All three files are on `origin/main2` and the worktree is torn down. Job complete.

----- COMPLETION REPORT: self-heal-port-capture-skills -----

**What I did**

Ported the two v1-only foundational capture skills into v2 (`skills/`), per `designs/self-healing-audit.md` (Part A role/skill gaps). Built in an isolated worktree off `origin/main2`, committed with explicit pathspecs under the bot identity, and pushed `HEAD:main2` (accepted on first try, no contention).

**What changed** (3 new files on `origin/main2`, commit `38ac085d`):

- `skills/prompt-on-failure-capture/SKILL.md` — the capture-by-SHA playbook (capture → known-SHA short-circuit → four-slot brief → `claude -p` → apply). Translated from v1 rather than blind-copied: it now wraps the v2 primitives already in `scripts/jobs/common.sh` (`capture_blob` / `inspect_note` / `anchor_blob`), references `designs/self-healing-audit.md` (Part B), folds in the cross-host reachability nuance (loose blob is local-only; commit-a-file or `anchor_blob` to make it off-host reachable), and retargets the push example to `journal2`.
- `skills/gardener-inbox-error-reporting/SKILL.md` — the transcript-hash-to-inbox helper's contract, retargeted to the `journal2` branch (directory `journal`, branch `journal2`) with an explicit note that it honors `JOURNAL_BRANCH`.
- `skills/gardener-inbox-error-reporting/report-error.sh` — `chmod +x`, `bash -n` clean, **shellcheck clean** (verified locally). Retargeted all three branch references: `push HEAD:journal` → `push "HEAD:$JOURNAL_BRANCH"`, `fetch origin journal` → `fetch origin "$JOURNAL_BRANCH"`, `rebase origin/journal` → `rebase "origin/$JOURNAL_BRANCH"`, with `: "${JOURNAL_BRANCH:=journal2}"` matching `common.sh`. No stray plain-`journal`-branch refs remain.

**Notes / follow-ups**

- The `v1/` reference tree is local-only (not on `origin/main2`), so the port was done from the read source content into fresh `skills/` directories; neither skill pre-existed on `main2`.
- **Surfaced a translation gap, deliberately left out of scope:** v2's primary message bus is the per-doer `inbox/<doer>/{unread,read}` and the `msgs/role/gardener` topic (`skills/message-bus`), whereas this ported helper still appends to the host-scoped shared file `inboxes/<host>/gardener.md`. I kept the v1 file-append form (it's the durable, host-scoped failure log that survives when no gardener is actively working the host — the right shape for an ERR-trap) and documented the relationship plus a noted follow-up: optionally also emit a `msgs/role/gardener` ping on append. Reconciling the two surfaces is a separate decision, not part of this port.
- The audit also recommends authoring a canonical `self-healing-wrapper` skill (still ❌ in both v1 and v2) — out of scope for this job but the remaining named gap from `self-healing-audit.md` Part A.
