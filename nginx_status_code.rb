# !/usr/bin/env ruby
# coding: utf-8

HTTP_STATUS_CODES = {
#      '100' => 'Continue',
#      '101' => 'Switching Protocols',
#      '102' => 'Processing',
#      '200' => 'OK',
#      '201' => 'Created',
#      '202' => 'Accepted',
#      '203' => 'Non-Authoritative Information',
#      '204' => 'No Content',
#      '205' => 'Reset Content',
#      '206' => 'Partial Content',
#      '207' => 'Multi-Status',
#      '208' => 'Already Reported',
#      '226' => 'IM Used',
#      '300' => 'Multiple Choices',
#      '301' => 'Moved Permanently',
#      '302' => 'Found',
#      '303' => 'See Other',
#      '304' => 'Not Modified',
#      '305' => 'Use Proxy',
#      '306' => 'Reserved',
#      '307' => 'Temporary Redirect',
#      '308' => 'Permanent Redirect',
      '400' => 'Bad Request',
      '401' => 'Unauthorized',
#      '402' => 'Payment Required',
      '403' => 'Forbidden',
      '404' => 'Not Found',
      '405' => 'Method Not Allowed',
      '406' => 'Not Acceptable',
#      '407' => 'Proxy Authentication Required',
      '408' => 'Request Timeout',
#      '409' => 'Conflict',
#      '410' => 'Gone',
#      '411' => 'Length Required',
#      '412' => 'Precondition Failed',
#      '413' => 'Request Entity Too Large',
#      '414' => 'Request-URI Too Long',
#      '415' => 'Unsupported Media Type',
#      '416' => 'Requested Range Not Satisfiable',
#      '417' => 'Expectation Failed',
#      '422' => 'Unprocessable Entity',
#      '423' => 'Locked',
#      '424' => 'Failed Dependency',
#      '425' => 'Reserved for WebDAV advanced collections expired proposal',
#      '426' => 'Upgrade Required',
#      '427' => 'Unassigned',
#      '428' => 'Precondition Required',
#      '429' => 'Too Many Requests',
#      '430' => 'Unassigned',
#      '431' => 'Request Header Fields Too Large',
      '499' => 'Client Connection Terminated',
      '500' => 'Internal Server Error',
#      '501' => 'Not Implemented',
      '502' => 'Bad Gateway',
      '503' => 'Service Unavailable',
      '504' => 'Gateway Timeout',
#      '505' => 'HTTP Version Not Supported',
#      '506' => 'Variant Also Negotiates (Experimental)',
#      '507' => 'Insufficient Storage',
#      '508' => 'Loop Detected',
#      '509' => 'Unassigned',
#      '510' => 'Not Extended',
#      '511' => 'Network Authentication Required'
      'Other' => 'Other response'
} 

if ARGV[0] == 'config'
  puts 'graph_title nginx Error Codes'
  puts 'graph_vlabel errors per minute'
  puts 'graph_category nginx'
  puts 'graph_period minute'
  puts 'graph_info Non-2xx response codes per minute'
  HTTP_STATUS_CODES.each do |code, desc|
    puts "#{code}.label #{code} #{desc}"
    puts "#{code}.type DERIVE"
    puts "#{code}.min 0"
  end
else
  results = Hash[*HTTP_STATUS_CODES.keys.map { |k| [k, 0] }.flattan]
end
