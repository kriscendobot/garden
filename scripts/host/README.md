# scripts/host — host-only programs, run under the maintainer's identity

Programs here run **on the host**, under the **maintainer's own identity**, and are
explicitly **not** part of the `scripts/jobs/` fleet machinery: no gardener ever runs
them, they claim no job, and they hold no bot credentials. They are a sibling area to
`scripts/aws/` and `scripts/agoric/` — invoked by a human (or a host cron / `systemd
--user` timer the human sets up), never by the garden's autonomous fleet.

Because a host program runs outside the garden container, any credential material it
holds (a browser session token, an API key, an OAuth `storageState`) **must live
outside `<garden-root>`** — under `~/.config/…` with restrictive permissions — so the
container bind mount that mirrors the host filesystem cannot expose it to the
bot-identity fleet (CLAUDE.md § Container guard, § Host environment). A host program
communicates results back to the garden only by appending derived, non-sensitive data
to a staging file under the shared mount (e.g. `journal/inbound/…`), which a
garden-side deterministic timer then ingests with bot identity and the normal CAS-push
discipline. Never write git or hold a bot credential in a `scripts/host/` program.

## Contents

- `scrape-claude-usage.mjs` *(to be delivered by build job
  `build-claude-usage-dashboard-scraper`)* — reads the Claude.ai usage dashboard
  through an authenticated headless browser and appends readings to
  `journal/inbound/usage-scrapes/<host>.jsonl`. Design:
  [`designs/claude-usage-dashboard-scrape.md`](../../designs/claude-usage-dashboard-scrape.md);
  playbook: [`skills/claude-usage-dashboard-scrape/SKILL.md`](../../skills/claude-usage-dashboard-scrape/SKILL.md).
