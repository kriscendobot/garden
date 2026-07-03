---
created: 2026-07-03
updated: 2026-07-03
author: gardener
---

# Fixer sub-role: endojs

The fixer's project-keyed specialization for endojs work that touches **XS**:
`endojs/endo`'s XS builds and the **`xs2rust-endor`** port
(endojs/endo-but-for-bots#600, the XS-to-Rust translation, "endor"). Read
`roles/fixer/AGENT.md` first; this is additive. Selection and the sub-role
concept: [README](README.md).

This sub-role exists because the **XS debugging envelope is broader than one
repo** (maintainer directive, kriskowal/garden#22, 2026-07-03: "for XS is a
broader envelope which touches both agoric-sdk and endor in endojs"). The engine
knowledge is shared with the [agoric-sdk](agoric-sdk.md) sub-role; what differs is
the surface. In agoric-sdk, XS runs *user* code (contract bundles) and the fix is
usually at a JS call site. In endojs, XS *semantics themselves* are the subject:
endo's SES/XS builds, and `xs2rust-endor` porting XS behavior to Rust, where a
divergence is an XS-behavior debugging question.

**Repo etiquette.** `endojs/endo-but-for-bots` is an in-scope bot repo with
standing authorizations (`journal/projects/endo-but-for-bots/README.md`). Upstream
`endojs/endo` stays comment-and-link-free from the bot identity: no closing,
merging, or commenting on `endojs/endo` PRs; upstream `endojs/endo` actions remain
with kriskowal and the boatman identity-switch path, regardless of who issued the
directive (`roles/COMMON.md` § External-repo etiquette, *Maintainer-authority
actors* boundary).

## Debugging dimension

- [xs-debugging](../../../skills/xs-debugging/SKILL.md): the shared XS envelope.
  For endojs the most relevant parts are the **signal classification** (exit 12 /
  `E_STACK_OVERFLOW`), the **width-not-depth** root-cause pattern, and the
  **`@endo/hex` check**: `@endo/hex` was confirmed on kriskowal/garden#9 **not** to
  carry the wide-`flatMap` defect that `@agoric/internal/src/hex.js` did, so an
  endo-side hex/table build is a known-clean reference point when triaging an
  agoric-side one.
- For a value-stack question that reproduces against **agoric** chain state, cross
  to the [agoric-sdk](agoric-sdk.md) sub-role's
  [agoric-chain-snapshot](../../../skills/agoric-chain-snapshot/SKILL.md) lever.
  endojs XS surfaces reproduce with the project's own XS test harness rather than a
  swing-store.

## When this sub-role engages

- An `endojs/endo` XS build or SES-under-XS path hits an engine-level fault
  (overflow, a metering signal) rather than a plain JS bug.
- `xs2rust-endor` shows a **behavioral divergence** between XS and the Rust port:
  a case where knowing *how XS actually behaves* (value-stack width, snapshot
  format gates, metering) is the debugging lever.
- A durable structural remedy is in view (the `bundle-source`/esbuild
  sub-module-functor lever from [xs-debugging](../../../skills/xs-debugging/SKILL.md)),
  which is an endo-tooling change, not an agoric call-site patch.
