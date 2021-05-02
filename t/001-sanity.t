use String::Random;
use Test::Nginx::Socket 'no_plan';

#workers(2);
repeat_each(2);

my $string_gen = String::Random->new;
our $random_token = $string_gen->randpattern("CcCcCcCCcC");

# Start the nodejs backend
my $pid = fork();
if ($pid == 0) {  #child
    exec("node t/backend/index.js");
} else { #parent
    sleep 1;
}

add_cleanup_handler(sub {
    kill INT => $pid;
});

run_tests();

__DATA__

=== TEST 1: NTLM header should trigger keepalive for upstream
When the authorization header contains NTLM the token is saved on the server
connection and all subsequent requests should return it in X-NGX-NTLM-AUTH 
header
--- http_config
    upstream backend {
        server localhost:19841;
        server localhost:19842;
        ntlm; 
    }
--- config
    location /t {
        proxy_pass http://backend;
        proxy_http_version 1.1;
        proxy_set_header Connection "";
    }
--- pipelined_requests eval 
["GET /t", "GET /t", "GET /t"]
--- more_headers eval
["Authorization: NTLM " . $::random_token,"",""]
--- response_body eval 
["OK", "OK", "OK"]
--- response_headers eval
["X-NGX-NTLM-AUTH: " . $::random_token, "X-NGX-NTLM-AUTH: " . $::random_token, "X-NGX-NTLM-AUTH: " . $::random_token]
--- no_error_log
[error]


=== TEST 2: Negotiate header should trigger keepalive for upstream
When the authorization header contains Negotiate the token is saved on the server
connection and all subsequent requests should return it in X-NGX-NTLM-AUTH 
header
--- http_config
    upstream backend {
        server localhost:19841;
        server localhost:19842;
        ntlm;
    }
--- config
    location /t {
        proxy_pass http://backend;
        proxy_http_version 1.1;
        proxy_set_header Connection "";
    }
--- pipelined_requests eval 
["GET /t", "GET /t", "GET /t"]
--- more_headers eval
["Authorization: Negotiate " . $::random_token,"",""]
--- response_body eval 
["OK", "OK", "OK"]
--- response_headers eval
["X-NGX-NTLM-AUTH: " . $::random_token, "X-NGX-NTLM-AUTH: " . $::random_token, "X-NGX-NTLM-AUTH: " . $::random_token]
--- no_error_log
[error]


=== TEST 3: The backend connection should die when client connection dies
When the authorization header contains NTLM the token is saved on the server
connection if the client drops the connection the backend connection must die 
also
--- http_config
    upstream backend {
        server localhost:19841;
        server localhost:19842;
        ntlm; 
    }
--- config
    location /t {
        proxy_pass http://backend;
        proxy_http_version 1.1;
        proxy_set_header Connection "";
    }
--- request eval 
["GET /t", "GET /t", "GET /t"]
--- more_headers eval
["Authorization: NTLM " . $::random_token,"",""]
--- response_body eval 
["OK", "OK", "OK"]
--- raw_response_headers_like eval
["X-NGX-NTLM-AUTH: " . $::random_token, "", ""]
--- raw_response_headers_unlike eval
["========","X-NGX-NTLM-AUTH: ","X-NGX-NTLM-AUTH: "]
--- no_error_log
[error]


=== TEST 4: The backend connection should die when client connection dies
When the authorization header contains Negotiate the token is saved on the server
connection if the client drops the connection the backend connection must die 
also
--- http_config
    upstream backend {
        server localhost:19841;
        server localhost:19842;
        ntlm; 
    }
--- config
    location /t {
        proxy_pass http://backend;
        proxy_http_version 1.1;
        proxy_set_header Connection "";
    }
--- request eval 
["GET /t", "GET /t", "GET /t"]
--- more_headers eval
["Authorization: Negotiate " . $::random_token,"",""]
--- response_body eval 
["OK", "OK", "OK"]
--- raw_response_headers_like eval
["X-NGX-NTLM-AUTH: " . $::random_token, "", ""]
--- raw_response_headers_unlike eval
["========","X-NGX-NTLM-AUTH: ","X-NGX-NTLM-AUTH: "]
--- no_error_log
[error]
