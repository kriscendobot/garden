---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
endojs/endo-but-for-bots: root `package.json` declares `engines: node >=16`, but the openai v6 bump on PR #870 needs global `fetch` (Node 18+) — a documentation-accuracy fix to raise the stated engine floor.
