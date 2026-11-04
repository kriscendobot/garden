---
posted_at: 2026-11-04T00:22:06Z
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# minion.town: poll the mailbox assertion in the guest-pinned responder restart test

Repo: `kriscendobot/minion.town`. Tracker: https://github.com/kriscendobot/garden/issues/58.

`test/endo-daemon-integration.test.ts`, "reincarnates a guest-pinned Claude inbox responder
after restart", polls for the effect and then asserts once that the message is gone.
`src/endo/claude/inbox-responder-caplet.ts` writes the effect first and dismisses afterward,
so the single check can land between the two and fail with `expected true to be false`.

Seen on PR #234 (run 41613557847) and on `main` at `9196892` (run 41729564029; attempt 1 failed, attempt 2 passed).
The failure also skips the later guest-web daemon step in the same job, so a red run hides
that coverage.

Change only the test: poll the mailbox assertion with a bounded deadline, as the effect wait
above it already does. Do not add a sleep, a retry of the whole test, or a change to the
caplet's write-then-dismiss order. Open a draft PR; the gauntlet follows automatically.

---
claim:
  host: oros-studio-garden-ce242c49
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-11-04T00:29:29Z
