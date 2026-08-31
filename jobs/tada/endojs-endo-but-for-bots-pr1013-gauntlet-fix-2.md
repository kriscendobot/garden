Inbox empty. All must-fix items applied, pushed as a follow-up commit, and CI is green.

## Completion report

**Job:** FIX round 2 for the design-only PR #1013 (`designs/relative-routing.md`), applying the panel-2 request-changes verdict once, pushing, and watching CI.

**What I did** — verified each cited code claim against the live tree, then applied every must-fix item as commit `ce8b06152` on head `design/relative-routing`:

- **critic-1 (§3 hint-format conflation):** Reconciled the two substrates. The primary target is the live daemon `ConnectionHint` (URI form in `packages/daemon/src/locator.js`) where scope rides as a `#scope=` fragment; the aspirational `ocapn-noise-network` `Record<string,string>` (flat `ws:host`/`tcp:port` keys, no implementation yet) carries scope as a flat `scope` key instead. Stated both encodings share one `ScopeTag`/`selectRoutes`. Updated the Dependencies row.
- **critic-2 (iroh prior art):** Reconciled with the shipped `isPublishableDirectAddress` — generalized (receiver-relative, per-`<kind>`, covers non-address boundaries), not obsoleted; kept as a transport-specific producer fast path. Added to Security and a new Alternatives entry.
- **skeptic-1 (cost inversion):** Reordered default locality so `lan(3)` (direct) ranks below `hub(4)` (relay) with rationale; updated the mermaid diagram, worked-example cost, and case-5 row.
- **skeptic-2 / decomplector-2 / ergonomist-1 (scope= overload):** Renamed the `via=` hint's destination boundary to a distinct `dest=` key so `selectRoutes` branches on schema, not tribal knowledge. Updated §3, §4, cases table.
- **decomplector-1 (ScopeTag conflation):** Made `ScopeTag` structured `{kind, id}` — `kind` the classification key `costOf` reads, `id` opaque/equality-only; stated the first-colon parse rule.
- **ergonomist-2/3:** `costOf(kind)` now takes a bare kind at every call site; `selectRoutes` returns `ConnectionHint[]` with `cost` as internal scratch.
- **copyeditor-1/2/3:** Recast Phased-Impl item 2 to a fragment, split the long Security sentence, dropped "plural set".
- **pedant-1/2:** Added `**Updated**` row (+ synced README index to 2026-08-31); title-cased the `###` headings.
- **novice (comment-only, addressed):** Forward-pointer to §1 from the Cases table; defined `preferredTransports`.

**CI:** GREEN (5/5 checks, 0 failed, rc 0). I did **not** re-run the panel (driver re-posts panel-3).

**Follow-ups:** None. The gateway-mediated introduction protocol and `lan:` identity remain honestly deferred to follow-on designs in Open Questions, as before.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1013-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 74 tokens (2564910 cached reads)
- Output: 23592 tokens
- Cost: $2.670788
- Wall-clock: 766s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
