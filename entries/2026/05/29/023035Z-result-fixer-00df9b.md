---
ts: 2026-05-29T02:30:35Z
kind: result
role: fixer
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
refs:
  - jobs/claimed/20260529T022628Z--endolinbot--general-contractor--e7a0--234bf0--summary-fix-343.md
---

Addressed the four-item summary-fix bundle on design PR #343 (`design: gateway-package.md`) from the solicitor's 2026-05-23 panel. All four items are independent design-prose edits on `designs/gateway-package.md` only; the PR carries zero source files.

New head SHA on `design/gateway-package`: `e8d2aa445` (previous tip `ba4c81236`; matched the SHA the job body cited).

## Per-item commit mapping

Separate commit per item; the items are independent and per-item commits keep the maintainer's review of each item cheap.

1. `3a50d7b25` design(gateway): drop orphaned setVirtualHostAllocationPolicy (#343). Clean delete of the `GatewayAdmin.setVirtualHostAllocationPolicy(policy: AllocationPolicy)` method declaration at the previously-numbered lines 630-631 plus removal of the matching token from the Capability Surface listing (previously line 862). `AllocationPolicy` is only referenced as that one parameter type; no separate type definition needed removal.

2. `b8594c48e` design(gateway): fold OQ5 contradictory paragraphs (#343). Took the dispatch's "delete the obsolete sentence outright" option in light form: rewrote "the gateway-side cache shape is still underspecified." to "the gateway-side cache shape resolves to the framing below." so the lead sentence transitions into rather than contradicts the Resolved-framing paragraph that follows.

3. `13a2c4469` design(gateway): name alias-vs-identifier at the bind('chat', ...) example (#343). Added the alias-vs-identifier sentence as the last sentence of the `@apps` NameHub introduction paragraph (immediately before the `js` code block). Sentence-per-line per the project's markdown style. Used the dispatch's recommended phrasing with the minor adjustment "in the example below" to anchor the reference forward to `bind('chat', ...)`.

4. `e8d2aa445` design(gateway): name the OQ7 consequence for downstream readers (#343). Inserted the dispatch's recommended consequence sentence ("the Familiar must bundle its own gateway, and the developer install transitions from in-daemon HTTP to embedded `@endo/gateway`") immediately after the resolved-direction lead sentence, before the broader-architectural-framing paragraph. This keeps the consequence adjacent to the resolution rather than buried behind another paragraph of framing.

## Prose-style checks

- em-dash-style: no em-dashes, en-dashes, or double-hyphens in added prose (`git diff ba4c81236..HEAD | grep '^+' | grep -P '[\\x{2014}\\x{2013}]|--'` empty) nor in commit messages.
- relative-paths: all paths in commit messages and the prose addition are relative; no absolute paths introduced.
- pre-push-gates: markdown-only changeset; the deterministic gate has no codepath to exercise here. Sentence-per-line markdown convention from the project's `designs/CLAUDE.md` honored in all three added paragraphs.

## No post-fixer dispatch chain

Per `roles/fixer/AGENT.md` § Operating norms ("Summary-fix dispatches are one-shot"), no judge re-run follows. PR #343 was already un-drafted on this round; the maintainer's review is the next venue. Authorizations on this dispatch (`identity_switch=false`, `comment_repos=[]`) precluded the top-level summary comment on the PR; the orchestrator's reading of this result entry is the substitute trace.

## Loose ends for the orchestrator

The job body's *Acceptance* section anticipates "Submit a top-level summary comment citing each addressing SHA per `roles/COMMON.md` § External-repo etiquette fixer norm; the per-action authorization for thread replies is implicit in this summary-fix job's framing." That authorization is asserted in the job body's prose but contradicted by the dispatch prompt's explicit `comment_repos: []`. I deferred to the dispatch prompt (the tighter of the two) and did not post the summary comment. If the general-contractor wants the summary posted, it needs to be a separate dispatch with `comment_repos: [endojs/endo-but-for-bots]` (or the orchestrator posts it itself).

Self-improvement: nothing this time.
