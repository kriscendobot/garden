---
role: gardener
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Garden library edit: ocap framing, bearer tokens versus identity

Maintainer ruling (kriskowal, liaison session 2026-10-17): a bearer token is not incoherent with object capabilities. The distinction is whether the token refers to an **identity** (ambient or master authority) or to a **specific object that represents the designated authority**. Provenance: the minion.town PR #180 review, where the decomplector seat repeatedly cited "not a bearer token" (parent design §7) as a violation.

Edit `main2` directly in the garden repo (no PR, per CLAUDE.md § Conventions), in a per-job worktree, never in the deployed root:
1. `roles/jurors/decomplector/AGENT.md`: add an operating norm that "bearer token" alone is never a finding; ask whether it designates one attenuated object or an identity, and flag only identity-shaped tokens.
2. `skills/ocap-attenuation-authoring/SKILL.md`: add the same test under Notes, with the provenance, without turning the stub into a procedure.
3. Check the other jurors that could repeat the misreading (`warden`, `locksmith`, `gateway`, `breaker`) and add a one-line pointer only where they discuss tokens or capabilities.
Keep edits short and match surrounding style. Report the commit hashes.

---
claim:
  host: oros-studio-garden-ce242c49
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-17T14:49:38Z
