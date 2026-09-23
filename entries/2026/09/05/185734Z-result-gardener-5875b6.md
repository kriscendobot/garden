---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-09-05T18:57:36Z
---
---
kind: result
role: skeptic
repo: kriscendobot/minion.town
project: minion-town
---

Design-panel seat `skeptic` on kriscendobot/minion.town PR #95
(`designs/mcp-guest-surface-documentation.md`, diff base `origin/main`).

### skeptic

**Verdict:** request-changes

**Findings:**

- § 1 `remove`: the premise that the fix lives "at the facet rather than by
  re-classifying error text at the tool" does not hold. `GuestFacet.remove`
  delegates to `E(guest).remove(name)` over CapTP
  (`src/endo/root-host-socket.ts:263`), which resolves to `undefined` or
  rejects — there is no absent/present signal to return. The only way to
  synthesize `✅ "name" was already absent.` is to catch the daemon's rejection
  and match its message: the exact string match the design claims to eliminate,
  relocated from `guest-tools.ts` to `guest-control.ts`. The supporting citation
  is soft in the same direction — "`GuestAgent.remove` already documents 'no-op
  if absent'" is a local doc comment (`src/endo/guest-control.ts:68`) honored
  only by the in-memory fake (`src/endo/guest-memory.ts:90`, `Map.delete`) and
  falsified by the campaign's own live `Formula does not exist` evidence. Name
  the mechanism (pre-`has` probe, daemon-side change, or an owned string match)
  or the implementation cannot follow. [proposed-rule: a design that relocates a
  behavior must name the concrete mechanism at the new site, not only the site.]

- § Verification bullets 5 and 7 cannot fail on today's code. The tool tests are
  backed by `makeInMemoryGuestHost` (`test/endo-guest-tools.test.ts:32,67`),
  whose `remove` is already a silent no-op for an absent name and whose
  "sessions" share one `Map`. "`remove` succeeds for a missing name" and "a value
  written in one fresh tool session is readable in another" therefore pass
  against the unmodified implementation, while the one path § 1 actually changes
  — the live daemon — is never exercised. [rule: skills/regression-evidence/SKILL.md]

- § 1 `maxLength: 255` is not a faithful mirror of `assertValidPetName`
  (`src/endo/guest-control.ts:226`), which bounds `name.length` in UTF-16 code
  units, whereas the JSON Schema published to `tools/list` bounds code points. A
  200-emoji name passes the advertised schema and is rejected by the daemon —
  exactly the input class the design singles out as valid ("interior spaces,
  non-ASCII characters, and emoji are all valid"). The schema-aware caller the
  mirror exists to serve gets a wrong early answer. State the unit or narrow the
  claim. [proposed-rule: a schema value declared a "mirror" of a runtime check
  must mirror its unit of measure, not only its number.]

- § 2's recovery sentence points an **MCP** caller at a flow whose accept half is
  not on the MCP surface. The cited invitation § 7 tool table carries
  `guest_invite`, `guest_contacts`, `guest_introduce`, `guest_inbox` — no accept
  tool; shell states 1–3 are first-party *browser* states. The campaign's finding
  was that no *guest-surface* peer bootstrap exists; as cited, the companion
  design closes the invite half only. [proposed-rule: a design deferring a gap to
  a companion must confirm the companion covers the same surface, not only the
  same feature.]

**Notes (out of scope but worth flagging):**

- § 1 describes code that does not exist: nothing in `src/` re-classifies
  `Formula does not exist` by string match; `remove` reaches `toToolError`
  (`src/endo/guest-tools.ts:114`), which surfaces the message verbatim.
  [proposed-rule: a design's "current behavior" sentence is a claim about the
  checkout and must be grep-verifiable against it.]
- The absent-`remove` outcome flips `isError` from true to false, a breaking
  change to a published tool contract, with no compatibility note.
  [rule: skills/panel-review/SKILL.md]

Self-improvement: the sharpest premise attacks on this design all came from one
move — following each "already documents / already does X" citation to the line
and asking which *backend* satisfies it. Three of four findings are the
in-memory fake honoring a contract the live daemon does not. Proposing to
`skills/regression-evidence/SKILL.md` (via a `message` to liaison) that the
fake-vs-live split be named explicitly: a claim proven only against an in-memory
double is not regression evidence for a design whose whole subject is live
behavior.
