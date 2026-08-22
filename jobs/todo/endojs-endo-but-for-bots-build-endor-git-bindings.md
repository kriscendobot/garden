---
role: builder
tier: mentor
token-budget-epoch: 2026-08-22T04:02:06Z
---
<!-- garden-promoted-from-plan: gate=go-ahead priority=high at=2026-08-22T04:02:06Z cleared=none -->

---
tier: mentor
fallback-tier: minion
provider: openai
dispatch: automatic
---
# build: Endor Git bindings — libgit2 via Zig cross-builds (design PR #987)

Repo: endojs/endo-but-for-bots (base branch `llm`).

Implement the **revised** Endor Git-bindings design landed in
https://github.com/endojs/endo-but-for-bots/pull/987
("design(endor): bind libgit2 with Zig cross-builds"). The design file is
`designs/endor-git-bindings.md` (with its summary/milestone/estimate rows in
`designs/README.md`).

## What the design asks a builder to introduce

- A new Rust crate `rust/endor-git` that exposes a narrow, synchronous Rust
  interface over **libgit2** (via the safe `git2` crate and `libgit2-sys`),
  distinct from the earlier pure-Rust `gix` Phase-1 CAS build (PR #872).
- `Libgit2Repository` for ordinary on-disk repos and `Libgit2Backend`
  installing custom object/reference databases (the Minion Town CAS/SQLite
  adapter seam) through `libgit2-sys` — no raw libgit2 pointer crossing the
  module boundary; custom C callbacks isolated in one audited module that
  cannot unwind into C.
- Vendored, statically linked libgit2 built from pinned source as part of the
  Cargo build (`vendored-libgit2` + `unstable-sha256` features; `libgit2-sys`
  compiling the vendored C via the `cc` crate), Git object IDs kept distinct
  from Endor `ContentStore` identifiers.
- The Zig cross-build + native-run matrix (Windows, macOS, Linux) and release
  lanes; linkage audits, sanitizer coverage, reproducibility checks, and the
  shared-filesystem / custom-backend conformance suites the design specifies.

## Scope / known risk (from the design itself)

The design flags the Zig cross-compile premise as the **least-proven** part —
the Windows GNU lane is the first expected point of failure (`cargo-zigbuild`
does not yet claim Windows support). This is an **attempt**: land what builds
and passes natively (open a draft PR through the standard build flow / auto
gauntlet), and where the Zig/Windows lane proves infeasible, deliver a clear,
structured gap report rather than forcing a broken lane. Keep Endor's public
Git capability and Minion Town's HTTP/auth layer outside the binding crate, and
keep no network transports/credential helpers in the local profile.

## Provenance

Posted per maintainer directive (kriskowal) on PR #987:
https://github.com/endojs/endo-but-for-bots/pull/987#issuecomment-5337796794
— "post a builder to attempt this next week, after the quota reset on Friday at
9pm." Parked as a budget-hold and auto-promoted by the budget-refresh watcher
after the 2026-08-21 21:00 America/Los_Angeles (2026-08-22T04:00:00Z) reset, so
it draws on next week's fresh quota. Verify PR #987's design is current/merged
before building; if the design is still in review, build against its current
head and note any divergence.

**2026-08-21 (kriskowal, via liaison session):** pinned `provider: openai` —
Claude (gardener/monk) is throttled to 0 on the quota-pressured host while
Codex has fresh quota, so this build is directed to a Cleric specifically
(`role_default_model` already pins cleric+builder to a codex flagship; the
existing `tier: mentor` resolves to `gpt-5.6-sol` for openai via
`model-tier-inventory.tsv`, unchanged from the original stamp — only the
provider is now pinned, not the capability tier).
