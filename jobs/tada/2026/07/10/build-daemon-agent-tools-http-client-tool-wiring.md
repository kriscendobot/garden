The work is complete. Draft PR #661 is open against `llm` (20 files, +1017/-7), inbox is empty. Let me write the completion report.

The job is done: I built the daemon-side confined-outbound-HTTP agent tool wiring per `designs/daemon-agent-tools.md` Phase 3.6, with tests passing, type-checks clean, and a draft PR opened.

---

## Completion report — `build-daemon-agent-tools-http-client-tool-wiring`

**Outcome: built and delivered as draft PR [endojs/endo-but-for-bots#661](https://github.com/endojs/endo-but-for-bots/pull/661)** (base `llm`, draft, 20 files, +1017/−7). Advances M3's "confined outbound HTTP" exit criterion — Phase 3.6 of `designs/daemon-agent-tools.md`.

### What I built

`#566` had already landed the `@endo/exo-http-client` / `@endo/http-confine` capability pair; the remaining delta was the daemon provisioning + the agent-tool binding. I wired both:

**`@endo/daemon`**
- New **`http-client` formula type + maker**. It derives from no mount — the Network tier is the deliberate exception to "everything derives from the mount," rooted in a **host-owned `fetch` (and `now`) seam** injected in the daemon process (mirroring how the shell maker injects its host spawner). Policy is formula-owned and reconstitutes identically across restart.
- **`host.provideHttpClient(petName, policy)`** mints the client/control pair, binds only the use-facing `HttpClient` into the guest petstore, and retains the policy-bearing `HttpClientControl` host-side — the same control/client split as git-remote. **`host.getHttpClientControl(clientCap)`** recovers the control via a host-private companion map (mirrors `getGitRemoteController`).
- **`normalizeHttpClientPolicy`** validates the allowlist/limits and restricts `policyMode` to the formula-honorable modes (`strict`/`tofu-auto`), refusing the authority-bearing tofu modes rather than silently degrading.
- Registered across all sites: `formula-type`, dependency graph, reincarnation maker, `formula-record` inspector, `EndoHost` interface guard, and `types.d.ts`.

**`@endo/agent-tools`** — **`makeHttpTool(httpCap)`** emits `fetch` and `allowedOrigins` `ToolRecord`s. Input args are guard-pinned against `HttpClientInterface` by the divergence gate; `fetch` bridges its live `HttpResponse` remotable to a JSON-safe `{ status, statusText, ok, url, headers, truncated, body }` record (the same wire↔cap divergence `makeGitMountTools` spans).

**`@endo/exo-http-client`** — exported the interface guards (`HttpClientInterface`, `HttpClientControlInterface`, `HttpResponseInterface`, `FetchOptionsShape`) so the tool adapter pins its schema against the guards the exo enforces.

### Verification
- **New tests all green**: daemon composition test (9 — allowlist enforce/refuse, inspect-without-seam-leak, revoke, byte-cap truncation, rate limit, policy normalization) and agent-tools tests (9 — divergence gate + response bridging).
- **Regression-clean**: `@endo/exo-http-client` (32) and full `@endo/agent-tools` (100) suites pass; `tsc` clean on all three packages; eslint 0 errors on authored files.
- The two `shell.test.js` failures observed are pre-existing **sandbox `EACCES`** on spawning written executables (this environment blocks exec of `/tmp` scripts) — unrelated to this change, which never touches shell exec.
- yarn.lock landed as a separate `chore: Update yarn.lock` commit (net diff: the new workspace-dep edges only).

### Follow-ups (out of scope, noted in the PR)
- **Phase 3.6 first bullet** — reconciling #286's in-flight CLI-facing `makeHttpClient` daemon formula onto this shared core, and the open question of whether `provideHttpClient` and `makeHttpClient` become one host method. This PR builds the agent-tools path directly on the merged capability instead.
- Phase 3 push tier (`makeGitRemoteTool`) and Phase 2c sandbox shell engine remain.
