---
role: designer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Design: host-side dynamic API-key injection proxy (replacing/augmenting container-recreation for key changes)

Maintainer directive (kriskowal, 2026-09-21). Today, adding or rotating a
provider API key requires exporting it on the host and recreating the
container (`scripts/systemd/seed-api-key-handoff.sh`'s allowlist bridge —
`ANTHROPIC_API_KEY`, `MOONSHOT_API_KEY`, `FIREWORKS_API_KEY`,
`OPENROUTER_API_KEY`, `OLLAMA_CLOUD_API_KEY`, and (pending a sibling job)
`TYPESAFE_API_KEY`). The maintainer wants to explore a host-side proxy that
injects the right provider's API key into outbound requests dynamically,
so a key can be added/rotated without touching any running container.

**Post this as a PR** on `kriscendobot/garden` (frozen-base-branch
mechanics per `CLAUDE.md`'s open-questions carve-out — snapshot the commit
immediately before the design lands as the base, design commit(s) on a
head branch) — this design will almost certainly carry genuine open
questions the maintainer needs to decide (see below), so it should not
land bare. Mark it `<!-- garden-design-open-questions -->` per convention.

## Groundwork already established (verify, don't re-derive from scratch)

- **SOCKS is the wrong primitive.** A SOCKS4/5 proxy relays raw TCP with no
  HTTP awareness — it cannot see or inject headers. This must be an
  **HTTP(S) forward proxy that terminates TLS** for the provider hostnames
  it injects credentials for (api.anthropic.com, api.openai.com,
  api.moonshot.cn, api.fireworks.ai, openrouter.ai, api.typesafe.ai, and
  whatever else is in the routing table) — decrypt, inject the header,
  re-encrypt, forward.
- **Requires a CA cert each container trusts**, so the proxy can present
  its own cert for the terminated hosts. This is a one-time trust
  provisioning cost (unlike API keys, a CA doesn't rotate often) — likely
  still baked at container-creation time via the existing image/entrypoint
  path, which is fine; the goal is eliminating recreation for KEY changes
  specifically, not for the CA itself.
- **Client cooperation**: verify whether `claude`/`codex`/`gh`/npm-yarn
  registry calls actually honor `HTTPS_PROXY`/`NO_PROXY` env vars, or need
  their own proxy configuration. Does not affect this repo's own
  `git@github.com:...` SSH-based journal/main2 pushes (different protocol,
  different credential class, unaffected either way).
- **The dynamic part (hostname -> key routing table, hot-reloadable via a
  watched config file or a local control socket) is the easy part** —
  design it, but it's not the risky piece.

## The real design questions (yours to work through, not to hand-wave)

- **Blast radius / centralization.** Every provider credential lives in one
  host-side process instead of today's per-container env-var handoff. That
  is better for rotation, worse for compromise blast-radius (one process
  holds everything). Weigh this explicitly against the status quo — don't
  just assert the proxy is strictly better.
- **Scope of TLS termination.** Blanket MITM of all outbound traffic from
  every container, or scoped to only the known provider API hostnames
  (passthrough/CONNECT for everything else)? Scoped is almost certainly
  right (smaller trust surface, smaller cert-pinning risk if any provider
  ever pins), but state the reasoning and the mechanism (an explicit
  allowlist of hostnames to terminate, everything else passed through
  untouched).
- **Fail-open or fail-closed on proxy failure.** If the host-side proxy
  process dies or is unreachable, do outbound API calls fail entirely
  (fail-closed — safer, but takes down every worker kind at once, a new
  single point of failure the fleet doesn't have today) or fall back to a
  direct connection using whatever the container's own baked-in
  environment already has (fail-open — preserves availability but
  reintroduces the exact "recreate to change a key" problem this design
  exists to remove, and only for the fallback path). Recommend one and
  justify it against this garden's existing fail-open/fail-closed
  precedents elsewhere (the budget-gate and comment-provenance work both
  set real precedent here — read `scripts/jobs/comment-provenance.sh`'s
  "FAIL OPEN, NEVER CLOSED" section and the `subscription-based-budget-
  model` job's "ask the maintainer, never auto-enable" gate for the two
  different postures this garden has already chosen in adjacent problems).
- **Relationship to `seed-api-key-handoff.sh`.** Does the proxy REPLACE
  that mechanism entirely, or coexist as a fallback/bootstrap path (e.g.
  the container still gets baked-in keys at creation for cold-start before
  the proxy is confirmed reachable, then prefers the proxy once up)? State
  a position.
- **Credential storage on the host for the proxy itself.** Where do the
  actual key values live for the proxy process to read (a host-local file,
  a secrets manager, systemd credentials)? This is a new secret-at-rest
  surface that doesn't cleanly map to the existing `/run/environment.d`
  tmpfs-volatile bridge pattern (which is itself deliberately volatile/
  container-scoped) — don't assume an answer, work through it.
- **Multi-host fleet implications.** The garden runs on multiple hosts
  (leader, garden2, oros-studio, potentially more). Is this ONE proxy per
  host, or a shared/replicated design? Each host currently has its own
  independent credential set (see `designs/fleet-gh-identity.md` and this
  session's subscription-per-host reality — `claude-endolin1`/`claude-
  endolin2`/`claude-oros` are genuinely separate, non-shared subscriptions;
  `codex-endolin` is shared across exactly two hosts) — the proxy design
  must respect that some credentials are host-exclusive and some are
  shared, not assume one global key set.

## Report / open questions section

Land the design with a real `## Open questions` section naming whichever of
the above (or others you surface) the maintainer should decide — this is
what triggers the PR-not-bare path, so don't skip it or pad it with
already-settled items.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-21T21:31:32Z
