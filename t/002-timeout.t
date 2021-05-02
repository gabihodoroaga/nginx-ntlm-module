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

=== TEST 1: Handle client connection drop after backend timeout 
When the ntlm_timeout expires the backend connection is dropped and 
after this event the client connection clean up 
should be handled properly (crashed the server before)
--- http_config
    upstream backend {
        server localhost:19841;
        server localhost:19842;
        ntlm;
        ntlm_timeout 2s;
    }
--- config
    location /t {
        proxy_pass http://backend;
        proxy_http_version 1.1;
        proxy_set_header Connection "";
    }
--- request eval 
["GET /t/1", "GET /t/2"]
--- more_headers eval
["Authorization: NTLM " . $::random_token . "\r\nConnection: keep-alive",""]
--- timeout: 3s
--- abort
--- response_body eval 
["OK", "OK"]
--- response_headers eval
["X-NGX-NTLM-AUTH: " . $::random_token, ""]
--- raw_response_headers_unlike eval
["========","X-NGX-NTLM-AUTH: "]
--- no_error_log
[error]


=== TEST 2: Handle client request after backend timeout
--- http_config
    upstream backend {
        server localhost:19841;
        server localhost:19842;
        ntlm;
        ntlm_timeout 2s;
    }
--- config
    location /t {
        proxy_pass http://backend;
        proxy_http_version 1.1;
        proxy_set_header Connection "";
    }
--- pipelined_requests eval 
["GET /t/1", "GET /t/2", [{value => "GET /t/3", delay_before =>3}]]
--- more_headers eval
["Authorization: NTLM " . $::random_token,"",""]
--- response_body eval 
["OK", "OK", "OK"]
--- response_headers eval
["X-NGX-NTLM-AUTH: " . $::random_token, "X-NGX-NTLM-AUTH: " . $::random_token, ""]
--- raw_response_headers_unlike eval
["========","==========","X-NGX-NTLM-AUTH: "]
--- no_error_log
[error]
--- SKIP # pipelined_requests does not support spliting into packets ... yet

