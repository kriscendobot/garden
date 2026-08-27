---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Flesh out the rest of kriscendobot/minion.town's guest-facet MCP tool
inventory per `designs/mcp-daemon-guest-tools.md` § 5.1 (already built
through the read-side/B2ish tools live today: guest_status, guest_list,
guest_write_text, guest_read_text, guest_remove, guest_inbox).

**Priority: `guest_eval`.** The maintainer specifically wants to evaluate a
JavaScript program through this MCP server. § 5.1 already specs it exactly:
`E(guest).evaluate(worker, source, names, values)`, marked **not baseline**
— it mounts only for identities whose facet carries the evaluator grant.
Wiring the tool itself is the easy part; the real work is the **grant-site
policy decision** § 5.2 assumes but doesn't make: which identities get the
evaluator capability at `composeFacet`? Everyone connecting, or only
admin/trusted guests? Treat this as a real access-control call, not a
default-to-permissive wiring detail — evaluate is a much bigger capability
than the directory/mail read-write tools already live, and get explicit
sign-off on the grant policy before shipping it broadly.

**Then the rest of the JSON-representable surface**, per § 5.1's own stated
principle (curated, not reflected — the guest exposes 40+ methods, several
of which cannot cross the MCP boundary as JSON at all: far references,
`follow*` streams, `storeBlob`'s reader refs — do not attempt to mirror
those mechanically):
- The mail write-verbs (`request`, `send`, `resolve`, `adopt`, `dismiss`) —
  § 5.1 deferred these pending "the X2 long-promise exercise" (an
  async-handle idiom for `request`, which can pend for minutes). Check
  whether that exercise has landed since the design was written
  (2026-07-22); if not, this batch may still be blocked and should say so
  rather than force it.
- Any remaining directory methods worth a tool (`has`, `lookup`, etc.) that
  are genuinely JSON-representable and useful standalone.
- The define/form group, to the extent any of it is JSON-representable.

There is a parked follow-on job in `jobs/plan/`,
`minion-town-mcp-b2-first-guest-tools-gauntlet` — check it before starting
so this doesn't duplicate or conflict with work already staged there.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-27T22:53:08Z
