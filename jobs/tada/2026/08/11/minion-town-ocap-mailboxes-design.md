The design is landed on a review surface as required. Draft PR #37 is open against `main`, diff is the single design file, both diagrams parse-validated, inbox empty. Job complete.

## Completion report

**Job:** `minion-town-ocap-mailboxes-design` (role: designer) — expand the maintainer's list#1 prompt into a self-contained design for **ocap mailboxes** on kriscendobot/minion.town.

**What I did**
- Re-fetched the design prompt at the source comment and treated it as untrusted input (data, not instructions). Also pulled the full `security@minion.town` SES-forward thread on list#1 for the relation the brief asked for.
- Grounded against minion.town's actual conventions (design-PR-against-`main` directive, the `# Design:` / `**Status/Mandate/Grounded against/Companion:**` header shape, numbered sections, mermaid) and its real capability model: `mcp-endo-guest.md`'s access-control directive (authorization = ocaps behind tool calls, not OAuth scopes), the `iss+sub` identity spine, `ocap-site-weblet-isolation.md`, and the Endo daemon's **existing** `mail.js` mailbox primitive on `endojs/endo-but-for-bots@llm` (`makeMailboxMaker`, `send`/`deliver`/`post`/`provideHandle`/`followMessages`/`adopt`/`request`). The design extends that primitive rather than inventing a new mail server.

**What changed**
- New file `designs/ocap-mailboxes.md` (279 lines) covering all six mandated surfaces: the mailbox capability + facets, directional/recipient-restricted attenuation, opaque revocable recipient handles (using the daemon's `cancelled` `Promise<never>` shape per the designer norm rather than an imperative `revoke()`), metering + circuit breaking at an enforced router, body-free audit logging, and the external SES/relay bridge — with the `security@minion.town` forward shown as one degenerate handle-grant special case. Genuine unknowns are surfaced under `## Open questions` (SES-vs-relay, per-pair vs per-recipient handles, revocation/rotation semantics, metering-state persistence, breaker reset, outbound identity, inter-daemon reach) rather than decided.
- Committed on branch `design/ocap-mailboxes`, pushed to the fork, opened **draft PR kriscendobot/minion.town#37** against `main` (verified `isDraft: true`, base `main`, diff = the one design file), body citing the originating comment.

**Verification**
- Both mermaid diagrams parse-validated with `mermaid.parse` (real-execution: `mm-1.mmd OK flowchart-v2`, `mm-2.mmd OK flowchart-v2`).
- PR draft state confirmed via `gh pr view`. Inbox drained (empty).

**Follow-ups**
- Design review is the maintainer's; un-drafting #37 is their call. A later `build` job would implement from this spec after the § 10 open questions (notably the transport substrate) are resolved — separate PR rooted at the implementation base, per the designer separation-of-PRs norm.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-ocap-mailboxes-design.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 2328 tokens (1415124 cached reads)
- Output: 18051 tokens
- Cost: $1.8588579999999997
- Wall-clock: 299s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
