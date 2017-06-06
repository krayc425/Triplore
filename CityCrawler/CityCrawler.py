#!/usr/bin/env python3

import requests
from bs4 import BeautifulSoup
import re
import json
import time
import random

main_url = "http://www.mafengwo.cn/mdd/"

agents = [
    "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_8; en-us) AppleWebKit/534.50 (KHTML, like Gecko) Version/5.1 Safari/534.50",
    "Mozilla/5.0 (Windows; U; Windows NT 6.1; en-us) AppleWebKit/534.50 (KHTML, like Gecko) Version/5.1 Safari/534.50",
    "Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Trident/5.0",
    "Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.0; Trident/4.0)",
    "Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.0)",
    "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)",
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:2.0.1) Gecko/20100101 Firefox/4.0.1",
    "Mozilla/5.0 (Windows NT 6.1; rv:2.0.1) Gecko/20100101 Firefox/4.0.1",
    "Opera/9.80 (Macintosh; Intel Mac OS X 10.6.8; U; en) Presto/2.8.131 Version/11.11",
    "Opera/9.80 (Windows NT 6.1; U; en) Presto/2.8.131 Version/11.11",
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_0) AppleWebKit/535.11 (KHTML, like Gecko) Chrome/17.0.963.56 Safari/535.11",
    "Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; Maxthon 2.0)",
    "Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; TencentTraveler 4.0)",
    "Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1)",
    "Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; The World)",
    "Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; Trident/4.0; SE 2.X MetaSr 1.0; SE 2.X MetaSr 1.0; .NET CLR 2.0.50727; SE 2.X MetaSr 1.0)",
    "Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; 360SE)",
    "Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; Avant Browser)",
    "Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1)"
]

headers = {
    'User-Agent': random.choice(agents),
    'Connection': 'close'
}


def getUserAgentHeader():
    return headers


def get_proxy():
    proxies = ["114.104.227.180:808", "125.161.208.143:3128", "121.40.40.182:80", "49.79.145.231:8998",
               "116.48.31.156:8998", "61.6.55.216:53281", "176.125.63.2:8080", "218.93.58.154:8998",
               "223.12.78.39:8998", "159.203.60.178:8080", "176.45.249.148:8080", "115.208.2.7:8998",
               "86.57.235.84:8080", "27.76.108.192:8080", "171.37.194.190:8088", "171.88.175.50:8998",
               "122.241.72.254:808", "175.155.244.224:808", "175.155.24.22:808", "79.119.252.37:8080",
               "80.31.139.120:8080", "190.90.8.132:53281", "95.104.37.75:8080", "61.6.129.53:53281",
               "106.46.3.62:38451", "218.29.181.73:21177", "201.231.80.94:8080", "171.211.26.4:808",
               "78.187.83.161:9090", "103.92.209.1:8080", "60.205.95.162:808", "122.52.133.131:8080",
               "185.9.149.102:8080", "203.192.229.129:8080", "27.19.7.228:8998", "110.191.221.33:8998",
               "202.114.114.34:3129", "118.144.154.253:3128", "41.250.46.46:8080", "222.132.145.122:53281",
               "91.203.63.107:8080", "117.57.234.46:8998", "180.125.38.188:44485", "212.109.146.245:8080",
               "183.128.65.146:39833", "186.206.168.241:3128", "201.9.79.241:3128", "110.73.33.65:8123",
               "222.186.45.58:56859", "36.73.71.115:65000", "110.153.16.148:8998", "27.18.189.198:8998",
               "49.231.150.233:3128", "222.85.50.201:808", "5.142.226.166:8080", "183.164.129.165:8998",
               "178.164.246.62:8080", "140.250.130.249:34054", "179.209.141.145:53281", "121.226.164.70:808",
               "222.93.73.82:8998", "175.155.24.90:808", "117.63.67.78:8998", "113.79.74.231:9797", "113.120.2.130:808",
               "82.76.40.4:443", "219.150.189.212:9999", "202.79.19.226:8080", "1.179.203.10:8080", "1.82.6.99:8998",
               "120.32.207.176:8998", "123.163.163.141:808", "221.229.46.1:808", "113.242.134.25:8998",
               "61.160.208.221:8080", "190.80.192.116:8080", "139.59.68.208:8888", "115.215.48.197:808",
               "114.99.22.47:808", "84.52.122.189:8080", "80.31.137.156:8080", "113.69.37.183:808",
               "115.237.229.252:8998", "180.110.7.231:808", "201.128.132.179:8080", "114.224.87.211:23745",
               "61.6.79.107:53281", "213.222.246.2:8081", "79.181.10.190:8080", "178.185.6.192:8080",
               "91.244.47.65:3128", "115.220.147.51:808", "182.182.0.24:8080", "79.130.59.161:8080", "115.220.1.43:808",
               "60.178.130.254:8081", "223.240.208.178:8998", "170.244.173.235:8080", "189.90.81.250:3128",
               "101.51.97.178:8888"]
    return proxies


