---
source: packages/where/index.js
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/blob/master/packages/where/index.js
source_path: packages/where/index.js
section_kind: source
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - tooling
  - daemon
  - getting-started
genre: §endo-source-comment-fragment
cycle: 167
lane: chat
status: current
title: §XDG_RUNTIME_DIR for ephemeral state
parent: endo--packages-where-index-js--four-state-domain-path-resolution-with-XDG-precedence-and-platform-fallback-chain
---

```js
export const whereEndoEphemeralState = (platform, env, info) => {
  if (env.XDG_RUNTIME_DIR !== undefined) {
    return `${env.XDG_RUNTIME_DIR}/endo`;
  } else if (platform === 'win32') {
    return `${whereHomeWindows(env, info)}\\Temp\\Endo`;
  }
  ...
```

§XDG_RUNTIME_DIR is the §canonical-tmpfs-cleared-on-reboot
location on systemd-managed Linux systems. §OS-cleans-up-
on-reboot is the §intended-PID-file-and-socket-lifecycle.

§Why-not-just-/tmp: `/tmp` on most systems is *not* cleared
on reboot (only on `tmpwatch` schedule, weeks); §XDG_
RUNTIME_DIR is §guaranteed-cleared-on-logout. §PID-files-
after-reboot-are-misleading; §XDG_RUNTIME_DIR-prevents-this.
