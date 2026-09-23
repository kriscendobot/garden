Everything has landed and verified. The job is complete.

## Completion report

**Built:** a GitHub-wide `@kriscendobot` mention watcher gated on a deterministic, no-LLM sender-trust check, modeled on `comment-watcher.sh`. Committed to `origin/main2` at **SHA `5ee69791`** (bot identity, from an isolated worktree off `origin/main2`, rebased cleanly onto the latest tip before push).

**What changed (main2):**
- `scripts/jobs/mention-watcher.sh` — single-instance watcher. Per tick: poll GitHub-wide mentions since a durable journal cursor (`mentions/kriscendobot`) → **sender-trust gate (first, plain code, no LLM)** → verb-map deterministically → reactji-acknowledge as the bot → post job → verify it landed on `origin/journal2` before advancing the cursor. Invokes **no `claude` at all** — the only judgement is the trust gate and the fixed verb table.
- `scripts/jobs/handlers/mention-source-gh.sh` — notifications (`reason==mention`) + `search/issues?q=mentions:` source.
- `scripts/jobs/handlers/mention-trust-gh.sh` — read-only `gh api orgs/{endojs,Agoric}/members/<login>` (204 = member) with a brief on-disk cache.
- `scripts/jobs/handlers/mention-reactji-gh.sh` — surface-aware 👀 ack as the bot (honors `GARDEN_BOT_GH_TOKEN` if set).
- `scripts/systemd/garden-mention-watcher.{service,timer}` — single instance (not per-repo); registered + enabled + summary-lined in `install-units.sh`.
- `scripts/jobs/test/mention-watcher-test.sh` — 5 cases, **16/16 pass**; `bash -n` clean and `shellcheck` at the same baseline as the existing scripts (zero error-severity findings).
- `roles/triager/AGENT.md` + `CLAUDE.md` § Monitoring safety — document the sender-gate rationale as a maintainer-authorized, sender-gated exception to repo-gating.

**Maintainer authorization (journal2):** recorded a `message` entry (`entries/2026/06/24/223601Z-message-mentor-269acb.md`) per CLAUDE.md § Monitoring safety constraint, plus the allowlist as extensible journal data at `trusted-senders/allowlist`.

**Resolved allowlist:** `kriskowal`, `erights`, `gibson42`, `kumavis`, `0xpatrickdev`, **`mhofman`** (mathieu → Mathieu Hofman, confirmed via `gh api users/mhofman`).

**Gate drop behavior (tested):** a mention is triaged only if the author is allowlisted **or** a current endojs/Agoric org member; **any other sender's mention is logged and discarded** — the test proves it produces no job, no reactji, and **never reaches the post/triage handler**, while the cursor still slides past it (no re-poll loop). Verifying Agoric membership is a read-only trust check and does **not** authorize agoric-sdk work.

**Follow-up (not blocking):** the unit is registered and wired into `install-units.sh enable-services` + the summary line, but I did not run `systemctl enable --now` this session — bringing up a live GitHub-wide monitor is the deliberate operator bring-up step (`install-units.sh enable-services`). It will start on the next bring-up; flagging it since actually arming a live monitor is a monitoring-safety action I left to an explicit run rather than triggering from inside this job.
