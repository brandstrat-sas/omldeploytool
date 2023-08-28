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

class AMICore(object):
    _manager = None 
    _kill_flag = False 
    _redis = None  # The Redis client for updating key/values

    def __init__(self):
        self._manager = pystrix.ami.Manager()
        self._redis = redis.Redis(host=_REDIS_HOST, port=_REDIS_PORT, db=_REDIS_DB)
        self._register_callbacks()

        try:
            self._manager.connect(_HOST)
            challenge_response = self._manager.send_action(core.Challenge())
            if challenge_response and challenge_response.success:
                action = core.Login(_USERNAME, _PASSWORD, challenge=challenge_response.result['Challenge'])
                self._manager.send_action(action)
            else:
                self._kill_flag = True
                print("Asterisk did not provide an MD5 challenge token")

        except pystrix.ami.ManagerSocketError as e:
            self._kill_flag = True
            print(f"Unable to connect to Asterisk server: {str(e)}")

        except pystrix.ami.core.ManagerAuthError as reason:
            self._kill_flag = True
            print(f"Unable to authenticate to Asterisk server: {reason}")

        except pystrix.ami.ManagerError as reason:
            self._kill_flag = True
            print(f"An unexpected Asterisk error occurred: {reason}")

        self._manager.monitor_connection()

    def _register_callbacks(self):
        self._manager.register_callback('QueueSummary', self._handle_queue_summary)

    def _handle_queue_summary(self, event, manager):
        print(f"Received QueueSummary event: {event.name}")

        queue_data = {
            'LoggedIn': event.get('LoggedIn'),
            'Available': event.get('Available'),
            'Callers': event.get('Callers'),
        }

        print(queue_data)  # Print event details
        # you can store the data in redis if you want
        # self._redis.set('QueueSummary', queue_data)

            
    def is_alive(self):
        return self._manager.is_connected() and not self._kill_flag

    def kill(self):
        self._manager.close()

if __name__ == '__main__':
    ami_core = AMICore()

    while ami_core.is_alive():
        # Send a QueueSummary action every second
        ami_core._manager.send_action(QueueSummary(_QUEUE))
        time.sleep(5)
    ami_core.kill()
