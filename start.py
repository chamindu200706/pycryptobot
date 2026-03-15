import os
import subprocess
import sys

def main():
    # Read API keys from environment variables
    api_key = os.environ.get('BINANCE_API_KEY')
    api_secret = os.environ.get('BINANCE_API_SECRET')

    if not api_key or not api_secret:
        print("ERROR: BINANCE_API_KEY and BINANCE_API_SECRET must be set as environment variables.")
        sys.exit(1)

    # Write them to the key file expected by the bot
    with open('binance.key', 'w') as f:
        f.write(f"{api_key}\n{api_secret}")

    print("API key file created. Starting pycryptobot...")

    # Now launch the original bot
    # The original entry point is pycryptobot.py (or maybe the Dockerfile runs something else)
    # We'll assume the Dockerfile runs `python pycryptobot.py` eventually.
    # Instead, we can just run the same command the original Dockerfile would.
    # For simplicity, we'll call `python pycryptobot.py` with any arguments passed to this script.
    cmd = [sys.executable, 'pycryptobot.py'] + sys.argv[1:]
    subprocess.run(cmd)

if __name__ == '__main__':
    main()
