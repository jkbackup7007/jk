# Importing The Modules
from email.quoprimime import quote
from pyrogram import Client, filters
from pyrogram.handlers import MessageHandler
from selenium import webdriver
from selenium.common.exceptions import NoSuchElementException
import time
import sys
import os
import requests as rq
import re
import json as js
from bs4 import BeautifulSoup as bt
import re
import requests
from lxml import etree

# Adding Bot CLient
SUDO_USER = [1862995182, 664418878, -
             1001519679213, -1001437242938, -1001368224697]
bot = Client('aio3module',
             api_id=1460212,
             api_hash="541edeae8d883917e5bda002185c8ffa",
             bot_token='5235219181:AAET8A7eqU44DwzyyUl82l4zibkidfVYJnI',
             workers=50,
             sleep_threshold=10)
# Start Command
@bot.on_message(filters.command('start') & filters.chat(SUDO_USER))
def start_message(bot, message):
    msg = "Hello"
    message.reply_text(msg)

# The Game Start's Here


@bot.on_message(filters.command('link') & filters.chat(SUDO_USER))
def aiobot(bot, message):
    if len(message.command) > 1:
        url2 = message.command[1]
    else:
        message.reply_text(f"Provide Link Along With Command")
    chrome_options = webdriver.ChromeOptions()
    chrome_options.binary_location = os.environ.get("GOOGLE_CHROME_BIN")
    chrome_options.add_argument("--headless")
    chrome_options.add_argument("--disable-dev-shm-usage")
    chrome_options.add_argument("--no-sandbox")
    driver = webdriver.Chrome(executable_path=os.environ.get("CHROMEDRIVER_PATH"), chrome_options=chrome_options)
    # driver = webdriver.Chrome()
    # HubDrive
    if "hubdrive" in url2:
        connect = message.reply_text(
            f"Connecting to Hubdrive:`\n\n```{url2}```", quote=True)
        driver.get(url2)
        b = driver.find_element_by_xpath(
            '/html/body/div[1]/div/div/div/center/div[2]/div/div/div[2]/div[3]/form/button').click()
        c = driver.find_element_by_xpath(
            "/html/body/div[1]/div[1]/div/div/div/div/div/div[2]/div/form/div[1]/div[1]/div/input").send_keys("gdtotwala@gmail.com")
        time.sleep(3)
        d = driver.find_element_by_xpath(
            "/html/body/div[1]/div[1]/div/div/div/div/div/div[2]/div/form/div[1]/div[2]/div/input").send_keys("Hubdrive@6789")
        time.sleep(3)
        e = driver.find_element_by_xpath(
            "/html/body/div[1]/div[1]/div/div/div/div/div/div[2]/div/form/div[2]/button[1]").click()
        f = driver.find_element_by_xpath('''//*[@id="down"]''').click()
        time.sleep(15)
        g = driver.find_element_by_xpath('''//*[@id="page-top"]''').click()
        time.sleep(5)
        h = driver.find_element_by_xpath(
            '''/html/body/div[1]/div[1]/div/center/div[2]/div/div/div/center/div[2]/a''').get_attribute('href')
        i = h.replace("open?id=", "file/d/")
        connect.delete()
        msg = (f"**HubDrive Link:**\n{url2}\n\n**Drive Link:**\n{i}")
        message.reply_text(msg, quote=True)
        driver.quit()
     # AppDrive
    elif "appdrive" in url2:
        driver = webdriver.Chrome()
        connect = message.reply_text(
            f"Connecting to AppDrive:`\n\n```{url2}```", quote=True)
        driver.get(url2)
    # Direct Download
        try:
            # b = driver.find_element_by_xpath('//*[@id="drc"]').click()
            b = driver.find_element_by_xpath('//*[@id="drc"]').click()
            c = driver.find_element_by_xpath(
                "/html/body/div[1]/div/div[2]/div[2]/a")
            time.sleep(8)
            link = (driver.current_url)
            # print(link)
            connect.delete()
            msg = f"**Appdrive Link:**\n{url2}\n\n**Drive Link:**\n{link}"
            message.reply_text(msg, quote=True)
            # driver.quit()
        # Login Download
        except NoSuchElementException:
            c2 = driver.find_element_by_xpath(
                '/html/body/div[1]/div/div[2]/div[2]/a').click()
            # print(driver.current_url)
            # form1Example1
            driver.find_element_by_id("form1Example1").send_keys(
                "sravanbot66@gmail.com")
            time.sleep(2)
            driver.find_element_by_id("form1Example2").send_keys("helloworld")
            time.sleep(3)
            submitbtn = driver.find_element_by_xpath(
                '/html/body/div[1]/div/div/div/div/form/button').click()
            time.sleep(3)
            e = driver.find_element_by_xpath('//*[@id="ddl"]').click()
            time.sleep(7)
            link = (driver.current_url)
            msg = f"**Appdrive Link:**\n{url2}\n\n**Drive Link:**\n{link}"
            message.reply_text(msg)
            driver.quit()

    # GDToT
    elif "gdtot" in url2:
        class gdtot:
            def __init__(self):
                self.url = url2
                self.list = gdtot.error(self)
                self.r = ''
                self.c = {"PHPSESSID": "q810h0c2lklfelnacuk9add3mo",
                          "crypt": "ZUlIVk85dUMzT0o5WFZqdHBjUlVtWjRxdkZML0ZTS0RleVNsNWFUNUduZz0%3D"}
               #  self.c = gdtot.check(self)
                self.h = {
                    'upgrade-insecure-requests': '1',
                    'save-data': 'on',
                    'user-agent': 'Mozilla/5.0 (Linux; Android 10; Redmi 8A Dual) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.101 Mobile Safari/537.36',
                    'accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9',
                    'sec-fetch-site': 'same-origin',
                    'sec-fetch-mode': 'navigate',
                    'sec-fetch-dest': 'document',
                    'referer': self.r,
                    'prefetchAd_3621940': 'true',
                    'accept-language': 'en-IN,en-GB;q=0.9,en-US;q=0.8,en;q=0.7'
                }

            def error(self):
                try:
                    self.url = sys.argv[1]
                except:
                    pass
                if len(self.url) == 0:
                    return "yes"
                else:
                    url = re.findall(r'\bhttps?://.*gdtot\S+', self.url)
                    return url

            def check(self):
                if self.c == '':
                    return False
                else:
                    j = js.loads(self.c)['cookie'].replace(
                        '=', ': ').replace(';', ',')
                    c = re.sub(r'([a-zA-Z_0-9.%]+)', r'"\1"', "{%s}" % j)
                    c = js.loads(c)
                    return c

            def parse(self):
                if len(self.list) == 0:
                    return "regex not match"
                elif self.list == "yes":
                    return "Empty Task"
                elif self.c == False:
                    return "cookies.txt file not found"
                else:
                    print("Gdtot Parser\n")
                    for i in self.list:
                        r1 = rq.get(self.url, headers=self.h,
                                    cookies=self.c).content
                        p = bt(r1, 'html.parser').find(
                            'button', id="down").get('onclick').split("'")[1]
                        self.r = self.url
                        r2 = bt(rq.get(p, headers=self.h, cookies=self.c).content, 'html.parser').find(
                            'meta').get('content').split('=', 1)[1]
                        self.r = p
                        r3 = bt(rq.get(r2, headers=self.h, cookies=self.c).content,
                                'html.parser').find('div', align="center")
                        if r3 == None:
                            r3 = bt(rq.get(r2, headers=self.h,
                                    cookies=self.c).content, 'html.parser')
                            f = r3.find('h4').text
                            return f
                        else:
                            s = r3.find('h6').text
                            i = r3.find(
                                'a', class_="btn btn-outline-light btn-user font-weight-bold").get('href')
                            f = "**File:** {}\n\n**Link:** {}\n".format(s, i)
                            return f
        connect = message.reply_text(
            f"**Connecting to gdtot:**\n\n```{url2}```", quote=True)
        message.reply_text(gdtot().parse(), quote=True)
        connect.delete()

    if "https://sharer.pw" in url2:
        XSRF_TOKEN = "eyJpdiI6IjR1NEhyOVl5UHVmS2ViWjZvcnVtR1E9PSIsInZhbHVlIjoiZHY4b2FIUzdsMHpuSGNZRkNXaTF4cG1iOXEzNFBxV3VGMVhUOGF0UEhSamNiVEJ3V1BoVTJwM0ZSY091SGRqSiIsIm1hYyI6IjRiNjhkMmI0MzlkNmY3NTg2OGI3NWRkNWRiYTk5YmY0ODgwYjFkZjZmZWZiNjQ0MTM4NjIxZjQ0NWNiYTJjMDcifQ%3D%3D"  # XSRF-TOKEN cookie
        laravel_session = "eyJpdiI6ImNJXC9OTjZmaURrSlV5VUUrKzBBaVhBPT0iLCJ2YWx1ZSI6IkxMYUt0MkgrNjd2bWM5ODRRaDQ5dENtNlJRa1ZobXNcLzhaQWFvMUlcLzJURzV1alM1aTE0MTU4a0FcL2RhYTFLalAiLCJtYWMiOiI3YzZmODdlYjg5MDNmNGNlOTBmNDBhODQ2YTI0ZmIwYTQyNzA4ZjY2YzNmNTliMWNhZjU2ZDliZWM5NWMyNTEzIn0%3D"  # laravel_session cookie
        '''
            404: Exception Handling Not Found :(
            NOTE:
            DO NOT use the logout button on website. Instead, clear the site cookies manually to log out.
            If you use logout from website, cookies will become invalid.
            '''
        # ===================================================================
        def parse_info(res):
            f = re.findall(">(.*?)<\/td>", res.text)
            info_parsed = {}
            for i in range(0, len(f), 3):
                info_parsed[f[i].lower().replace(' ', '_')] = f[i+2]
            return info_parsed

        def sharer_pw_dl(url2, forced_login=False):
            client = requests.Session()
            client.cookies.update({
                "XSRF-TOKEN": XSRF_TOKEN,
                "laravel_session": laravel_session
            })
            res = client.get(url2)
            token = re.findall("_token\s=\s'(.*?)'", res.text, re.DOTALL)[0]
            ddl_btn = etree.HTML(res.content).xpath(
                "//button[@id='btndirect']")
            info_parsed = parse_info(res)
            info_parsed['error'] = True
            info_parsed['src_url'] = url2
            info_parsed['link_type'] = 'login'  # direct/login
            info_parsed['forced_login'] = forced_login
            headers = {
                'content-type': 'application/x-www-form-urlencoded; charset=UTF-8',
                'x-requested-with': 'XMLHttpRequest'
            }
            data = {
                '_token': token
            }
            if len(ddl_btn):
                info_parsed['link_type'] = 'direct'
            if not forced_login:
                data['nl'] = 1
            try:
                res = client.post(url2+'/dl', headers=headers, data=data).json()
            except:
                return info_parsed
            if 'url' in res and res['url']:
                info_parsed['error'] = False
                info_parsed['gdrive_link'] = res['url']
            if len(ddl_btn) and not forced_login and not 'url' in info_parsed:
                # retry download via login
                return sharer_pw_dl(url2, forced_login=True)
            return info_parsed
        # ===================================================================
        out = sharer_pw_dl(url2)
        # print(out.keys())
        filename2 = out['file_name']
        size2 = out['size']
        gdlink = out['gdrive_link']
        msg = f'''**File Name:** ```{filename2}```\n\n**Size:** {size2}\n\n**Gdrive Link:** {gdlink}'''
        print(msg)
        message.reply_text(msg)
        # == =================================================================

        ''' 
                    SAMPLE OUTPUT:
                {
                    file_name: xxx, 
                    type: video/x-matroska, 
                    size: 880.6MB, 
                    added_on: 2022-02-04, 
                    error: False, 
                    link_type: direct/login
                    forced_login: False (True when script retries download via login if non-login dl fails for any reason)
                    src_url: https://sharer.pw/file/xxxxxxxx, 
                    gdrive_link: https://drive.google.com/...
                }
                '''


bot.run()
