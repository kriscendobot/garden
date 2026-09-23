---
title: §Persistence with atomic write-then-rename
source-slug: endo-but-for-bots--llm-designs-endoclaw-timer
source-url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/endoclaw-timer.md
authors: [Kris Kowal (prompted), Joshua T Corbin (evolving)]
repo: endojs/endo-but-for-bots
path: designs/endoclaw-timer.md
total-lines: 837
ingest-cycle: 244
ingest-date: 2026-06-08
lane: designs
parent: endo-but-for-bots--llm-designs-endoclaw-timer--two-author-fields-and-heartbeat-vs-cron-split-and-start-to-start-timing-and-TickResponse-one-shot-exo-with-three-fates-and-missed-ticks-coalesced-not-replayed
---

§Atomic-write-via-write-then-rename established in `synced-pet-store`:

```
async function atomicWriteJSON(filePowers, targetDir, fileName, value):
    temporaryPath = filePowers.joinPath(targetDir, `.tmp.${randomHex()}`)
    finalPath = filePowers.joinPath(targetDir, fileName)
    await filePowers.writeFileText(temporaryPath, JSON.stringify(value) + '\n')
    await filePowers.renamePath(temporaryPath, finalPath)
```

§Atomic-rename-after-write as named persistence pattern. §The-temporary-path-uses-`.tmp.`-prefix-plus-random-hex + §the-final-path-is-the-canonical-name + §the-rename-is-atomic-on-POSIX. §When-a-persisted-entry-must-be-readable-or-completely-absent-not-partially-written, §write-to-a-temporary-path-and-rename-atomically. §Sibling-to-cycle-166's-daemon-mount POSIX-rename-atomicity discipline.

§In-memory-`Map<string, NodeJS.Timeout>`-NOT-persisted-rebuilt-on-startup — §the-in-memory-state-is-derived-from-the-persisted-state + §the-persisted-state-is-the-source-of-truth + §the-in-memory-state-is-the-cache. §When-restart-is-a-real-scenario, §design-the-in-memory-state-as-derived-from-the-persisted-state-not-the-other-way-around.
