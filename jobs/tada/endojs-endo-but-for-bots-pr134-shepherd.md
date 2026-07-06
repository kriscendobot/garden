Inbox empty. CI is fully green on the PR head — the shepherd's definition of done is met.

## Completion report

**Job:** shepherd PR #134 (`endojs/endo-but-for-bots`, `feat/docker-selfhost` → `llm`) — auto-dispatched on red CI.

**Starting state:** One failing check, `build-and-smoke` (the Docker self-host image build + outside-the-container smoke test, both introduced by this PR). All other checks green.

**Two root causes, two atomic fixes — verified locally, then confirmed green in CI:**

1. **`docker/Dockerfile` — addon staging couldn't find better-sqlite3.** The `RUN node -e "…require.resolve('better-sqlite3')…"` step failed with `Cannot find module 'better-sqlite3'`. Under the workspace's pnpm linker, better-sqlite3 is a dependency of `@endo/daemon`, not the `/build` root, so it isn't resolvable from the root. Fix: anchor the resolve at `packages/daemon` (`require.resolve('better-sqlite3', { paths: ['/build/packages/daemon'] })`). Commit `8fe33e833`.

2. **`packages/familiar/scripts/bundle.mjs` — daemon crashed at container startup.** After fix #1 the image built, but the container exited before the gateway answered (and `--rm` discarded the logs, so CI showed only `No such container`). I reproduced the crash locally by building the bundles and running `endo-daemon.mjs` with the entrypoint's args/env: `ReferenceError: __filename is not defined`. The `bindings` package (better-sqlite3's native-addon locator) references the CJS-only `__filename`/`__dirname`, which esbuild leaves undefined in ESM output. The bundle banner already shimmed `require` via `createRequire`; I extended it to also define `__filename`/`__dirname` from `import.meta.url` (the standard esbuild ESM shim). Commit `155307e7d`.

**Local end-to-end verification** (staging the exact runtime layout the Dockerfile produces — `bundles/` + `better_sqlite3.node` under `build/Release/` + `bundles/package.json` — and running the daemon with the container's args/env): daemon boots, `GET /` → `Endo Gateway`, WebSocket upgrade → `101`, process stays running — the three `build-and-smoke` assertions. (A `/tmp` noexec mount initially masked the addon load with `failed to map segment`; re-running off an exec-capable filesystem cleared it — an environment artifact, not a code issue.)

**Final CI state:** All **25 checks green** on head `155307e7d00848c294ad2051e7513621e8d69728`, including `build-and-smoke` and the full test matrix (no regression from the bundler change).

**No comment posted** — the job body carried no per-action comment authorization, and no standing authorization covers a summary comment here.

**Follow-ups:** none. `next: none` (CI green).
