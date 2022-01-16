# ToolVersion

A utility gem to fetch the most recent tool version from your git repoistory.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'tool_version'
```

Additional you'll need a provider gem:

**Github:**

```ruby
gem 'octokit'
```

And then execute:

    $ bundle install

## Usage

    # Create a client of your choosing -> Currently only github is supported
    client = Octokit::Client.new([credentials])

    # Interface for detect_tools => detect_tools(client, repository, schemas, branch: :main, provider: :github)
    versions = ToolVersion.detect_tools(client, 'username/repository', [:ruby], branch: :master)

    versions = [
        ToolVersion::Tool.new(
            'ruby',
            '3.0.2',
            '.ruby-version'
          )
    ]


### Options

parameter | options
----------|--------------------------
schemas   | ruby, node, asdf
branch    | main, master, develop....

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Liberatys/tool_version. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/Liberatys/tool_version/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the ToolVersion project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/tool_version/blob/master/CODE_OF_CONDUCT.md).
