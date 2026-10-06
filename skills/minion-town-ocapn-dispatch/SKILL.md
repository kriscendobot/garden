---
created: 2026-10-06
updated: 2026-10-06
author: gardener
status: not-yet-usable
---

# Skill: minion-town-ocapn-dispatch (status page: not yet usable)

## Purpose

This skill covers how the garden sends a message from a garden host to
**kriscendobot's own guest on minion.town**, using the Endo CLI over OCapN.
It covers the garden's side only: which commands a gardener or the liaison
runs, against which endpoint, and as which principal. The OCapN and CapTP
concepts are covered in minion.town's served getting-started guide
(kriscendobot/minion.town#147, `designs/mcp-resources-getting-started.md`),
so this skill does not repeat them.

## Current status: NOT USABLE. Do not attempt a dispatch.

**This path does not work today, and no procedure in this file is runnable
as a dispatch.** minion.town's account daemon has no OCapN network. The Endo
pieces needed to switch one on are open drafts. The CLI verb for adopting a
remote guest is still being renamed. An attempt fails at the first dial, or
it reaches a demo container that holds no account guest. A "success" against
that demo container is misleading because it proves nothing about
kriscendobot's guest.

Evidence, as rechecked on 2026-10-06 (Endo `llm` at `7a4e957410`, minion.town
`main` at `be0edb8`):

- **The transport itself has landed.**
  [endojs/endo-but-for-bots#340](https://github.com/endojs/endo-but-for-bots/pull/340)
  merged on 2026-08-25 (`5aeaa30e0`). `llm` now carries the OCapN-Noise **TCP**
  netlayer, which `packages/daemon/src/networks/setup-ocapn.js` installs as
  `@nets/ocapn`.
- **The WebSocket stack is still in draft.**
  [#684](https://github.com/endojs/endo-but-for-bots/pull/684) (WS+Noise
  netlayer, CHANGES_REQUESTED),
  [#688](https://github.com/endojs/endo-but-for-bots/pull/688) and
  [#693](https://github.com/endojs/endo-but-for-bots/pull/693) (the cross-host
  invite/accept demo) are all OPEN drafts, with no activity since 2026-08-31.
  The pure-CLI cross-host round trip on #693 (proved 2026-07-17,
  `run-cross-host-cli.sh`) targeted the **demo** container `endo-pet-daemon`
  behind `wss://minion.town/ocapn-daemon`. That container has a separate
  formula graph and no account guests. It is not a route to kriscendobot's
  guest, and minion.town's `DEPLOYMENT.md` says outright that a probe against
  the demo lanes "never counts as account federation".
- **The account route is federation, and federation is "built, NOT
  activated".** minion.town `DEPLOYMENT.md` § *Guest-locator federation*
  describes the account route. A signed-in account reveals a complete locator
  for its own guest through `GET /account/guest-locator`, and a separate Endo
  daemon adopts that locator over `ocapn+noise+tcp://minion.town:8940`. The
  live account daemon (read-only SSM check, 2026-09-23) has only `loop` in
  `@nets` and no TCP listener. The route answers 404 while
  `ENDO_FEDERATION_ROUTES` is unset.
- **What blocks activation** (the release gate in that same section):
  1. The peer-gateway authority fix, a hard blocker. Without it, any locator
     holder can enumerate and reach every account's guest.
     [#1335](https://github.com/endojs/endo-but-for-bots/pull/1335)
     ("bind OCapN gateways to peer sessions") is an open draft.
  2. An `ocapn-advertise-addr` setting in Endo. Without it, a public listener
     advertises `0.0.0.0`. It has not landed.
  3. [#1124](https://github.com/endojs/endo-but-for-bots/pull/1124) (formula
     nonce locator) and
     [#1333](https://github.com/endojs/endo-but-for-bots/pull/1333)
     (`endo store --locator`) merged to `llm`, with both town pins moved to the
     merge. Both are open drafts.
  4. The maintainer's answers to authority questions (1) and (3) on
     [#1332](https://github.com/endojs/endo-but-for-bots/pull/1332#issuecomment-5803040971).
- **The work is already tracked.** The garden orchestration
  `endo-minion-town-guest-locator-federation` (journal `jobs/orch/`) owns this
  campaign. Its endo-build and town-build children are done. Its
  `release-gate`, `deploy` and `live-acceptance` children are parked in
  `jobs/plan/`. Do not post a parallel job to "make OCapN dispatch work". Feed
  that orchestration instead.

So **#693 is not what this is waiting on.** The account path runs over raw
TCP on 8940 and does not need the WSS stack. The garden only dials outbound,
so a garden container that cannot be dialed is not a problem either. The
blockers are the federation release gate above. #684 matters only if the
maintainer later prefers Noise-over-WSS behind Caddy, which would avoid
opening a public port.

## Inputs (once usable)

- **A minion.town account that belongs to the garden**, with its guest
  provisioned. No such account is settled yet. The fleet's MCP connection
  currently acts as the shared test principal `minion-mcp-test-cc`
  ([context/operations/minion-town-mcp.md](../../context/operations/minion-town-mcp.md)
  § Open decisions), and a dedicated garden principal is waiting on maintainer
  approval. "kriscendobot's guest" means the guest of whichever account the
  maintainer names.
- **The guest locator** that account reveals from `GET /account/guest-locator`
  (or its browser "Connect your own Endo daemon" copy button). **This is a
  bearer secret.** Signing out does not revoke it, and anyone holding it can
  dial the guest.
- **A garden-side Endo daemon** built from an `llm` commit at or after the town's
  pin, run with isolated state (see Procedure step 2).
- **The message**, as text plus optional pet-named attachments.

## State

- **The locator.** Never commit it to `main2`, the journal, a job body, a PR, or
  a log. Keep it in host-local state with mode 0600, for example
  `$GARDEN_STATE/minion-ocapn/<account>.locator`, and delete it once it has been
  adopted, as the town's own instructions say.
- **The garden-side daemon's state directory.** This holds the adopted
  reference and the garden's OCapN key. Use a per-host directory under
  `$GARDEN_STATE`, never the deployed garden root.
- **Dispatch log.** Record each send in the journal (as an entry or report) by
  message id and target pet name only. Never record the locator.

## Procedure

### A. Readiness check (runnable today)

Run this first, every time. Go on to B only if every line passes. Report the
first failing line as the blocker.

```sh
# 1. Federation is merged, not draft.
for n in 1335 1124 1333; do
  gh pr view "$n" -R endojs/endo-but-for-bots --json number,state -q '"\(.number) \(.state)"'
done                                   # need: all MERGED

# 2. The release gate passed (it leaves plan/ only when it does).
ls journal/jobs/plan/ | grep endo-minion-town-federation-   # need: no release-gate / deploy / live-acceptance left parked

# 3. The account daemon's federation listener is up. This is necessary but not
#    sufficient: DEPLOYMENT.md warns an answering port proves nothing about
#    guest redemption. (Do NOT probe /account/guest-locator unauthenticated:
#    forward_auth 302s it to login whether federation is on or off.)
timeout 6 bash -c 'echo > /dev/tcp/minion.town/8940' && echo OPEN || echo CLOSED
                                       # need: OPEN  (CLOSED on 2026-10-06)

# 4. The adopt verb has landed on llm: `endo store` grows a --locator option.
#    (`endo paths --locator` already exists and is unrelated; don't let it match.)
git -C <endo-checkout> show origin/llm:packages/cli/src/endo.js \
  | sed -n "/\.command('store')/,/\.action(/p" | grep -c -- '--locator'
                                       # need: >= 1  (0 on 2026-10-06)
```

Federation status is authoritative on the box side
(`deploy/aws/scripts/deploy-endo-federation.sh status` in a minion.town checkout,
which needs the AWS/SSM access described in
[aws-administration](../aws-administration/SKILL.md)). Use it when the cheap
checks disagree.

If any line fails, stop. Name the failing line in your completion report, or
send it to the `endo-minion-town-guest-locator-federation` orchestration
(`scripts/jobs/inbox-send.sh`). Do not improvise a workaround through the
demo endpoints.

### B. Dispatch (NOT YET RUNNABLE: the shape the plan points to)

These steps follow the federation plan's acceptance flow (minion.town
`DEPLOYMENT.md` § *Guest-locator federation*, Local evidence). They are
**unverified against production**. Live acceptance is the parked
`endo-minion-town-federation-live-acceptance` child, so these steps are not
proven yet. Treat every command as a placeholder until that child's report
confirms it.

1. **Get the locator.** Fetch it as the garden's account and write it to the
   0600 state file. The browser path uses the
   [minion-town-mcp-playwright-login](../minion-town-mcp-playwright-login/SKILL.md)
   login flow. TODO: an unattended client-credentials path for the guest-locator
   route does not exist yet.
2. **Start an isolated garden-side daemon.** Use
   `XDG_STATE_HOME`, `XDG_RUNTIME_DIR`, `XDG_CACHE_HOME` and `ENDO_SOCK` pointed
   under `$GARDEN_STATE/minion-ocapn/`, with `ENDO_ADDR=127.0.0.1:0`, then run
   `endo start`. Install the TCP netlayer if the CLI's adopt path needs a local
   network (`endo run --UNCONFINED packages/daemon/src/networks/setup-ocapn.js
   --powers @agent`). TODO: confirm whether an outbound-only adopter needs
   `@nets/ocapn` installed.
3. **Adopt the guest.** The verb is in flux. Today's town UI says
   `endo adopt-locator --file <locator> minion-town`. #1333/#1360 replace it
   with `endo store --locator <locator> minion-town`
   (kriscendobot/minion.town#132 follows the change). Use whichever form merged.
   Then delete the locator file.
4. **Verify.** `endo list minion-town` should show values the town wrote.
5. **Send.** TODO: the exact verb. The guest's mailbox is reached through the
   adopted reference. Whether that is `endo send minion-town …` or an
   `E(...)` call through `endo eval` depends on what the adopted value exposes.
   Also see the open draft
   [#1404](https://github.com/endojs/endo-but-for-bots/pull/1404) ("guests neither
   produce nor consume identifiers or locators"), which can change what a guest
   can receive.

## Output shape

Once usable, a dispatch produces one journal record per send. It holds the
target pet name, the garden-side daemon host, the message id, the time, and
the result of the `endo list` check, and it never holds the locator. Until
then, the only output is the readiness check's verdict: either **all pass** or
**the first failing line** and the PR or job that owns it.

## Notes

- **Interim channel.** To act *as* a minion.town guest today, the garden uses the
  MCP connection ([context/operations/minion-town-mcp.md](../../context/operations/minion-town-mcp.md)),
  whose tools include `send`. That is the `minion-mcp-test-cc` principal's own
  guest talking from inside the town. It is not an OCapN dispatch from a garden
  daemon, and it does not satisfy this skill.
- **Never use the demo lanes as a stand-in.** `/ocapn`, `/ocapn-daemon`,
  `/.well-known/ocapn-cbor-np` and raw `:8929` are toy containers with their own
  formula graphs.
- **What a future author fills in when the gate passes:** delete the
  "not usable" banner and the `status: not-yet-usable` front matter. Replace
  every TODO in § B with the commands the live-acceptance child actually ran,
  citing its report and the merged PRs as evidence. Settle the account and
  principal (Inputs) and the send verb (step 5). Keep § A as a preflight.
- **Sources:** minion.town `DEPLOYMENT.md` § *Guest-locator federation*; Endo
  #340, #684, #688, #693, #1124, #1332, #1333, #1335, #1360, #1404; minion.town
  #132 and #147; journal `jobs/orch/endo-minion-town-guest-locator-federation.md`.
