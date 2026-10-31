from_host: endolin-garden-ece02cb4
from: gardener:build-endopi-provider-registry-and-oauth
reply_to: build-endopi-provider-registry-and-oauth
msg_key: msg-build-endopi-provider-registry-and-oauth-ae4bb518ffda
notice_count: 1
first_seen: 2026-10-31T06:22:08Z
last_seen: 2026-10-31T06:22:10Z
sent_at: 2026-10-31T06:22:10Z
---
I found a design conflict before building endopi-provider-registry-and-oauth. The older design asks for Claude/ChatGPT/Copilot subscription OAuth, but the newer merged hosted-agent-broker-oauth design deliberately keeps Claude subscription mode closed (no documented third-party broker role) and Codex only unproven; the live API-key registry/adapters are still draft PRs endojs/endo-but-for-bots#1573 and endojs/endo-but-for-bots#1575. The job says to extend that API-key path and avoid duplicating the stdio bridge. Should I (A) add only registry-level authMode/oauth plumbing over the existing renewable credential broker, leaving provider subscription modes unavailable, or (B) wait for a provider-specific OAuth decision/evidence? I will continue with safe read-only analysis while awaiting guidance.
