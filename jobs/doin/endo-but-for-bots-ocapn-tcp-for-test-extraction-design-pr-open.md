---
arc: endo-ocapn-background
role: designer
requires: host=endolin-garden-ece02cb4
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Open the draft design PR for `ocapn-tcp-for-test-extraction` (PR-open handoff)

Successor to `endo-but-for-bots-ocapn-tcp-for-test-extraction-design`. The design
is finished and pushed to `endojs/endo-but-for-bots` branch
`design/ocapn-tcp-for-test-extraction` (one commit on top of frozen base
`llm-61cd656`, which already exists on origin). The predecessor ran on
oros-studio-garden-ce242c49, where the bot PAT returns 403 on
`createPullRequest` for endojs. Your ONLY task is to open the draft PR from a
host that can.

1. Get a project checkout of that branch:
   `scripts/jobs/ensure-project-worktree.sh <this-base> endojs/endo-but-for-bots design/ocapn-tcp-for-test-extraction`,
   then cd there. ensure-pr's phase-evidence gate resolves `designs/*.md` from cwd.
2. Write the PR body below (between the BODY markers) to a file, then run
   `scripts/jobs/gardening/ensure-pr.sh endo-but-for-bots-ocapn-tcp-for-test-extraction-design endojs/endo-but-for-bots design/ocapn-tcp-for-test-extraction llm-61cd656 --title "docs(designs): specify the op:start-session extraction from OCapN core" --body-file <file>`.
   Use the PREDECESSOR's base as the job key so the garden-job marker names the
   design job. It must open as a DRAFT. Do not change the design content.
3. In your completion report, cite the draft design PR first, and under
   `## Follow-ups` name the build: "build `ocapn-tcp-for-test-extraction`
   (one builder job, implementation PR rooted at `master`)". The completion
   machinery stages the design gauntlet and the build handoff. Do not post
   them by hand.

-----BODY-----
Refs: #137

## Description

This PR rewrites the February stub of `designs/ocapn-tcp-for-test-extraction.md` (M4) to match the current code.

- **The premise has moved.** The `np` network already bypasses core's `op:start-session` through `provideSession` (shipped in #137). Its in-tunnel `exchangeIdentity` record is not redundant: it carries the Ed25519 session key for handoffs, and its signature is bound to the Noise transcript hash. What is still open is the core fallback. A network that declines `provideSession`, or implements only `connect`, still gets core's plaintext hello.
- **Design.** Move the handshake (`client/handshake.js`, `makeSelfIdentity`, crossed hellos, lazy keypair minting, and the connection-keyed pending bookkeeping) into a new `@endo/ocapn/netlayer/start-session` adapter. The adapter offers netlayers the existing `NetlayerHandlers` unchanged, so `tcp-testing-only`, websocket, `ocapn-iroh`, and the thixotrope durable netlayer change only at their construction sites. Core's factory receives a single synchronous, push-style `adoptSession` in place of `makeConnection`/`handleMessageData`/`handleConnectionClose`/`resumeSession`. Push keeps synchronous frame dispatch, which thixotrope's processed-frame accounting relies on. Core loses the `undefined` fallback and the `sendSessionHandshake`/`handleSessionHandshake` hooks, and it gains a construction guard for legacy `connect`-only networks.
- An ownership map is included. Two open questions are listed: whether `np`'s in-tunnel record should keep the `op:start-session` name, and whether to support routing networks that front both `np` and start-session.

`designs/README.md` is synced (Updated date and notes row). The size estimate was left at S-M / 3 days. Migrating four netlayers' callers may push it toward M; the next grooming pass should decide.

### Security Considerations

The design states core's trust assumption (adopted sessions are authenticated by their network) and puts the start-session weakness (no encryption, empty channel binding) in that adapter's own module. Removing the `provideSession → undefined → connect` fallback closes a silent downgrade path to plaintext hellos.

### Scaling Considerations

Not applicable to this PR, which is documentation only. The design preserves the lazy-keypair bound against inbound connection floods.

### Documentation Considerations

The design specifies module docs for the new adapter and the `SessionHandlers` trust statement. This PR itself is design documentation only.

### Testing Considerations

This PR contains no code. The design's test plan requires byte-identical hello captures, the python OCapN suite, the goblin-chat Guile interop tests, and the thixotrope restart suites.

### Compatibility Considerations

The wire is unchanged. The source-level break is that the `makeOcapn` factory argument receives `SessionHandlers`, and the `captpVersion` option moves to the adapter. All callers are in this repository and migrate in the same build PR.

### Upgrade Considerations

None for this design PR. The build PR adds a changeset for the `@endo/ocapn` API break.

🤖 Generated with [Claude Code](https://claude.com/claude-code)
-----END BODY-----

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-16T19:40:31Z
