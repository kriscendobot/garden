Work complete and pushed to `origin/main2` (4f03967fa). My inbox was empty; the worktree is torn down.

## Completion report

**Job:** Encode kriskowal's 2026-06-28 directive — issue/PR-scoped agents communicate with the maintainer via comments only; restrict (and information-hide) the maintainer inbox to free-standing roles.

### What I did

**A. COMMON.md — the standing, inbox-free rule.** Added `roles/COMMON.md` § *Communicating with the maintainer*: when work is scoped to an issue/PR, every maintainer reply goes on that issue/PR as a comment — inline on the specific code/design-doc line (`pr-review-thread-replies`) plus one top-level summary (`pr-completion-summary-comment`), reconciled with the existing completion-summary norm. It states the rule **without naming or hinting at the inbox**, and explicitly carves out the inter-agent message bus as a separate, unaffected facility (§ C).

**B. Per-role classification (the deliverable).** Read every role and juror:
- **Free-standing (may reference the inbox):** liaison, proxy, foreman, gardener, watchman, triager, journalist, librarian, scholar, researcher, monitor, mentor.
- **Issue/PR-scoped (comment-only, must be inbox-free):** appellate, assayer, barrister, boatman, botanist, builder, cleaner, conductor, designer, fixer, judge, justice, shepherd, solicitor, weaver, and all jurors.

Only two scoped surfaces actually leaked, and I scrubbed both:
- **`roles/boatman/AGENT.md`** — removed every maintainer-inbox reference (boatman is PR-scoped), dropped its `message-bus` skill ref (its only use was the maintainer channel), and rerouted all blocked/conflict paths to the job's blocked **completion report**.
- **`skills/pr-creation-flow/SKILL.md`** — the missing-case escalation now routes over the inter-agent bus (`role/gardener` or `broadcast`), not the inbox (this skill is linked by PR-scoped jurors).

**C/D. Channel separation + skills audit.** Left the inter-agent bus (role inboxes, `inbox-send.sh`, `send-msg.sh`, broadcast) untouched. After the boatman fix, every inbox-documenting skill (`message-bus`, `at-mention-surveillance`, `activity-feed-watcher`, `self-healing-wrapper`) is referenced only by free-standing roles. Confirmed `issue-inbox` routes to the issue thread (unchanged).

**Verification gate.** New `scripts/checks/maintainer-inbox-information-hiding/` (check.sh + prompt.md + README, registered in the runner index). It fires if (1) a scoped role file carries an inbox token, (2) a skill a scoped role *loads* carries one (catches exposure even via an allowlisted skill), or (3) the token-bearing file set under `roles/`+`skills/` ≠ the free-standing allowlist (machine-enforces the "equals the audited set" property; widening requires editing the allowlist in-commit). Test suite `tests/checks/test_maintainer_inbox_information_hiding.sh` passes **10/10**, including the authoritative real-tree-clean assertion. All 3 gates clean on `--dry-run`; the double-space gate does not fire on my added prose.

### Follow-ups / notes
- `tests/checks/test_run_all.sh` reports 2 failures ("non-dry firing did not invoke claude") — **pre-existing**, confirmed identical on the unmodified deployed root; it's a `claude`-stub/PATH issue in this sandbox, unrelated to this change.
- The change is on `origin/main2`; it reaches the deployed root via the normal deliberate-deploy path, not by me.
- The `designs/` mentions of the inbox (job-board, issue-inbox, inbox-discipline-audit, self-healing-audit) are reference docs, not agent-loaded instructions, so they're intentionally out of the gate's scope.

Self-improvement: nothing this time.
