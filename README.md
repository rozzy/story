# Story
[![Gem Version](https://badge.fury.io/rb/story.png)](http://badge.fury.io/rb/story) [![Code Climate](https://codeclimate.com/github/rozzy/story.png)](https://codeclimate.com/github/rozzy/story) [![Dependency Status](https://gemnasium.com/rozzy/story.png)](https://gemnasium.com/rozzy/story) [![Coverage Status](https://coveralls.io/repos/rozzy/story/badge.png)](https://coveralls.io/r/rozzy/story)  
Gem for creating awesome personal blog.  

[Installing](#installation)  
[Setting up](#setting-up)  
Using (in progress)      
API (in progress)  

## Installation
Story is a RubyGem, so simply install it with `gem install story`.  
Or add it to your Gemfile `gem "story"` and use `$ bundle install` in terminal pwd.  

## Setting Up
Story can work “out of the box”. You don't need any complex customizations or settings.  
First of all you should require all necessary gems in your **Gemfile**:
```ruby
gem 'sinatra'
gem 'story'
gem 'slim'
gem 'compass'
gem 'sass'
```

The simpliest way to start working with your blog with default settings is:  
```ruby
# app.rb
require 'story'
Story::Base.run!
```
And in your terminal: 
```bash
$ ruby app.rb
```
