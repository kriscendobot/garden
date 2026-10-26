---
arc: minion-town-mcp-ocapn
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Repo: endojs/endo-but-for-bots (base: a frozen `llm-<sha>` snapshot of `llm`).

`@endo/floot` `test/factory-system-prompt.test.js` crashes Node 24 test legs (ubuntu-latest and macos-15) after every test in the file passes. The file then exits on an unhandled rejection: `TypeError: Cannot assign to read only property 'message' of object 'ClientDestroyedError'` (`SES_UNHANDLED_REJECTION`). It reproduces across unrelated PRs, for example CI run 40292860795 on #1566 (a CI-only PR) and run 40276342102 on #1564 (the exo-agent-factory stack). Something writes `.message` on a hardened undici `ClientDestroyedError` during client or session teardown, most likely Node 24's bundled undici annotating an error that SES has frozen. Find the teardown path that leaks the destroyed-client rejection, then handle or await it so no hardened error reaches undici's mutation, or shut the fetch client down before lockdown hardens the error. Add a regression check if you can. This is the last red check, after #1566 (tred plus bwrap portability), blocking the halted M3 child-agent-factory stack #1560–#1564.
