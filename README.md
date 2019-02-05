
# Short Url

By [Chiligumvideos](http://chiligumvideos.com/)

Is a small app to gerenate short url via authenticated api.
[You can use this gem(urli_me) together](https://github.com/chiligumdev/urli_me)

## Instalation

Clone repo

```ruby
git clone https://github.com/chiligumdev/short_url
```

Install dependencies

````ruby
bundle install
````

Install figaro and configure domain (check application.yml.example)

```ruby
figaro install
```

Create database

```ruby
rake db:migrate && rake db:migrate
```

[Create a user](http://localhost:3000/users/sign_up) and [generate credentials.](http://localhost:3000/credentials)

Update user to use api

```ruby
$ rails console
User.last.update(disabled: false)
```

## Endpoints

Required libs to test endpoint and credential

```ruby
require 'HTTParty'
require 'json'

headers = {
	"key" => "YOUR key",
	"pwd" => "YOUR pwd",
	'Content-Type' => 'multipart/form-data'
}
```

#### [GET] Get Links

```ruby
HTTParty.get("http://localhost:3000/api/links", headers: headers)
```
return

```ruby
{"id"=>48, "original_url"=>"http://google.com/", "short_url"=>"http://urlcurta.com/324cce", "token"=>"324cce", "created_at"=>"2017-05-23T23:22:33.347Z"}
```

#### [POST] Create Links

```ruby
HTTParty.post('http://localhost:3000/api/links', :query => {
	link: {
		original_url: 'http://google.com/'
	}},
  headers: headers)
```
return

```json
{"id":67,"original_url":"http://google.com/","short_url":"https://shor_url.com/7df540","token":"7df540","created_at":"2017-05-24T22:54:47.234Z"}
```
#### [GET] Get Link
Pass token as param

```ruby
HTTParty.get("http://localhost:3000/api/links/7df540", headers: headers)
```
return

```json
{"id":67,"original_url":"http://google.com/","short_url":"https://shor_url.com/7df540","token":"7df540","created_at":"2017-05-24T22:54:47.234Z"}
```
#### [PATCH] Update Link
Pass token as param

```ruby
HTTParty.patch("http://localhost:3000/api/links/7df540", :query => {
	link: {
		original_url: 'http://gmail.com/'
	}},
headers: headers)
```

return

```json
{"id":67,"original_url":"http://gmail.com/","short_url":"https://shor_url.com/7df540","token":"7df540","created_at":"2017-05-24T22:54:47.234Z"}
```

#### [DELETE] Delete Link

```ruby
HTTParty.delete("http://localhost:3000/api/links/#{id}", headers: headers)
```
return

```json
{"msg":"deleted"}
```