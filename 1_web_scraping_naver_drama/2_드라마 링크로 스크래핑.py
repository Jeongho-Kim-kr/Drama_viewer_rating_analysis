from selenium import webdriver
from selenium.webdriver.common.keys import Keys
import time

import requests
from bs4 import BeautifulSoup

## link.txt를 읽은 후 selenium으로 검색 후 bs4로 긁어옴(드라마 기본정보, 등장배우 두군대 링크가 필요해서)
## 등장인물에서 펼쳐보기가 아닌 페이지의 경우 오류가 남

## 링크 텍스트 파일에서 링크 받아오기
link_file = open('link.txt', 'r', encoding='utf8')
link = link_file.readlines() # 드라마 링크 저장 변수(0 ~ 115)
link.reverse() # 최신 드라마부터 긁어오므로 시간순으로 하기 위해 역순

## 스크래핑 시작(ctrl + c로 정지)
data_file = open('data.txt', 'a', encoding='utf8')
browser = webdriver.Chrome('../파이썬/chromedriver/chromedriver')
index = 0

for i in range(0,100):
    time.sleep(0.5)
    link_tmp = str(link[index])

    time.sleep(0.5)
    browser.get(link_tmp)

    time.sleep(0.5)
    browser.find_element_by_link_text('기본정보').click()       

    time.sleep(0.5)
    soup = BeautifulSoup(browser.page_source, 'lxml')

    title = soup.find('a', attrs={'class':'area_text_title'})
    org = soup.find('div', attrs={'class':'info_group'})
    talk = soup.find('span', attrs={'class':'num_txt'})
    original = org.find_next_sibling('div').find_next_sibling('div')
    producer = soup.find('dl', attrs={'class':'pro_info'})
    series = soup.find('ul', attrs={'class':'list'})
    nx = soup.find('div', attrs={'class':'list_info'})

    time.sleep(0.5)
    try:
        browser.find_element_by_link_text('등장인물').click()
        
        time.sleep(0.5)
        soup = BeautifulSoup(browser.page_source, 'lxml')

        actor = soup.find('div', attrs={'class':'list_image_info _content'})
        actor_all = actor.find_all('span', attrs={'class':'sub_text type_ell_2 _html_ellipsis'})

    except: 
        browser.find_element_by_link_text('출연진').click()
        time.sleep(0.5)
        soup = BeautifulSoup(browser.page_source, 'lxml')

        actor = soup.find('div', attrs={'class':'list_image_info _content'})
        actor_all = actor.find_all('strong', attrs={'class':'name type_ell_2 _html_ellipsis'})

    time.sleep(0.5)
    data_file.write('\n{0}/'.format(title.get_text().strip()))
    data_file.write('{0}/'.format(producer.get_text().strip()))
    
    for i in range(len(actor_all)):
        data_file.write(actor_all[i].get_text() + ', ')
    data_file.write('/')

    try:
        data_file.write('{0}/'.format(org.get_text().strip()))
    except:
        data_file.write('/')

    try:
        data_file.write('{0}/'.format(talk.get_text().strip()))
    except:
        data_file.write('/')
    
    try:
        data_file.write('{0}/'.format(nx.get_text().strip()))
    except:
        data_file.write('/')
    
    try:
        if original.get_text().strip() == '원작  원작소설':
            data_file.write('{0}/'.format(original.get_text().strip()))
        elif original.get_text().strip() == '원작  원작만화':
            data_file.write('{0}/'.format(original.get_text().strip()))
        else:
            data_file.write('/')
    except:
        data_file.write('/')

    try:
        data_file.write('{0}/'.format(series.get_text().strip()))
    except:
        data_file.write('/')
    
    index += 1