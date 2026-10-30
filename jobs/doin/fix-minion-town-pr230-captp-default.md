---
posted_at: 2026-10-30T03:09:51Z
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Revise the design PR https://github.com/kriscendobot/minion.town/pull/230 (`designs/clip-governor-column.md`, branch `design/clip-governor-column`) with the maintainer's answers (kriskowal, 2026-10-30, relayed by the liaison). Read the PR comments and the rubric as updated on main2 (skills/api-transport-rubric/SKILL.md, commit d3604334bf3; https://github.com/kriscendobot/garden/blob/main2/skills/api-transport-rubric/SKILL.md).

Answers:
- **(g)** Clips form a **tree**. A released child is **immediately destroyed along with all of its children** (destroy cascades). Reparenting is explicitly deferred ("we can talk about reparenting again later"): record it as a deferred item, not an open question. Rewrite rung 5/6 and the destroy invariants and tests accordingly (cascade order, crash safety mid-cascade, what the owner sees).
- **(h)** **Use CapTP in general, REST only where absolutely necessary** (the rubric's new Default section). Re-score every endpoint in the design under that default. REST remains only for bootstrapping the session (login, the locator mint) and callers that cannot speak CapTP. So the powers read (rung 1), clone and clone-with-alternate-powers (rungs 2-3), destroy (4), and the clip list's governor link become methods on a CapTP facet. Rung 3's clone plan then passes references, not pet-name strings, which resolves the override-2 tension.
- **(i)** Confirmed as you read it: eject puts the ejected clip as the leftmost column after the gutter, and every other column shifts right to make room, making visible the clip that was previously represented by the gutter.

This surfaces a prerequisite: the shell (the chrome page, `deploy/aws/www/shell.js`) currently speaks REST only and holds no CapTP session to the owner's facet (verify this on `main`). Add a **rung 0: the shell opens an authenticated CapTP session to an owner facet**, bootstrapped by the minimum REST (login cookie, then a minted, expiring, revocable locator, following the #228/#88 nonce-locator pattern), carrying no powers beyond the facet it names. Specify it with the same detail as rungs 1-3 (what the session is, how it is bound to the chrome origin and unreachable from any clip, reconnect and revoke, tests including a hostile clip that cannot reach it). Rung 1 then reads powers through that session. Keep rung 0 as small as it can honestly be; if it can be split (session + one trivial method first), split it.

Also: remove (g), (h), (i) from `## Open questions`; keep (f) (rung 9 only) and add any new ones. Re-run the mermaid parse check on touched diagrams, keep the PR a draft, update the PR body, leave a summary comment. Do not post any build job.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 3
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-30T03:10:14Z
