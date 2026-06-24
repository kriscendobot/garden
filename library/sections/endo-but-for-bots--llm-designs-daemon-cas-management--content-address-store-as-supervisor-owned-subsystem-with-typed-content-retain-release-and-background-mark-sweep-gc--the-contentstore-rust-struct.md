---
section: content-address-store-as-supervisor-owned-subsystem-with-typed-content-retain-release-and-background-mark-sweep-gc
source: endo-but-for-bots--llm-designs-daemon-cas-management
topics: [daemon]
status: current
title: §The ContentStore Rust struct
parent: endo-but-for-bots--llm-designs-daemon-cas-management--content-address-store-as-supervisor-owned-subsystem-with-typed-content-retain-release-and-background-mark-sweep-gc
---

```rust
pub struct ContentStore {
    dir: PathBuf,
    refs: RwLock<HashMap<String, u32>>,
}

impl ContentStore {
    pub fn store(&self, data: &[u8], content_type: &str) -> io::Result<String>;
    pub fn fetch(&self, hash: &str) -> io::Result<Vec<u8>>;
    pub fn has(&self, hash: &str) -> bool;
    pub fn retain(&self, hash: &str);
    pub fn release(&self, hash: &str);
    pub fn gc(&self, live_roots: &HashSet<String>) -> io::Result<GcReport>;
}
```

The §in-memory-ref-count-cache-flushed-to-meta discipline: `refs`
is `RwLock<HashMap>` — fast reads, occasional writes. The cache
syncs to `.meta` files on flush. The §two-level-persistence: the
hot path doesn't touch the filesystem; cold flushes are atomic
write-rename.
