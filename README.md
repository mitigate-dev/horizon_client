# HorizonClient

Client to use with Horizon REST xml API.

## Usage

```ruby
client = HorizonClient.new

get_response = client.get('example')

post_response = client.post('example', 'post body')
```

`get_response` will be parsed from xml to hash.


### Necessary environment variables

* **HORIZON_REST_URL**
* **HORIZON_USERNAME**
* **HORIZON_PASSWORD**

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.
