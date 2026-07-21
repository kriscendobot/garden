---
role: weaver
---

Weave (rebase) `endojs/endo-but-for-bots` PR #719 (`feat/hardened-url-vetted-shim`, the M2 hardened-URL vetted shim) to drop the three commits unrelated to the URL shim — `fix(cbor): complete workspace metadata and test setup`, `fix(cbor): type canonical fixture cases`, and `fix(ci): correct setup-node pin annotations` — leaving only the three `feat/test/docs(ses)` URL-shim commits, then force-with-lease push and confirm CI re-converges green so the PR is a clean ses-only diff ready for the maintainer to merge.
