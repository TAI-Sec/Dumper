# 🔥 Dumper A Multi-threaded Files Grabber

This is a **multi-threaded file downloader** built in Python for recursively grabbing media or file URLs from directory listing pages or known file storage endpoints. 

🛡️ It includes features for **firewall bypass**, **proxy rotation**, **user-agent spoofing**, and colorful, real-time logs.  
📁 Supports organized domain-based file storage and selective downloads by extension.

---

## 📦 Features
- ✅ Multi-threaded (1–100 bots)
- ✅ Optional **firewall bypass** headers (`-w`)
- ✅ Proxy & user-agent rotation support
- ✅ Extension filtering (`jpg`, `png`, `pdf`, etc. or `all`)
- ✅ TQDM-free logging with real-time duration
- ✅ Auto domain-folder based download saving
- ✅ Saves logs of successful downloads in `log.txt`


## ⚙️ Installation

$ sudo apt update
$ sudo apt install python3 python3-pip -y
$ pip3 install requests tqdm beautifulsoup4 colorama

📁 Setup
Clone or Download the Script:

$ git clone https://github.com/yourusername/file-grabber
$ cd file-grabber
Prepare Optional Files:

proxy.txt - list of HTTP/HTTPS proxies (optional)

🚀 Usage

python3 grab.py -u <URL> [options]

📌 Options:

Option	Description
-u, --url	Base URL to grab files from (required)
-t, --threads	Number of threads to use (default: 10)
-p, --proxy	Path to proxy list file (optional)
--ext	Extensions to download (comma-separated or all)
-w, --firewall	Enable firewall bypass headers
💡 Examples:
# Download all JPG and PNG files using 10 threads
python3 grab.py -u https://example.com/files/ -t 10 --ext jpg,png

# Use a proxy list and enable firewall bypass
python3 grab.py -u https://target.com/storage/ -t 5 -p proxy.txt -w --ext all
🔒 Firewall Bypass Mode
Enable with -w to send spoofed headers:

X-Forwarded-For

X-Originating-IP

X-Remote-IP

X-Remote-Addr

Referer

This is useful against basic IP filtering or WAF-protected endpoints.

🧾 Output
Downloads saved to: Domains/<domain>/

Success log saved to: Domains/<domain>/log.txt

Logs are real-time, thread-safe, and color-coded.

🧠 Notes
Too many threads on weak servers may cause timeouts or bans.

Use proxy + user-agent rotation for stealth.

Firewall bypass is basic header injection, not advanced evasion.

👨‍💻 Author
Script by YOU
Customized & enhanced for real-world use.

📜 License
This tool is for educational and authorized use only.
You are responsible for your own actions.

Tested ok...🔥🧪
