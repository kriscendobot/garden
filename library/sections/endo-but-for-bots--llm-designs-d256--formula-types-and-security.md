---
title: The 26 formula types, security considerations, and the no-backward-compatibility migration
source: designs/daemon-256-bit-identifiers.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: bcb6c379325b0f66d211d759ce7d3031fbf94e5b
source_date: 2026-02-24
source_authors: [Kris Kowal]
topics: [daemon, capability-security]
status: current
---

## The 26 formula types

The migration listed the complete set of formula types as a stable
reference for the cluster. From `formula-type.js`:

`directory`, `endo`, `eval`, `guest`, `handle`, `host`, `invitation`,
**`keypair`**, `known-peers-store`, `least-authority`, `lookup`,
`loopback-network`, `mail-hub`, `mailbox-store`, `make-bundle`,
`make-unconfined`, `marshal`, `message`, `peer`, `pet-inspector`,
`pet-store`, `promise`, `readable-blob`, `resolver`, `worker`.

That is 25 names + `eval` listed twice in the source's bulleted form,
totalling 26 formula types in the post-migration daemon (the design
text says "26"). The newly-added one in this migration is **`keypair`**
(see [[endo-but-for-bots--llm-designs-d256--per-agent-keypairs]]).

This list is the **formula-type taxonomy** that every other daemon
design implicitly references when speaking of "a formula":

- Identity / agency: `host`, `guest`, `handle`, `keypair`, `peer`.
- Naming / lookup: `pet-store`, `pet-inspector`, `lookup`, `directory`,
  `known-peers-store`.
- Messaging: `mailbox-store`, `mail-hub`, `message`, `invitation`.
- Execution: `worker`, `eval`, `make-bundle`, `make-unconfined`,
  `marshal`.
- Promises: `promise`, `resolver`.
- Content: `readable-blob`.
- Network: `loopback-network` (and other network types arriving later).
- Policy: `least-authority`.
- Root: `endo`.

Future cycles ingesting daemon designs should cross-reference this
list when introducing new types; e.g., the `retention-set` and the
`network` formula types added by later designs extend this taxonomy.

## Security considerations

| Concern | Resolution |
|---|---|
| **256-bit random** | Provides 2^256 collision resistance; birthday-bound 2^128 attempts to find a collision exceeds any conceivable adversary's computational capacity. |
| **SHA-256** | 128-bit security against collision attacks (birthday bound); 256-bit security against preimage attacks. Adequate for content addressing where an attacker would need a collision to substitute malicious content. |
| **Ed25519** | 128-bit security level. Public key is the permanent identifier; private key authenticates during OCapN-Noise handshakes. Signatures are deterministic — no nonce-reuse vulnerability. |
| **Migration weakening?** | None. 256-bit security is considered safe against quantum computers with Grover's algorithm (Grover gives effective 128-bit security against 256-bit primitives). |

The asymmetry between the *128-bit-effective* security of the
primitives (under birthday or Grover attacks) and the *256-bit*
identifier length is intentional: the identifier length is set by
*peer-key alignment with Ed25519*, not by a target security level.
The 128-bit effective security is the floor; the 256-bit length is
what aligns with the protocol layer.

## Migration discipline: no backward compatibility

The migration **breaks** on-disk state. Three explicit notes:

- **No backward compatibility.** The migration does not maintain
  compatibility with the original 512-bit identifiers.
  > *All test users must purge their daemon state
  > (`rm -rf ~/.local/state/endo/`).*
- **Clean slate.** Fresh daemon state is assumed.
- **Future versioned identifiers.** *"Future work may introduce
  versioned formula identifiers if backward compatibility becomes
  necessary"* — explicitly deferred, not solved.

The acceptance of "purge and restart" as a migration mechanism is
itself an instance of Formula Persistence's *destruction by cohort,
reconstruction on demand* pattern at the daemon's own lifecycle
boundary: rather than write a state-conversion tool, the design
relies on the system's ability to *reconstruct from formulas* (in
this case, from no formulas — a fresh start). The OCapN-Noise
alignment removes the need to maintain two separate peer-ID schemes,
so the cost of the clean-slate migration is paid once, against a
permanent simplification.

## Upgrade and compatibility considerations

- **State purge required.** `rm -rf ~/.local/state/endo/
  ~/.config/endo/`
- **No automatic migration.** Manual state purge required. Future
  work may provide migration tooling.
- **Network protocol unchanged.** OCapN-Noise already uses Ed25519
  keys — this migration aligns the daemon-internal ID scheme with
  what the wire already carried.
- **API stability.** The daemon API returns identifiers; callers
  should *not* assume identifier length. TypeScript branded types
  enforce this — code that previously held a 128-char hex string
  unbranded would compile-error if it tried to mix lengths post-
  migration.
- **Documentation update.** Any user-facing documentation that
  references identifier format or length needs updating.

## Test plan (as recorded in the design)

1. **Unit tests for crypto functions**: `randomHex256()` returns
   64-char hex; `makeSha256()` produces correct digests;
   `generateEd25519Keypair()` returns valid keypairs.
2. **Validation tests**: `isValidNumber()` accepts 64-char hex,
   rejects 128-char; `parseId()` correctly parses new format;
   `formatId()` produces valid identifiers.
3. **Integration tests**: fresh daemon starts with 256-bit
   identifiers; formula storage uses new path format; content
   addressing uses SHA-256; locators parse correctly; keypair JSON
   files appear in test state directories; agents have `@keypair` in
   their special names.
4. **Cross-package tests**: CLI commands handle new identifier
   format; chat displays identifiers correctly.

## Future work pointer

> *Network registration, per-agent connection hints, locator
> construction with agent keys, and the null local node sentinel are
> covered in `daemon-agent-network-identity.md`.*

That design is a sibling not yet ingested. The
[[endo-but-for-bots--llm-designs-dlt--local-node-sentinel]] section
implements the LOCAL_NODE sentinel piece referenced here.