def change_proxy():
    proxy = random.choice(get_proxy())
    while proxy is None:
        proxy = random.choice(get_proxy())
    return proxy


def country_crawler():
    country_list = []
    s = requests.session()
    s.keep_alive = False
    main_page = requests.get(main_url,
                             headers=getUserAgentHeader(),
                             # proxies={"http": change_proxy()},
                             timeout=10)
    html_data = main_page.text
    soup = BeautifulSoup(html_data, "html.parser")

    all_countries = soup.find("div", class_="row-list")

    for subList in all_countries.find_all("dd", class_="clearfix"):
        for sub_subList in subList.find_all("li"):
            try:
                if sub_subList['class'] == "letter":
                    break
            except:
                is_China = len(sub_subList.find_all("img", class_="domestic")) > 0
                is_hot = len(sub_subList.find_all("i", class_="icon-label")) > 0
                is_America = len(sub_subList.find_all("a", class_="texas")) > 0

                if is_China or is_America or is_hot:
                    link = "http://www.mafengwo.cn" + sub_subList.find("a")['href']
                    name_arr = sub_subList.text.split(" ")
                    chinese_name = name_arr[0]
                    english_name = " ".join(name_arr[1:]).strip()
                    country_dict = {"link": link,
                                    "chinese_name": chinese_name,
                                    "english_name": english_name}
                    country_list.append(country_dict)
    return country_list


def city_crawler(country_list):
    real_country_list = []
    for country_dict in country_list:
        try:
            # 国家图片
            country_url = country_dict["link"]
            s = requests.session()
            s.keep_alive = False
            country_page = requests.get(country_url,
                                        headers=getUserAgentHeader(),
                                        # proxies={"http": change_proxy()},
                                        timeout=10)
            html_data = country_page.text
            soup = BeautifulSoup(html_data, "html.parser")
            country_image_url = soup.find("div", class_="r-main").find("a", class_="photo").find("img")['src']
            country_dict["country_image_url"] = country_image_url
        except:
            country_url = country_dict["link"].replace("travel-scenic-spot/mafengwo", "jd").replace(".html",
                                                                                                    "/gonglve.html")
            s = requests.session()
            s.keep_alive = False
            country_page = requests.get(country_url,
                                        headers=getUserAgentHeader(),
                                        # proxies={"http": change_proxy()},
                                        timeout=10)
            html_data = country_page.text
            soup = BeautifulSoup(html_data, "html.parser")
            country_image_url = soup.find("div", class_="pic").find("div", class_="large").find_all("img")[0]["src"]
            country_dict["country_image_url"] = country_image_url

        try:
            city_url = country_dict["link"].replace("travel-scenic-spot/mafengwo", "mdd/citylist")
            s = requests.session()
            s.keep_alive = False
            city_page = requests.get(city_url,
                                     headers=getUserAgentHeader(),
                                     # proxies={"http": change_proxy()},
                                     timeout=10)
            html_data = city_page.text
            soup = BeautifulSoup(html_data, "html.parser")
            all_cities = soup.find("ul", class_="clearfix", id="citylistlist")
            city_list = []
            for subList in all_cities.find_all("div", class_="img"):
                image_url = subList.find("a").find("img")['data-original']
                name_arr = re.sub(r" ", "", subList.find("div", class_="title").text).strip().replace("\n", " ").split(
                    " ")
                chinese_name = name_arr[0]
                english_name = " ".join(name_arr[1:]).strip()
                city_dict = {"image_url": image_url,
                             "chinese_name": chinese_name,
                             "english_name": english_name}
                city_list.append(city_dict)
            country_dict["city_list"] = city_list
            real_country_list.append(country_dict)
        except:
            pass
        time.sleep(random.randint(0, 1))

    return real_country_list


print(json.dumps(city_crawler(country_crawler())))
