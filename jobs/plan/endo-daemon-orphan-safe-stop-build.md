---
gate: awaiting-maintainer
maintainer_question: 'Design OQ2: should run-daemon run the manager in-process, or keep the child process and forward signals?'
asked_at: https://github.com/endojs/endo-but-for-bots/pull/1383
priority: normal
posted_by: producer
posted_at: 2026-09-29T22:47:57Z
---

---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Endo daemon: orphan-safe run-daemon/workers + complete stop (phase 3)

Repo: endojs/endo-but-for-bots, base `llm` (DRAFT PR). Design: https://github.com/endojs/endo-but-for-bots/pull/1383 (designs/daemon-lifecycle-idempotency.md). Motivation: kriscendobot/minion.town#130 and #137 deploy workarounds.

Implement §§ 4–5. Enable the shutdown-signals.js orphan watch by default for workers, and for the manager when it is launched by `run-daemon` (keep the env override). Make `run-daemon` forward SIGTERM and SIGINT to its child, or run the manager in-process per the answer to design OQ2. `stop` also finds the daemon through the lock-marker pid, prints "stopped pid N" or "not running", exits 0 in both cases, and exits non-zero only if a process survives SIGKILL. Tests: SIGKILL the manager and assert its workers exit; `stop` twice exits 0 both times.

<!-- garden-annotation: key=mt117-cite by=deadmail-20260929T225705Z-deb454 at=2026-09-29T23:08:51Z -->

Also cite kriscendobot/minion.town#117 (kriskowal review note asking for idempotent daemon start/stop), alongside kriscendobot/minion.town#130 and kriscendobot/minion.town#137, in the PR body and commit message. Required coverage, restated from that ask: `endo stop` finds and reaps ALL recorded workers (not just the manager), is a no-op that exits 0 when nothing runs, and uses supervisor-reliable exit codes (non-zero only when a process survives SIGKILL). (Carried from dead-lettered message, job deadmail-20260929T225705Z-deb454.)
