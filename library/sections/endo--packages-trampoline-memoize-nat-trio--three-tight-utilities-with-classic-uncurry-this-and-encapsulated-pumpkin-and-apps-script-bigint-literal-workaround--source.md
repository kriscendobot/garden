---
title: Source
source: endo packages/{trampoline,memoize,nat}/{src/*.js,README.md,docs/memoize.md}
source-slug: endo--packages-trampoline-memoize-nat-trio
ingest-cycle: 199
ingest-date: 2026-06-06
lane: chat
authors: [Mark Miller, Kris Kowal, Endo contributors]
related:
  - endo--packages-base64 (cycle 181: §three-tier-dispatch + §Reflect.apply capture sibling)
  - endo--packages-cli-src-utility-cluster (cycle 195: §six-tight-utilities-with-no-internal-dependencies sibling)
  - endo--packages-panic (cycle 197: §Eval-Twin-Problem cross-reference; memoize.md cites endojs/endo#1583)
  - endo--packages-pass-style (cycle 71+: passStyleOf is the §canonical-memoize-user named in memoize.md)
keywords:
  - three-tight-utilities cluster
  - classic-uncurry-this via bind.bind(bind.call)
  - encapsulated-pumpkin sentinel for recursion-protection
  - contingent-safety framing
  - four-tier safety hierarchy (defensiveness / unobservable / preserves-isolation / not-communications-channel)
  - sync/async two-color sharing via generator trampoline
  - generator-throw send-error-into-generator
  - Apps-Script-bigint-literal-workaround
  - two-different-error-types (TypeError type / RangeError range)
  - safely-representable IEEE-754 integer discipline
  - freeze-as-harden-substitute pending PR #3008
parent: endo--packages-trampoline-memoize-nat-trio--three-tight-utilities-with-classic-uncurry-this-and-encapsulated-pumpkin-and-apps-script-bigint-literal-workaround
---

- `endo packages/trampoline/src/trampoline.js` — 59 lines + `types.d.ts` 24 lines + `README.md` 101 lines (sync + async generator-based trampolining)
- `endo packages/memoize/src/memoize.js` — 54 lines + `README.md` 76 lines + `docs/memoize.md` 176 lines (memoize with encapsulated-pumpkin recursion-protection)
- `endo packages/nat/src/index.js` — 119 lines + `README.md` 116 lines (isNat predicate + Nat assertion; ZERO_N + ONE_N bigint constants)

Cycle 199 of `/loop resume the librarian work.` (chat-lane; alternates from cycle 198's designs-lane patterns-diagnostic-feedback; §thirty-third consecutive designs/chat alternation cycle 166-199).

§Eighteenth-member of §small-files-with-large-knowledge-density family (cycles 165 + 167 + 169 + 171 + 173 + 175 + 177 + 179 + 181 + 183 + 185 + 187 + 189 + 191 + 193 + 195 + 197 + 199).
