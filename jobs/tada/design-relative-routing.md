Design job complete.

**What I did**

Wrote `designs/relative-routing.md` on `endojs/endo-but-for-bots` and opened it as **draft PR #1013 against the `llm` roadmap branch** (base `llm`, diff is exactly the new design file + a `designs/README.md` integration). Left draft for the design panel.

**The design** specifies the missing receiver-side half of the locator/hint model. Grounded in the garden library's `relative-routing` concept (Miller's choose-a-route framing, the erights `acceptFrom`/`donorPath`/`vatASearchPath` lineage) and the existing Endo locator/hint designs (`daemon-locator-reference`, `daemon-locator-terminology`, `ocapn-noise-network`, `daemon-agent-network-identity`), it defines:

- **Scope tags** (`<kind>:<id>`, extensible kinds: `process`/`host`/`supervisor`/`hub`/`lan`/`gateway`) whose `id` is distributed out-of-band by the boundary's own authority, never derived from a locator.
- A **local scope** (`LocalScope`) — how a vat expresses "where it is" — as the receiver-side complement of the inbound `AgentConnectionHints` policy.
- **Encoding**: a per-hint `#scope=` claim on the existing `@hint` path segment (a Syrup-struct `scope` field projected into the URL), round-tripping through the current `encodeURIComponent` encoding and degrading safely for scope-blind parsers; a compound `via=<gateway>` hint for the relayed case.
- **`selectRoutes`** filter/rank: drop unreachable hints (so a cross-host connector never dials its own `127.0.0.1`), keep global relays as the fallback tail, order by a configurable locality cost, race within a rank.
- A **Security** section stating the crux: a scope boundary *filters reachability, does not authorize* (the Noise keypair handshake still gates); narrow hints leak information but not reach; tags aren't forgeable into reach.

All six requested cases are mapped. Per the job's instruction, `lan:` scope identity and the gateway-relay introduction protocol are explicitly deferred to named follow-on designs in Open Questions rather than forced into this document. Both mermaid diagrams were parse-validated.

**Follow-ups**
- Messaged the liaison: `ensure-pr.sh` now hits its default 200-PR page-limit refusal on this repo (>200 open kriscendobot PRs); I worked around it with `GARDEN_ENSURE_PR_LIST_LIMIT=600`, but the default should be raised or the marker query paginated, since it will bite every PR-opening job on `endo-but-for-bots`.

Self-improvement: nothing this time (the ensure-pr limit lesson is routed to the liaison as a bus message rather than a role/skill edit).
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/design-relative-routing.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 68 tokens (4340469 cached reads)
- Output: 30507 tokens
- Cost: $4.2018325
- Wall-clock: 625s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
