#!/usr/bin/env python3
import argparse
import os
import threading
import requests
from urllib.parse import urljoin, urlparse
from bs4 import BeautifulSoup
from random import choice
from colorama import Fore, Style, init
from tqdm import tqdm
from datetime import timedelta
import time
import urllib3
import sys

# main

urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

init(autoreset=True)
print_lock = threading.Lock()

def load_user_agents(path="useragent.txt"):
    try:
        with open(path, 'r') as f:
            return [line.strip().strip(',') for line in f if line.strip()]
    except:
        return ["Mozilla/5.0 (Windows NT 10.0; Win64; x64)"]

def load_proxies(path):
    try:
        with open(path, 'r') as f:
            return [line.strip() for line in f if line.strip()]
    except:
        return []

def get_links(url, headers):
    try:
        r = requests.get(url, headers=headers, timeout=10, verify=False)
        soup = BeautifulSoup(r.text, 'html.parser')
        return [urljoin(url, link.get('href')) for link in soup.find_all('a') if link.get('href')]
    except:
        return []

def get_domain_folder(url):
    domain = urlparse(url).netloc
    folder = os.path.join("Domains", domain)
    os.makedirs(folder, exist_ok=True)
    return folder

def is_valid_file(url, extensions):
    if extensions == ["all"]:
        return True
    return any(url.lower().endswith(f".{ext}") for ext in extensions)

def download_file(url, folder, proxy_list, user_agents, log, extensions, firewall_bypass):
    if not is_valid_file(url, extensions):
        return
    attempt = 1
    try:
        headers = {"User-Agent": choice(user_agents)}
        if firewall_bypass:
            headers.update({
                "X-Forwarded-For": "127.0.0.1",
                "X-Originating-IP": "127.0.0.1",
                "X-Remote-IP": "127.0.0.1",
                "X-Remote-Addr": "127.0.0.1",
                "Referer": url
            })
        proxies = {"http": choice(proxy_list), "https": choice(proxy_list)} if proxy_list else None
        r = requests.get(url, headers=headers, proxies=proxies, stream=True, timeout=10, verify=False)

        status = r.status_code
        length = r.headers.get("Content-Length")
        size_kb = f"{int(length)/1024:.2f} KB" if length else "? KB"

        color = Fore.GREEN if status == 200 else Fore.RED if status in [301, 404, 403] else Fore.YELLOW
        url_color = Fore.CYAN
        size_color = Fore.YELLOW
        time_color = Fore.MAGENTA

        elapsed = time.strftime("%H:%M:%S", time.gmtime(time.perf_counter()))

        with print_lock:
            print(f"{color}[{status}] {url_color}{url} (Attempt {attempt}) {size_color}({size_kb}) {time_color}[{elapsed}]")

        if status == 200:
            filename = os.path.join(folder, os.path.basename(url))
            with open(filename, 'wb') as f:
                for chunk in r.iter_content(1024):
                    f.write(chunk)
            log.append(url)
    except Exception as e:
        with print_lock:
            print(f"{Fore.RED}[ERR] {url} -> {e}")

def main():
    parser = argparse.ArgumentParser(description="🔥 Multi-threaded file grabber with colorful output")
    parser.add_argument("-u", "--url", required=True, help="Target base URL")
    parser.add_argument("-t", "--threads", type=int, default=10, help="Number of threads")
    parser.add_argument("-p", "--proxy", help="Proxy list file")
    parser.add_argument("--ext", default="jpg,png", help="Extensions to download (e.g., jpg,png,pdf or 'all')")
    parser.add_argument("-w", "--firewall", action='store_true', help="Enable basic firewall bypass headers")
    args = parser.parse_args()

    print(Fore.YELLOW + f"=======================================================================")

    print(Fore.RED + Style.BRIGHT + """
██████╗ ██╗   ██╗███╗   ███╗██████╗ ███████╗██████╗ 
██╔══██╗██║   ██║████╗ ████║██╔══██╗██╔════╝██╔══██╗
██║  ██║██║   ██║██╔████╔██║██████╔╝█████╗  ██████╔╝
██║  ██║██║   ██║██║╚██╔╝██║██╔═══╝ ██╔══╝  ██╔══██╗
██████╔╝╚██████╔╝██║ ╚═╝ ██║██║     ███████╗██║  ██║
╚═════╝  ╚═════╝ ╚═╝     ╚═╝╚═╝     ╚══════╝╚═╝  ╚═╝  v 0.1
    """) 

    print(Fore.RED + f"Multi-threaded File Grabber by TAI-Sec")
    print(Fore.YELLOW + f"TEAM {Fore.WHITE}ANONYMOUS {Fore.GREEN}INDIA")                                                 
    print(Fore.RED + f"Find us   : {Fore.CYAN}github.com/TAI-Sec")
    print(Fore.RED + f"Developer : {Fore.BLUE}JORD4N {Fore.WHITE}WH04MI {Fore.YELLOW}SABIT")
    print(Fore.YELLOW + f"========================================================================")                                   
    print(Fore.YELLOW + f"[*] socket    = {Fore.CYAN}Bot")
    print(Fore.YELLOW + f"[*] URL       = {Fore.CYAN}{args.url}")
    print(Fore.YELLOW + f"[*] Threads   = {Fore.CYAN}{args.threads}")
    print(Fore.YELLOW + f"[*] Proxy     = {Fore.CYAN}{args.proxy if args.proxy else 'None'}")
    print(Fore.YELLOW + f"[*] Firewall  = {Fore.CYAN}{'Enabled' if args.firewall else 'None'}")
    print(Fore.YELLOW + f"[*] Extension = {Fore.CYAN}{args.ext}\n")    
    print(Fore.YELLOW + f"========================================================================")

    user_agents = load_user_agents()
    proxy_list = load_proxies(args.proxy) if args.proxy else []
    extensions = [e.lower() for e in args.ext.split(",")]

    folder = get_domain_folder(args.url)
    links = get_links(args.url, headers={"User-Agent": choice(user_agents)})
    valid_links = [link for link in links if is_valid_file(link, extensions)]

    print(Fore.YELLOW + f"[*] Found {Fore.CYAN}{len(valid_links)}{Fore.YELLOW} valid file(s) to download\n")

    log = []
    with tqdm(total=len(valid_links), bar_format="{desc}") as pbar:
        for link in valid_links:
            threading.Thread(target=download_file, args=(link, folder, proxy_list, user_agents, log, extensions, args.firewall)).start()
            time.sleep(0.01)

    time.sleep(3)  # Let threads finish
    if log:
        with open(os.path.join(folder, "log.txt"), "w") as f:
            f.write("\n".join(log))
    print(Fore.GREEN + f"\n[✔] Download completed and saved in: {folder}")

if __name__ == "__main__":
    main()
