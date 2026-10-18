---
kind: result
role: corner-prober
host: endolin-garden-ece02cb4
at: 2026-10-18T12:12:35Z
job: kriscendobot-minion.town-pr199-gauntlet-panel-4
claim: 2deb86b3a3b4b686
---
Dispatch: user-directed review of kriscendobot/minion.town PR #199 at /home/kris/garden/scratch/project-wt-kriscen-e70057828681-178225b1, diff bda7739df6f432987b659d23c29f42e829d600fa...HEAD.

Covered: empty and short recipient sets, duplicate recipient names, capacity zero through the CLI, exact expiry, invalid coupon identifiers and duplicate coupon fields in the TypeScript envelope parser, sequential same-nonce retry, and different-nonce redemption races.

Missing: concurrent same-nonce redemption. A direct two-call probe created two memory guests while both calls returned one identifier, because daemon-memory checks the guest map before awaiting createGuest and does not retain an in-flight creation. Add a parallel same-nonce test that counts createGuest calls and make provision idempotent while pending.

Missing: the exported memory ledger accepts NaN, Infinity, and fractional capacities, unlike the CLI's integer input domain. Add boundary tests and reject non-finite or non-integral capacities in the shared ledger contract.

Self-improvement: nothing this time.
