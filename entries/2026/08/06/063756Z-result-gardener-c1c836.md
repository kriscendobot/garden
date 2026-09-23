---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-08-06T06:37:57Z
---
Design-panel juror block for kriscendobot/minion.town PR #21 (`designs/weblet-gateway.md`; base `origin/main`, head `e78c17a`). Read against the shipped siblings `src/endo/guest-tools.ts` and `src/endo/gateway/base32.ts`.

### ergonomics

**Verdict:** request-changes

**Findings:**

- § 7.1: `weblet_publish`'s `content` entry `{ path, bytes, contentType }` names a base64 *string* `bytes`, and the design's own commonest first use ("publishing a static page") then forces every caller to base64 plain HTML. The sibling spells its text affordance plainly (`guest_write_text`). Rename to `base64` and give text a first-class arm; an LLM caller reading `bytes` passes raw text and gets a corrupt weblet on first use. [proposed-rule: a field holding an encoded string is named for the encoding, never for the decoded type it stands in for]
- § 7.1: the capability is named `publish` yet grants `weblet_list` and `weblet_unpublish` too. A capability that un-publishes is not a `publish` capability. Rename (`weblets`). Related: only `E(publish).publishWeblet(...)` is spelled, so the object surface is half-specified while its MCP projection is complete; spell all three methods and state the noun-order inversion (`weblet_publish` versus `publishWeblet`) once. [proposed-rule: a capability's name covers every operation it grants, and a specified tool projection implies a specified method surface]
- § 7.1: `weblet_unpublish`'s failure arm is exact (`{ hash, removed: false, reason }`); its success arm is only "a clean tagged result". A caller cannot tell `{ hash, removed: true }` from `reason: null`. [proposed-rule: specifying one arm of a tagged result specifies every arm]
- § 3: `parseWebletHost` returns `{ id }` but bare strings `non-canonical` / `not-a-weblet-host`, so discrimination is `typeof r === 'string'` while § 7.1 tags with a `reason` field on an object. Two idioms, one design. Use `{ ok: false, reason: ... }`, which still carries § 3's logging distinction. [proposed-rule: one tagged-result idiom per design; do not mix bare-sentinel and object-tagged unions]
- § 7.1: a byte-identical collision returns a working `url` with `owned: false`, but `weblet_list` is "the caller's own weblets", so that weblet appears in no list the caller can call and no unpublish it can issue. The unpublish half is stated; the list half is silent. Recommend listing it with `owned: false`. [proposed-rule: when an operation returns a resource handle, the design states which sibling query surfaces it]
- § 6's table presents four `/.well-known/*` endpoints as served; the As-built note 60 lines later says `ocapn-cbor` and `ocapn-syrup` policy-close. § 6 is where a reader looks up the powers surface. Annotate those rows in the table. [rule: skills/gricean-maxims/SKILL.md § Quality]

**Notes (out of scope but worth flagging):**

- One concept, three spellings: `hash` (tool field), `label` (§ 3 prose), `id` (record field). § 3 declares the encodings but not the names. [proposed-rule: a design declaring canonical encodings of an identifier also declares the one name each surface uses]
- The 52-character base32 host is untypeable and unspeakable, but well mitigated (seeder and `weblet_publish` both return `url`) and owned by § 9 OQ1. Acknowledged, not raised. [rule: skills/gricean-maxims/SKILL.md § Relation]
- § 5.1's unstyled-semantic-HTML 404, reasoned from `style-src 'self'` and the reserved path space rather than around it, is the right accessibility call.
- Type-accuracy of the `parseWebletHost` union is the typist's, on the implementation PR's code panel.

Self-improvement: every sharp finding here was an *asymmetry* (specified failure arm, unspecified success arm; specified tool projection, unspecified method surface; specified unpublish consequence, unspecified list consequence), not a bad name. Proposing to the liaison that the ergonomist brief's norm (e) add: read each specified arm and ask what its counterpart is, because designs half-specify a surface far more often than they mis-specify one.
