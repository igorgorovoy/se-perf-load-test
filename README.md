# se-perf-load-test
 
 BUILD
 <br>
 cd se-docker-static-mfsite
 <br>
 docker build -t se/static-test ./
 <br>
 RUN
 <br>
 docker run -itd --name mfserver  --publish 8080:80 se/static-test

 <br>
 test site provision on https://stoic-jackson-4a8b51.netlify.app/
 <br> 
 <br>
 <br>

:~$ curl -so /dev/null https://stoic-jackson-4a8b51.netlify.app
 <br>
dnslookup: 0,040020 | connect: 0,073700 | appconnect: 0,124257 | pretransfer: 0,124378 | starttransfer: 0,476516 | total: 0,476924 | size: 5109
 <br>
:~$ curl -so /dev/null http://motherfuckingwebsite.com/
 <br>
dnslookup: 0,004692 | connect: 0,182079 | appconnect: 0,000000 | pretransfer: 0,182162 | starttransfer: 0,359876 | total: 0,360274 | size: 5108
 <br>
