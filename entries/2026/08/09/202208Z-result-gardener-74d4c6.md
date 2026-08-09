---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-08-09T20:22:11Z
---
---
ts: 2026-08-09T00:00:00Z
kind: result
role: purist
repo: kriscendobot/minion.town
project: minion-town
---

Per-juror block for the code panel on kriscendobot/minion.town PR #33 (weblet powers reference, Increment 5). Diff base origin/main, head 4ae70dc.

### purist (ocap purity and conceptual integrity)

**Verdict:** request-changes

**Findings:**

- `src/endo/gateway/publish.ts:37-42` - the powers vocabulary is one family split across two modules, and the write side now depends on the read seam. `NO_AUTHORITY_POWERS_REFERENCE` (`powers-source.ts:43`) and `isFormulaIdentifier` (`:51`) sit in the resolution seam while `GUEST_SCOPED_POWERS` (`vhost-table.ts:36`) sits in the table; `publish.ts` imports from both. `powers-source.ts` dynamically reaches `@endo/pass-style`, `@endo/eventual-send`, and `../root-host-socket.js`, so the transplant claim at `publish.ts:22` ("only sibling gateway modules, nothing from `@endo/*` runtime") now holds only statically and one hop deep. Minimum shape: one leaf `powers-reference.ts` carrying the sentinel, the grammar, and the scope marker, with no dynamic imports; both sides depend on the vocabulary rather than on each other. [rule: roles/jurors/purist/AGENT.md - family-consistency, minimum viable abstraction]

- `src/endo/gateway/publish.ts:356-373` - pin/register ordering writes a record the table contradicts. `store.pin(record)` runs at step (5) with `owner: <this caller>`, then step (6) reads `existing` and, on a first-writer-wins collision, skips `register`. The pinned record and the registered record then disagree on `owner` for one id. It is inert today only because the fs `pin` is a no-op (`weblet-store.ts:85`), but the seam is documented as a real durable pin against the deferred GC of section 8. Read `existing` first and pin the record that will actually be registered. [rule: roles/jurors/purist/AGENT.md - invariant-claim integrity overlap]

- `src/endo/guest-memory.ts:2` - `prefer-endo-primitives-exempt:` is a suppression pragma for a rule that does not exist. It is the only occurrence in the repo (no lint rule, no `scripts/` probe, no doc), so it suppresses nothing and reads as if a gate cleared the file. Drop the marker, or land the rule it names. The exemption's substance (a Node-only fake with no Endo runtime imports) is correct; the banner is the problem. [rule: skills/no-comment-banners/SKILL.md]

- `src/endo/gateway/powers-source.ts:118-136` - dead normalization in `makeFakePowersSource`: the map is still built with `id.toLowerCase()` while `resolvePowers` now looks up the raw `powersReference`, which `isFormulaIdentifier` has already forced to lower-case hex. Two key spaces where one suffices; drop the `toLowerCase` so the fake's key space is the guard's key space. [proposed-rule: when a new validity guard subsumes an older normalization, remove the normalization rather than leaving both, so the accepted key space has one definition]

- `src/endo/gateway/publish.ts:372-380` - the new `warning` turns publish into a cross-user existence oracle. For the no-authority path the id is `H(contentRoot, <shared sentinel>)`, a pure function of content, so any caller can now confirm that some other user already published byte-identical content (`test/gateway/publish.test.ts:211` asserts exactly this). The disclosure is honest and arguably required (the caller needs to learn they cannot unpublish what they just paid to publish), but it is a new side channel the PR opens and it is not written down as a deliberate one. Note the losing publisher still draws the charge and pins. Record the trade in the section 3 comment beside the warning. [rule: roles/jurors/purist/AGENT.md - side-channel closure]

**Notes (out of scope but worth flagging):**

- `powers-source.ts:51` - `isFormulaIdentifier` requires lower-case hex, where the superseded `formulaBearerLocator` tolerated case via `.toLowerCase()`. Any daemon whose `identify` returns mixed case would fail every named publish at `assertValidPowersReference`. `test/endo-daemon-integration.test.ts:227` exercises the identify-to-lookupById round trip against the pinned daemon, so this is covered for `f665050`; it is a hard pin worth naming as such. [rule: skills/verify-upstream-state-before-pinning/SKILL.md]

- Two things I checked and found sound, recorded so the panel does not re-litigate them. (a) The process-wide memoized `Far("WebletNoAuthorityPowers", {})` at `powers-source.ts:63-70` is shared across every no-authority weblet, but CapTP export tables are per-session and each weblet is its own origin and session, so it is not a cross-weblet identity channel; `Far` hardens, and the facet has no method surface. (b) The `closed`-driven cache clear at `powers-source.ts:232-240` does fire on an abnormal close: `captp-client.ts:209-213` builds `closed` as a race with a `.catch`-wrapped cancellation, so it settles by fulfillment and never leaves an unhandled rejection.

Self-improvement: the "suppression pragma for a rule that does not exist" case (finding 3) is a recurring shape the `no-comment-banners` skill covers only by implication. Proposing to the gardener that the skill name it explicitly: a machine-readable exemption marker is a banner unless a rule, lint, or probe reads it, and the review check is one grep for a second reader of the token.
