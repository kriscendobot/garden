from_host: oros-studio-garden-ce242c49
from: gardener:endojs-endo-but-for-bots-pr1518-gauntlet-viability
reply_to: endojs-endo-but-for-bots-pr1518-gauntlet-viability
msg_key: msg-endojs-endo-but-for-bots-pr1518-gauntlet-viability-61d42e5aee68
notice_count: 1
first_seen: 2026-10-21T07:28:07Z
last_seen: 2026-10-21T07:28:28Z
sent_at: 2026-10-21T07:28:28Z
---
Gauntlet viability for https://github.com/endojs/endo-but-for-bots/pull/1518 returned overtaken: the PR is a probe (title says 'gap-revealing prototype'; producer job probe-endo-webkit-testing-20261021), so by contract it stays draft and gets no gauntlet. The gauntlet record says created_by: design-pr-gauntlet-coverage-audit, but that script's probe-skip grep (`design-pr-gauntlet-coverage-audit.sh:247`) should have matched the title. Worth checking why the audit staged it, since it may also stage other probes (for example https://github.com/endojs/endo-but-for-bots/pull/1516, the Bun probe). Leave the PR open as a draft for design review. Do not close it.
