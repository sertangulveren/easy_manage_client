# EasyManageClient [![Build Status](https://travis-ci.org/sertangulveren/easy_manage_client.svg?branch=master)](https://travis-ci.org/sertangulveren/easy_manage_client)

This client allows you to download compiled dumps in JSON or YAML format, such as translation, configuration etc. on EasyManage server to your project easly.

It is recommended to use at the projects initial stage.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'easy_manage_client'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install easy_manage_client

## Configuration

Client must be configured before use. Configuration fields are as:

| Field           | Description                                                                                             |
| --------------- | ------------------------------------------------------------------------------------------------------- |
| root_url        | Root url of the EasyManage server.                                                                      |
| auth_token      | Your 2.0 authentication token string without the 'Bearer'.                                              |
| extension       | Dump format. Available values: 'json', 'yaml'                                                            |
| download_folder | Information to which folder the dump will be downloaded.                                                |
| compile_id      | The id of the compiled version. If not passed, the client always downloads the latest compiled dump.    |

### Configuration on Rails Application:
Create a file in the `config/initializers` directory and configure client in this file as below:
`# config/initializers/easy_manage_client.rb`
```ruby
EasyManageClient.configure do |config|
  config.root_url = 'https://easymanage.example.com'
  config.auth_token = 'YOUR_SECRET_AUTH_TOKEN'
  config.extension = 'yaml'
  config.download_folder = File.join(Rails.root, 'config', 'translations')
  config.compile_id = 'SPECIAL_COMPILED_VERSION_ID'
end
```
### Multiple Configuration
You can define multiple configurations separated by profile. To do this, you must pass the profile parameter to the `configure` definition.
If the profile name is not pass in the configuration, it defaults to use `:default`.
##### Example:
In this example, to download dynamicly application settings, profile name specified as `settings`.

`# config/initializers/dynamic_settings.rb`
```ruby
EasyManageClient.configure(:dynamic_settings) do |config|
  config.root_url = 'https://easymanage.example.com'
  config.auth_token = 'YOUR_SECRET_AUTH_TOKEN'
  config.extension = 'json'
  config.download_folder = File.join(Rails.root, 'config', 'settings')
end
```
## Usage
Initialize a client object before starting process.
```ruby
client = EasyManageClient::Downloader.new
```
To download compiled dump, call the method `perform`.
The client downloads the compiled version to the directory specified in the configuration, in the specified format.
In this case, client uses the folder: `File.join(Rails.root, 'config', 'translations')`.
```ruby
client.perform
```

> In case of an unsuccessful download; `perform!` can be used instead of `perform` for error exception. This method creates an `EasyManageClient::DownloadProcessFailed` exception.

You can pass the profile argument on client initialization to use different configuration.
```ruby
client = EasyManageClient::Downloader.new(profile: :dynamic_settings)
client.perform
```

If the download process will be performed only in the Rails initialization, the following method can be used:
`# config/initializers/easy_manage_client.rb`
```ruby
EasyManageClient.configure(:dummy_profile) do |config|
  config.root_url = 'https://easymanage.example.com'
  config.auth_token = 'YOUR_SECRET_AUTH_TOKEN'
  config.extension = 'yaml'
  config.download_folder = File.join(Rails.root, 'config', 'settings')
end
client = EasyManageClient::Downloader.new(profile: :dummy_profile)
client.perform!
```

### Using Rake Tasks
The client has its own rake tasks.
This feature can be used in configurations such as CI configurations, Dockerfile etc.

Use rake task to download your compiled dump as below:

`rake easy_manage_client:download`

Pass profile to rake task via environment variable:

`rake easy_manage_client:download EASY_MANAGE_PROFILE=dummy_settings`
## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/sertangulveren/easy_manage_client.

