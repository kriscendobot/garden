Inbox empty. The work is complete, verified, and landed on `main2`.

## Completion report

**Job:** Harden `scripts/jobs/reaper.sh` so a poison-job alert is never silently dropped when the maintainer inbox is unreachable.

**Problem.** Both poison-alert paths (`reaper.sh:647-649` and `660-662`) piped into `poison-notice.sh` with `>/dev/null 2>&1` and, on failure, only logged a bare `WARNING: could not surface …` before falling through and `break`ing out of the requeue loop — permanently dropping the alert. The poison job stayed parked in `plan/` (held) but the maintainer was never told, so a deterministically-overrunning job (e.g. the `xs2rust-…-boot-surface-remainder` tail) silently vanished from human view.

**What I changed** (`scripts/jobs/reaper.sh`):
- **(a) Diagnosable failures** — new `surface_poison()` captures `poison-notice.sh`'s stderr and names the cause (the FATAL die line, falling back to the last non-blank line, with the `<N>` journald prefix stripped) in the WARNING, so a push race / unreachable clone / bad key is now legible instead of opaque.
- **(b) No permanent swallow** — on failure it writes the notice to a **durable spool** (`GARDEN_POISON_SPOOL`, default `$GARDEN_STATE/reaper/poison-spool`), keyed by the same `<base>+<signature>` dedup key `poison-notice.sh` uses (idempotent re-spool). `drain_poison_spool()` runs at the **top of every tick — before the no-stale-claims early exit** — re-attempting each spooled notice, so a transient inbox-unreachable window heals on a later tick. A successful delivery clears the spool entry. Body extraction is first-`---`-only, so a notice body that itself contains `---` round-trips intact.
- The two inline poison invocations now build the body into `pbody` and call `surface_poison`.

**Tests** (`scripts/jobs/test/reaper-poison-park-test.sh`): added **SUBTEST 4 (SPOOL)** and **SUBTEST 5 (DRAIN)** using a pre-receive hook that rejects `inbox/maintainer/` pushes while accepting the reap batch — proving the reap still lands, the alert is diagnosed + spooled (not dropped), and the next tick re-drains it once the inbox heals. **7/7 subtests pass**; `reaper-live-handler-guard-test.sh` still passes; `bash -n` + shellcheck clean on new code.

**Landed:** commit `30c56fc77d` pushed to `origin/main2` (first-attempt CAS).

**Follow-ups:** none required. The spool dir self-heals if unwritable (logs a WARNING); `GARDEN_POISON_SPOOL` is overridable if a host wants a different location.
