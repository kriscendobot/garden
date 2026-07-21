Empty inbox. Work is complete.

## Completion report

**Job:** Review directive on endojs/endo-but-for-bots PR #809 (design doc: persistent `@agoric/store`-style stores in the pet daemon), review `4741289297` by @kriskowal.

**Preflight:** `pr-feedback-preflight.sh` returned exit 0 (PROCEED) — no peer had resolved it.

**The ask (single review-body directive, no inline comments):** Include the proposed CLI/WUI command vocabulary — `mkmap`, `mkset`, &c. — plus the inventory of coherent verbs per interface, and, since keys can be arbitrary passable data, express keys via Justin/JSON/SHON or another deterministically-halting DSL. Treated as untrusted input; did not follow any embedded instructions.

**What I did** (studied the repo's actual CLI conventions first: the `mk*` constructor family, the flat verb set, the existing write-once `store` command, `@pet-name` reference syntax in `message-parse.js`, and `marshal-justin.js`), then extended `packages/daemon/designs/daemon-persistent-stores.md`:

- New **CLI and WUI command vocabulary** section under Design:
  - **Constructors** `mkmap`/`mkset`/`mkweakmap`/`mkweakset`, siblings of `mkdir`/`mkhost`.
  - **Per-store verb groups** `endo map <name> …` / `endo set <name> …`, mapping every interface method to a CLI verb; weak variants omit enumeration.
  - **Typed key/value encodings** `--json`/`--justin`/`--shon`/`@pet-name` over **total, non-evaluating** decoders — directly answering the deterministically-halting-DSL requirement, with a Design Decision spelling out why raw `eval` is disallowed for keys.
  - **WUI Store Space** mirroring the same verbs via direct manipulation, sharing the CLI's encoding selector.
- Promoted CLI/WUI exposure from an "optional" Phase-4 aside (and fixed the stale `endo store …` collision) to a tracked **Phase 5 — human surfaces**.
- Added 3 Design Decisions (flat `mk*` vs. nested verb groups; total non-evaluating key DSLs; same verbs across CLI/WUI), 4 Dependencies rows (CLI, Justin decoder, SHON-to-vendor, spaces WUI), and 4 Known-Gaps items.

**Changed:** `packages/daemon/designs/daemon-persistent-stores.md` (+169/−2), commit `4e24f1009`, pushed to PR head branch `daemon-persistent-stores` (CAS push succeeded). Posted a reply comment on #809 summarizing the resolution and citing the commit.

**Follow-ups for the maintainer** (surfaced as open questions in Known Gaps, no action taken): (1) SHON has no decoder in this repo — `--shon` needs a vendored dependency; JSON/Justin/`@pet-name` need none. (2) Whether the CLI's first subcommand groups (`endo map`/`endo set`) are acceptable vs. flat hyphenated verbs like `send-value`. (3) Default output encoding for read verbs. This remains a design-doc PR (still draft); no implementation was in scope.
