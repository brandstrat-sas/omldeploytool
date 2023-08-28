import os
import time
import pystrix
import redis
from pystrix.ami import core

_HOST = os.getenv('ASTERISK_HOSTNAME')
_USERNAME = os.getenv('AMI_USER')
_PASSWORD = os.getenv('AMI_PASSWORD')
_REDIS_HOST = os.getenv('REDIS_HOST')
_REDIS_PORT = int(os.getenv('REDIS_PORT', '6379'))  # default Redis port
_REDIS_DB = int(os.getenv('REDIS_DB', '0'))  # default Redis DB
_QUEUE = '2_test_entrante_campaign'  # add your queue name here

# ... (código anterior)

class AMICore(object):
    # ... (código anterior)
    def _get_core_calls_info(self):
        try:
            response = self._manager.send_action(core.Command(command='core show calls'))
            # Parse the response and extract relevant information
            calls_info = response.result['data']
            return calls_info

        except pystrix.ami.ManagerError as reason:
            print(f"An error occurred while getting calls info: {reason}")
            return None

    def update_calls_info_in_redis(self):
        while self.is_alive():
            calls_info = self._get_core_calls_info()
            if calls_info:
                self._redis.set('CoreCallsInfo', calls_info)

            time.sleep(5)

# ... (código posterior)

if __name__ == '__main__':
    ami_core = AMICore()

    while ami_core.is_alive():
        # Send a QueueSummary action every second
        ami_core._manager.send_action(QueueSummary(_QUEUE))
        time.sleep(5)
    ami_core.kill()
