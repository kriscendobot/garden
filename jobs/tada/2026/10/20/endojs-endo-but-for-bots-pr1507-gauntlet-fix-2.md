FIX round 2 for endojs/endo-but-for-bots PR #1507 is done. I pushed two follow-up commits and edited the PR body, and CI is green: 35 checks, 0 failed (`ci-wait-merge.sh --no-merge` rc 0).

**Missing evidence.** The must-fix review (5580132832) and the panel record `6bf76c700498` both cut every finding off at about 100 characters. The full text from the seats isn't anywhere on this host. I worked from the file, line and topic each truncated item names. Check panel-3 for any finding I misread.

**Code fixes** (commit `b1f3d3f316`):
- **Typing (integrator):** `OcapnNoiseTransport` now takes a generic `ListenOptions` type, and `network.listen` forwards those options with their type. The TCP, WebSocket and mock transports each declare their own options type, which replaced the casts in their `listen` code.
- **Docs in `types.d.ts` (archivist):** I fully documented `network.listen`: when hints get published, the three rejection cases, and what closing the handle does. `removeTransport` now documents that it throws while the transport has a listener.
- **Error messages (integrator):** The TCP and WebSocket transports said "listen called more than once", but `close()` now makes a second listen legal. They now say "already listening", and the two tests that match the message are updated.
- **Comments (pruner):** I removed the three-line comment in `network.js` that restated the code, and cut the README example comment to one line.

**Design docs** (commit `f75bcbcd80`):
- `ocapn-network-transport-separation.md` has a new Implementation Status table. It marks step 3 done and steps 4 and 5 partial, with the remaining pieces listed. It also says why steps 3 and 4 landed before 1 and 2, which answers the integrator's comment on ordering.
- `ocapn-noise-network.md` now has a note pointing to that design, and its transport typedef uses `listen(options, accept)`.
- `daemon-ocapn-external-connectivity.md` no longer says `addTransport` owns listening.
- The dates in `designs/README.md` are updated.

**PR body (pruner):** I removed the repetition between the description and "Review attention". I also cut the padded Scaling, Security and Testing sections and merged Compatibility with Upgrade. The garden markers are kept.

**Checks before pushing:** the package type check, the repo-root type check (filtered to ocapn files), the package's 84 tests and prettier all passed. eslint reported 0 errors and 6 warnings, such as unused eslint-disable directives in test files.

**Follow-up:** none. The driver re-posts panel-3 next.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1507-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 74 tokens (3080961 cached reads)
- Output: 16023 tokens
- Cost: $1.6885242
- Wall-clock: 2138s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
