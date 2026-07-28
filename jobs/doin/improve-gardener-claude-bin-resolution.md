scripts/jobs/handlers/gardener-claude.sh
`command -v claude || die` (line 182) is a single-probe, zero-tolerance resolution of the agent binary, and it is the direct cause of the ps23 outage above. Two hardenings:

1. **Resolve robustly instead of trusting the inherited PATH.** The image installs the CLI at `/usr/local/bin/claude` (Dockerfile ~line 145, npm global under the `/usr/local` prefix), but `systemd --user` units carry no `Environment=PATH` — no unit under `scripts/systemd/` sets one — so the handler runs on whatever PATH the user manager happened to inherit. A native-installer or nvm-prefixed CLI lands somewhere else entirely (`$HOME/.local/bin`, `$HOME/.claude/local`). Add a `claude_bin()` resolver in `common.sh` that probes PATH first, then the known install locations, and have every handler that shells out to `claude` use it. Alternatively (or additionally) pin `Environment=PATH` on the gardener unit so the fleet's PATH is declared rather than inherited.

2. **Do not treat a momentary absence as fatal.** An in-place `npm install -g @anthropic-ai/claude-code` — which the image now performs against a version floor (`CLAUDE_CODE_MIN`, recent commit "carry the claude CLI upgrade into the image") — unlinks the global bin for a window. Give the probe a short bounded retry before failing, and exit with a code that marks the failure as **environmental** so `gardener.sh` can classify it as transient (see the companion job) rather than as a defect in the job that happened to be claimed at that moment.

The same bare-`command -v`-then-`die` shape appears in the sibling handlers (`triager-claude.sh:64`, `watchman-claude.sh:42`, `bulletin-claude.sh:26`, `proxy-claude.sh:38`, `follow-up-claude.sh:99`); route them through the shared resolver in the same change.

---
claim:
  host: ps23
  gardener: 8
  worker_kind: gardener
  claimed_at: 2026-07-28T02:53:56Z
