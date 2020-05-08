# AasmPlus
Add some features to AASM. 
Include
- scopes.
- pass more params when trigger events.
- log state changes,

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'aasm_plus'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install aasm_plus
```

## Usage
1. Edit target model.
```ruby
# In model that to include AasmEnhancing
include AASM
include AasmPlus::Stateable
# Add into aasm config
before_all_events :set_related_data
after_all_transitions :log_state_change
```

2. Run migration, it will create tables for state chains.
```bash
rails aasm_plus:install:migrations
rails db:migrate
```

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
