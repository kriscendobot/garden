---
handed-off: ebfb-guest-designation-consumers
deliverable-complete: false
---
# Completion report: `ebfb-guest-no-identifiers-locators`

I opened **endojs/endo-but-for-bots#1404** as a draft. Its head is `guest-no-identifiers-locators` and its base is the frozen `llm-80054c3`. Affected packages are `@endo/daemon`, `@endo/agent-mcp-stdio` and `@endo/agentry`. The daemon integration tests have not run anywhere yet (details under Verification).

## What changed

**Guest surface (`packages/daemon`)**
- **Removed from `EndoGuest`:** `identify`, `reverseIdentify`, `locate`, `reverseLocate`, `followLocatorNameChanges`, `listIdentifiers`, `listLocators`, `lookupById`, `lookupByLocator`, `storeIdentifier`, `storeLocator`, `invite` and `accept`. Guest-native invitations go too, because an invitation is a locator.
- **Also removed: the internal `deliver`.** I found this second escalation route during the audit. A guest could forge an envelope carrying a host id into its own mailbox and then `adopt` it.
- **The host keeps every one of these methods.** I updated the guards in `interfaces.js`, the TypeScript types and the help text.

**What a guest reads**
- **Messages:** `from`/`to` are replaced by `fromNames`/`toNames`, which are the guest's own pet names for each party. `ids`, `promiseId`, `resolverId` and `valueId` are withheld. To get an attachment or a form value, the guest calls `adopt(n, 'value', name)`.
- **`followNameChanges`:** events no longer carry the formula id.

**Host access into its own guest still works**
- Without the guest's id methods, host operations like `copy` into a guest, `introducedNames`, and settling invitations a guest issued earlier would have broken.
- To keep them working, a new daemon-private module (`src/guest-amplification.js`) maps each guest to its internal directory. Only daemon code uses it; guest code runs in workers and can't reach it.

**Other packages**
- **`@endo/agent-mcp-stdio`:** the matching guest tools are dropped and the README is updated.
- **`@endo/agentry`:** code-mode grants are now bound into the guest with `host.copy`.
- **Docs:** `MULTIPLAYER.md` now says invite and accept are host-only.

**Changeset:** `@endo/daemon` and `@endo/agent-mcp-stdio` are bumped as major, with migration instructions; `@endo/agentry` is a patch.

**Tests**
- New tests check that the withheld methods are absent from the guest and still present on the host.
- They also check that the #1371 escalation fails every way it could be attempted, including the forged `deliver`.
- They check the redacted message and name-change fields, adopting a form value, and a host binding a value into its guest.
- I deleted the guest-native invite/accept tests and moved the `cancel()` test to a host inviter.

## Verification
- **Passed:** `tsc` (daemon and agentry), ESLint, prettier 3, the pre-push probes, and the `agent-mcp-stdio` tests (37/37).
- **Not run locally:** the daemon integration tests. The installed `better-sqlite3` is built for Node 24 and this host runs Node 22, so the test daemon wouldn't start. CI will be their first run.

## Follow-ups
- **Posted job `ebfb-guest-designation-consumers`:** migrates the remaining in-repo consumers that still use guest locators or ids, mostly to spot their own messages and read form replies. These are lal, fae, jaine, floot, workflow, claude-sandbox, the chat/spaces guest profiles, the CLI's guest paths, and the listed designs. It stacks on #1404's head branch. Until it lands, those consumers will fail against the new guest surface.
- **Breakage ledger:** the PR body lists every affected caller and how each is recovered.
- **Conflict with the Minion Town guest-locator federation campaign:** that orchestration (design PR #1332) assumes guests can invite and accept. I flagged this in the PR for the maintainer and did not resolve it.
- **Open question for the maintainer:** I left content locators (`magnet:` URNs) on the guest, since they name bytes by hash rather than a capability. However, `loadContent` makes the daemon fetch the URN's web-seed URLs on the guest's behalf. If that counts as an escape hatch, removing the content methods from the guest is a small follow-up.
- **The gauntlet** (clean, panel, fix-loop, un-draft) is staged automatically from this completion.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-guest-no-identifiers-locators.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 244 tokens (20880735 cached reads)
- Output: 76645 tokens
- Cost: $10.157880000000002
- Wall-clock: 941s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
