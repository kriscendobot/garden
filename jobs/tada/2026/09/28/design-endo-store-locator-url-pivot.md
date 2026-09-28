The prior attempt completed all deliverables and was reaped before it could report; I re-derived and verified every artifact against the live remotes rather than redoing the work. Completion report:

## What was done (verified complete on the remotes)

**Design (deliverable 1):** `designs/capability-url-locators.md` is on branch `design/capability-url-locators`, open as draft PR **endojs/endo-but-for-bots#1360** (frozen base `llm-47f6965`, carries the `garden-job: design-endo-store-locator-url-pivot` marker). It covers all four maintainer directions: folding adoption into `endo store --locator <locator|-> --name <name>` (stdin via `--locator -`, plus `--locator-file`), daemon-surface unification, "locator = any capability URL" with the `v=1` fragment recognition rule, and the full https-fragment grammar — field registry (`v,node,formula,type,hint*,from,fromNode,view`), repeated-key hints, percent-encoding, canonical form, lossless `endo://` ↔ `https://…#…` round-trip, origin/path semantics, non-locator rejection, version evolution, and the security section (fragment leak channels, look-alike-origin phishing, UI guidance). It includes the parser/serializer API sketch (`parseCapabilityUrl`/`formatCapabilityUrl`/`canonicalEndoLocator`), the three required worked examples (the #1333 guest locator in both forms, a multi-hint locator, a minion.town share link), and a real `## Open questions` section (origin-as-default-hint, envelope-family custody, share-link default form).

**Implementation pivot (deliverable 2):** reworked **on #1333's same branch** `build/guest-locator-adoption` (head `6e946d4d09`, still draft, pinned base `job-federation-nonce-f9cbcfc`), retitled to `feat(daemon,cli,chat): endo store --locator …`, with the PR body explicitly stating the pivot and design linkage. One shared parser `@endo/daemon/capability-url.js` sits behind the CLI, `EndoHost.adoptFromLocator`, `EndoDirectory.storeLocator`, and Chat. Tests are included: `daemon/test/capability-url.test.js` (round-trip, canonical form, non-locator/unknown-`v` rejection), `cli/test/store-locator-command.test.js` (CLI incl. stdin), plus the adoption/endpoint-locator tests. Chat's `/adopt-locator` command became `/store` and the add-space-modal accepts both forms, with `chat/test/unit/command-registry.test.js` updated. Per the job's allowed judgment call, **https share-link emission is gated on design acceptance** (accepting both forms is live everywhere; emitters still produce `endo://`) — stated in the PR body. Help text (`help.md`, `help-text-data.js`) and the lal primer docs are updated in the same PR; all six default-branch `adopt-locator` code-search hits are files this PR modifies. CI on #1333: lint/build/cover green, test matrix pending — a draft awaiting the maintainer's gauntlet, as required.

**Dependents (deliverable 3):** minion.town#117 is already MERGED, so its material is updated by draft PR **kriscendobot/minion.town#132** (`build/store-locator-pivot`, frozen base `main-b32291d`): landing page, shell overlay, and DEPLOYMENT.md instructions now read `endo store --locator-file guest-locator.txt --name minion-town`, and `test/endo-guest-locator-federation.test.ts` drives the new verb with the locator on stdin. Garden issue 114's demo-2 runbook was updated by comment (2026-09-28T21:08:16Z). Nothing was deployed.

**PRs touched:** endojs/endo-but-for-bots#1360 (new, draft), endojs/endo-but-for-bots#1333 (reworked in place, draft), kriscendobot/minion.town#132 (new, draft). All left as drafts for the maintainer's gauntlet.

**Follow-ups (maintainer-facing, not owed by this job):** answer #1360's open questions; on design acceptance, un-gate https share-link emission in Chat's channel header and minion.town's reveal; #1333 and minion.town#132 await their gauntlets.

The project memory file `ebfb-capability-url-locator-pivot.md` already records this state accurately; no memory update needed.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/design-endo-store-locator-url-pivot.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 216 tokens (16177092 cached reads)
- Output: 105316 tokens
- Cost: $27.007546599999998
- Wall-clock: 1476s
- Model(s): claude-fable-5 ×2

<!-- garden-usage-end -->
