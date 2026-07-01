# Contributing to Enterprise Data Platform

Thank you for your interest in contributing! This guide explains how to contribute to the project.

## Code of Conduct

- Be respectful and inclusive
- Follow the project structure
- Test your changes before submitting
- Document your changes

## Getting Started

1. Fork the repository
2. Clone your fork locally
3. Create a feature branch
4. Make your changes
5. Submit a Pull Request

## Development Setup

```bash
git clone https://github.com/YOUR_USERNAME/metdata-driven-pipeline.git
cd enterprise-data-platform
cp .env.example .env
./start.sh  # Linux/Mac
# or
start.bat   # Windows
```

## Making Changes

### Branch Naming
- `feature/xxx` - New features
- `bugfix/xxx` - Bug fixes
- `docs/xxx` - Documentation updates

### Commit Messages
```
[TYPE] Short description

Optional longer description
- Point 1
- Point 2
```

Types: `feat`, `fix`, `docs`, `test`, `refactor`, `chore`

## Testing

Before submitting PR:

```bash
# Test syntax
python -m py_compile airflow/dags/*.py

# Validate DAGs
docker-compose exec airflow-webserver airflow dags list

# Test file validation
cd watchdog
python -m pytest .
```

## Pull Request Process

1. Update README.md with any new steps/features
2. Ensure all CI/CD checks pass
3. Request review from maintainers
4. Address feedback
5. Once approved, your PR will be merged

## Areas to Contribute

- **Airflow DAGs** - `airflow/dags/`
- **Notebooks** - `notebooks/bronze/silver/gold/`
- **Metadata** - `metadata/schema_mapping/` and `metadata/business_rules/`
- **Tests** - `tests/`
- **Documentation** - README, guides, comments

## Questions?

- Open an Issue
- Check existing discussions
- Review documentation

Happy coding! 🚀
