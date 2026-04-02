# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Culture Link is a cultural history learning app (文化史学習アプリ) built with Rails 7.2.3, Ruby 3.3.6, and PostgreSQL 16. It targets Japanese high school and exam students, helping them visualize timelines and causal relationships in cultural history. The project is in early MVP stage.

## Development Commands

### Starting the dev server

```bash
./bin/dev                    # Starts Rails server + Tailwind watcher via foreman (port 3000)
```

### Docker-based development

```bash
docker compose up            # Starts PostgreSQL + Rails app
```

Note: `Dockerfile.dev` is located one directory up at `/home/takahiro/culture_link/Dockerfile.dev`.

### Database

```bash
bin/rails db:prepare         # Create and migrate database
bin/rails db:migrate         # Run pending migrations
bin/rails db:seed            # Seed data
```

### Testing (Minitest)

```bash
bin/rails test               # Run all tests
bin/rails test test/models   # Run model tests
bin/rails test test/models/user_test.rb          # Run a single test file
bin/rails test test/models/user_test.rb:10       # Run a single test by line number
bin/rails test:system        # Run system tests (requires Selenium)
```

### Linting & Security

```bash
bin/rubocop                  # Lint with Rails Omakase style
bin/rubocop -a               # Auto-fix lint issues
bin/brakeman --no-pager      # Security vulnerability scan
```

### Asset Building

```bash
yarn build                   # Build JavaScript (esbuild)
yarn build:css               # Build Tailwind CSS
bin/rails tailwindcss:watch  # Watch Tailwind changes
```

## Architecture

- **Rails 7.2** with Hotwire stack (Turbo + Stimulus) — no separate frontend framework
- **Tailwind CSS 4** for styling, bundled via `cssbundling-rails` and `tailwindcss-rails`
- **esbuild** for JavaScript bundling
- **PostgreSQL 16** — dev DB: `myapp_development`, test DB: `myapp_test`
- **Minitest** for testing (ignore the `spec/` directory — it's legacy/unused)
- **CI** runs on GitHub Actions: brakeman scan, rubocop lint, then minitest with PostgreSQL service

## Key Conventions

- Commit messages and view text are in Japanese
- Rubocop uses `rubocop-rails-omakase` (Rails default style guide)
- Views use ERB with shared partials in `app/views/shared/`
- Stimulus controllers live in `app/javascript/controllers/`

## ルール

- 新しい機能は必ずブランチを切って作業する
- mainブランチへの直接コミットは禁止
- テストを書いてから実装する（TDD）
- docker compose exec web bundle exec rubocop -Aを実行してからcommitをする

## 注意事項

- APIキーは.envファイルで管理（Gitにコミットしない）
