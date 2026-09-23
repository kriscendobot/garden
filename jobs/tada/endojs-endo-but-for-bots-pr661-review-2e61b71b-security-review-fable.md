Inbox empty. The security review is complete.

## Completion report

**Job:** Security review of `endojs/endo-but-for-bots` PR #661 (`provideHttpClient` + `makeHttpTool`, daemon-agent-tools Phase 3.6), requested by maintainer review 4701009228. First serial stage — did **not** run the gauntlet.

**What I did:**
- Set up an isolated project worktree on the PR head (`790d802`) and read the full diff plus the confinement core it builds on (`@endo/http-confine`, `@endo/exo-http-client`), the daemon wiring (`host.js`, `daemon.js`, `formula-record.js`, `interfaces.js`, `types.d.ts`), and the agent-tool adapter (`http-tool.js`, `tool.js`).
- Installed deps (`corepack yarn install --immutable`) and ran the three affected suites: `@endo/agent-tools` http-tool (10), `@endo/daemon` http-client (13), `@endo/exo-http-client` (35) — **58 tests green**. Ran `tsc` for all three packages — **clean**.
- Wrote a throwaway probe to verify the sharpest edge empirically: a `tofu-auto` client with an empty allowlist reaches an arbitrary origin (cloud-metadata `169.254.169.254`) on first contact, while the default `strict` client blocks it.

**Findings:** No exploitable defect introduced by this PR. Confinement is correctly delegated to the merged core (CRLF/header-injection blocking, forbidden-header blocklist, manual-redirect re-check, rate budget consumed only after the strict origin check, byte cap, timeout, revocation). The control/client split holds — the guest-facing `HttpClient` has no policy mutators, so an agent cannot widen its own allowlist in strict mode. `normalizeHttpClientPolicy` correctly rejects malformed policies up front and refuses the authority-bearing TOFU modes.

Recorded four by-design observations (none blocking) in a PR review comment: (1) `tofu-auto` is effectively unrestricted egress — confinement holds only in `strict` mode; recommend agent-facing provisioning default to strict + explicit allowlist; (2) allowlist-by-hostname leaves DNS-rebinding/SSRF-to-internal reachable even in strict, inherent to the #566 core; (3) response headers incl. `set-cookie` are surfaced to the agent (data exposure from an allowed origin, not a confinement break); (4) `getHttpClientControl` recovers control from any daemon-minted client cap, mirroring the established `getGitRemoteController` pattern.

**What changed:** No source changes — the PR is sound, so I did not fabricate a fix or add tests. Posted a security-review comment: https://github.com/endojs/endo-but-for-bots/pull/661#issuecomment-4977145257. Worktree left clean.

**Follow-ups:** The next serial stage (gauntlet run) can proceed. No security blocker. If the deployment cares about link-local/private-range SSRF, an IP-level deny would need to live in the `@endo/http-confine` core (out of scope for this wiring PR).
