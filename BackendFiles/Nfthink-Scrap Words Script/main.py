from bs4 import BeautifulSoup
import requests
import re
from selenium import webdriver
import sys


def findKeywordsFromUrl(url):
    searched_words = ["metaverse", "roadmap", "airdrop", "loyalty", "game","p2e", "play to earn", "stake", "staking", "rarity"]
    results_dict = {}
    response = requests.get(url=url)
    html_doc = response.text
    soup = BeautifulSoup(html_doc, "html.parser")

    for word in searched_words:
        results = soup.body.find_all(string=re.compile('.*{0}.*'.format(word)), recursive=True)
        results_dict[word] = len(results)

    return results_dict

url = sys.argv[1];
keys = findKeywordsFromUrl(sys.argv[1])
print(keys)
