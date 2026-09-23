## Stage 2 (minion.town account locator and deployment wiring): draft PR ready, not activated

The minion.town changes are in draft PR https://github.com/kriscendobot/minion.town/pull/117. It is one commit, `79ff6ec`, on branch `build/guest-locator-federation`, against the frozen base `main-3062124`. Nothing was deployed and no port was opened. Activation is blocked by a serious security problem in Endo #1333, described below.

**Security blocker for activation.** Endo #1333 says to install the OCapN network on the account daemon. Once that is done, any peer holding a locator also has the daemon's designator, because it is inside the locator's hint. That peer can reach the one shared gateway through `endo-peer-entry` → `getGreeter().hello()`:
- `followRetentionSet(node)` runs `SELECT number FROM formula WHERE node = ?` on a node the caller chooses, with no check against the caller, so it lists every formula on the daemon.
- `provide(id)` then returns any of them, including the top host and every other account's guest.

Signup is open, so any account holder could take over the account daemon. The `endo adopt-locator` path depends on this same handshake, so removing it is not a fix. I sent this to you through the liaison, commented on #1332 (https://github.com/endojs/endo-but-for-bots/pull/1332#issuecomment-5803339422), and posted the builder job `endo-ocapn-gateway-session-binding-build` (draft PR only). That job covers this fix and a second gap: the Endo OCapN network advertises its bind address, so on a server listening on `0.0.0.0` it would hand out an address nobody can dial.

**Live box (read-only SSM, no secrets read):**
- The account daemon runs pin `f665050`, has only the `loop` network, and no TCP listener.
- The demo containers are separate from the account daemon: 8931 (behind `/.well-known/ocapn-cbor-np`), 8930, and 8929 open to the internet.
- The security group allows 80, 443, 3469 and 8929.
- The Caddy containment file for the demo routes is currently disabled.

**What the PR changes:**
- **New route `GET /account/guest-locator`.**
  - It has the same checks as the existing identifier route: gate secret, verified `iss`+`sub`, `mcp/guest` admission (suspended accounts are denied), `no-store`, and no guest selector.
  - The daemon writes the locator. The town then keeps only hints for routes listed in `ENDO_FEDERATION_ROUTES` that name the hosting daemon, checking the dial target inside each hint too. It refuses a locator for any formula other than the caller's guest.
  - Without that setting the route answers 404. `/account/guest-formula-id` is unchanged.
- **Browser:** the landing page and the shell overlay get a locator field with a Copy button. The instructions use `endo adopt-locator minion-town` with the locator on stdin, so it stays out of URLs and shell history, and they say that signing out does not revoke a copied locator.
- **Caddy:** one matcher routes both reveal routes. It passed `caddy adapt` on the box against a temporary file; the running config was not touched.
- **`deploy-endo-federation.sh` (preflight / enable / status / disable)** plus a box-side script.
  - Enable installs Endo's stock OCapN network on the account daemon (tcp/8940, advertised as `minion.town:8940`), adds a `minion-mcp` drop-in, and opens the port.
  - The preflight refuses unless both pins are merged on `llm`, the pinned code supports formula fetch and an advertised address, and a merged gateway-fix commit is named.
  - Disable reverses it, app first.
  - This script is not in CD.
- **`deploy-endo-daemon.sh`:**
  - refuses pins that are not merged on `llm`;
  - on a pin change, snapshots the state and dry-runs the new code against a copy, which catches the #111 kind of startup failure;
  - rolls back automatically if the health check fails after the swap.
  - The new `rollback-endo-daemon.sh` is the manual path.
- **`DEPLOYMENT.md`** gains a federation section: topology, preconditions, deploy sequence, rollback, candidate pins and evidence. It also corrects an old claim that the raw identifier could be redeemed over the public route; that route is served by the demo container, not the account daemon.

**Served routes:** only CBOR + Noise over raw TCP. WSS needs Endo #684, and nothing here advertises it. Candidate pin for evidence only: #1333 head `11e726e7b1`. The pins stay at `f665050`.

**Tests (run locally):**
- `npm test`: 449 passed, 6 skipped. `tsc` is clean.
- **Real-daemon integration test** (`ENDO_CHECKOUT` pointing at a #1333 build), passed 3 of 3 runs:
  - The town endpoint issues Alice's locator, and Bob gets a different one.
  - `endo adopt-locator` on a second daemon succeeds.
  - `endo list` and a text read over OCapN then show a value the town wrote.
- **Headless Chromium on the real `index.html` and `shell.html`**, with the routes stubbed:
  - the section shows the exact locator, the Copy button puts it on the clipboard, and the instructions render;
  - the section stays hidden when the route returns 404.
- **Box script run locally against a real daemon:** it refused the #1333 code (no advertised-address support), then enable, re-enable (no change), status and disable all worked.
- **Driver preflight:** it refused the current pin (no OCapN network) and the #1333 draft SHA (not on `llm`).
- **Not tested:** the snapshot, dry-run and rollback steps in the daemon deploy scripts need systemd and the box, so they have only passed syntax checks and shellcheck.
- **Existing flaky test:** "B2 tool layer" in `test/endo-daemon-integration.test.ts` fails intermittently against the #1333 daemon on unchanged `main` too (2 of 4 runs).

**Still needed before activation (the release gate):**
1. The gateway fix and the advertised-address setting, from `endo-ocapn-gateway-session-binding-build`.
2. Endo #1124 and #1333 merged on `llm`, then both pins moved together through a reviewed PR.
3. Your answers to authority questions (1) and (3) on #1332.
4. Review of #117. It stays a draft, and I did not start a gauntlet.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endo-minion-town-federation-town-build.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 212 tokens (17919566 cached reads)
- Output: 98459 tokens
- Cost: $7.646693199999999
- Wall-clock: 1185s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
