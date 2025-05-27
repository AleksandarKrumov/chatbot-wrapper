# Smart Research Assistant CLI

A command-line tool that leverages the Perplexity API to generate comprehensive research summaries on any topic.

## ✨ Features

- 🔍 Generate detailed research summaries using Perplexity's search capabilities
- 📄 Multiple output formats (markdown, plain text, JSON)
- ⚙️ Configurable research depth levels
- 💾 Built-in caching to reduce API calls
- 💰 Cost tracking and usage monitoring

## ⚙️ Configuration

1. Get your Perplexity API key from [Perplexity AI](https://www.perplexity.ai/)
2. Create a `.env` file in the project root:

## 📖 Usage

### Basic Research Query

python research_cli.py "impact of AI on healthcare"

### Advanced Usage

python research_cli.py "quantum computing applications"
--depth detailed
--format markdown
--output research.md

## 📋 Requirements

- **Python**: 3.8 or higher
- **API Key**: Valid Perplexity API key
- **Network**: Internet connection required