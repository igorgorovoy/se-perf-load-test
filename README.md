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
