# Architecture

MonkeyLens has four layers:

1. **Capture** resolves configured constants and records their ancestor chains and effective method tables.
2. **Snapshot** stores a deterministic, versioned representation of the runtime.
3. **Diff** compares baseline and current targets, classifies changes, and assigns severities.
4. **Formatters** render the same result as human text, JSON, or SARIF.

The core does not load application files by itself. CLI `--require` options are explicit boundary crossings used to boot a framework or application before reflection.
