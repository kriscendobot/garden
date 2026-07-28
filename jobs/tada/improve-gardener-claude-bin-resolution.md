Landed on `main2` as `e89290ff87`.

## Completion report — improve-gardener-claude-bin-resolution

**What I did.** Replaced the single-probe `command -v claude || die` shape across the fleet with a shared, retrying resolver, and taught the spine that a missing CLI is an *environmental* failure rather than a defect in the job that happened to be claimed.

**`scripts/jobs/common.sh` § agent-CLI resolution (new)**
- `agent_bin_probe <name>` — resolution order: explicit `GARDEN_<NAME>_BIN` override (**fail-closed**: an unrunnable override refuses to fall back to some other binary) → **PATH first** (so every test's PATH-injected stub keeps working) → known install locations: `/usr/local/bin` (the image's npm -g prefix), `/usr/bin`, `~/.local/bin`, `~/.claude/local`, `$NVM_BIN`, `~/.npm-global/bin`, `~/.node/bin`, `~/bin`. Uses no external command (built-in case conversion, not `printf | tr`), so it resolves even when PATH is broken outright.
- `agent_bin` — bounded retry (`GARDEN_AGENT_BIN_ATTEMPTS=5` × `GARDEN_AGENT_BIN_SLEEP=3`) over the npm-relink window; `claude_bin` / `claude_bin_now` wrap it.
- `die_environmental` — exits `GARDEN_ENV_RC` (EX_TEMPFAIL 75, the same code `GARDEN_OFFLINE_RC` uses; an offline tick is one species of environmental failure), still writing its diagnostic to the capture.
- `is_environmental_rc` — the third capture-content-independent transient class beside `is_external_kill_rc` / `is_handler_timeout_rc`.
- PATH normalization: **appends** the image's declared tool dirs when missing.

**`scripts/jobs/gardener.sh`** — classifies the environmental rc transient *before* the empty/non-empty capture split (die_environmental deliberately writes output, so a content-gated branch would miss it), and excludes it from both elapsed-constancy escalation gates (an environmental failure dies fast at a near-constant elapsed and would otherwise read as an "overrun suspect"). Timer-driven handlers get this for free: `self-heal-run.sh` already normalizes EX_TEMPFAIL to a clean exit, so no self-heal responder is burned.

**Handlers routed through the resolver** — hard failures via `die_environmental`: `gardener`, `triager`, `watchman`, `bulletin`, `proxy`, `follow-up`, `mentor` (the last two keep their explicit `GARDEN_*_CLAUDE` stub injection authoritative). Soft skips via a single probe: `foreman`, `self-heal`, `banner-sweep`, `catch-all-swallow`, `portability-coupling`, plus `meter_claude` in `usage-meter.sh`.

**On the systemd PATH pin:** I deliberately did *not* pin `Environment=PATH` on the worker unit. An absolute unit-level pin would silently *narrow* PATH on any host whose session legitimately carries something else (nvm node, `~/.cargo/bin`, `/snap/bin`) and break the very builds the fleet runs; the append-if-missing in `common.sh` declares the same dirs, can only add, covers every entry point that sources it, and needs no unit re-render or deploy.

**Tests.** New `scripts/jobs/test/claude-bin-resolver-test.sh` — 27/27 pass. Covers resolution order, the fail-closed override, empty-PATH resolution, the bounded retry over a momentary absence (deterministic, file-counter probe stub), the classifier, that `cli="$(claude_bin)" || die_environmental` actually exits the *handler* (the exit-inside-a-subshell pitfall), and an integration run of the real `gardener.sh`: rc=75 with non-empty output → transient, no inbox escalation, left in doin. It probes for an exec-allowed temp base because `[ -x ]` honors the sandbox's noexec `/tmp`.

Regression runs, all clean: `gardener-worktree`, `empty-output-classifier`, `signal-kill-classifier`, `triager-claude-handler`, `foreman-provider-order`, `log-syslog-prefix`, `quota-panel`, `hermit-ollama-self-heal`, `handler-budget`. Three suites (`run-test.sh`, `claude-session-limit-classifier`, `elapsed-constancy-classifier`) have failures — I verified each against a pristine `origin/main2` copy and the failure sets are **byte-identical**, so they are pre-existing, not from this change.

**Follow-ups (left undone, deliberately).**
1. `scripts/jobs/gardening/seat-gate-coverage-auditor.sh:89` and `scripts/checks/run-all.sh:174` still use a bare `command -v claude`. Neither sources `common.sh`, and adding that source to a per-seat panel gate is a behavioral change beyond this job's scope. Both are soft-skip paths, so the cost is a *silent* degradation (the coverage-auditor seat quietly falls back to its deterministic block) rather than a failure.
2. Pre-existing failures in the three suites above are worth their own job.
3. `git gc` in the shared root repo is logging `fatal: unable to read 9ad05cc3563a7ba4b8f3a0b3e7941090e4d427d6 / failed to run repack`, and a stale `gc.log` is suppressing automatic cleanup. Unrelated to this change, but it is a repo-health signal on the host that shares its object store with the journal.
