---
role: builder
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-09T18:52:03Z -->

---
role: builder
---

# Build: mount revocation + deny patterns (PR A of the #127 reconstruction)

Repo: endojs/endo-but-for-bots. Spec: `designs/mount-extensions-reconstruction.md`
§ "PR A — revocation and deny patterns" on design PR
https://github.com/endojs/endo-but-for-bots/pull/648 (branch
`design/mount-extensions-reconstruction`; read the design from that branch —
it may not be merged to `llm` yet).

Reconstruct the revocation caretaker (`makeRevocableMount`, `EndoMountControl`,
formula `onCancel` wiring) and the deny-pattern set with an overridable
`deniedSegments` creation option, on the CURRENT `llm` (not the stale #127
diff — see the design's drift section: `subView` not `subDir`, gate
`followNameChanges`, platform-conformance allowlist). Head branch
`feat/mount-revocation`, base a frozen `llm-<sha>` snapshot per
`skills/frozen-base-branch/SKILL.md`. PR #127 is the reference diff. Run the
standard PR-creation chain (`skills/pr-creation-flow/SKILL.md`). File the
CLI-plumbing follow-up the design names.
