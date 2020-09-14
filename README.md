<strong> Методика измерения, тестирования.</strong>



1. Были созданы два сайта с идентичным содержанием. Страница тестового сайта которая использовалась в тесте размещена по адрессу : https://github.com/igorgorovoy/se-mfs
2. Сайты размещены на сервисах AWS Amplify (https://aws.amazon.com/amplify/) и Netlify (https://www.netlify.com/)

  - master.d2a8dehuglpvfd.amplifyapp.com 
  - stoic-jackson-4a8b51.netlify.app

3. Для запуска тестов, было создано два идентичных сервера  AWS в регионах USA (Ohio) us-east-2 и Asia Pacific (Sydney) ap-southeast-2 Тип инстанса t2.micro. На серверах небыло никакой другой нагрузки, кроме тестовой утилиты. Максимально пытались приблизиться к идеальной среде измерения.

   Скрипты создания серверов доступны https://github.com/igorgorovoy/se-perf-load-test/tree/master/provision/aws

4. Метрики измерений хорошо описаны в статье https://medium.com/cloudflare-blog/timing-web-requests-with-curl-and-chrome-c3da5580462a

    <strong>time_namelookup</strong> in this example takes a long time.
   
    <strong>time_connect</strong> is the TCP three-way handshake from the client’s perspective. It ends just after the client sends the ACK — it doesn’t include the time taken for that ACK to reach the server. It should be close to the round-trip time (RTT) to the server. In this example, RTT looks to be about 200 ms.
    
    <strong>time_appconnect</strong> here is TLS setup. The client is then ready to send it’s HTTP GET request.
    
    <strong>time_starttransfer</strong> is just before cURL reads the first byte from the network (it hasn’t actually read it yet). time_starttransfer - time_appconnect is practically the same as Time To First Byte (TTFB) from this client. This includes the round trip over the network, so you might get a better guess of how long the server spent on the request by calculating TTFB - (time_connect - time_namelookup), so in this case, the server spent only a few milliseconds responding, the rest of the time was the network.
    
    <strong>time_total</strong> is just after the client has sent the FIN connection tear down.
    
    


5. Использовали два подхода к тестированию:

    5.1. один запрос раз в минуту к каждому из сайтов с каждого сервера 
         https://github.com/igorgorovoy/se-perf-load-test/blob/master/test-scripts/scenario1_t1.sh
         https://github.com/igorgorovoy/se-perf-load-test/blob/master/test-scripts/scenario1_t2.sh
         
         
    5.2  пять запросов в минуту к каждому из сайтов с каждого сервера 
         https://github.com/igorgorovoy/se-perf-load-test/blob/master/test-scripts/scenario2_t1.sh
         https://github.com/igorgorovoy/se-perf-load-test/blob/master/test-scripts/scenario2_t2.sh
         
    Результаты измерений собирались <strong>24 часа<.strong> и доступны https://github.com/igorgorovoy/se-perf-load-test/tree/master/harvester - файлы AU - это файлы с результатами собранные с австралийского сервера , US - с американского соответственно, в префиксее наименования файла указан какой тип измерения использовалсядля получения данных в данном файле.
    
    









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
