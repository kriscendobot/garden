I opened draft PR **endojs/endo-but-for-bots#1498** (https://github.com/endojs/endo-but-for-bots/pull/1498). It is based on the frozen branch `llm-ca5aaef`, from head `build/daemon-locator-terminology`, and touches `@endo/daemon`, `@endo/cli` and `designs/`. The locator and formula-identifier tests pass (60 tests) and `pre-push-gates.sh` passed, with one non-blocking note about a comment that I chose to keep.

**What was already done.** The job said the design was Not Started, but the design file said In Progress and most of it was already on `llm`:
- the new type names (`PeerKey`, `FormulaAddress`, `FormulaKey`, `ConnectionHint`, `PeerLocator`, `FormulaLocator`);
- the locator format where connection hints are separated by `@` (5bd2f09d69);
- `formatLocatorWithHints` and `hintsFromLocator`;
- `locateWithHints`. Plain `locate` also already includes connection hints.

**What this PR changes:**
- **Commit `54bb57b404`, code wording:**
  - `locator.js` gets a short glossary of the new terms, and the docs for `externalizeId` and `internalizeLocator` are corrected. They wrongly said the function swaps in the agent's key; it hasn't done that since the SQLite migration (d0ce26b327).
  - `formula-identifier.js` and `types.d.ts` docs map the old names (`number`, `node`, `FormulaNumber`, `NodeNumber`, `FormulaIdentifier`) onto the new terms. Nothing is renamed, because the design says no existing signature changes.
  - Three locator parse errors now read `Invalid peer key.`, `Missing formula address.` and `Invalid formula address.` instead of the old wording. This is the only user-visible change; the only in-repo code that matched the old messages is the test I updated.
  - The `identify` and `locate` help text (`help.md`, with `help-text-data.js` regenerated) and the `endo locate` CLI description use the new terms.
  - Two new tests: hints for several transports at once, and the design's check that splitting a locator apart and rebuilding it gives back the same locator.
  - A patch changeset for `@endo/daemon` and `@endo/cli`.
- **Commit `eb07f183cc`, design docs:**
  - `daemon-locator-terminology.md` is marked **Complete**, with an implementation-status section added.
  - Its LOCAL_NODE section described an approach the SQLite migration removed, so I replaced it with what the code actually does: stored formula keys carry the real peer key.
  - The doc now states two answers other designs were waiting on: locators keep the `endo://` scheme, and `invite`, `accept` and `correspondentName` keep their names.
  - The status rows and dependency graph in `designs/README.md` are updated to match.

**Decisions to check in review:**
- Marking the design Complete was my call, made because nothing in its file list remains undone.
- Saying `invite`, `accept` and `correspondentName` are final is my reading of the design's own table, which lists them as unchanged; `guest-native-invitations` treats those names as provisional.

The PR stays draft. When this job completes, the gauntlet (cleanup, panel review, fix loop, un-draft) is staged automatically, so there is nothing else to post.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endo-daemon-locator-terminology-build.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 82 tokens (3846813 cached reads)
- Output: 22820 tokens
- Cost: $2.1446905999999997
- Wall-clock: 995s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
