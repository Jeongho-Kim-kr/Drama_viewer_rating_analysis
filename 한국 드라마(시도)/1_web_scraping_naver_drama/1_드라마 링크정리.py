from selenium import webdriver
from selenium.webdriver.common.keys import Keys
import time

import requests
from bs4 import BeautifulSoup

## 네이버 종영 드라마 검색 후 셀레니움으로 원하는 연도 데이터 로드 후 페이지 소스를 로드해 bs4로 긁은 후 link.txt에 저장


## 페이지 소스 가져오기(여기서 클릭하는 연도 수정)
browser = webdriver.Chrome(r'C:\Users\KJH\OneDrive - 인하대학교\0 정리\1 깃허브 업로드\chromedriver\chromedriver.exe')

url = 'https://search.naver.com/search.naver?sm=tab_sug.top&where=nexearch&query=%EB%B0%A9%EC%98%81%EC%A2%85%EB%A3%8C%ED%95%9C%EA%B5%AD%EB%93%9C%EB%9D%BC%EB%A7%88&oquery=%EB%B0%A9%EC%98%81%EC%A2%85%EB%A3%8C%ED%95%9C%EA%B5%AD%EB%93%9C%EB%9D%BC%EB%A7%88&tqi=huaBXsprvmZssemcPMZssssstnV-331748&acq=%EB%B0%A9%EC%98%81%EC%A2%85%EB%A3%8C%ED%95%9C%EA%B5%AD%EB%93%9C%EB%9D%BC%EB%A7%88&acr=1&qdt=0'
browser.get(url)

time.sleep(1)
browser.find_element_by_xpath('//*[@id="main_pack"]/div[1]/div[2]/div/div/div[1]/div/div/ul/li[2]/a').click()

time.sleep(1)
browser.find_element_by_xpath('//*[@id="main_pack"]/div[1]/div[2]/div/div/div[1]/div/div/ul/li[2]/div/div/div/div/div/ul/li[2]/a').click()

for i in range(0, 14):
    time.sleep(0.5)
    browser.find_element_by_xpath('//*[@id="main_pack"]/div[1]/div[2]/div/div/div[3]/div/a[2]').click()


## 드라마 링크 정리
soup = BeautifulSoup(browser.page_source, 'lxml')
drama_list = soup.find('div', attrs={'class':'box_card_image_list _list'}).find_all('strong')
link_file = open('link.txt', 'a', encoding='utf8')
for index, drama in enumerate(drama_list):
    link_file.write('\nhttps://search.naver.com/search.naver?' + drama.find('a')['href'])
link_file.close()