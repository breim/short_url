require 'HTTParty'
require 'json'

# Create a user and generate credentials
headers = { 
	"key" => "4694e7df32",
	"pwd" => "e4b7b7e482",
	'Content-Type' => 'multipart/form-data'
}

puts "============= Initializing tests ============="

# Retrivel all links of your user
puts "\n === [GET] - Index links ==="
@links = HTTParty.get("http://dev.com:3000/api/links", headers: headers)
puts @links

# Create link 
puts "\n === [POST] - Link get all ==="
@link = HTTParty.post('http://dev.com:3000/api/links', :query => {
	link: { 
		original_url: 'http://google.com/'
	}},
	headers: headers)
puts @link.body
parse_token = JSON.parse(@link.body)['token']

# Show link
puts "\n === [GET] - Link Show ==="
id = parse_token
@link = HTTParty.get("http://dev.com:3000/api/links/#{id}", headers: headers)
puts @link.body

# Update link
puts "\n === [GET] - Link Update ==="
id = parse_token
@link = HTTParty.patch("http://dev.com:3000/api/links/#{id}", :query => {
	link: { 
		original_url: 'http://gmail.com/'
	}},
	headers: headers)
puts @link.body

# Delete link
puts "\n === [DELETE] - Link Destoy ==="
id = parse_token
@link = HTTParty.delete("http://dev.com:3000/api/links/#{id}", headers: headers)
puts @link.body