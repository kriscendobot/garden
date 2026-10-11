I added the three resource caps on git-remote pushes and opened them as draft PR [kriscendobot/minion.town#178](https://github.com/kriscendobot/minion.town/pull/178). CI is green: `test` and both Claude harness legs pass.

Every refusal leaves the repository's refs unchanged, and stock git prints the reason as a normal git error. When a refusal comes before the upload starts, the pusher sees `remote error: …`. When it comes after, they see `! [remote rejected] main -> main (…)`.

| Cap | Env var (default) | How it's enforced |
| --- | --- | --- |
| Push size | `GIT_REMOTE_MAX_PUSH_BYTES` (100 MiB) | A declared size over the cap is refused before git starts. A streamed push is counted and stopped once it passes the cap. Git's own `receive.maxInputSize` stops a compressed push from expanding past it. |
| Partition size | `GIT_REMOTE_MAX_PARTITION_BYTES` (1 GiB) | The repository is measured before each push, and a full one refuses pushes. Otherwise a push may only use the space left, minus what other pushes in progress have reserved. |
| Push rate | `GIT_REMOTE_PUSH_RATE_LIMIT` (60) per `GIT_REMOTE_PUSH_RATE_WINDOW_SECONDS` (3600) | Counted per partition over a sliding window, held in memory, so it resets when the process restarts. |

- **Config:** a cap value that isn't a positive integer stops the process at startup, so a typo can't silently loosen a cap. The systemd unit is unchanged, so production will run on the defaults above.
- **Refusal on a compressed push:** when the push body is gzipped and the router can't read which branches it names, the refusal is a plain HTTP 413, 429 or 507 instead of the git-style message.
- **New code:** the caps live in a new `src/endo/git-remote/limits.ts`, wired into `git-backend.ts`, `git-http.ts`, `config.ts`, `app.ts` and `main.ts`.
- **Tests:** `test/git-remote/git-remote-limits.test.ts` has 16 tests covering every refusal, using the real git client wherever it can trigger one. It passed three runs in a row locally. As a mutation check, I disabled `receive.maxInputSize` and three of those tests failed, so they really exercise it. Config tests now cover defaults, overrides and bad values.
- **Docs:** deferred item 3 in `designs/git-remote-capability-increment-1.md` now describes the caps, along with that file's environment table and test list. `DEPLOYMENT.md` § Git remote gets a new environment table.
- **Local test failures:** I can't run 13 of the existing tests cleanly here. The partition-script and SSM-helper tests need to execute scripts from `/tmp`, which this host doesn't allow. One projection test fails because of where the temp directory sits on this host. All of them pass in CI.

Follow-ups:
- With no cleanup of old git data yet (deferred item 4), a full partition stays full until an operator steps in. The design doc says so.
- The design's per-file size, object count and folder depth limits aren't capped separately. The push-size cap bounds them in total.
- Metering and billing stay with #174.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-git-remote-push-caps.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 72 tokens (3770732 cached reads)
- Output: 48010 tokens
- Cost: $2.7311064000000003
- Wall-clock: 1422s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
