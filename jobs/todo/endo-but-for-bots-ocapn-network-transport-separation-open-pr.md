---
role: builder
requires: host=endolin-garden-ece02cb4
arc: endo-ocapn-background
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Open the draft PR for the ocapn-network-transport-separation .np location-ID increment (successor to endo-but-for-bots-ocapn-network-transport-separation-build)

The predecessor builder job implemented and tested the increment, but host
oros-studio-garden-ce242c49 cannot create PRs on endojs (PAT 403 on
createPullRequest), so this job only opens the PR.

Already pushed to endojs/endo-but-for-bots:
- frozen base `llm-61cd656` (= origin/llm 61cd656cb)
- head `feat/ocapn-np-identity-location-id` at 7f52fa6ee (one commit touching
  `packages/ocapn/src/client/util.js`, both legacy netlayers, a new
  `packages/ocapn/test/location-id.test.js`, and a changeset)

Task: get a project checkout of that head with
`scripts/jobs/ensure-project-worktree.sh <this-job-base> endojs/endo-but-for-bots feat/ocapn-np-identity-location-id`,
cd there (the phase-evidence gate resolves design paths from cwd), save the PR
body below to a file, and run this command. Pass the PREDECESSOR's base as the
first argument so the `garden-job` marker stays the same:

    scripts/jobs/gardening/ensure-pr.sh endo-but-for-bots-ocapn-network-transport-separation-build \
      endojs/endo-but-for-bots feat/ocapn-np-identity-location-id llm-61cd656 \
      --title 'feat(ocapn): key .np location IDs on network and designator' \
      --body-file <file>

Open the PR as a draft, then name it in your completion report so the gauntlet
is staged. Do not change the commit unless the head has drifted.

## PR body

Refs: designs/ocapn-network-transport-separation.md

## Description

Build increment for `designs/ocapn-network-transport-separation.md` (M4), the `@endo/ocapn` half of Migration Plan step 4: the `.np` session key becomes `(network, designator)`.

- `locationNetworkId(location)` in `packages/ocapn/src/client/util.js` names the migration rule `network ?? transport`. `locationToLocationId` and both legacy netlayers' network checks now use it, so the network, not the legacy `transport` field, identifies the peer.
- For the identity-keyed `np` network, `locationToLocationId` omits hints and returns `ocapn://<designator>.np`. One authenticated Noise peer therefore keeps one location ID, and one session, however its published hints change (bind, rebind, withdrawal, or a new `tcp+cbor`/`wss+cbor` combination). Legacy netlayers (`tcp-testing-only`, `websocket`) keep their sorted-hints IDs until they migrate.
- The WebSocket netlayer's location now declares `network: 'websocket'` beside its legacy `transport`, matching the TCP test netlayer.

The `@endo/ocapn-noise` steps (splitting `addTransport` from `listen`, `<transport>+<codec>` hint keys, the `tcp+cbor` transport, listener handles) are later increments.

### Security Considerations

Noise IK still authenticates the designator. Hints were already untrusted routing suggestions; removing them from the `.np` location ID means a peer cannot mint a second session identity for the same key by varying its hints.

### Scaling Considerations

None. Shorter `.np` location IDs, and fewer duplicate sessions for a peer whose hints change.

### Documentation Considerations

The changeset describes the new `.np` location-ID rule and the `locationNetworkId` helper.

### Testing Considerations

New `packages/ocapn/test/location-id.test.js` covers hint-independent `.np` IDs (bare, `tcp+cbor`, dual `tcp+cbor`/`wss+cbor` with an IPv6 authority), distinct designators, legacy sorted-hint IDs, and network-over-transport precedence. Locally, `packages/ocapn` `yarn test` passed 564 tests (including the api-surface snapshot), `yarn lint` reported 0 errors, and `packages/ocapn-noise` `yarn test` passed 78 tests. The rebind/withdraw session-reuse end-to-end test arrives with the `ocapn-noise` listener increment.

### Compatibility Considerations

The wire codec is unchanged: `transport: 'np'` stays on the wire and hints stay string tables. Only the internal `LocationId` string for `.np` peers changes. Nothing persists it across restarts.

### Upgrade Considerations

None. Location IDs are in-memory session keys and are not persisted.

<!-- garden-job: endo-but-for-bots-ocapn-network-transport-separation-build -->

🤖 Generated with [Claude Code](https://claude.com/claude-code)
