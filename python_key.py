V=22
import json
import base64
import os
import time
try:
	import datetime
except Exception:
	os.system('pip install datetime')
	import datetime

try:
	from cryptography.hazmat.primitives.asymmetric.x25519 import X25519PrivateKey 
	from cryptography.hazmat.primitives import serialization
except Exception:
	try:
		print("cryptography module not installed. Installing now...")
		os.system('pkg install python3 rust binutils-is-llvm -y')
		os.system('export CXXFLAGS="-Wno-register"')
		os.system('export CFLAGS="-Wno-register"')
		os.system('python3 -m pip install cryptography ')
	except Exception:
	   os.system("wget https://github.com/pyca/cryptography/archive/refs/tags/43.0.0.tar.gz")
	   os.system("tar -zxvf 43.0.0.tar.gz")
	   os.chdir("cryptography-43.0.0")
	   os.system("pip install .")
try:
	from cryptography.hazmat.primitives import serialization
	from cryptography.hazmat.primitives.asymmetric.x25519 import X25519PrivateKey
except Exception:
 print('somthing wemt wrong with cryptography')

try:
    import requests
except ImportError:
    print("Requests module not installed. Installing now...")
    os.system('pip install requests')
try:
    import requests
except ModuleNotFoundError:
    os.system('wget https://github.com/psf/requests/releases/download/v2.32.2/requests-2.32.2.tar.gz')
    os.system('tar -xzvf requests-2.32.2.tar.gz')
    os.chdir('requests-2.32.2')
    os.system('python setup.py install')
try:
    import requests
except ModuleNotFoundError:
    os.system('curl -L -o requests-2.32.2.tar.gz https://github.com/psf/requests/releases/download/v2.32.2/requests-2.32.2.tar.gz')
    os.system('tar -xzvf requests-2.32.2.tar.gz')
    os.chdir('requests-2.32.2')
    os.system('python setup.py install')
    import requests

time.sleep(10)
def byte_to_base64(myb):
    return base64.b64encode(myb).decode('utf-8')
def generate_public_key(key_bytes):
    # Convert the private key bytes to an X25519PrivateKey object
    private_key = X25519PrivateKey.from_private_bytes(key_bytes)
    
    # Perform the scalar multiplication to get the public key
    public_key = private_key.public_key()
    
    # Serialize the public key to bytes
    public_key_bytes = public_key.public_bytes(
        encoding=serialization.Encoding.Raw,
        format=serialization.PublicFormat.Raw
    )    
    return public_key_bytes



def generate_private_key():
    key = os.urandom(32)    
    # Modify random bytes using algorithm described at:
    # https://cr.yp.to/ecdh.html.
    key = list(key) # Convert bytes to list for mutable operations
    key[0] &= 248
    key[31] &= 127
    key[31] |= 64    
    return bytes(key) # Convert list back to bytes




def register_key_on_CF(pub_key):
    url = 'https://api.cloudflareclient.com/v0a4005/reg'
    # url = 'https://api.cloudflareclient.com/v0a2158/reg'
    # url = 'https://api.cloudflareclient.com/v0a3596/reg'

    body = {"key": pub_key,
            "install_id": "",
            "fcm_token": "",
            "warp_enabled": True,
            "tos": datetime.datetime.now().isoformat()[:-3] + "+07:00",
            "type": "Android",
            "model": "PC",
            "locale": "en_US"}

    bodyString = json.dumps(body)

    headers = {'Content-Type': 'application/json; charset=UTF-8',
               'Host': 'api.cloudflareclient.com',
               'Connection': 'Keep-Alive',
               'Accept-Encoding': 'gzip',
               'User-Agent': 'okhttp/3.12.1',
               "CF-Client-Version": "a-6.30-3596"
               }

    r = requests.post(url, data=bodyString, headers=headers)
    return r




def bind_keys():
    priv_bytes = generate_private_key()
    priv_string = byte_to_base64(priv_bytes)
    
    
    
    
    pub_bytes = generate_public_key(priv_bytes)
    pub_string = byte_to_base64(pub_bytes)
    
    



    result = register_key_on_CF(pub_string)
    
    if result.status_code == 200:
        try:
            z = json.loads(result.content)
            client_id = z['config']["client_id"]      
            cid_byte = base64.b64decode(client_id)
            reserved = [int(j) for j in cid_byte]

            
        except Exception as e:
 
            exit()
            
        with open('keys.txt','w') as f:
            f.write(f'2606:4700:110:846c:e510:bfa1:ea9f:5247/128\n{priv_string}\nbmXOC+F1FxEMF9dyiK2H5/1SUtzH0JuVo51h2wPfgyo=\n{reserved}')
bind_keys()
