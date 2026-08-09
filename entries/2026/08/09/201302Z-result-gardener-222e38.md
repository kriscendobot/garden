---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-08-09T20:13:04Z
---
---
kind: result
role: purist
repo: kriscendobot/minion.town
project: minion-town
---

Per-juror block for the code panel on kriscendobot/minion.town PR #33 ("resolve
weblet powers from the caller's own guest facet"), diff base origin/main.

## purist

**Verdict: request-changes**

### Findings

1. **must-fix. The no-authority sentinel is minted in the LOCATOR namespace but
   stored in the FORMULA-ID field, so the family's other renderer mangles it.**
   `src/endo/gateway/powers-source.ts:43` sets
   `NO_AUTHORITY_POWERS_REFERENCE = "endo:no-authority-empty-facet-v1"`, already
   carrying the `endo:` prefix that `formulaBearerLocator`
   (`src/endo/gateway/powers-source.ts:91-93`) exists to add. Every `powers`
   value in a `VhostRecord` is rendered two ways: `resolvePowers` (special-cased,
   correct) and `locatorFor`, which `src/endo/gateway/gateway.ts:139` serves
   publicly at `/.well-known/ocapn-bootstrap`. A no-authority weblet therefore
   advertises `endo:endo:no-authority-empty-facet-v1` (verified by evaluating the
   template), a malformed bearer line no handoff can resolve. Either drop the
   `endo:` prefix from the sentinel or special-case it in `locatorFor` as
   `resolvePowers` does. No test covers the locator on this path.
   [proposed-rule: a sentinel added to a value family must be checked against
   every renderer of that family, not only the one it was introduced for.]

2. **should-fix. `identify` collapses a daemon fault into "you hold no such
   name".** `src/endo/root-host-socket.ts:174-181` wraps `E(guest).identify` in
   `catch { return undefined }`. The sibling adapters (`writeText`,
   `maybeReadText`, `remove`, lines 164-167) let the fault propagate precisely so
   `DaemonUnavailableError` reaches `toToolError`. Here the caller instead gets
   `PowersReferenceError: you hold no powers object named "x"` when the session
   dropped mid-call. Keep the `has` gate; let `identify`'s rejection propagate.
   [proposed-rule: an adapter must not answer "absent" for a transport fault when
   the module already carries a distinct fault type for it.]

3. **should-fix. Empty string silently downgrades authority.**
   `src/endo/gateway/publish.ts:103` treats `petName === ""` as omitted and binds
   the no-authority default. `PublishInput` is the transplantable mechanism
   surface (`@endo/gateway`-shaped, design § 2); the zod `.min(1)` at
   `src/endo/guest-tools.ts:349-355` guards only the MCP lane. A non-MCP caller
   passing an unfilled `""` gets a no-authority weblet rather than a clean error.
   Absent and empty are different on an authority-bearing field: reject `""`.

4. **should-fix. The doc claims a structural invariant the shape does not
   carry.** `src/endo/gateway/publish.ts:172-179` says the resolver "closes over
   this one owner ... the § 6 invariant made structural, not a per-call check".
   But `WebletPublisher.publish` (`src/endo/gateway/publish.ts:302-306`) takes
   `powersResolver` as a third parameter, and `makeWebletPublisher` is exported
   and constructed directly (`src/http.ts:130`). Anyone holding the publisher can
   pass any resolver, including one bound to another guest; only
   `bindPublishFacet` happens to close the right one. Either make it structural
   (mint the publisher per caller, or move the resolver into `bindPublishFacet`'s
   closure with no publisher-level parameter) or soften the comment to describe
   the one-call-site discipline it actually is.

5. **should-fix. The shared sentinel makes cross-user id collision the DEFAULT
   path.** `deriveWebletId(contentRoot, powersReference)` plus first-writer-wins
   (`src/endo/gateway/publish.ts:355-360`) already contemplated collision, but
   `powers` was previously a caller-chosen string. Now every static-page publish
   shares one constant, so identical content across users always collides: the
   second publisher receives `serving: true` and a URL for a record they do not
   own, `list()` omits it (an existence oracle for "has anyone published these
   exact bytes?"), and the first owner's `unpublish` deletes their site. If § 3
   intends this, the publish result should say so; silence reads as ownership.
   [rule: garden/skills/adversarial-tests/SKILL.md, side-channel category]

6. **comment-only. A test title claims a property its assertions do not
   establish.** `test/gateway/weblet-powers-e2e.test.ts:236` is titled "a second
   guest cannot name the first guest's object -- different reference, different
   origin", then asserts `expect(referenceA).toBe(referenceB)` at line 258. What
   the test proves is name-scoping (each resolver reads its own directory), not
   reference distinctness. Retitle to the property actually held.

7. **comment-only. Two minimum-viable notes.** `Far` is defined by
   `@endo/pass-style` (already in the tree as a transitive dep); adding
   `@endo/marshal` to production `dependencies` for it pulls the whole capdata
   marshaller. And `noAuthorityBootstrap` (`powers-source.ts:53-56`) mints a
   fresh `Far` per resolve; one memoized empty facet suffices, since the value is
   stateless and its identity carries no meaning.

Not verified: I read the diff and evaluated the locator template by hand; I did
not run the test suite.

Self-improvement: the purist brief's family-consistency axis assumes the family
is a set of SYMBOLS; finding 1 came from applying it to a set of RENDERERS over
one field (which functions read this value?). Worth adding that phrasing to
`roles/jurors/purist/AGENT.md` § Family-consistency, since a sentinel's cost
usually shows up in the renderer nobody special-cased.
