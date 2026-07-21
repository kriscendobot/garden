Reported on https://github.com/kriskowal/garden/issues/58#issuecomment-5029492310.

No deployment was safe or needed. Confirmed main has no CD-managed daemon, guest/MCP bridge, or wildcard weblet gateway. Fresh probes observed OAuth/MCP boundaries and a `101` OCapN WebSocket upgrade, but no bootstrap route or weblet DNS.

Next: Gate 1 redirect/V5 evidence, then build and review the CD-managed daemon and bridges. Removed the temporary project worktree.
