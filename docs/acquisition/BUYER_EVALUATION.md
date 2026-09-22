# Buyer evaluation â€” monkeylens

## Goal

In 15â€“45 minutes, verify the Product builds or runs as documented and that proprietary notices are present.

## Steps

1. Confirm root `LICENSE` is proprietary and `ACQUISITION.md` exists.
2. Skim `README.md` install/run claims.
3. Execute:

```
```ruby
gem "monkey_lens"
```
```bash
bundle install
```
```bash
gem install monkey_lens
```
```yaml
targets:
  - String
  - Array
  - MyApp::User
fail_on: high
format: text
```
```bash
bundle exec monkeylens capture --output .monkeylens.json
```
```bash
bundle exec monkeylens check
```
```text
monkeylens capture   Capture a runtime baseline
monkeylens check     Compare the current runtime with a baseline
monkeylens diff      Compare two saved snapshots
monkeylens inspect   Explain one target's effective method table
monkeylens doctor    Validate configuration and runtime support
monkeylens version   Print the installed version
```
```bash
bundle exec monkeylens capture \
  --require ./config/environment \
  --output .monkeylens.json
```
```bash
bundle exec monkeylens check --format json
bundle exec monkeylens check --format sarif > monkeylens.sarif
```
```

4. Run tests if present (`npm test`, `pytest`, `cargo test`, `go test ./...`, etc.).
5. Record README vs observed behavior gaps in workpapers.

## Pass criteria

- [ ] Clone succeeds
- [ ] Documented happy path works **or** failure is explained
- [ ] Minimal path needs no surprise secrets
- [ ] License notices intact

*Updated: 2026-09-22*
