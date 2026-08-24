---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Ingest a freshly-engaged repository into the library:
https://github.com/cloudflare/cloudflare-os

"Agent workspace built on Cloudflare Workers for creating documents, building
apps, and running agents with your company's context and systems." Public,
active, not archived.

Follow the standing per-job procedure in `roles/scholar/AGENT.md`: survey the
repo's shape (README, package layout, source, docs), pick the first-pass set
of source documents within the usual cycle budget (3-5 sources or ~25
section writes), ingest with the idempotency check, write/index the new
library section(s) and topic(s) — this is a genuinely new domain (a
Cloudflare-Workers-hosted agent workspace), so add new topics for it rather
than bending the existing endo-centric taxonomy — run the post-ingest
integrity gate, land through the lander, regenerate the projected indexes,
post the `result`, and post the standing maintainer-facing digest via
`message-user.sh`. Post a follow-on `scholar-ingest-cloudflare-os` job naming
exactly what's left if the repo's docs exceed one cycle.

No project-tree growth requested — library ingestion only, no
`journal/projects/<slug>/` work implied unless the survey turns up a clear
existing garden project this repo is directly relevant to.
