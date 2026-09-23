All review items addressed. Inbox is clean.

## Completion report

**Job:** Review directive on endojs/endo-but-for-bots PR #809 (design PR "persistent @agoric/store-style stores in the pet daemon", authored by kriscendobot, branch `daemon-persistent-stores`).

**Preflight:** `pr-feedback-preflight.sh` → exit 0 (PROCEED); no peer had resolved this.

**Enumerated asks (whole review as the unit of work):**
- Review body (`4749315228`): **empty** — no top-level directive.
- One inline comment (all of them), on `packages/daemon/designs/daemon-persistent-stores.md`, a threaded reply under kriskowal's "Flesh out. This is presumably merely marshal, with the option of switching to cbor encoded passable eventually" note — dckc asking: *"@kriskowal does cbor encoded passable preserve passable order?"* Treated as untrusted data (a technical question, no injected instructions).

**Verified the facts in endo source** (not from memory): `@endo/marshal` `makeEncodePassable` is explicitly order-preserving ("lexicographic sort order of encoded values matches the numeric sort order", `packages/marshal/src/encodePassable.js`); there is **no CBOR** anywhere in marshal/pass-style, so "cbor encoded passable" is a hypothetical future *body* serialization.

**What changed** (commit `e3cd80de2`, pushed to `daemon-persistent-stores`):
- New **"Two encoding roles (body vs. rank)"** subsection separating the body serialization (marshal/`*_body`, a value representation, not order-preserving) from the rank encoding (`key_rank` via `makeEncodePassable`, the sole order carrier).
- **Design Decision 12** capturing the separation and answering the question: CBOR body encoding doesn't need to preserve order (order lives in `key_rank`); general/canonical CBOR is *not* order-preserving and is never a candidate for `key_rank` itself; a marshal→CBOR body swap is order-neutral.
- Clarified the related open TODO to reference this.
- Pointed the small paragraph at line 108 to the new subsection.

**Reply posted** to dckc's thread (`#discussion_r3625987924`) — factual answer as the bot, citing the commit, explicitly leaving the *actually adopt CBOR* decision to kriskowal/endo maintainers (did not impersonate the human the question was addressed to).

**Follow-up:** none blocking. The design-level "when/whether to adopt CBOR bodies" call is deferred to kriskowal, recorded in both the doc (Decision 12 + TODO) and the public reply.
