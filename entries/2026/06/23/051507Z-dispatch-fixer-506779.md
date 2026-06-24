---
kind: dispatch
role: fixer
host: endolinbot
posture: liaison
short_id: 506779
dispatch_root: dispatches/fixer--506779
repo: endojs/endo-but-for-bots
branch: feat/lal-pi-harness
pr_number: 290
model: sonnet
---

RSVP 0xpatrickdev's previously-held inline comment on PR #290
(https://github.com/endojs/endo-but-for-bots/pull/290#discussion_r3453545144,
comment id 3453545144, 2026-06-22T15:37:54Z, on
`packages/lal/package.json:47`):

> @kriscendobot this was clobbered somehow. the latest revision
> still depends on @endo/genie's `runAgentRound`. please restore
> the vendoring

User authorized this RSVP at 2026-06-23T05:15Z (previously held off
on 2026-06-22T23:05Z when only the dep-swap ask was authorized).

The original vendoring (pre-clobber): a copy of `runAgentRound`
from `@endo/genie` lived in `packages/lal/src/` (or similar
location) so that the lal package did not need a runtime dep on
`@endo/genie`. The recent retcons removed this.

Fixer brief:
1. Investigate the prior shape — was there a `runAgentRound.js`
   in lal/src? Check git history pre-retcon. Patrick may have
   originally landed the vendoring; find his commit and use it as
   the reference shape.
2. Restore the vendoring: copy `runAgentRound` from `@endo/genie`
   into `packages/lal/src/run-agent-round.js` (or similar).
3. Update the imports in `lal/agent.js` (and anywhere else that
   uses `runAgentRound`) to import from the vendored copy.
4. Drop the `@endo/genie` runtime dependency from
   `packages/lal/package.json` if it was added by the retcon and
   is no longer needed.
5. Run lal tests; gates; push.
