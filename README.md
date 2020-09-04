# se-perf-load-test
 
 BUILD
 cd se-docker-static-mfsite
 docker build -t se/static-test ./
 
 RUN
 docker run -itd --name mfserver  --publish 8080:80 se/static-test
