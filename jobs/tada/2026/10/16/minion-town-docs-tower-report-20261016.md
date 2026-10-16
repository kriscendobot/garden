# Completion report: minion-town-docs-tower-report-20261016

I updated all three pages and pushed them to `main2` in one commit, **`7c326153965`** ("docs(minion-town): guest API, remote invitations, client-daemon recipe"). I could not read the source report. `/home/kris/garden/note-from-tower.md` does not exist on this host (`oros-studio-garden-ce242c49`), so I worked from the claims listed in the job body and checked each one against the code, the live site, and a local daemon run. If the note contains anything the job body leaves out, it is not in these pages.

## What changed
1. **`skills/minion-town-clip-publishing/SKILL.md`**: new section "Publishing is reachable only through the MCP". The HTTP guest API has only these routes: create, inspect, invite, accept-invite and mail. Mail sends text with empty name and identifier arrays, so it cannot carry a capability. A route that publishes without the MCP would need a way for an HTTP guest to send a capability.
2. **`context/operations/minion-town-mcp.md`**: new section "The anonymous guest API (not the MCP)", with a "Remote invitations" subsection. It covers:
   - creating a guest with `POST /api/guest` and the body `{}`;
   - the formula identifier being the bearer credential, with no way to rotate or delete it;
   - `GET /api/guest` echoing the identifier back, plus the fix job `minion-town-guest-state-stop-echoing-formula-identifier-20261016`;
   - remote invitations carrying no connection hints, so they cannot be dialed;
   - accepting one making the acceptor the guest's correspondent, not the holder of its powers.
3. **`skills/minion-town-ocapn-dispatch/SKILL.md`**: new "§ C. Client-daemon recipe" plus the correspondent-not-powers note. The recipe covers:
   - which Endo to use: the endo-but-for-bots `llm` branch, not npm 1.0.3 or upstream `master`;
   - setting `TMPDIR` off the noexec `/tmp`;
   - `yarn workspaces focus --production @endo/cli`;
   - isolated state directories and the 107-byte socket path limit;
   - `endo start`, then the `setup-ocapn.js` step that installs `@nets/ocapn`;
   - `endo accept` reading the locator on stdin;
   - cleanup.

The new text has no em-dashes or Latin shorthand, the GitHub URLs are fully qualified, and the cliché grep found 0 hits. No real identifier, locator or credential is recorded anywhere.

## How each claim was checked
- **Code, on minion.town `main` at `51ad067`:** checked the routes in `src/web/guest-web-router.ts`, the mail send with empty arrays in `guest-web-socket-service.ts`, and `guest.js`.
- **Code, on endo-but-for-bots `llm` at `a7947533c`:** checked stdin reading in `cli/src/commands/accept.js`, the `invite`/`accept` doc comments in `daemon/src/guest.js` (the correspondent claim, and hints coming from the daemon's advertised addresses), the socket-length warning at 104 bytes in `manager-node-powers.js`, and `setup-ocapn.js`.
- **npm:** `@endo/cli` and `@endo/daemon` on `latest` are both `1.0.3`; the fork's packages are private `2.x`.
- **Live production probe** (values never printed):
  - `POST /api/guest {}` answered 201.
  - `GET /api/guest` echoed the bearer.
  - A remote invitation answered 201, with one path component and only the `type`, `from` and `fromNode` query keys, so no hints.
  - `POST /api/guest/publish` answered 404.
- **Local run:** the recipe worked end to end. The focused install, `endo start`, the `@nets/ocapn` setup and `endo list @nets` (showing `loop` and `ocapn`) all succeeded. A local `endo invite` also produced a locator with no hints. I then stopped the daemon and deleted the state.

## Claims I could not verify
- **Correspondent, not powers:** this comes from the Endo code's doc comments only. I could not test it by accepting a remote invitation, because no hintless locator can be dialed.
- **The "107-byte" limit:** this is the Linux `sun_path` fact (108 bytes including the NUL; 103 on macOS). I did not reproduce a failure with an over-long path. The daemon itself only warns at 104 bytes or more.
- **Why `TMPDIR` matters:** `/tmp` here is confirmed `noexec`, and the install relinked `better-sqlite3`. I did not reproduce a build failure on `/tmp`.
- **"No hints" is a snapshot:** it holds while the account daemon has no advertised network. I did not check the box itself for that today; I relied on the existing skill's 2026-09-23 check and on the live locator's shape.
- **`@nets/ocapn` for an outbound-only acceptor:** whether one needs it is still an open TODO in § B.

## Follow-ups
- My live probe left one anonymous guest on production. The API has no route to delete it. Its identifier was never recorded.
- The source note was not on this host. If the maintainer wants the report itself checked against these pages, re-run on the host that holds `/home/kris/garden/note-from-tower.md`.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-docs-tower-report-20261016.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 98 tokens (3776465 cached reads)
- Output: 18780 tokens
- Cost: $1.8971169999999997
- Wall-clock: 717s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
