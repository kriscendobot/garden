# Gauntlet fix round 4: endojs/endo-but-for-bots#1404

I applied the round-4 panel's must-fix and its related should-fix in one follow-up commit, `91a851e202`, and pushed it to `guest-no-identifiers-locators` (it advanced from `90b4f72604`). CI is green on all 33 checks, but only after rerunning the failed `test (22.x, ubuntu-latest)` job twice.

**What was wrong.** When a guest looked up `@mail`, it got the full `MailHub` object, and each message under it was the full `MessageHub`. Both still had `identify`, `locate`, `listIdentifiers` and the other identifier and locator methods. So a guest could read a message's `@from`/`@to` designations as data, which is exactly what the PR says a guest can no longer do. `guestFacetFor` only narrowed directories built by `makeIdentifiedDirectory`, and these two hubs aren't built that way.

**What changed:**
- **`packages/daemon/src/directory.js`:** new exported `registerReadOnlyGuestFacet`. It gives a read-only hub a guest-facing view built on the same interface guest directories use (`EndoGuestDirectory`). That view has no identifier or locator methods, and its mutators reject. Anything looked up through it, or returned by `listValues` or `readOnly()`, is narrowed the same way. Name-change events have their `value` withheld. `reverseLookup` maps the guest's view back to the real hub, and daemon code walking a path through the view still reaches the real hub.
- **`packages/daemon/src/manager.js`:** `makeMailHub` and `makeMessageHub` now register that view for themselves. A guest reaching either hub, directly or through `@mail/N`, gets the view. The host still gets the full hub.
- **`packages/daemon/test/endo.test.js`:** a new test checks that the guest's `@mail` hub, a message hub reached through a path, and one reached through a nested lookup all lack the eight identifier and locator methods. It also checks that `list` still works, `remove` is rejected, and the host's `@mail` still has `identify`.
- **`.changeset/guest-no-identifiers-locators.md`:** now covers the `@mail` and message hubs. It also says plainly that channels are outside the claim, since a channel message still carries `ids` to every member, guests included. That addresses the panel's comment-only note about the scope of the headline.

**Local checks:** the endo and guest test suites passed (273 tests), and the daemon `tsc` and prettier passed. eslint showed no errors on the changed files, only existing warnings.

**CI:** the first wait ended red with one failing job, `test (22.x, ubuntu-latest)`. Every individual test in that job passed, but `test/endo.test.js` then exited non-zero on an unhandled `Termination requested` error during daemon shutdown. The other three test jobs passed with the same code. On the first rerun the daemon tests passed and a different test failed: `space-nixos-admin` read a half-written `apply-status.json`. This PR doesn't change that package. The second rerun went green.

**Follow-ups:**
- The panel's other comment-only note is still open: `messageId` is not withheld from guest messages.
- The round-4 verdict came from a durable record that kept only the breaker juror's findings. The other eleven jurors who requested changes have no per-juror detail, so panel-5 should run fresh rather than resume from that record.
- The two CI failures in `test (22.x, ubuntu-latest)` both look like intermittent failures that need their own fix: the shutdown error in `test/endo.test.js`, and the partly written file read in `space-nixos-admin`'s `deploy-performer` test.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-guest-no-identifiers-locators-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 106 tokens (4372645 cached reads)
- Output: 19531 tokens
- Cost: $2.0191570000000003
- Wall-clock: 5359s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
