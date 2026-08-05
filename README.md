<p align="center">
  <img src="assets/brand/monkeylens-lockup.svg" alt="MonkeyLens — make runtime patches visible" width="760">
</p>

<p align="center">
  <strong>Audit monkey patches, method ownership, prepend layers, and Ruby runtime drift.</strong>
</p>

<p align="center">
  <a href="https://github.com/theworker02/monkeylens/actions/workflows/ci.yml"><img alt="CI" src="https://github.com/theworker02/monkeylens/actions/workflows/ci.yml/badge.svg"></a>
  <a href="https://rubygems.org/gems/monkey_lens"><img alt="RubyGems" src="https://img.shields.io/gem/v/monkey_lens.svg"></a>
  <a href="https://theworker02.github.io/monkeylens/"><img alt="Website" src="https://img.shields.io/badge/website-GitHub%20Pages-f97316.svg"></a>
  <a href="LICENSE.txt"><img alt="MIT License" src="https://img.shields.io/badge/license-MIT-blue.svg"></a>
</p>

MonkeyLens captures the effective Ruby method table for selected classes and modules, records who owns every method, tracks source locations, visibility, signatures, and ancestor order, then compares that runtime against a committed baseline.

It turns invisible runtime mutation into reviewable evidence.

## Why MonkeyLens?

Ruby deliberately makes classes open. That flexibility is powerful, but a production process can behave differently because a gem reopened a core class, a concern used `prepend`, a test helper redefined a method, or load order changed which implementation won.

MonkeyLens answers:

- Which methods were added, removed, or redefined?
- Which module currently owns the method Ruby will dispatch?
- Did a `prepend` layer enter or leave the ancestor chain?
- Did arity, parameters, visibility, or source location change?
- Does CI boot with the same runtime shape as the approved baseline?

## Install

Add the gem to your bundle:

```ruby
gem "monkey_lens"
```

Then run:

```bash
bundle install
```

After release, direct installation will be:

```bash
gem install monkey_lens
```

## Quick start

Create `.monkeylens.yml`:

```yaml
targets:
  - String
  - Array
  - MyApp::User
fail_on: high
format: text
```

Capture the approved runtime:

```bash
bundle exec monkeylens capture --output .monkeylens.json
```

Check for drift:

```bash
bundle exec monkeylens check
```

## CLI

```text
monkeylens capture   Capture a runtime baseline
monkeylens check     Compare the current runtime with a baseline
monkeylens diff      Compare two saved snapshots
monkeylens inspect   Explain one target's effective method table
monkeylens doctor    Validate configuration and runtime support
monkeylens version   Print the installed version
```

### Load an application before capture

```bash
bundle exec monkeylens capture \
  --require ./config/environment \
  --output .monkeylens.json
```

### JSON or SARIF output

```bash
bundle exec monkeylens check --format json
bundle exec monkeylens check --format sarif > monkeylens.sarif
```

SARIF output can be uploaded to GitHub code scanning or processed by other security tooling.

## Library API

```ruby
require "monkey_lens"

baseline = MonkeyLens.capture(targets: ["String", "MyApp::User"])
baseline.write(".monkeylens.json")

current = MonkeyLens.capture(targets: ["String", "MyApp::User"])
result = MonkeyLens.diff(baseline, current)

abort result.to_text unless result.clean?
```

## Rake integration

```ruby
require "monkey_lens/rake_task"

MonkeyLens::RakeTask.new do |task|
  task.config = ".monkeylens.yml"
  task.baseline = ".monkeylens.json"
end
```

This creates `monkey_lens:capture` and `monkey_lens:check` tasks.

## Rails integration

Add MonkeyLens to your development and test groups. Its Railtie adds the same Rake tasks after the application environment loads.

```ruby
group :development, :test do
  gem "monkey_lens"
end
```

## Change severities

| Change | Default severity |
| --- | --- |
| Method owner changed | Critical |
| Method source changed | High |
| Method removed | High |
| Prepend/ancestor order changed | High |
| Method signature changed | Medium |
| Visibility changed | Medium |
| Method added | Low |

The threshold is configured with `fail_on: low|medium|high|critical`.

## Design guarantees

- Does not execute arbitrary project files unless explicitly passed with `--require`.
- Does not upload runtime information.
- Produces deterministic JSON for the same runtime state.
- Uses Ruby's public reflection APIs.
- Supports Ruby 3.2 and newer.

## Documentation

- [Configuration](docs/configuration.md)
- [Architecture](docs/architecture.md)
- [Release process](docs/releasing.md)
- [Brand guidelines](docs/branding.md)
- [Security policy](SECURITY.md)
- [Contributing](CONTRIBUTING.md)

## Funding

MonkeyLens supports:

- [GitHub Sponsors](https://github.com/sponsors/theworker02)
- [thanks.dev](https://thanks.dev/u/gh/theworker02)

## License

MIT © 2026 Matthew Looney
