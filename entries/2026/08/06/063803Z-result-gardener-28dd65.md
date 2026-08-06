---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-08-06T06:38:09Z
---
repo: kriscendobot/minion.town
project: minion-town
pr: 21
seat: critic

Design-panel seat `critic` on kriscendobot/minion.town PR #21 (`designs/weblet-gateway.md`; diff base `origin/main`).

### critic

**Verdict:** request-changes

**Findings:**

- `designs/weblet-gateway.md:875` (§ 7.1) says "the id is `{ content, powers }` (§ 3)". § 3 and the shipped code say content only: `id = sha-256(contentRoot)` (`src/endo/gateway/seed-weblet.ts:68`), `powers` an optional record field (`vhost-table.ts:43`). The stale premise is load-bearing: the collision rule built on it covers only "content *and* powers identical", so the case content-only addressing actually produces (identical content, different powers) is unspecified at the exact call site Increment 4 implements. Decide it: does the second publish return `owned: false` under the first registrant's powers, or re-register `powers` and change the powers plane of an origin it does not own? [rule: roles/jurors/critic/AGENT.md § Operating norms, secondary surface]
- `designs/weblet-gateway.md:903-917` (§ 7.1 flow) is circular as ordered. Steps 2 (collision) and 3 (charge) precede step 4, which interns and yields `contentRoot`, yet the id and therefore the collision check are functions of `contentRoot`. Say that steps 2 and 3 run over a non-persisting digest pass and step 4 is the persisting write. [proposed-rule: an ordered flow in a design must be checkable step by step for input availability]
- `designs/weblet-gateway.md:234-236` (§ 3) claims `immutable` caching "is sound under" content-only addressing. True for bytes, and the section supplies the counterexample it does not draw: `powers` is mutable in the record and unpublish is de-registration (§ 5.1), so after owner A unpublishes, another guest can register the same content with its own powers, and every browser holding A's year-cached page bootstraps B's powers on that origin. The one-year `max-age` is what makes this a window rather than a race. Open question 7 recommends keeping content-only without weighing it. [proposed-rule: a design settling an open question by recommendation states the strongest counterexample against that recommendation, not only its cost]
- `designs/weblet-gateway.md:794-796` (Increment H item 4): "the other three are mechanical and settled" miscounts four (items 1, 2, 3, 5). More substantively, if item 4 splits into its own increment, § 10 does not say whether publish stays gated on it, while § 4.2 calls that cutover a hard pre-publish gate. [proposed-rule: when a design lets an increment shed an item, it states whether the downstream gate follows the item or stays with the increment]

**Notes (out of scope but worth flagging):**

- § 10 (`:1061-1073`) restates the failure policy as halt, "each increment's edge evidence gates the next", in the paragraph recording that it did not hold, and row 3 defers Increment 3's positive live observation past H to Increment 4. The policy in force is halt with named carried deferrals; stating it as halt reads stricter than what H institutionalizes.
- The operator intern cap (H item 5) bounds interning, but the bytes have already crossed the MCP request boundary. A request-size bound at the app edge is the complementary control, on the MCP surface rather than this design.

Self-improvement: grepping the shipped `src/endo/gateway/` turned finding 1 from a two-sections-disagree pedant note into a critic finding with a named winner. For a design PR carrying *As built* reconciliation notes, reading the code those notes reconcile against is the critic seat cheapest leverage; worth a line in `roles/jurors/critic/AGENT.md` § Operating norms.
