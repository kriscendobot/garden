---
title: Contributing back to Git, and what comes next
source_kind: web
source_url: https://openai.com/index/scaling-git-at-openai/
source_snapshot: http://web.archive.org/web/20261110004756id_/https://openai.com/index/scaling-git-at-openai/
source_content_sha256: f93cf33cc74d4badf1d49db844bf99ef616bba6e2d3cf0f59a11ef638a1cb48e
source_authors: [Aaron Friel, Taylor Blau, Ted Nyman]
source_date: 2026-11-02
retrieved: 2026-11-12
ingested: 2026-11-12
ingested_by: scholar
topics: [source-control-architecture]
status: current
---

Abstract: The upstream-Git side of Pando and the outlook. Serving reusable packs made **downloading and indexing packs** central, which surfaced client edge cases in concurrent downloads, cleanup after interrupted transfers, and resuming already-completed downloads; OpenAI fixed them, added validation when accepting an existing pack for a fetch, and sent the work upstream, plus **tracing for `packfile-uri` downloads and byte counts for pack generation** to tell generation time from transfer time. OpenAI's own Git build also **downloads and indexes independent packs in parallel** and adds **"explicit haves"**, letting a server advertise a branch's current tip separately from the history a pushing client may omit, so `--force-with-lease` can check that a feature branch has not moved while the client still builds its pack against trunk alone (keeping the pack reusable by anyone holding trunk). Several changes are already upstream, more are in OpenAI's public repository and patch tracker. Next: other uses inside OpenAI, notably workloads where large numbers of agents collaborate on one shared Git repository, and ways to share the technology externally.

### Contributing back to the Git project

Building Pando on the Git protocol and client helped OpenAI find bugs and opportunities to improve Git's own performance.

Pando serves reusable packs directly to clients, so **downloading and indexing those packs** became central to making the system fast and reliable. That work surfaced edge cases in concurrent downloads, cleanup after interrupted transfers, and resuming downloads that had already completed. OpenAI fixed those paths, added validations when accepting an existing pack for a fetch, and contributed the work upstream.

To see where time and bandwidth were going, they added **tracing for `packfile-uri` downloads** and **byte counts for pack generation**, making it easier to tell whether a slow fetch was spending its time generating packs or transferring them.

In OpenAI's Git build, the client can **download and index independent packs in parallel**. They also added the concept of **"explicit haves"**, so a server can advertise a branch's current tip separately from the history a pushing client may leave out of its pack. On Pando this lets clients use `--force-with-lease` to check that a feature branch hasn't moved while building its pack against trunk alone; anyone with that trunk history can then fetch the branch using the same pack.

Several of these improvements are already in upstream Git and many others are in OpenAI's public repository; the work continues with the Git community through a public patch tracker.

### What's next

Pando lets OpenAI scale its monorepo without changing the Git workflows engineers and agents already use; it has unlocked more parallelism, improved merge reliability, and cut the time to publish code changes. OpenAI is also exploring other internal uses, **including workloads where large numbers of agents need to collaborate on a shared Git repository**, and ways to share the technology with its users, while continuing to work with the open-source Git community on improvements that benefit Git users broadly.

Source: [Scaling Git at OpenAI](https://openai.com/index/scaling-git-at-openai/#contributing-back-to-the-git-project) by OpenAI, 2026-11-02. Captured via the Internet Archive (`source_fetched_via=wayback`, the canonical host returned HTTP 403); content SHA-256 `f93cf33c`.
