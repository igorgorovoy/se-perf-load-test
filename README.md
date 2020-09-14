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
    
    [![Diagrama 1](/based_on/pic1ttfb.png "Diagrama1")](https://miro.medium.com/max/1000/0*swLuPiCo5Nn1UuQ5.png)
    [![Diagrama 2](/based_on/pic2ttfb.png "Diagrama2")](https://miro.medium.com/max/1000/0*EImyjXUWO9bFKgse.png)

    
    


5. Использовали два подхода к тестированию:

    5.1. один запрос раз в минуту к каждому из сайтов с каждого сервера 
         https://github.com/igorgorovoy/se-perf-load-test/blob/master/test-scripts/scenario1_t1.sh
         https://github.com/igorgorovoy/se-perf-load-test/blob/master/test-scripts/scenario1_t2.sh
         
         
    5.2  пять запросов в минуту к каждому из сайтов с каждого сервера 
         https://github.com/igorgorovoy/se-perf-load-test/blob/master/test-scripts/scenario2_t1.sh
         https://github.com/igorgorovoy/se-perf-load-test/blob/master/test-scripts/scenario2_t2.sh
         
    Результаты измерений собирались <strong>24 часа</strong> и доступны https://github.com/igorgorovoy/se-perf-load-test/tree/master/harvester - файлы AU - это файлы с результатами собранные с австралийского сервера , US - с американского соответственно, в суффиксе наименования файла указан какой тип измерения использовался для получения данных в данном файле.
    
    



refs:
</br>
DOMAIN NAMES - CONCEPTS AND FACILITIES https://www.ietf.org/rfc/rfc1034.txt 
</br>
DOMAIN NAMES - IMPLEMENTATION AND SPECIFICATION https://www.ietf.org/rfc/rfc1035.txt
</br>
Timing web requests with cURL and Chrome https://medium.com/cloudflare-blog/timing-web-requests-with-curl-and-chrome-c3da5580462a by Piers Cornwell
</br>
What computer networks are and how to actually understand them https://www.freecodecamp.org/news/computer-networks-and-how-to-actually-understand-them-c1401908172d/
