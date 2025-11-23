# IRL2

A Ruby on Rails application for task and group management.

## Table of Contents

- [Overview](#overview)
- [Local Development](#local-development)
- [Configuration](#configuration)
- [Running Tests](#running-tests)
- [Contributing](#contributing)
- [License](#license)

## Overview

IRL2 is an open source project built with Ruby on Rails, featuring user authentication, task management, and group collaboration capabilities.

## Local Development

### Prerequisites

- Ruby 3.x
- Rails ~> 8.0.4
- PostgreSQL (~> 1.1)
- Node.js (for importmap-rails and asset compilation)
- Docker (optional, for containerized development)

### Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/irl2.git
   cd irl2
   ```

2. **Install dependencies**
   ```bash
   bundle install
   yarn install
   ```

3. **Database setup**
   ```bash
   rails db:create
   rails db:migrate
   rails db:seed
   ```

4. **Start the development server**

   Using the Procfile:
   ```bash
   bin/dev
   ```

   Or manually:
   ```bash
   rails server
   ```

   The application will be available at `http://localhost:3000`

### Using Docker

Alternatively, run the application using Docker:

```bash
docker build -t irl2 .
docker run -p 3000:3000 irl2
```

### Development Tools

- **Console**: `rails console`
- **Database console**: `rails dbconsole`
- **Routes**: `rails routes`
- **Security checks**: `bin/brakeman`
- **Code linting**: `bin/lint` (or `bin/rubocop`)

## Configuration

### Database

Database configuration is managed in `config/database.yml`. For local development, ensure PostgreSQL is running and accessible.

### Assets

- Tailwind CSS configuration: `config/tailwind.config.js`
- JavaScript modules: `config/importmap.rb`
- Stimulus controllers: `app/javascript/controllers/`

### Authentication

The application uses Devise for user authentication. Configuration can be found in:
- `config/initializers/devise.rb`
- `config/locales/devise.en.yml`

## Running Tests

Execute the test suite with:

```bash
bundle exec rspec
```

For specific test files:

```bash
bundle exec rspec spec/models/user_spec.rb
```

Run tests with documentation format:

```bash
bundle exec rspec --format documentation
```

## Contributing

Contributions are welcome and appreciated! Here's how to get started:

### Getting Started

1. **Fork the repository** on GitHub
2. **Clone your fork** locally
3. **Create a feature branch** from `main`:
   ```bash
   git checkout -b feature/your-feature-name
   ```

### Making Changes

1. Make your changes in your feature branch
2. Write or update tests as needed
3. Ensure all tests pass: `bundle exec rspec`
4. Run the linter: `bin/lint`
5. Commit your changes with clear, descriptive commit messages:
   ```bash
   git commit -m "Add feature: description of your changes"
   ```

### Submitting a Pull Request

1. Push your branch to your fork:
   ```bash
   git push origin feature/your-feature-name
   ```
2. Open a Pull Request on GitHub
3. Provide a clear description of the changes and any relevant issue numbers
4. Wait for review and address any feedback

### Code Standards

- Follow Ruby style guidelines (enforced by Standard)
- Write meaningful test coverage for new features
- Keep commits atomic and well-documented
- Update documentation for any user-facing changes

### Linting

The project uses Standard for Ruby linting. Run the linter with:

```bash
bin/lint
```

For compatibility, `bin/rubocop` is also available and redirects to `bin/lint`.

To auto-fix issues:

```bash
bin/lint --fix
```

### Reporting Issues

Found a bug or have a feature request? Please open an issue on GitHub with:
- A clear, descriptive title
- Steps to reproduce (for bugs)
- Expected vs actual behavior
- Your environment details (Ruby version, OS, etc.)

### Code of Conduct

This project adheres to a code of conduct that all contributors are expected to follow. Be respectful, inclusive, and collaborative.

## License

This project is open source and available under the [MIT License](LICENSE).
