I answered kriskowal's question on endojs/endo-but-for-bots PR #1336 with a threaded reply. The question was "Please explain these dependencies" on `packages/agent-mcp-stdio/bin/endo-mcp-stdio.js:20`, and "rsvp" asked for a written answer. The reply is at https://github.com/endojs/endo-but-for-bots/pull/1336#discussion_r4101304064.

**Preflight:** it exited 2, but that was a false hint. The only thing citing feedback id 4101294934 was the watcher's own "On it — I've posted a job" acknowledgment, not an answer, so I did the work.

**What the reply explains:** the bin script is the only place that reads `process`/`os`. It passes those values into `main` so `src/main.js` has no ambient authority, and the tests inject fakes in `test/server.test.js`. Each input's use:
- **`env`** carries `ENDO_GUEST_FORMULA_ID`, which names the one guest this server serves. The same `env` also goes to `@endo/where`'s `whereEndoSock`, which honors `ENDO_SOCK`, `XDG_RUNTIME_DIR`, `USER`/`USERNAME`, `HOME` and `TMPDIR`.
- **`platform`** only selects the socket style inside `whereEndoSock` (named pipe on Windows, `Library/Application Support` on macOS, otherwise the XDG or temp-dir socket).
- **`info: { user, home, temp }`** is `whereEndoSock`'s fallback when those variables are unset. The CLI builds the same object in `packages/cli/src/context.js`, so both find the same daemon. `temp` is `@endo/where`'s field name, which is why the `spell-out-exempt` comment is there.
- **`stdin`/`stdout`/`stderr`** carry the MCP frames and the one-JSON-per-line diagnostics.
- **`version`** comes from `package.json` and becomes the MCP `serverInfo.version`. I checked this against `server.js:184`; the other claims were checked against the source before posting.

The reply also offers a follow-up: the bin script could work out the socket path itself and pass only `sockPath` and `formulaId` to `main`, which would narrow what `main` receives. I posted nothing for it and will only do it if kriskowal asks.

No code or garden changes were made.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1336-131bf767.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 26 tokens (651490 cached reads)
- Output: 4517 tokens
- Cost: $0.6155579999999998
- Wall-clock: 76s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
