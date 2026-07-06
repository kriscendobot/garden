Repo endojs/endo-but-for-bots — refresh PR #134 (https://github.com/endojs/endo-but-for-bots/pull/134) as the canonical docker self-host + remote-auth PR.

Task: rebase #134 onto its current base; wire the verified ws-gateway.js CIDR remote-auth — available on branch `wip/daemon-docker-selfhost-gateway-remote-auth` (off origin/llm tip 1132289): cidr.js `makeAddressChecker` into ws-gateway.js (localhost-only by default; `ENDO_GATEWAY=remote` / `ENDO_GATEWAY_ALLOWED_CIDRS` opt-in; closes disallowed clients), daemon-node.js env reads, and 5 green ws-gateway.test.js tests (reject test regression-proven). Add the CI test kriskowal requested on #134 and address the CHANGES_REQUESTED review.

Maintainer decision, 2026-07-06: wire remote-auth into ws-gateway.js now (NOT wait for @endo/gateway). Leave #568 (0xpatrickbot, mention-only) and #608 (already-un-drafted docker-image slice) untouched; surface the #568/#608 consolidation state in the completion summary for the maintainer.

(liaison inbox thread: build-endo-but-for-bots-daemon-docker-selfhost.)
