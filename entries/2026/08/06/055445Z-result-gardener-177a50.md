---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-08-06T05:54:48Z
---
---
kind: result
role: ergonomist
repo: kriscendobot/minion.town
project: minion-town
---

Per-juror block for the design panel on kriscendobot/minion.town PR #21
(`designs/weblet-gateway.md`, diff base `origin/main`, head `0d6a412`).

### ergonomist — request-changes

Read the proposed `weblet_*` tool surface and the operator surface against their
siblings: `src/endo/guest-tools.ts` (the shipped `guest_*` conventions),
`designs/mcp-daemon-guest-tools.md` § 5.1 (the tool-table convention), and
`src/endo/gateway/config.ts` (the shipped operator env surface).

**Findings**

1. **must-fix — § 7.1: `powers` is unspellable, and blocks the commonest first
   use.** `weblet_publish` takes "`powers` as a powers-formula reference" and
   never says what a caller passes (a pet name in their own guest directory? a
   64-hex formula id? a locator string?), while `content` is specified down to
   base64. Sibling guest tools address everything by pet name; say so. Worse, the
   parameter reads as required, so publishing a static page — the first thing any
   guest does — demands a powers formula the user has no way to have yet and no
   documented way to make. Make `powers` optional with a no-authority default,
   and spell its accepted form. [rule: roles/jurors/ergonomist/AGENT.md §
   Operating norms (i) — "a path that asks for information the user does not have
   yet is a finding"]

2. **must-fix — § 7.1: `serving` names implementation state and is false on the
   happy path.** `serving` is defined as "whether the first-hit cert has been
   minted" (§ 4.2), but under on-demand TLS the cert mints on the *first
   handshake* — which by construction has not happened when `weblet_publish`
   returns. So a fully successful publish returns `serving: false`, training
   callers to ignore the one field meant to carry liveness; `weblet_list` repeats
   it for every never-visited weblet. Answer the user's question ("will this URL
   serve?") instead of the implementor's ("is there a cert yet?"): either warm the
   cert at publish so the field is true, or define `serving` as registered +
   issuance headroom available. [rule: roles/jurors/ergonomist/AGENT.md §
   Operating norms (d)]

3. **should-fix — §§ 3, 4.3: the documented operator seed no longer exists.**
   § 3 presents `GATEWAY_SEED_WEBLETS` (hex ids in a `0600`
   `/etc/endo-gateway/seed.env`) as the operator-facing seed and anchors the
   "hex is the canonical internal spelling" claim on it. Shipped code retired it:
   `src/endo/gateway/config.ts:26` says so explicitly, `deploy-endo-gateway.sh:47`
   removes the stale EnvironmentFile, and the live path is `GATEWAY_STORE_DIR` +
   `seedWeblet()`, which returns `{ id, contentRoot, label, url }` — i.e. it
   already hands the operator the addressable host instead of making them run
   `idToLabel` by hand, the friction § 3 still describes. An operator following
   this reconciled design sets a variable nothing reads. Since recording what
   Increments 2–3 shipped is this PR's own job, replace the paragraph. [rule:
   roles/COMMON.md § Document frontmatter — a reconciliation must reconcile]

4. **should-fix — § 7.1: an authorization refusal returned as a non-error.**
   `weblet_unpublish` returns `{ hash, removed: false, reason: "no-such-weblet" |
   "not-owner" }`. The `maybeReadText` precedent it cites covers *absence*, not
   *denial*: on the sibling surface every admission denial throws through `guard`
   and surfaces as `isError` (`guest-tools.ts` `run` → `toToolError`). Two
   different failure kinds spelled identically also invite the caller (often an
   LLM) to read "not-owner" as "already gone". Keep `no-such-weblet` clean; make
   `not-owner` an `isError`. [rule: roles/jurors/ergonomist/AGENT.md § Operating
   norms (f) — error visibility consistent across the surface]

5. **should-fix — § 7.1: the capability is named for one of its three verbs, and
   two are never spelled.** The facet grant is `publish`, yet the same capability
   backs `weblet_list` and `weblet_unpublish` — a capability named `publish` that
   also revokes. Only `E(publish).publishWeblet({content, powers})` appears; the
   other two backing calls and their return shapes are left to be inferred from
   the tool table, where the sibling design gives every row an explicit backing
   call (`designs/mcp-daemon-guest-tools.md` § 5.1, `E(guest).maybeReadText(name)`
   and friends). This is the `@endo/gateway`-owned reusable surface per § 2, so it
   is the half that most needs spelling. Rename to `weblets` (or
   `webletPublisher`) and add the backing-call column. [rule:
   designs/mcp-daemon-guest-tools.md § 5.1]

6. **should-fix — § 1 "As built": `MINION_TOWN_DOMAIN` breaks its own prefix and
   now misnames its value.** Every other gateway knob is `GATEWAY_*`
   (`GATEWAY_PORT`, `GATEWAY_HOST`, `GATEWAY_STORE_DIR`, `GATEWAY_VHOST_TTL_MS`,
   `GATEWAY_ENDO_SOCK`); the parent-domain knob alone is `MINION_TOWN_DOMAIN`, and
   after the § 4.3 namespace correction its value is `weblet.minion.town`, so the
   variable named for the site holds the weblet namespace. Rename to
   `GATEWAY_PARENT_DOMAIN` while the only consumers are two deploy scripts.
   [proposed-rule: one process's operator env vars share one prefix, and a
   variable is named for the value it holds, not the deployment it was born in]

7. **comment-only — § 7.1: one return shape stated twice, differently.** The tool
   table says `weblet_unpublish` "returns a clean `{ hash, removed }` result"; the
   bullet below adds `reason`. State it once.

8. **comment-only — § 7.1: `contentType` required per entry.** Publishing a
   40-file site through a JSON MCP client means 40 hand-written MIME types.
   `content-store.ts` already exports `safeContentType`; make the field optional
   with an extension-derived default, keeping the explicit override.

**Out of scope (flagged, not pursued):** whether `hash` is the right user-facing
noun for an id that changes on a powers-only re-attenuation — § 3 states the
trade explicitly and owns it; and the typing accuracy of the `content` array,
which is the implementation PR's typist surface.

Self-improvement: the strongest findings here came from diffing the design's
"As built" paragraphs against the shipped module they describe rather than
reading the design alone — findings 3 and 6 are invisible from the prose. Worth
adding to `roles/jurors/ergonomist/AGENT.md` § Operating norms: when a design
carries *As built* reconciliation notes, read the named operator surface in the
code before judging it, because a stale operator surface is an ergonomics defect
the design's own prose cannot show. Routing this as a message to `liaison`.
