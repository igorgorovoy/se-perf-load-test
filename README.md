# se-perf-load-test
 
 BUILD
 docker build -t se/static-test ./
 
 RUN
 docker run -itd --name mfserver  --publish 8080:80 se/static-test
