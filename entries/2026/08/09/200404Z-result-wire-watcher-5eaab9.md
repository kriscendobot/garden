---
kind: result
role: wire-watcher
host: endolin-garden-ece02cb4
at: 2026-08-09T20:04:06Z
---

Panel seat wire-watcher, PR #33 (kriscendobot/minion.town), diff base origin/main.

### wire-watcher

**Verdict:** request-changes

**Findings:**

- **Write and read sides name different namespaces, and no test can see it.** `publish.ts:348` stores what `E(guest).identify(name)` minted, a guest-scoped *formula id*; the only live reader, `powers-source.ts:194`, resolves it with `E(host).lookup(powersFormulaId)`, the daemon top host's **pet-name** walk (`root-host-socket.ts:48`). Nothing here shows a formula id resolves through `lookup`. If it does not, every powered weblet fails to bootstrap in production; if it does, a guest-scoped identifier is read in the higher-authority host namespace. `weblet-powers-e2e.test.ts:186` keys `makeFakePowersSource` on the very string publish stored, so the namespaces agree by construction and the test cannot fail. Add a `makeDaemonPowersSource` test over a fake `DaemonLookupHost` asserting the call shape, and soften that file's "proving the § 6 invariant holds through real machinery". [rule: skills/adversarial-tests/SKILL.md]

- **The invariant is not retroactive.** `publish.ts` calls this "the single write-side enforcement", but `makeFsWebletStore` is durable and Increment 4 (on main) took `powers` as a raw caller string. Records written earlier still hand an attacker-chosen token to the top-host `lookup` at `powers-plane.ts:191`. Version, migrate, or read-gate them. [proposed-rule: a PR closing a write-side trust gap on a durable store must migrate, version, or read-gate the records already written.]

- **No pinned format on the derived reference.** `assertValidPowers` (`publish.ts:189`) takes any 1-512 char control-char-free string, so a misbehaving resolver can seed the record with a top-host pet name or the `NO_AUTHORITY_POWERS_REFERENCE` sentinel. Tests pin `/^[0-9a-f]{64}$/`; production pins nothing. Assert the formula-id shape; reject an `endo:`-prefixed value. [proposed-rule: an identifier crossing a trust boundary is pinned by a regex assertion in product code, not only in a test.]

- **`locatorFor` is not sentinel-aware.** `gateway.ts:139` feeds `record.powers` to `formulaBearerLocator`, which prefixes `endo:`, so a no-authority weblet's `/.well-known/ocapn-bootstrap` serves `endo:endo:no-authority-empty-facet-v1` as a durable offline bearer line designating nothing. `resolvePowers` special-cases the sentinel; `locatorFor` does not. Same field, two readings. [rule: skills/adversarial-tests/SKILL.md]

- **A daemon fault is reported as a caller error.** `root-host-socket.ts:174-181`: the bare `catch { return undefined }` turns a CapTP drop between `has` and `identify` into `PowersReferenceError` "you hold no powers object named X" (`guest-control.ts:219`), while a throwing `has` is left uncaught. Narrow the catch; let a session fault surface as `DaemonUnavailableError`. [proposed-rule: a transient transport fault is never collapsed into a caller-error class; failing closed governs the authority granted, not the error the caller is told.]

**Notes (out of scope but worth flagging):**

- The bound powers object is served to any **anonymous** client reaching the origin (`powers-plane.ts:186`, no auth on `/.well-known/endo-captp`): the URL is the whole bearer credential. The new tool text (`guest-tools.ts:325`) invites naming `guest_write_text` and says only that you cannot reference another user's object; it should say who *can* invoke the result. Nothing stops naming a daemon-seeded reserved name (`SELF`, `HOST`) and publishing the whole agent. [proposed-rule: a tool description inviting a user to delegate a capability states who ends up able to invoke it, not only who cannot.]
- Three normalizations of one identifier (sentinel `===`, fake source lower-cases, daemon source verbatim), and untested marker failure modes: `powers: ""` (zod `.min(1).optional()` rejects it while `resolvePowersReference` reads it as no-authority), the sentinel passed as a pet name, a resolver returning 128 hex zeros. [rule: skills/adversarial-tests/SKILL.md]

Self-improvement: the seat's in-band-marker axis assumes a marker's hazard runs toward *more* authority. Here the sentinel is fail-safe on the resolve path yet divergent on the locator path, so the axis should read "every reader of the marked field", not "every trust decision". Worth a line under Parser divergence in `roles/jurors/wire-watcher/AGENT.md`.
