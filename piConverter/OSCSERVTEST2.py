from pythonosc.dispatcher import Dispatcher
from typing import List, Any

dispatcher = Dispatcher()


def set_data(address: str, *args: List[Any]) -> None:

    # Check that address starts with filter
    if not address[:-1] == "/hargrove":  # Cut off the last character
        return

    value1 = args[0]
    print(f"data: {value1}")


dispatcher.map("/hargrove*", set_data)

# Set up server and client for testing
#from pythonosc.osc_server import BlockingOSCUDPServer
from pythonosc.udp_client import SimpleUDPClient

client = SimpleUDPClient("10.0.0.3", 5001)

# Send message and receive exactly one message (blocking)
client.send_message("/hargrove1", 0.21)
