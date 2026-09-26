# Gauntlet fix round 2: kriscendobot/minion.town#119

I applied the round-2 panel's must-fix items and pushed them as one commit, `793c89a`. CI is green. The `test` job failed once on the known live-daemon B1 restart flake (`endo-daemon-integration.test.ts`, the step that restarts the daemon and reads back). That failure is outside the changed Claude files, so I re-ran it and it passed. Typecheck is clean, and the full local suite passes (516 passed, 7 skipped).

**What changed** (in `src/endo/claude/{agents,reauth,wiring,classify}.ts` and `test/claude-reauth.test.ts`):
- **assessor:** `infer()` now returns its classified outcome even if the credential store fails during the bookkeeping afterward (the `revoke()` call). Before, that failure made `infer()` reject.
- **saboteur, breaker:** an inference that started before the root replaced the credential now skips all host bookkeeping, not just the `credential-invalid` case. If such a stale inference comes back `needs-auth`, the caller now gets `unavailable` and retries, instead of parking for a wake-up that never comes.
- **breaker:** a `needs-auth` report now ends a run of unclassified outcomes, so no diagnostic notice can contradict an open reauth notice.
- **purist:** when a usage or unclassified condition clears, its queued notice is removed from the outbox, the same way the reauth notice already was.
- **locksmith:** `reauthFor()` now returns a read-only view (`status`, `tick`, `idle`) instead of the full tracker, which could change state.
- **wire-watcher:** a pinned response shape with an empty `match` no longer matches every response. A comment now links the two halves of the stale-credential check (`handleSetupToken` in `wiring.ts` and the guard in `agents.ts`).
- **duality-auditor:** renamed `reconnected()` to `rootReconnected()` so it pairs with `rootDisconnected()`.
- **saboteur (should-fix):** a corrupt reauth state file now names its path in the error.
- **migrator, wire-watcher:** six new tests, most going through `infer()` and the deployment rather than calling the tracker directly. All six fail against the previous head, `d9b3111`.
- **scribe:** posted a summary comment covering fix rounds 1 and 2 (https://github.com/kriscendobot/minion.town/pull/119#issuecomment-5843948648).

**Left for the next panel or the maintainer** (all comment-only or should-fix, and listed in the PR comment):
- locksmith: take the webhook secret out of `config`.
- saboteur: round `resetAt` before comparing when deduplicating notices.
- purist: `usage.since` is stored but never read.
- duality-auditor: the `enqueue`/`dropNotices` naming.
- Move the `ctx` → `context` rename into its own change.
- The stale `neverReject` doc references already existed before this PR and are unchanged.

I did not re-run the panel; the driver posts panel round 3.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr119-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 50 tokens (2229922 cached reads)
- Output: 16926 tokens
- Cost: $1.6244964000000002
- Wall-clock: 631s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
