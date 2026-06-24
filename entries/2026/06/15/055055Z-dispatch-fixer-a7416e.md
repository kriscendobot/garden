---
ts: 2026-06-15T05:50:55Z
kind: dispatch
role: fixer
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: "*"
dispatch_root: /home/kris/dispatches/fixer--a7416e
short_id: a7416e
prs:
  - { repo: endojs/endo-but-for-bots, pr: 411, role: target }
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/411
  - https://github.com/endojs/endo-but-for-bots/pull/411#issuecomment-4641543763
---

# dispatch: fixer — rsvp #411: broader browser-test investigation per kriskowal directive

Maintainer directive (2026-06-07 top-level comment on #411):

> Please note that the fix did not fix the browser-test CI
> job. We will need a broader investigation to identify a
> solution to the browser-test problem. We appear to fail
> this test regardless of timeout. It may be a version-
> specific problem and we may need to probe for a version
> that works, but not so old that it has critical
> vulnerabilities. Please search for similar issues and
> solutions.

The prior fix (caching + retry-install) addressed install
timeout but not the underlying failure. The browser-test
job fails regardless. Investigation directives:
1. Probe for a Playwright version that works.
2. Honor the floor: not so old that it has critical
   vulnerabilities (CVE check).
3. Search for similar issues and solutions (Playwright +
   Endo issues; CI provider-specific quirks).

Full brief in the prompt.
