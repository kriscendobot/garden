---
gate: orchestrated
orchestrated_by: garden-book-orch
priority: normal
posted_by: producer
posted_at: 2026-09-30T03:44:26Z
---

---
handler-timeout: 7200
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Garden book, chapter 4: Creating your own instance

One chapter of a multi-part "book" (orchestration `garden-book-orch`). Write
to `journal/projects/garden-book/ch4-creating-your-own-instance.md` as
Markdown. This is the practical "how do I stand up my own garden" chapter —
the counterpart to chapter 1's historical metamorphosis narrative.

## Ground this in real sources

- `CLAUDE.md` § Host environment (the `GARDEN` identity derivation, the
  container mirroring model, the bot git identity bootstrap) and § Container
  guard.
- `scripts/check-in-container.sh` and the guard's rationale.
- `context/operations/starting.md` and `context/first-run/identity.md` — the
  actual bring-up procedure and identity rules.
- `designs/turnkey-garden-host.md` in full — the AWS turnkey-host design
  (AMI/launch-template pipeline, the two supported GitHub-credential paths,
  the decisions table, the implementation script inventory under
  `scripts/aws/turnkey/`), and its operator runbook
  `context/operations/turnkey-host.md` if present.
- `README.md`'s own onboarding framing, if it addresses first-time setup.

## What this chapter should cover

1. **The container model.** Why the garden runs inside a container that
   bind-mounts the host directory, what the container guard protects
   against (accidentally operating on the host under the maintainer's own
   identity), and how to tell which side you're on.
2. **Identity.** How a `GARDEN` identity is derived from the checkout's
   path, why it must be unique across running instances, and the
   multi-instance recipe.
3. **Bot credentials.** How the bot git identity and GitHub PAT get
   provisioned (the per-host journal override vs. the tracked canonical
   default), and the two supported `gh` login paths (interactive vs. a
   scoped Secrets Manager PAT for a turnkey AWS host).
4. **Bring-up, step by step**, following the actual starting procedure:
   linger, unit install/enable, sizing the worker pool, designating the
   leader, arming the liaison's monitors, the optional armings.
5. **The turnkey path**, for someone who wants a disposable/automatable
   host rather than a hand-provisioned one: the AMI pipeline, launch
   template, credential-free smoke test, and the two GitHub-login options
   the design resolved.
6. **What "creating your own" actually produces**: a new, independent
   instance running the same library against its own journal fork/state —
   tie this back to chapter 1's metamorphosis framing (each instance can
   itself evolve independently from here).

If a script or file this chapter should cite doesn't exist yet (the design
may be ahead of full implementation in places), say so plainly rather than
inventing detail.
