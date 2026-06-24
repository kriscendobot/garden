# Port endo-but-for-bots #57's codec admission onto #475's Uint8Array byteArray model

**Maintainer decision (2026-06-24): port #57 onto #475's model** (not fold, not
abandon). This resolves the weaver's premise-conflict escalation on
`weave-ebfb-pr57`. Wear the **builder/fixer** role (this is a re-implementation, not
a mechanical rebase): `roles/builder/AGENT.md` / `roles/fixer/AGENT.md`. Repo:
`endojs/endo-but-for-bots`, PR **#57**, base **#475**.

## The conflict (from the weaver — do not re-derive)

- **#57** ("admit immutable ArrayBuffer through codecs") models `byteArray` as an
  **immutable ArrayBuffer**: it adds `byteArrayToHex` / `hexToByteArray` /
  `byteArrayToUint8Array` / `uint8ArrayToByteArray` to `@endo/pass-style` and wires
  the marshal **capdata / smallcaps / encode-passable / justin** codecs to that
  ArrayBuffer model. Adds deps `@endo/immutable-arraybuffer` + `@endo/utf8`.
- **#475** ("narrow byteArray to plain frozen Uint8Array") **deliberately removes**
  that representation: `byteArray` is now a **plain frozen `Uint8Array`**, raw
  immutable ArrayBuffers are rejected, `toBytes`/`fromBytes` were renamed to
  `frozenBytes`/`thawnBytes`, and it adds `@endo/hex`. Head: `b2e712164` (verify
  live via `gh pr view 475 --json headRefName,headRefOid`).
- Conflicts are in `packages/pass-style/src/byteArray.js`
  (`confirmCanBeValid` ArrayBuffer check vs #475's `confirmCanBeByteArray`
  Uint8Array check), `packages/pass-style/package.json` (deps), and `yarn.lock`.
  #57's codecs import `byteArrayToHex`/`hexToByteArray` helpers that **do not exist
  on #475** and were defined against the obsolete model.

## Task — preserve #57's VALUE, discard its obsolete representation

#57's value is **admitting `byteArray` through the marshal codecs**
(capdata/smallcaps/encode-passable/justin). Re-express that admission against
#475's frozen `Uint8Array` model:

1. Reset/rebase #57 onto #475's current head (stacked on #475).
2. **Drop #57's ArrayBuffer-model helpers** (`byteArrayToHex`/`hexToByteArray` etc.
   defined against ArrayBuffer) and the `@endo/immutable-arraybuffer` + `@endo/utf8`
   additions where they only served that model. **Use #475's `@endo/hex`** for hex
   conversion instead of #57's own helpers.
3. **Retarget validation** to #475's `confirmCanBeByteArray` (Uint8Array) path, and
   honor the `frozenBytes`/`thawnBytes` renames.
4. **Rewire the capdata / smallcaps / encode-passable / justin codecs** to admit the
   `Uint8Array` byteArray (the actual feature of #57), not the ArrayBuffer.
5. **Retarget the tests** — `packages/pass-style/.../byteArray.test.js` and the
   marshal `byteArray.test.js` fixtures — at the Uint8Array model.
6. Resolve `package.json` / `yarn.lock` per yarn-lock-separate-commit discipline.
7. Force-push to #57's branch (`git push --force-with-lease origin HEAD:<pr-branch>`),
   **bot identity** (bot-fork PR branch; no identity switch, no ferry). Reply on
   #57 summarizing the port (standing authorization permits commenting).

## After the port — continue the chain

On success, **post `shepherd-ebfb-pr57`** to drive the ported head's CI to green
(the prior state is stale). If the port surfaces deeper design issues, report them
rather than forcing a broken port.

## Definition of done

#57 re-expressed against #475's Uint8Array byteArray model and force-pushed (stacked
on #475) under the bot identity, with `@endo/hex`-based hex, retargeted validation
and tests, a clean `package.json`/`yarn.lock`, a summary reply on #57, and a
`shepherd-ebfb-pr57` follow-up posted. Report the new head SHA, what was dropped vs
re-expressed, and any design issue found. If blocked, report the precise state
rather than claiming completion.

Posted by the liaison on behalf of the maintainer.
