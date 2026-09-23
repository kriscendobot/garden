---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-08-24T02:28:10Z
---
---
kind: result
role: warden
repo: kriscendobot/minion.town
project: minion-town
---

Panel round 2, PR #52 (`feat/daemon-sites-exo`, head bc9dd3e), warden seat.

### warden

**Verdict:** request-changes

**Findings:**

- **must-fix — the exo's returns cross CapTP unhardened, so the live path throws where the fakes pass.** `src/endo/gateway/site-registry-exo.ts:201` returns a fresh `{ hash, url }` record and `:225` returns a fresh `VhostRecord[]`, neither `harden`ed. Both values leave the daemon worker over CapTP (the guest's `E(sites).register(...)`, the gateway's `E(sitesFar).list(owner)` at `daemon-weblet-wiring.ts:115`), where `@endo/marshal` calls `passStyleOf`, which fails closed on a mutable object. Verified against the pinned `node_modules/@endo/pass-style/src/passStyleOf.js:173` and empirically under `@endo/init`: an unfrozen record and an unfrozen array of records both throw ``Cannot pass non-frozen objects like (an object). Use harden()``; the same record under `harden` is a `copyRecord`. So live `weblet_publish` rejects at exactly the step this PR exists to fix, and live `weblet_list` rejects too. The unit tests cannot see it — `test/gateway/site-registry-exo.test.ts:49-50` binds `E` and `Far` to identity, and the only live coverage (V1–V3) is `ENDO_CHECKOUT`-gated and unrun in CI, per this module's own § Verification status. Fix: `harden` the register record and the list array (`harden` is already a worker global per the module's endowment note); `harden` appears nowhere in `src/`, so treat this as the first callee-side boundary in the codebase, not a one-off. [rule: roles/jurors/warden/AGENT.md § Operating norms — "does it `harden` what it returns across a vat or endo boundary"]

- **must-fix — the full exo is introduced to every guest, so a public weblet hash is a cross-tenant capability.** `root-host-socket.ts:161` introduces `sites` to every guest as `@sites`, and this PR is what first installs a real object there. `site-registry-exo.ts` exposes `directory(directoryId)` on that same object; `directoryId` is recoverable from any public URL (`hash` is `base32(id)`, and `labelToId` inverts it). Any authenticated guest can therefore do `E(sites).directory(labelToId(victimHash))` and hold another tenant's daemon directory far-ref — which per `site-registry.ts:12-13` carries `back`, "an opaque power", i.e. the victim's endowed capability — and can also rewrite that directory's `front`. `unregister(owner, hash)` and `register(directoryId, owner)` compound it: authority there is a caller-supplied `owner` string, not the caller's capability, so it is forgeable. The design's residual note (`designs/weblet-ocap-synthesis.md`, "Deferred residuals (unit 3)") and § Known residuals R1 both name the missing attenuated facet but state it as a reachability gap, not as capability theft — and `DEPLOYMENT.md` ships this mode live on `minion-mcp` at boot. Deferring the *clean* per-guest facet is fine; deferring *any* separation is not. Cheap interim: install two names — a register-only `Far` for guests, the full exo under the top-host `sites` the gateway resolves — and point `introducedNames` at the attenuated one. That leaves only the forgeable `owner` for unit 3. [rule: roles/jurors/warden/AGENT.md § Operating norms — secondary surface, "an object crosses the SES boundary unhardened / a capability handed across a boundary"]

- **should-fix — the guest eval source leans on `JSON.stringify` as a JS-source escaper without saying so.** `daemon-site-registry.ts:206,209` bake `front` and `owner` into a string the daemon worker `evaluate`s. `owner` is `identityKey(iss, sub)`, i.e. token-claim text. This is *not* exploitable today — `JSON.stringify` escapes quotes, backslashes and control chars, and U+2028/U+2029 have been legal in string literals since ES2019, which every Compartment parser here is — but it is an untrusted-text-becomes-worker-source seam held together by an unstated parser assumption. Add an explicit charset assert on `owner` (or a U+2028/U+2029 escape helper) at the source-construction site and a one-line comment naming the ES2019 dependency, so a future refactor cannot quietly turn this into injection. [proposed-rule: when untrusted text is interpolated into a string that will be `evaluate`d, the escaping guarantee must be asserted at the construction site, never inherited implicitly from `JSON.stringify`.]

**Notes (out of scope but worth flagging):**

- Clean on the warden's other primary surfaces: the diff adds no `globalThis` write, no `__proto__` / `Object.prototype` / `defineProperty` touch, and no prototype walk on untrusted input. `Far("SiteRegistry", …)` at `site-registry-exo.ts:235` correctly hardens the exo *object* — it just does not reach the per-call return values above.
- `evaluateRegister` (`daemon-site-registry.ts:288-296`) validating the guest-returned `hash` against `/^[a-z2-7]{52}$/` and recomputing the URL locally rather than trusting the returned one is the right posture for a result crossing back from an untrusted authority. Worth keeping as the pattern when the R1 facet lands.
- `installSiteRegistry` claims a re-`evaluate` under the same result name "converges on the same formula". Unverified here, and it is a durability claim (V1 covers restart, not re-install). If daemon eval formula ids are not source-derived, each gateway restart mints a fresh exo while pre-existing guests keep the old introduced one; shared `sites-store` state probably makes that benign, but the comment asserts more than the tests show.

Self-improvement: the load-bearing lesson this round is that a test fake which binds `Far` and `E` to identity silently deletes the guarantee the seat exists to check — the boundary is exactly where fakes stop being honest. `skills/adversarial-tests/SKILL.md` § SES-specific lists "a hardened input the implementation tries to mutate" and "a `passStyleOf` claim against a compartment-bound value", but not the inverse and more common defect: *a value the implementation returns across the boundary without hardening, under a fake that cannot notice*. Sending a `message` to the liaison proposing that entry, plus a companion line for `skills/panel-hints/probes/C-warden.sh`, whose pattern fires on `harden(` being **present** and so cannot fire on this PR — where the defect is `harden` being absent from a module that endows `Far`/`E`.
